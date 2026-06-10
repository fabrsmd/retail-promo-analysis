#######
# Exploratory Data analysis,first analysis + graph

library(dplyr)
library(ggplot2)
library(scales)

daily    <- readRDS("data/processed/daily.rds")
products <- readRDS("data/processed/products.rds")
enriched <- readRDS("data/processed/enriched.rds")

# Graph 1: Revenue evolution

p1 <- ggplot(daily, aes(x = sale_date, y = revenue)) +
  geom_line(color = "#2C7BE5") +
  scale_y_continuous(labels = comma) +
  labs(title = "Trend in daily revenues",
       x = NULL, y = "Sales (£)") +
  theme_minimal()
ggsave("outputs/figures/01_trenddailyrevenue.png", p1, width = 9, height = 4.5, dpi = 150)




# Graph 2: Top 10 Products by Sales

top10 <- products %>% arrange(desc(total_revenue)) %>% head(10)
p2 <- ggplot(top10, aes(x = reorder(description, total_revenue), y = total_revenue)) +
  geom_col(fill = "#2C7BE5") +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  labs(title = "Top 10 Products by Sales",
       x = NULL, y = "Sales (£)") +
  theme_minimal()
ggsave("outputs/figures/02_top10products.png", p2, width = 9, height = 5, dpi = 150)





# Graph 3: Distribution of discounts (excluding regular price)

p3 <- enriched %>%
  filter(discount_pct > 0) %>%
  ggplot(aes(x = discount_pct)) +
  geom_histogram(bins = 40, fill = "#E55353") +
  scale_x_continuous(labels = percent) +
  labs(title = "Distribution of Applied Discounts",
       x = "Discount (%)", y = "Number of lines") +
  theme_minimal()
ggsave("outputs/figures/03_distribution_discount.png", p3, width = 9, height = 4.5, dpi = 150)



# Graph4 : Revenue by country (top 10)

by_country <- enriched %>%
  group_by(country) %>% summarise(revenue = sum(revenue)) %>%
  arrange(desc(revenue)) %>% head(10)
p4 <- ggplot(by_country, aes(x = reorder(country, revenue), y = revenue)) +
  geom_col(fill = "#1F9D55") + coord_flip() +
  scale_y_continuous(labels = comma) +
  labs(title = "Top 10 COUNTRY BY REVENUE", x = NULL, y = "Revenue (£)") +
  theme_minimal()
ggsave("outputs/figures/04_revenuebycountry.png", p4, width = 9, height = 5, dpi = 150)

message("graph import in  outputs/figures/")
