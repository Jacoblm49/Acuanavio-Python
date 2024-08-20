#Importar consulta para conexion
from consultas import obtener_datos

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from io import BytesIO
import base64


#--- Cantidad insumo consumido por lote -> CICL

def obtener_CICL(conexion):
    query="""
            SELECT LC.Lote AS 'Lote', SUM(AL.Cantidad) AS 'Cantidad Total en KG'
            FROM tblalimentacion AS AL
            INNER JOIN tbllotecanal AS LC ON AL.LoteCanal = LC.IdLoteCanal
            GROUP BY LC.Lote
            ORDER BY LC.Lote ASC;
        """
    return obtener_datos(conexion, query)

def grafica_CICL(df):
    plt.figure(figsize=(12,6))

    barras= plt.bar(df['Lote'], df['Cantidad Total en KG'], color='skyblue')

    # Añadir etiquetas con el valor del promedio encima de las barras
    for barra in barras:
        yval = barra.get_height()
        plt.text(barra.get_x() + barra.get_width()/2.0, yval + 0.05, 
                 round(yval, 2), ha='center',  fontsize=10, color='black', rotation=90)
        
    # Configurar los IDs de lote en el eje X
    plt.xticks(df['Lote'], df['Lote'], fontsize=10)

    #Estilos
    plt.title('Cantidad de insumo consumido por lote', fontsize=16)
    plt.xlabel('Id Lote', fontsize=14)
    plt.ylabel('KG consumidos de insumo',fontsize=14)

    # Ajustar el rango del eje Y
    plt.ylim(0, max(df['Cantidad Total en KG']) * 2)

    #Fondo de cuadricula
    plt.grid(axis='y', linestyle='--')

    lote_mayor= round(df['Cantidad Total en KG'].max(),2)
    lote_mayor_nombre = df.loc[df['Cantidad Total en KG'].idxmax(), 'Lote']

      # Mostrar la gráfica en el formato requerido
    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    image_png = buffer.getvalue()
    buffer.close()

    grafica_base64 = base64.b64encode(image_png).decode('utf-8')
    return f'data:image/png;base64,{grafica_base64}', lote_mayor,lote_mayor_nombre
        
