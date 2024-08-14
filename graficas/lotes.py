import matplotlib.pyplot as plt
import pandas as pd
from io import BytesIO
import base64

def grafica_PromIngresos(df):
    plt.figure(figsize=(10, 5))
    plt.plot(df[df.columns[1]], df[df.columns[3]], marker='o')
    plt.title('Promedio de fecha de ingresos')
    plt.xlabel(df.columns[1])
    plt.ylabel(df.columns[3])
    plt.grid(True)

    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    image_png = buffer.getvalue()
    buffer.close()

    grafica_base64 = base64.b64encode(image_png).decode('utf-8')
    return f'data:image/png;base64,{grafica_base64}'

def crear_grafica2(df):
    plt.figure(figsize=(10, 5))
    plt.bar(df[df.columns[4]], df[df.columns[0]], color='skyblue')
    plt.title('Promedio en pesos')
    plt.xlabel(df.columns[4])
    plt.ylabel(df.columns[0])
    plt.grid(True)

    buffer = BytesIO()
    plt.savefig(buffer, format='png')
    buffer.seek(0)
    image_png = buffer.getvalue()
    buffer.close()

    grafica_base64 = base64.b64encode(image_png).decode('utf-8')
    return f'data:image/png;base64,{grafica_base64}'

def crear_grafica3(df):
    # grafica_base64 = base64.b64encode(image_png).decode('utf-8') --> Convertir imagen apta para UTF-8 web
     plt.figure(figsize=(10,5))
     plt.bar(df[df.columns[4]], df[df.columns[0]], color='red')
     plt.title('Prom')