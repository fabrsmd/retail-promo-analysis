-- ============================================================
-- 03_joins_aggregations.sql — Jointure + flag promotion
-- ============================================================

DROP VIEW IF EXISTS v_sales_enriched CASCADE;
CREATE VIEW v_sales_enriched AS
SELECT
    f.sale_id,
    f.invoice_no,
    f.stock_code,
    f.description,
    f.quantity,
    f.invoice_date,
    f.unit_price,
    d.reference_price,
    f.customer_id,
    f.country,
    f.revenue,
    -- remise en % par rapport au prix de référence
    ROUND((d.reference_price - f.unit_price) / NULLIF(d.reference_price, 0), 4) AS discount_pct,
    -- promotion si vendu à plus de 5% sous le prix de référence
    CASE WHEN f.unit_price < d.reference_price * 0.95 THEN 1 ELSE 0 END AS is_promo
FROM fact_sales f
JOIN dim_product d ON f.stock_code = d.stock_code;