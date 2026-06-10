-- ============================================================
-- 04_business_views.sql — Vues métier réutilisables
-- ============================================================

-- 1) Ventes quotidiennes (pour la tendance temporelle)
DROP VIEW IF EXISTS v_daily_sales CASCADE;
CREATE VIEW v_daily_sales AS
SELECT
    DATE(invoice_date)            AS sale_date,
    SUM(revenue)                  AS revenue,
    SUM(quantity)                 AS units,
    COUNT(DISTINCT invoice_no)    AS orders
FROM fact_sales
GROUP BY DATE(invoice_date)
ORDER BY sale_date;

-- 2) Performance par produit
DROP VIEW IF EXISTS v_product_performance CASCADE;
CREATE VIEW v_product_performance AS
SELECT
    e.stock_code,
    e.description,
    SUM(e.revenue)                                        AS total_revenue,
    SUM(e.quantity)                                       AS total_units,
    ROUND(AVG(e.discount_pct), 4)                         AS avg_discount,
    SUM(CASE WHEN e.is_promo = 1 THEN e.revenue ELSE 0 END) AS promo_revenue
FROM v_sales_enriched e
GROUP BY e.stock_code, e.description
ORDER BY total_revenue DESC;

-- 3) Effet promo : compare ventes en promo vs hors promo, par produit
DROP VIEW IF EXISTS v_promo_effect CASCADE;
CREATE VIEW v_promo_effect AS
SELECT
    stock_code,
    description,
    is_promo,
    COUNT(*)            AS n_lines,
    SUM(quantity)       AS units,
    ROUND(AVG(quantity), 2) AS avg_units_per_line,
    ROUND(AVG(unit_price), 2) AS avg_price
FROM v_sales_enriched
GROUP BY stock_code, description, is_promo;

-- 4) Points prix/quantité pour estimer l'élasticité (entrée du modèle R)
DROP VIEW IF EXISTS v_elasticity_input CASCADE;
CREATE VIEW v_elasticity_input AS
SELECT
    stock_code,
    description,
    unit_price,
    SUM(quantity)  AS units,
    COUNT(*)       AS n_obs
FROM v_sales_enriched
GROUP BY stock_code, description, unit_price
HAVING SUM(quantity) > 0;

-- 5) Synthèse des KPI globaux
DROP VIEW IF EXISTS v_kpi_summary CASCADE;
CREATE VIEW v_kpi_summary AS
SELECT
    SUM(revenue)                                              AS total_revenue,
    COUNT(DISTINCT invoice_no)                                AS total_orders,
    COUNT(DISTINCT customer_id)                               AS total_customers,
    ROUND(SUM(revenue) / COUNT(DISTINCT invoice_no), 2)       AS avg_order_value,
    ROUND(SUM(CASE WHEN is_promo = 1 THEN revenue ELSE 0 END)
          / SUM(revenue), 4)                                  AS promo_revenue_share
FROM v_sales_enriched;
