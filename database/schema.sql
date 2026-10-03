-- =========================================================
-- RETAIL INVENTORY AND SALES MANAGEMENT SYSTEM
-- Database Schema
-- =========================================================

CREATE DATABASE IF NOT EXISTS retail_inventory_db;

USE retail_inventory_db;


-- =========================================================
-- 1. CATEGORY
-- =========================================================

CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);


-- =========================================================
-- 2. BRAND
-- =========================================================

CREATE TABLE Brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL UNIQUE
);


-- =========================================================
-- 3. SUPPLIER
-- =========================================================

CREATE TABLE Supplier (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_code VARCHAR(50) NOT NULL UNIQUE,
    supplier_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(150) UNIQUE,
    address VARCHAR(255)
);


-- =========================================================
-- 4. CUSTOMER
-- =========================================================

CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_code VARCHAR(50) NOT NULL UNIQUE,
    customer_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(150) UNIQUE,
    address VARCHAR(255)
);


-- =========================================================
-- 5. PRODUCT
-- =========================================================

CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,

    product_code VARCHAR(50) NOT NULL UNIQUE,
    product_name VARCHAR(150) NOT NULL,

    category_id INT NOT NULL,
    brand_id INT NOT NULL,

    purchase_price DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,

    stock_quantity INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,

    CONSTRAINT chk_product_purchase_price
        CHECK (purchase_price > 0),

    CONSTRAINT chk_product_selling_price
        CHECK (selling_price > 0),

    CONSTRAINT chk_product_stock
        CHECK (stock_quantity >= 0),

    CONSTRAINT chk_product_reorder_level
        CHECK (reorder_level >= 0),

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES Category(category_id),

    CONSTRAINT fk_product_brand
        FOREIGN KEY (brand_id)
        REFERENCES Brand(brand_id)
);


-- =========================================================
-- 6. PURCHASE
-- =========================================================

CREATE TABLE Purchase (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,

    supplier_id INT NOT NULL,

    purchase_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT chk_purchase_total
        CHECK (total_amount >= 0),

    CONSTRAINT fk_purchase_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES Supplier(supplier_id)
);


-- =========================================================
-- 7. PURCHASE ITEM
-- =========================================================

CREATE TABLE PurchaseItem (
    purchase_item_id INT AUTO_INCREMENT PRIMARY KEY,

    purchase_id INT NOT NULL,
    product_id INT NOT NULL,

    quantity INT NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,

    subtotal DECIMAL(12,2)
        GENERATED ALWAYS AS (quantity * unit_cost) STORED,

    CONSTRAINT chk_purchase_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_purchase_item_cost
        CHECK (unit_cost > 0),

    CONSTRAINT uq_purchase_product
        UNIQUE (purchase_id, product_id),

    CONSTRAINT fk_purchase_item_purchase
        FOREIGN KEY (purchase_id)
        REFERENCES Purchase(purchase_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_purchase_item_product
        FOREIGN KEY (product_id)
        REFERENCES Product(product_id)
);


-- =========================================================
-- 8. SALE
-- =========================================================

CREATE TABLE Sale (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,

    customer_id INT NULL,

    sale_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
    discount DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT chk_sale_subtotal
        CHECK (subtotal >= 0),

    CONSTRAINT chk_sale_discount
        CHECK (discount >= 0),

    CONSTRAINT chk_sale_total
        CHECK (total_amount >= 0),

    CONSTRAINT chk_sale_discount_limit
        CHECK (discount <= subtotal),

    CONSTRAINT fk_sale_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
);


-- =========================================================
-- 9. SALE ITEM
-- =========================================================

CREATE TABLE SaleItem (
    sale_item_id INT AUTO_INCREMENT PRIMARY KEY,

    sale_id INT NOT NULL,
    product_id INT NOT NULL,

    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    subtotal DECIMAL(12,2)
        GENERATED ALWAYS AS (quantity * unit_price) STORED,

    CONSTRAINT chk_sale_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_sale_item_price
        CHECK (unit_price > 0),

    CONSTRAINT uq_sale_product
        UNIQUE (sale_id, product_id),

    CONSTRAINT fk_sale_item_sale
        FOREIGN KEY (sale_id)
        REFERENCES Sale(sale_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_sale_item_product
        FOREIGN KEY (product_id)
        REFERENCES Product(product_id)
);


-- =========================================================
-- 10. PRODUCT RETURN
-- =========================================================

CREATE TABLE ProductReturn (
    return_id INT AUTO_INCREMENT PRIMARY KEY,

    sale_item_id INT NOT NULL,

    quantity INT NOT NULL,

    return_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    reason VARCHAR(255),

    refund_amount DECIMAL(12,2) NOT NULL DEFAULT 0,

    CONSTRAINT chk_return_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_return_refund
        CHECK (refund_amount >= 0),

    CONSTRAINT fk_return_sale_item
        FOREIGN KEY (sale_item_id)
        REFERENCES SaleItem(sale_item_id)
);


-- =========================================================
-- 11. STOCK MOVEMENT
-- =========================================================

CREATE TABLE StockMovement (
    movement_id INT AUTO_INCREMENT PRIMARY KEY,

    product_id INT NOT NULL,

    movement_type ENUM(
        'PURCHASE',
        'SALE',
        'RETURN',
        'ADJUSTMENT'
    ) NOT NULL,

    quantity INT NOT NULL,

    reference_id INT NULL,

    movement_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    remarks VARCHAR(255),

    CONSTRAINT chk_stock_movement_quantity
        CHECK (quantity > 0),

    CONSTRAINT fk_stock_movement_product
        FOREIGN KEY (product_id)
        REFERENCES Product(product_id)
);


-- =========================================================
-- 12. INVOICE
-- =========================================================

CREATE TABLE Invoice (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,

    sale_id INT NOT NULL UNIQUE,

    invoice_code VARCHAR(50) NOT NULL UNIQUE,

    invoice_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    status ENUM(
        'UNPAID',
        'PARTIALLY_PAID',
        'PAID',
        'CANCELLED'
    ) NOT NULL DEFAULT 'UNPAID',

    CONSTRAINT fk_invoice_sale
        FOREIGN KEY (sale_id)
        REFERENCES Sale(sale_id)
);


-- =========================================================
-- 13. PAYMENT
-- =========================================================

CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,

    invoice_id INT NOT NULL,

    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    amount DECIMAL(12,2) NOT NULL,

    payment_method ENUM(
        'CASH',
        'CARD',
        'UPI',
        'BANK_TRANSFER'
    ) NOT NULL,

    CONSTRAINT chk_payment_amount
        CHECK (amount > 0),

    CONSTRAINT fk_payment_invoice
        FOREIGN KEY (invoice_id)
        REFERENCES Invoice(invoice_id)
        ON DELETE CASCADE
);


-- =========================================================
-- INDEXES
-- =========================================================

CREATE INDEX idx_product_name
ON Product(product_name);

CREATE INDEX idx_product_category
ON Product(category_id);

CREATE INDEX idx_product_brand
ON Product(brand_id);

CREATE INDEX idx_purchase_date
ON Purchase(purchase_date);

CREATE INDEX idx_sale_date
ON Sale(sale_date);

CREATE INDEX idx_stock_product
ON StockMovement(product_id);

CREATE INDEX idx_customer_name
ON Customer(customer_name);

CREATE INDEX idx_supplier_name
ON Supplier(supplier_name);