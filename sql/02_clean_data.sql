-- ============================================================
-- 02_clean_data.sql — Nettoyage + chargement des tables propres
-- ============================================================

-- 1) Peupler fact_sales depuis la table brute, en nettoyant
TRUNCATE TABLE fact_sales RESTART IDENTITY;

INSERT INTO fact_sales
    (invoice_no, stock_code, description, quantity,
     invoice_date, unit_price, customer_id, country, revenue)
SELECT
    invoice_no,
    stock_code,
    description,
    quantity::INTEGER,
    invoice_date::TIMESTAMP,
    ROUND(unit_price::NUMERIC, 2),
    customer_id::INTEGER,
    country,
    ROUND((quantity * unit_price)::NUMERIC, 2) AS revenue
FROM online_retail_raw
WHERE quantity   > 0            -- on garde les ventes (pas les retours)
  AND unit_price > 0            -- on retire les prix nuls/erreurs
  AND invoice_no NOT LIKE 'C%'  -- 'C' = facture annulée (Cancelled)
  AND stock_code IS NOT NULL
  AND description IS NOT NULL;

-- 2) Construire la dimension produit
TRUNCATE TABLE dim_product;

INSERT INTO dim_product (stock_code, description, reference_price, min_price, max_price)
SELECT
    stock_code,
    MAX(description) AS description,                          -- libellé représentatif
    mode() WITHIN GROUP (ORDER BY unit_price) AS reference_price,  -- prix le plus fréquent
    MIN(unit_price) AS min_price,
    MAX(unit_price) AS max_price
FROM fact_sales
GROUP BY stock_code;