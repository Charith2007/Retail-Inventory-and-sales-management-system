import mysql.connector
from mysql.connector import Error


def create_connection():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            port=3306,
            user="root",
            password="Manulu@0207",
            database="retail_inventory_db"
        )

        if connection.is_connected():
            print("Connected to retail_inventory_db successfully!")
            return connection

    except Error as e:
        print(f"Database connection failed: {e}")

    return None


if __name__ == "__main__":
    connection = create_connection()

    if connection:
        connection.close()
        print("Connection closed.")