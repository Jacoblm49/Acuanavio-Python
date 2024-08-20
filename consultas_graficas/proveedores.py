#Importar consulta para conexion
from consultas import obtener_datos

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from io import BytesIO
import base64


#---- Unidades Vendidas -> UV
def obtener_UV(conexion):
    query="""
            SELECT 
                PR.DocIdentidad AS 'Doc de Identidad', 
                PR.Nombre AS 'Nombre del Proveedor',
                SUM(LO.Unidades) AS 'Total de Unidades Vendidas'
            FROM 
                tblprovedores AS PR
            INNER JOIN 
                tbllotes AS LO ON PR.DocIdentidad = LO.Provedor
            GROUP BY 
                PR.DocIdentidad, PR.Nombre
            ORDER BY 
                'Total de Unidades Vendidas' DESC;
        """
    return obtener_datos(conexion, query)
def grafica_UV(df):
    plt.figure(figsize=(12,6))

    barras = plt.bar(df['Nombre del Proveedor'], df['Total de Unidades Vendidas'], color='skyblue')

    #Añadir etiquetas con el valor de unidades por encima de la barra
    for barra in barras:
        yval = barra.get_height()
        plt.text(barra.get_x() + barra.get_width()/2.0, yval + 0.05, 
                 round(yval, 2), ha='center',  fontsize=10, color='black', rotation=90)
        
    # Configurar los nombres en el eje X
    plt.xticks(df['Nombre del Proveedor'], df['Nombre del Proveedor'], fontsize=10)

    #Configurar estilos y ejes
    plt.title('Total unidades vendidas por proveedor',fontsize=16, fontweight='bold') 
    plt.xlabel('Nombre', fontsize=14)   
    plt.ylabel('Unidades vendidas', fontsize=14)


    #Ajustar rango del eje Y
    plt.ylim([0, max(df['Total de Unidades Vendidas'])+20000])
    #Fondo de cuadricula
    plt.grid(axis="y", linestyle="--")

    #Obtener promedio
    promedio_ventas =  round(df['Total de Unidades Vendidas'].mean(),2)

    # Obtener el valor máximo y el nombre del proveedor correspondiente
    topVentas = df['Total de Unidades Vendidas'].max()
    topVentas_nombre = df.loc[df['Total de Unidades Vendidas'].idxmax(), 'Nombre del Proveedor']

    #Mostrar la grafica en el formato requerido
    buffer = BytesIO()
    plt.savefig(buffer, format="png")
    buffer.seek(0)
    image_png = buffer.getvalue()
    buffer.close()

    grafica_base64 = base64.b64encode(image_png).decode('utf-8')
    return f'data:image/png;base64,{grafica_base64}',promedio_ventas, topVentas,topVentas_nombre

