#Importar consulta para conexion
from consultas import obtener_datos

import matplotlib.pyplot as plt
import pandas as pd
from io import BytesIO
import base64


#----- Promedio de gramos por lotes

def obtener_promedio_gramos_por_lote(conexion):
    query = """
            SELECT LO.IdLote as 'Id Lote', LO.PromedioGramos as 'Promedio de Gramos'
            FROM tbllotes as LO
            ORDER BY LO.IdLote ASC
            """
    return obtener_datos(conexion, query)
def grafica_promedio_gramos_por_lote(df):
    plt.figure(figsize=(10, 5))
    plt.bar(df['Id Lote'], df['Promedio de Gramos'], color='skyblue')
    plt.title('Promedio de Gramos por Lote')
    plt.xlabel('Id Lote')
    plt.ylabel('Promedio de Gramos')
    plt.grid(True)

    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    image_png = buffer.getvalue()
    buffer.close()

    grafica_base64 = base64.b64encode(image_png).decode('utf-8')
    return f'data:image/png;base64,{grafica_base64}'

