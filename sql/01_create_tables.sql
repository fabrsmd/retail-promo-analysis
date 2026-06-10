-- ============================================================
-- 01_create_tables.sql — Tables propres (modèle en étoile)
-- ============================================================

-- Table de faits : une ligne = une ligne de transaction nettoyée
DROP TABLE IF EXISTS fact_sales CASCADE;
CREATE TABLE fact_sales (
    sale_id       BIGSERIAL PRIMARY KEY,   -- identifiant auto-incrémenté
    invoice_no    VARCHAR(20),
    stock_code    VARCHAR(20),
    description   TEXT,
    quantity      INTEGER,
    invoice_date  TIMESTAMP,
    unit_price    NUMERIC(10,2),
    customer_id   INTEGER,
    country       VARCHAR(60),
    revenue       NUMERIC(12,2)            -- quantity * unit_price
);

-- Dimension produit : un produit = une ligne, avec son prix "normal"
DROP TABLE IF EXISTS dim_product CASCADE;
CREATE TABLE dim_product (
    stock_code       VARCHAR(20) PRIMARY KEY,
    description      TEXT,
    reference_price  NUMERIC(10,2),  -- prix le plus fréquent = prix normal
    min_price        NUMERIC(10,2),
    max_price        NUMERIC(10,2)
);