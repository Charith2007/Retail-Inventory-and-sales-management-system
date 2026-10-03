USE retail_inventory_db;

-- =========================================================
-- 1. CATEGORIES
-- =========================================================

INSERT INTO Category (category_name, description) VALUES
('Beverages', 'Soft drinks, juices and packaged beverages'),
('Snacks', 'Chips, biscuits and packaged snacks'),
('Personal Care', 'Personal hygiene and grooming products'),
('Groceries', 'Daily household grocery products'),
('Stationery', 'Writing and school/office stationery');


-- =========================================================
-- 2. BRANDS
-- =========================================================

INSERT INTO Brand (brand_name) VALUES
('Coca-Cola'),
('Pepsi'),
('Parle'),
('Nestle'),
('Dove'),
('Surf Excel'),
('Classmate'),
('Britannia');


-- =========================================================
-- 3. SUPPLIERS
-- =========================================================

INSERT INTO Supplier
(supplier_code, supplier_name, phone, email, address)
VALUES
('SUP001', 'Hyderabad Wholesale Mart', '9876500011',
 'sales@hydwholesale.com', 'Ameerpet, Hyderabad'),

('SUP002', 'Metro Distributors', '9876500012',
 'contact@metrodistributors.com', 'Kukatpally, Hyderabad'),

('SUP003', 'Sai Retail Suppliers', '9876500013',
 'sales@sairetail.com', 'Madhapur, Hyderabad'),

('SUP004', 'City Super Distributors', '9876500014',
 'info@citysuper.com', 'Secunderabad, Hyderabad');


-- =========================================================
-- 4. CUSTOMERS
-- =========================================================

INSERT INTO Customer
(customer_code, customer_name, phone, email, address)
VALUES
('CUS001', 'Rahul Sharma', '9000000001',
 'rahul@example.com', 'Madhapur, Hyderabad'),

('CUS002', 'Ananya Reddy', '9000000002',
 'ananya@example.com', 'Gachibowli, Hyderabad'),

('CUS003', 'Arjun Kumar', '9000000003',
 'arjun@example.com', 'Kondapur, Hyderabad'),

('CUS004', 'Priya Singh', '9000000004',
 'priya@example.com', 'Kukatpally, Hyderabad'),

('CUS005', 'Karthik Rao', '9000000005',
 'karthik@example.com', 'Begumpet, Hyderabad');


-- =========================================================
-- 5. PRODUCTS
-- =========================================================

INSERT INTO Product
(product_code, product_name, category_id, brand_id,
 purchase_price, selling_price, stock_quantity, reorder_level)
VALUES

('PRD001', 'Coca-Cola 500ml',
 1, 1, 30.00, 40.00, 50, 15),

('PRD002', 'Pepsi 500ml',
 1, 2, 28.00, 38.00, 45, 15),

('PRD003', 'Parle-G Biscuits',
 2, 3, 8.00, 10.00, 100, 20),

('PRD004', 'Nestle Maggi 70g',
 4, 4, 12.00, 15.00, 80, 20),

('PRD005', 'Dove Soap 100g',
 3, 5, 35.00, 45.00, 30, 10),

('PRD006', 'Surf Excel 1kg',
 4, 6, 110.00, 135.00, 25, 10),

('PRD007', 'Classmate Notebook',
 5, 7, 45.00, 60.00, 40, 10),

('PRD008', 'Britannia Good Day',
 2, 8, 20.00, 25.00, 70, 15);


-- =========================================================
-- 6. PURCHASES
-- =========================================================

INSERT INTO Purchase
(supplier_id, purchase_date, total_amount)
VALUES
(1, '2026-09-20 10:30:00', 5000.00),

(2, '2026-09-22 11:15:00', 6500.00),

(3, '2026-09-25 09:45:00', 4200.00),

(4, '2026-09-28 14:00:00', 3500.00);


-- =========================================================
-- 7. PURCHASE ITEMS
-- =========================================================

INSERT INTO PurchaseItem
(purchase_id, product_id, quantity, unit_cost)
VALUES
(1, 1, 100, 30.00),
(1, 3, 100, 8.00),

(2, 2, 100, 28.00),
(2, 4, 100, 12.00),

(3, 5, 50, 35.00),
(3, 6, 30, 110.00),

(4, 7, 50, 45.00),
(4, 8, 80, 20.00);


-- =========================================================
-- 8. SALES
-- =========================================================

INSERT INTO Sale
(customer_id, sale_date, subtotal, discount, total_amount)
VALUES
(1, '2026-09-29 10:15:00', 120.00, 10.00, 110.00),

(2, '2026-09-29 13:30:00', 180.00, 0.00, 180.00),

(3, '2026-09-30 11:20:00', 200.00, 20.00, 180.00),

(4, '2026-09-30 16:45:00', 270.00, 20.00, 250.00),

(5, '2026-10-01 12:10:00', 150.00, 0.00, 150.00),

(1, '2026-10-02 18:00:00', 200.00, 10.00, 190.00);


-- =========================================================
-- 9. SALE ITEMS
-- =========================================================

INSERT INTO SaleItem
(sale_id, product_id, quantity, unit_price)
VALUES
(1, 1, 2, 40.00),
(1, 3, 4, 10.00),

(2, 2, 3, 38.00),
(2, 4, 5, 15.00),

(3, 3, 10, 10.00),
(3, 8, 4, 25.00),

(4, 5, 2, 45.00),
(4, 6, 1, 135.00),
(4, 7, 1, 60.00),

(5, 4, 10, 15.00),

(6, 1, 3, 40.00),
(6, 8, 3, 25.00);


-- =========================================================
-- 10. PRODUCT RETURNS
-- =========================================================

INSERT INTO ProductReturn
(sale_item_id, quantity, return_date, reason, refund_amount)
VALUES
(1, 1, '2026-09-29 17:30:00',
 'Damaged packaging', 40.00),

(6, 1, '2026-09-30 10:00:00',
 'Customer changed product', 38.00);


-- =========================================================
-- 11. STOCK MOVEMENTS
-- =========================================================

INSERT INTO StockMovement
(product_id, movement_type, quantity, reference_id, movement_date, remarks)
VALUES

(1, 'PURCHASE', 100, 1,
 '2026-09-20 10:30:00', 'Initial purchase'),

(3, 'PURCHASE', 100, 1,
 '2026-09-20 10:30:00', 'Initial purchase'),

(2, 'PURCHASE', 100, 2,
 '2026-09-22 11:15:00', 'Stock replenishment'),

(4, 'PURCHASE', 100, 2,
 '2026-09-22 11:15:00', 'Stock replenishment'),

(5, 'PURCHASE', 50, 3,
 '2026-09-25 09:45:00', 'Stock replenishment'),

(6, 'PURCHASE', 30, 3,
 '2026-09-25 09:45:00', 'Stock replenishment'),

(7, 'PURCHASE', 50, 4,
 '2026-09-28 14:00:00', 'Stock replenishment'),

(8, 'PURCHASE', 80, 4,
 '2026-09-28 14:00:00', 'Stock replenishment'),

(1, 'SALE', 2, 1,
 '2026-09-29 10:15:00', 'Sale transaction'),

(3, 'SALE', 4, 1,
 '2026-09-29 10:15:00', 'Sale transaction'),

(2, 'SALE', 3, 2,
 '2026-09-29 13:30:00', 'Sale transaction'),

(4, 'SALE', 5, 2,
 '2026-09-29 13:30:00', 'Sale transaction'),

(3, 'SALE', 10, 3,
 '2026-09-30 11:20:00', 'Sale transaction'),

(8, 'SALE', 4, 3,
 '2026-09-30 11:20:00', 'Sale transaction'),

(5, 'SALE', 2, 4,
 '2026-09-30 16:45:00', 'Sale transaction'),

(6, 'SALE', 1, 4,
 '2026-09-30 16:45:00', 'Sale transaction'),

(7, 'SALE', 1, 4,
 '2026-09-30 16:45:00', 'Sale transaction'),

(4, 'SALE', 10, 5,
 '2026-10-01 12:10:00', 'Sale transaction'),

(1, 'SALE', 3, 6,
 '2026-10-02 18:00:00', 'Sale transaction'),

(8, 'SALE', 3, 6,
 '2026-10-02 18:00:00', 'Sale transaction'),

(1, 'RETURN', 1, 1,
 '2026-09-29 17:30:00', 'Damaged product returned'),

(2, 'RETURN', 1, 2,
 '2026-09-30 10:00:00', 'Customer return');


-- =========================================================
-- 12. INVOICES
-- =========================================================

INSERT INTO Invoice
(sale_id, invoice_code, invoice_date, status)
VALUES
(1, 'INV-20260929-001', '2026-09-29 10:15:00', 'PAID'),

(2, 'INV-20260929-002', '2026-09-29 13:30:00', 'PAID'),

(3, 'INV-20260930-001', '2026-09-30 11:20:00', 'PAID'),

(4, 'INV-20260930-002', '2026-09-30 16:45:00', 'PARTIALLY_PAID'),

(5, 'INV-20261001-001', '2026-10-01 12:10:00', 'PAID'),

(6, 'INV-20261002-001', '2026-10-02 18:00:00', 'UNPAID');


-- =========================================================
-- 13. PAYMENTS
-- =========================================================

INSERT INTO Payment
(invoice_id, payment_date, amount, payment_method)
VALUES
(1, '2026-09-29 10:20:00', 110.00, 'UPI'),

(2, '2026-09-29 13:35:00', 180.00, 'CARD'),

(3, '2026-09-30 11:25:00', 180.00, 'CASH'),

(4, '2026-09-30 16:50:00', 150.00, 'UPI'),

(5, '2026-10-01 12:15:00', 150.00, 'CARD');