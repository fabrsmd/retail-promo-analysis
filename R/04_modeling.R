
###Price Elasticity


library(dplyr)
library(broom)
library(readr)
library(ggplot2)

el <- readRDS("data/processed/elasticity_in.rds") %>%
  filter(unit_price > 0, units > 0) %>%
  mutate(log_price = log(unit_price), log_units = log(units))

# Global elasticity (pooled model)
global_model <- lm(log_units ~ log_price, data = el)
print(summary(global_model))

global_elasticity <- coef(global_model)[["log_price"]]

cat("Estimated global price elasticity:",
    round(global_elasticity, 3), "\n")





# 2 Elasticity by product (only products with sufficient price variation) 
product_elasticity <- el %>%
  group_by(stock_code, description) %>%
  filter(n_distinct(unit_price) >= 5) %>%   # at least 5 different prices
  do(tidy(lm(log_units ~ log_price, data = .))) %>%
  filter(term == "log_price") %>%
  transmute(stock_code,description, elasticite = round(estimate, 3),p_value = round(p.value, 4)) %>%
  ungroup()







# Product classification:
# elastic products (discounts likely effective)
# vs inelastic products (discounts potentially risky)


product_elasticity <- product_elasticity %>%
  mutate(segment = case_when(
    elasticite <= -1 ~ "Elastic (effective promotion)",
    elasticite > -1 & elasticite < 0 ~ "Inelastic (risky promotion)",
    TRUE ~ "Atypical (positive elasticity)"))

print(head(product_elasticity, 10))

write_csv(product_elasticity,"outputs/tables/elasticity_by_product.csv")

# --- 3) Plot: price vs quantity scatterplot (log scale)
p <- ggplot(el, aes(x = log_price, y = log_units)) +
  geom_point(alpha = 0.15, color = "#2C7BE5") +
  geom_smooth(method = "lm", color = "#E55353") +
  labs(title = paste0("Price–Quantity Relationship (Global Elasticity = ",round(global_elasticity, 2),
      ")"),x = "log(price)",y = "log(quantity)") +theme_minimal()

ggsave("outputs/figures/05_elasticite.png",p,width = 9,height = 5,dpi = 150)



# Save global elasticity for ROI calculations
saveRDS(global_elasticity,"data/processed/global_elasticity.rds")

message("Modeling completed. Global elasticity = ", round(global_elasticity, 3))






















