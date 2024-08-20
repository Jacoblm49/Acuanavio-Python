#Importar consulta para conexion
from consultas import obtener_datos

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from io import BytesIO
import base64


#--- Porcentaje Ocupacion Canales -> POC

def obtener_POCtabla(conexion):
    query="""
            SELECT CA.IdCanal, EC.Descripcion AS 'Estado Canal'
            FROM tblcanales AS CA INNER JOIN tblestadocanal AS EC ON CA.EstadoCanal = EC.IdEstado; 
            """
    return obtener_datos(conexion,query)

def obtener_POC(conexion):
    query="""
        SELECT EC.Descripcion AS 'Estado Canal', COUNT(CA.IdCanal) AS 'Cantidad'
        FROM tblcanales AS CA
        INNER JOIN tblestadocanal AS EC ON CA.EstadoCanal = EC.IdEstado
        GROUP BY EC.Descripcion
        ORDER BY EC.Descripcion ASC;
        """
    return obtener_datos(conexion,query)
def grafica_POC(df):
    plt.figure(figsize=(12, 6))
    
    # Crear la gráfica de torta
    colores = ["#60D394","#EE6055",  "#AAF683", "#FFD97D", "#FF9B85"]
    plt.pie(df['Cantidad'], labels=df['Estado Canal'], autopct='%1.1f%%', startangle=10, colors=colores)
    
    # Asegurar que la gráfica sea un círculo
    plt.axis('equal')
    
    # Mejorar los estilos de título
    plt.title('Distribución de Estados de Canal', fontsize=16, fontweight='bold')
    
    # Mostrar la gráfica en el formato requerido
    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    image_png = buffer.getvalue()
    buffer.close()
    
    grafica_base64 = base64.b64encode(image_png).decode('utf-8')
    
    return f'data:image/png;base64,{grafica_base64}'

