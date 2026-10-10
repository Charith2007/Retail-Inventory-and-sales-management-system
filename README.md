# Retail Inventory and Sales Management System

A database-driven web application developed as part of a Database Management Systems (DBMS) project.

The application helps retailers manage product information and monitor inventory levels through a web-based interface. It uses Python Flask for backend processing and MySQL/MariaDB for storing and retrieving product data.

## Features

### 1. Dashboard
- Displays the total number of products.
- Provides an overview of inventory status.
- Displays low-stock and out-of-stock counts.
- Provides navigation to product and inventory management.

### 2. Product Management
- Add new products to the database.
- View existing product records.
- Edit product information.
- Delete products.
- Search products by product code or name.
- Store product details, including category, brand, purchase price, selling price, stock quantity, and reorder level.

### 3. Inventory Management
- View available stock quantities for products.
- Display product reorder levels.
- Identify products with low stock.
- Identify products that are out of stock.
- Search inventory by product code or product name.
- Refresh inventory information using data retrieved from the database.

## Technology Stack

| Technology | Purpose |
|---|---|
| Python | Backend programming |
| Flask | Web application framework |
| MySQL/MariaDB | Relational database |
| HTML | Web page structure |
| CSS | User interface styling |
| JavaScript | Frontend interactions and API requests |
| XAMPP | Local database server environment |

## Database

The application uses a relational database named:

`retail_inventory_db`

The main product information is stored in the `Product` table.

Product records include:

- Product ID
- Product code
- Product name
- Category ID
- Brand ID
- Purchase price
- Selling price
- Stock quantity
- Reorder level

Category and brand information is maintained separately and associated with products through their respective IDs.

The application retrieves product and inventory information through Flask API endpoints.

## Project Structure

```text
app/
├── app.py
├── db.py
├── requirements.txt
├── templates/
│   └── index.html
└── static/
    ├── style.css
    └── script.js
```

Additional database scripts or project files may be included if present in the repository.

## Prerequisites

Install the following before running the project:

- Python 3
- XAMPP with MySQL/MariaDB
- Git (optional, for cloning the repository)

## Installation and Setup

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/retail-inventory-sales-management-system.git
```

Navigate into the project directory:

```bash
cd retail-inventory-sales-management-system
```

If the Flask application is inside an `app` subfolder, navigate into that folder before continuing.

### 2. Start the Database

1. Open the XAMPP Control Panel.
2. Start MySQL.
3. Ensure the `retail_inventory_db` database exists.
4. Ensure the required tables and initial category and brand records have been created.

The database schema and initial records must be available before running the application.

### 3. Create a Virtual Environment

```bash
python -m venv venv
```

Activate it on Windows:

```bash
venv\Scripts\activate
```

### 4. Install Dependencies

```bash
pip install -r requirements.txt
```

### 5. Configure the Database Connection

Configure the database connection in `db.py` to match your local MySQL/MariaDB setup.

Do not commit real passwords, secret keys, or other credentials to a public repository.

### 6. Run the Application

```bash
python app.py
```

Open the following address in your browser:

http://127.0.0.1:5000

## Current Project Scope

The current implementation focuses on three features:

1. Dashboard
2. Product Management
3. Inventory Management

The application supports product CRUD operations (Create, Read, Update, and Delete) and inventory status monitoring.

Although the project is titled Retail Inventory and Sales Management System, sales transactions, purchase management, customer management, supplier management, and reporting are not included in the current implemented feature set.

## Future Enhancements

Potential future improvements include:

- Sales transaction processing
- Purchase management
- Customer and supplier management
- Sales reports and analytics
- Invoice generation
- Stock movement history
- User authentication and role-based access

## Academic Project

Developed as part of a Database Management Systems (DBMS) project.

The project demonstrates relational database integration, backend API development, product CRUD operations, and inventory monitoring through a web interface.
