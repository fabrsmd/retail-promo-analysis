
#Import SQL views in R
########
library(DBI)
library(RPostgres)
library(readr)

#Connexion to the DB
con <- dbConnect(RPostgres::Postgres(),
                 dbname = "retail_db", host = "localhost", port = 5432,
                 user = "postgres", password = Sys.getenv("PG_PASSWORD"))

# IMPORT EACH VIEW IN R
daily       <- dbGetQuery(con, "SELECT * FROM v_daily_sales;")
products    <- dbGetQuery(con, "SELECT * FROM v_product_performance;")
enriched    <- dbGetQuery(con, "SELECT * FROM v_sales_enriched;")
elasticity_in <- dbGetQuery(con, "SELECT * FROM v_elasticity_input;")
kpi         <- dbGetQuery(con, "SELECT * FROM v_kpi_summary;")

dbDisconnect(con)

# Save in local for next scripts
saveRDS(daily,        "data/processed/daily.rds")
saveRDS(products,     "data/processed/products.rds")
saveRDS(enriched,     "data/processed/enriched.rds")
saveRDS(elasticity_in,"data/processed/elasticity_in.rds")
saveRDS(kpi,          "data/processed/kpi.rds")

message("Import finished : ", nrow(enriched), " line enriched.")
