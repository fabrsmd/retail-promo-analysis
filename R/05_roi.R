##### Promotion Simulation and ROI Calculation


library(dplyr)
library(readr)
library(ggplot2)
library(scales)

products   <- readRDS("data/processed/products.rds")
elasticity <- readRDS("data/processed/global_elasticity.rds")

#####Assumptions
gross_margin  <- 0.50      # 50% gross margin
campaign_cost <- 5000      # fixed campaign cost (£)

# Simulate on the top 50 products (representing most of the revenue)
base <- products %>%
  arrange(desc(total_revenue)) %>%
  head(50) %>%
  mutate(
    P0 = total_revenue / total_units,   # average selling price
    Q0 = total_units                    # baseline quantity
  )

# Simulation function for a given discount level
simulate_discount <- function(discount) {
  base %>%
    mutate(
      P1 = P0 * (1 - discount),
      unit_cost = P0 * (1 - gross_margin),
      quantity_change = elasticity * (-discount),   # %ΔQ = elasticity × %ΔP
      Q1 = Q0 * (1 + quantity_change),
      
      baseline_margin = Q0 * (P0 - unit_cost),
      scenario_margin = Q1 * (P1 - unit_cost)
    ) %>%
    summarise(
      discount         = discount,
      baseline_margin  = sum(baseline_margin),
      scenario_margin  = sum(scenario_margin),
      margin_gain      = sum(scenario_margin) - sum(baseline_margin),
      baseline_revenue = sum(Q0 * P0),
      scenario_revenue = sum(Q1 * P1)
    ) %>%
    mutate(
      campaign_cost = campaign_cost,
      net_gain      = margin_gain - campaign_cost,
      roi           = (margin_gain - campaign_cost) / campaign_cost
    )
}

# Test multiple discount levels
scenarios <- bind_rows(
  lapply(c(0.05, 0.10, 0.15, 0.20, 0.25), simulate_discount)
)

scenarios <- scenarios %>%
  mutate(
    discount_pct = paste0(discount * 100, " %"),
    roi_pct      = round(roi * 100, 1)
  )

print(
  scenarios %>%
    select(discount_pct, margin_gain, campaign_cost, net_gain, roi_pct)
)

write_csv(
  scenarios,
  "outputs/tables/roi_scenarios.csv"
)

# Plot: ROI by discount level
p <- ggplot(scenarios, aes(x = discount, y = roi)) +
  geom_line(color = "#2C7BE5", linewidth = 1) +
  geom_point(size = 3, color = "#2C7BE5") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = percent) +
  labs(
    title = "Promotion ROI by Discount Level",
    x = "Applied Discount",
    y = "ROI"
  ) +
  theme_minimal()

ggsave(
  "outputs/figures/06_roi_scenarios.png",
  p,
  width = 9,
  height = 5,
  dpi = 150
)

# Automatic recommendation:
# discount level with the highest positive ROI
best <- scenarios %>%
  filter(roi > 0) %>%
  arrange(desc(roi)) %>%
  head(1)

cat(
  "Recommendation: optimal discount =",
  best$discount_pct,
  "| ROI =",
  best$roi_pct,
  "% | net gain =",
  round(best$net_gain),
  "£\n"
)