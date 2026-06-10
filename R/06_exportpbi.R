#####export PBI

library(readr)
products <- readRDS("data/processed/products.rds")
daily    <- readRDS("data/processed/daily.rds")
library(readr)

# Reexporter avec virgule comme séparateur décimal (format européen)
write_csv2(products, "outputs/tables/product_performance.csv")
write_csv2(daily,    "outputs/tables/daily_sales.csv")
write_csv2(scenarios,"outputs/tables/roi_scenarios.csv")
write_csv2(product_elasticity, "outputs/tables/elasticity_by_product.csv")
message("CSVfor PBI ready in outputs/tables/")