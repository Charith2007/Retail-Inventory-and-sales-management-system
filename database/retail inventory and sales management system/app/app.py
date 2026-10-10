from flask import Flask, render_template, jsonify, request
from db import create_connection

app = Flask(__name__)


@app.route("/")
def home():
    return render_template("index.html")


# Retrieve all products
# Retrieve all products
@app.route("/api/products", methods=["GET"])
def get_products():
    connection = create_connection()

    if connection is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                product_id,
                product_code,
                product_name,
                category_id,
                brand_id,
                purchase_price,
                selling_price,
                stock_quantity,
                reorder_level
            FROM Product
            ORDER BY product_id DESC
        """)

        products = cursor.fetchall()
        return jsonify(products)

    except Exception as error:
        return jsonify({"error": str(error)}), 500

    finally:
        if cursor:
            cursor.close()
        connection.close()

# Retrieve all brands
@app.route("/api/brands", methods=["GET"])
def get_brands():
    connection = create_connection()

    if connection is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM Brand")
        brands = cursor.fetchall()
        return jsonify(brands)

    except Exception as error:
        return jsonify({"error": str(error)}), 500

    finally:
        if cursor:
            cursor.close()
        connection.close()
    



# Add a product
@app.route("/api/products", methods=["POST"])
def add_product():
    data = request.get_json(silent=True) or {}

    required_fields = [
        "product_code",
        "product_name",
        "category_id",
        "brand_id",
        "purchase_price",
        "selling_price",
        "stock_quantity",
        "reorder_level"
    ]

    missing = [
        field for field in required_fields
        if data.get(field) is None or data.get(field) == ""
    ]
    print("Received product data:", data)
    print("Missing fields:", missing)

    if missing:
        return jsonify({
            "error": "Missing required fields",
            "fields": missing
        }), 400

    try:
        category_id = int(data["category_id"])
        brand_id = int(data["brand_id"])
        purchase_price = float(data["purchase_price"])
        selling_price = float(data["selling_price"])
        stock_quantity = int(data["stock_quantity"])
        reorder_level = int(data["reorder_level"])

        if (
            category_id <= 0
            or brand_id <= 0
            or purchase_price < 0
            or selling_price < 0
            or stock_quantity < 0
            or reorder_level < 0
        ):
            raise ValueError("IDs must be positive and other values non-negative.")

    except (ValueError, TypeError):
        return jsonify({
            "error": "Enter valid numeric values. IDs must be positive, and prices, stock and reorder level cannot be negative."
        }), 400

    connection = create_connection()

    if connection is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = None

    try:
        cursor = connection.cursor()

        query = """
            INSERT INTO Product (
                product_code,
                product_name,
                category_id,
                brand_id,
                purchase_price,
                selling_price,
                stock_quantity,
                reorder_level
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """

        values = (
            data["product_code"].strip(),
            data["product_name"].strip(),
            category_id,
            brand_id,
            purchase_price,
            selling_price,
            stock_quantity,
            reorder_level
        )

        if not values[0] or not values[1]:
            return jsonify({
                "error": "Product code and product name cannot be blank."
            }), 400

        cursor.execute(query, values)
        connection.commit()

        return jsonify({
            "message": "Product added successfully!",
            "product_id": cursor.lastrowid
        }), 201

    except Exception as error:
        connection.rollback()
        return jsonify({"error": str(error)}), 400

    finally:
        if cursor:
            cursor.close()
        connection.close()

# Get all categories for the dropdown
# Update an existing product
@app.route("/api/products/<int:product_id>", methods=["PUT"])
def update_product(product_id):
    data = request.get_json(silent=True) or {}

    required_fields = [
        "product_code",
        "product_name",
        "category_id",
        "brand_id",
        "purchase_price",
        "selling_price",
        "stock_quantity",
        "reorder_level"
    ]

    if any(data.get(field) is None or data.get(field) == "" for field in required_fields):
        return jsonify({"error": "All fields are required."}), 400

    try:
        values = (
            data["product_code"].strip(),
            data["product_name"].strip(),
            int(data["category_id"]),
            int(data["brand_id"]),
            float(data["purchase_price"]),
            float(data["selling_price"]),
            int(data["stock_quantity"]),
            int(data["reorder_level"]),
            product_id
        )

        if (
            not values[0]
            or not values[1]
            or values[2] <= 0
            or values[3] <= 0
            or values[4] < 0
            or values[5] < 0
            or values[6] < 0
            or values[7] < 0
        ):
            return jsonify({"error": "Enter valid product details."}), 400

    except (ValueError, TypeError, AttributeError):
        return jsonify({"error": "Invalid product details."}), 400

    connection = create_connection()

    if connection is None:
        return jsonify({"error": "Database connection failed."}), 500

    cursor = None

    try:
        cursor = connection.cursor()

        cursor.execute("""
            UPDATE Product
            SET product_code = %s,
                product_name = %s,
                category_id = %s,
                brand_id = %s,
                purchase_price = %s,
                selling_price = %s,
                stock_quantity = %s,
                reorder_level = %s
            WHERE product_id = %s
        """, values)

        if cursor.rowcount == 0:
            cursor.execute(
                "SELECT product_id FROM Product WHERE product_id = %s",
                (product_id,)
            )

            if cursor.fetchone() is None:
                return jsonify({"error": "Product not found."}), 404

        connection.commit()

        return jsonify({"message": "Product updated successfully."})

    except Exception as error:
        connection.rollback()
        return jsonify({"error": str(error)}), 400

    finally:
        if cursor:
            cursor.close()
        connection.close()


# Delete an existing product
@app.route("/api/products/<int:product_id>", methods=["DELETE"])
def delete_product(product_id):
    connection = create_connection()

    if connection is None:
        return jsonify({"error": "Database connection failed."}), 500

    cursor = None

    try:
        cursor = connection.cursor()

        cursor.execute(
            "DELETE FROM Product WHERE product_id = %s",
            (product_id,)
        )

        if cursor.rowcount == 0:
            return jsonify({"error": "Product not found."}), 404

        connection.commit()

        return jsonify({"message": "Product deleted successfully."})

    except Exception as error:
        connection.rollback()
        return jsonify({
            "error": "Could not delete this product. It may be referenced by existing sales, purchases, or stock movements."
        }), 409

    finally:
        if cursor:
            cursor.close()
        connection.close()

@app.route("/api/categories", methods=["GET"])
def get_categories():
    connection = create_connection()

    if connection is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("""
            SELECT category_id, category_name
            FROM Category
            ORDER BY category_name
        """)

        return jsonify(cursor.fetchall())

    except Exception as error:
        return jsonify({"error": str(error)}), 500

    finally:
        if cursor:
            cursor.close()
        connection.close()


# Get all brands for the dropdown
@app.route("/api/stock", methods=["GET"])
def get_stock():
    connection = create_connection()

    if connection is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                product_id,
                product_code,
                product_name,
                stock_quantity,
                reorder_level,
                CASE
                    WHEN stock_quantity = 0 THEN 'Out of Stock'
                    WHEN stock_quantity <= reorder_level THEN 'Low Stock'
                    ELSE 'In Stock'
                END AS stock_status
            FROM Product
            ORDER BY product_name
        """)

        stock = cursor.fetchall()
        return jsonify(stock)

    except Exception as error:
        return jsonify({"error": str(error)}), 500

    finally:
        if cursor:
            cursor.close()
        connection.close()

if __name__ == "__main__":
    app.run(debug=True)