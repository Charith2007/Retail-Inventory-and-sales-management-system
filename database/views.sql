USE retail_inventory_db;

-- =========================================================
-- REPORTING VIEWS
-- =========================================================


-- =========================================================
-- 1. LOW STOCK PRODUCTS
-- Shows products whose stock is at or below reorder level.
-- =========================================================

DROP VIEW IF EXISTS vw_low_stock;

CREATE VIEW vw_low_stock AS
SELECT
    p.product_id,
    p.product_code,
    p.product_name,
    c.category_name,
    b.brand_name,
    p.stock_quantity,
    p.reorder_level
FROM Product p
JOIN Category c
    ON p.category_id = c.category_id
JOIN Brand b
    ON p.brand_id = b.brand_id
WHERE p.stock_quantity <= p.reorder_level;


-- =========================================================
-- 2. STOCK VALUATION
-- Calculates the current value of inventory.
-- =========================================================

DROP VIEW IF EXISTS vw_stock_valuation;

CREATE VIEW vw_stock_valuation AS
SELECT
    p.product_id,
    p.product_code,
    p.product_name,
    p.stock_quantity,
    p.purchase_price,
    p.selling_price,
    (p.stock_quantity * p.purchase_price) AS inventory_cost_value,
    (p.stock_quantity * p.selling_price) AS potential_sales_value
FROM Product p;


-- =========================================================
-- 3. SUPPLIER PURCHASE REPORT
-- Shows purchases made from each supplier.
-- =========================================================

DROP VIEW IF EXISTS vw_supplier_purchases;

CREATE VIEW vw_supplier_purchases AS
SELECT
    s.supplier_id,
    s.supplier_code,
    s.supplier_name,
    COUNT(DISTINCT p.purchase_id) AS total_purchases,
    COALESCE(SUM(pi.quantity), 0) AS total_items_purchased,
    COALESCE(SUM(pi.subtotal), 0) AS total_purchase_value
FROM Supplier s
LEFT JOIN Purchase p
    ON s.supplier_id = p.supplier_id
LEFT JOIN PurchaseItem pi
    ON p.purchase_id = pi.purchase_id
GROUP BY
    s.supplier_id,
    s.supplier_code,
    s.supplier_name;


-- =========================================================
-- 4. DAILY SALES REPORT
-- =========================================================

DROP VIEW IF EXISTS vw_daily_sales;

CREATE VIEW vw_daily_sales AS
SELECT
    DATE(sale_date) AS sale_date,
    COUNT(sale_id) AS total_sales,
    SUM(subtotal) AS gross_sales,
    SUM(discount) AS total_discount,
    SUM(total_amount) AS net_sales
FROM Sale
GROUP BY DATE(sale_date);


-- =========================================================
-- 5. MONTHLY SALES REPORT
-- =========================================================

DROP VIEW IF EXISTS vw_monthly_sales;

CREATE VIEW vw_monthly_sales AS
SELECT
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    COUNT(sale_id) AS total_sales,
    SUM(subtotal) AS gross_sales,
    SUM(discount) AS total_discount,
    SUM(total_amount) AS net_sales
FROM Sale
GROUP BY
    YEAR(sale_date),
    MONTH(sale_date);


-- =========================================================
-- 6. RETURN REPORT
-- =========================================================

DROP VIEW IF EXISTS vw_returns;

CREATE VIEW vw_returns AS
SELECT
    r.return_id,
    r.return_date,
    p.product_code,
    p.product_name,
    r.quantity,
    r.reason,
    r.refund_amount
FROM ProductReturn r
JOIN SaleItem si
    ON r.sale_item_id = si.sale_item_id
JOIN Product p
    ON si.product_id = p.product_id;


-- =========================================================
-- 7. FAST-MOVING PRODUCTS
-- Products ranked by quantity sold.
-- =========================================================

DROP VIEW IF EXISTS vw_fast_moving_products;

CREATE VIEW vw_fast_moving_products AS
SELECT
    p.product_id,
    p.product_code,
    p.product_name,
    SUM(si.quantity) AS total_quantity_sold,
    SUM(si.subtotal) AS total_sales_value
FROM Product p
JOIN SaleItem si
    ON p.product_id = si.product_id
GROUP BY
    p.product_id,
    p.product_code,
    p.product_name
ORDER BY total_quantity_sold DESC;


-- =========================================================
-- 8. PRODUCT PROFIT REPORT
-- Estimates profit using selling price - purchase price.
-- =========================================================

DROP VIEW IF EXISTS vw_product_profit;

CREATE VIEW vw_product_profit AS
SELECT
    p.product_id,
    p.product_code,
    p.product_name,
    SUM(si.quantity) AS quantity_sold,
    SUM(si.quantity * si.unit_price) AS sales_value,
    SUM(si.quantity * p.purchase_price) AS cost_value,
    SUM(
        si.quantity * (si.unit_price - p.purchase_price)
    ) AS estimated_profit
FROM Product p
JOIN SaleItem si
    ON p.product_id = si.product_id
GROUP BY
    p.product_id,
    p.product_code,
    p.product_name;
    
SELECT *
FROM vw_low_stock;

SELECT *
FROM vw_product_profit
ORDER BY estimated_profit DESC;

SELECT * FROM vw_fast_moving_products;

SELECT * FROM vw_stock_valuation;

SELECT * FROM vw_daily_sales;

SELECT * FROM vw_product_profit
ORDER BY estimated_profit DESC;

SELECT USER(), CURRENT_USER();

ALTER USER 'root'@'localhost'
IDENTIFIED BY 'Manulu@0207';

FLUSH PRIVILEGES;

SELECT
    @@hostname AS host,
    @@port AS port,
    @@version AS mysql_version;
    
SELECT User, Host
FROM mysql.user
WHERE User = 'root';

CREATE USER IF NOT EXISTS 'root'@'LAPTOP-LLH42S8L'
IDENTIFIED BY 'Manulu@0207';