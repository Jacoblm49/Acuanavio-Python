#Importar consulta para conexion
from consultas import obtener_datos

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from io import BytesIO
import base64


#----- Promedio de gramos por lotes -> PGL
def obtener_PGL(conexion):
    query = """
            SELECT LO.IdLote as 'Id Lote', LO.PromedioGramos as 'Promedio de Gramos'
            FROM tbllotes as LO
            ORDER BY LO.IdLote ASC
            """
    return obtener_datos(conexion, query)

def grafica_PGL(df):
    plt.figure(figsize=(12, 6))
    
    # Crear la gráfica de barras
    barras = plt.bar(df['Id Lote'], df['Promedio de Gramos'], color='skyblue')
    
    # Añadir etiquetas con el valor del promedio encima de las barras
    for barra in barras:
        yval = barra.get_height()
        plt.text(barra.get_x() + barra.get_width()/2.0, yval + 0.05, 
                 round(yval, 2), ha='center',  fontsize=10, color='black', rotation=90)
    
    # Configurar los IDs de lote en el eje X
    plt.xticks(df['Id Lote'], df['Id Lote'], fontsize=10)
    
    #Estilos de título y ejes
    plt.title('Promedio de Gramos por Lote', fontsize=16, fontweight='bold')
    plt.xlabel('Id Lote', fontsize=14)
    plt.ylabel('Promedio de Gramos', fontsize=14)

    # Ajustar el rango del eje Y
    plt.ylim(0, max(df['Promedio de Gramos']) + 1)
    
    # Añadir un fondo de cuadrícula más ligero
    plt.grid(axis='y', linestyle='--')

    promedio_general = round(df['Promedio de Gramos'].mean(),2)

    if promedio_general > 4.5:
        estado_peso = "buen peso"
    else:
        estado_peso = "mal peso"

    
    # Mostrar la gráfica en el formato requerido
    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    image_png = buffer.getvalue()
    buffer.close()

    grafica_base64 = base64.b64encode(image_png).decode('utf-8')
    return f'data:image/png;base64,{grafica_base64}', promedio_general, estado_peso

#----- Promedio de costos por lote -> PCL
def obtener_PCL(conexion):
    query = """
            SELECT LO.IdLote as 'Id Lote', LO.PrecioUnidad as 'Precio unidad'
            FROM tbllotes as LO
            ORDER BY LO.IdLote ASC;
            """
    return obtener_datos(conexion, query)
def grafica_PCL(df):
    plt.figure(figsize=(12, 6))
    
    # Crear la gráfica de barras
    barras =  plt.bar(df['Id Lote'], df['Precio unidad'], color='skyblue')
    
    # Añadir etiquetas con el valor del promedio encima de las barras
    for barra in barras:
        yval = barra.get_height()
        plt.text(barra.get_x() + barra.get_width()/2.0, yval + 0.05, 
                 round(yval, 2), ha='center',  fontsize=10, color='black', rotation=90)
    
    # Configurar los IDs de lote en el eje X
    plt.xticks(df['Id Lote'], df['Id Lote'], fontsize=10)
    
    # Mejorar los estilos de título y ejes
    plt.title('Promedio de costos por Lote', fontsize=16, fontweight='bold')
    plt.xlabel('Id Lote', fontsize=14)
    plt.ylabel('Promedio de costos', fontsize=14)

    # Ajustar el rango del eje Y
    plt.ylim(0, max(df['Precio unidad']) + 100)
    
    # Añadir un fondo de cuadrícula más ligero
    plt.grid(axis='y', linestyle='--')

    promedio_general = round(df['Precio unidad'].mean())

    # if promedio_general > 4.5:
    #     estado_peso = "buen peso"
    # else:
    #     estado_peso = "mal peso"

    
    # # Mostrar la gráfica en el formato requerido
    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    image_png = buffer.getvalue()
    buffer.close()

    grafica_base64 = base64.b64encode(image_png).decode('utf-8')
    return f'data:image/png;base64,{grafica_base64}', promedio_general