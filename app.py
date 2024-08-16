# app.py
from flask import Flask, render_template
#conexion bd
from db_conexion import conexion_db

#Consultas generales DF
from consultas import obtener_todos_canales, obtener_todos_lotes, obtener_todos_proveedores

#Subconsultas, tablas y graficas
from consultas_graficas.lotes import obtener_promedio_gramos_por_lote,grafica_promedio_gramos_por_lote

app = Flask("Acuanavio_python")

@app.route('/')
def index():
    return render_template("index.html")

@app.route('/Canales')
def canales():
    conexion = conexion_db()
    if conexion:
        df = obtener_todos_canales(conexion)
        conexion.close()
        if df is not None:
            return render_template("canales.html", tables=[df.to_html(classes='data')], tittles=df.columns.values)
        return "Error en la consulta tblcanales a la base de datos"

@app.route('/Lotes')
def lotes():
    conexion = conexion_db()
    if conexion:
        df_lotes = obtener_todos_lotes(conexion)
        df_promedio_gramos = obtener_promedio_gramos_por_lote(conexion)
        conexion.close()
        if df_lotes is not None and df_promedio_gramos is not None:
            grafica_promedio_url = grafica_promedio_gramos_por_lote(df_promedio_gramos)
            tabla_grafica_promedio_gramos = df_promedio_gramos.to_html(classes='data')
            return render_template('lotes.html', 
                                   tables=[df_lotes.to_html(classes='data')],
                                   titles=df_lotes.columns.values, 
                                   grafica1=grafica_promedio_url,
                                   tabla_grafica_promedio_gramos=tabla_grafica_promedio_gramos)
        return "Error en la consulta tbllotes a la base de datos"



@app.route('/Proveedores')
def proveedores():
    conexion = conexion_db()
    if conexion:
        df = obtener_todos_proveedores(conexion)
        conexion.close()
        if df is not None:
            return render_template("proveedores.html", tables=[df.to_html(classes='data')], tittles=df.columns.values)
        return "Error en la consulta tblproveedores a la base de datos"
    
if __name__ == "__main__":
    app.run(debug=True)
