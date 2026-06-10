
#  load   Excel brut in PostgreSQL
 
library(readxl)
library(DBI)
library(RPostgres)

# 1. Read excel file
raw <- read_excel("data/raw/Online Retail.xlsx")

# 2. Rename column
names(raw) <- c("invoice_no", "stock_code", "description",
                "quantity", "invoice_date", "unit_price",
                "customer_id", "country")

# 3. Connexion to the base
con <- dbConnect(RPostgres::Postgres(),
                 dbname   = "retail_db", host = "localhost", port = 5432,
                 user     = "postgres", password = Sys.getenv("PG_PASSWORD"))

# 4. Overwrite the table
dbWriteTable(con, "online_retail_raw", raw, overwrite = TRUE, row.names = FALSE)

#  Check number of line line
#print(dbGetQuery(con, "SELECT COUNT(*) AS n FROM online_retail_raw;"))

# dbDisconnect(con)
