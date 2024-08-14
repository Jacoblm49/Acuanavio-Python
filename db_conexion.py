import mysql.connector
from mysql.connector import Error

def conexion_db():
    config = {
        'user': 'root',
        'password': '',
        'host': 'localhost',
        'database': 'acuanavio',
        'raise_on_warnings': True
    }

    try: 
        conexion = mysql.connector.connect(**config)
        print("Conexion exitosa")
        return conexion
    except mysql.connector.Error as Err:
        print(f"Error: {Err}")
        return None
    
conexion_db()
