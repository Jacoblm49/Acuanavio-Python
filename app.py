# app.py
from flask import Flask, render_template
from db_conexion import conexion_db
from consultas import obtener_todos_canales, obtener_todos_lotes, obtener_todos_proveedores
from graficas.lotes import grafica_PromIngresos, crear_grafica2

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
        df = obtener_todos_lotes(conexion)
        conexion.close()
        if df is not None:
            grafica1_url = grafica_PromIngresos(df)
            grafica2_url = crear_grafica2(df)
            return render_template('lotes.html', tables=[df.to_html(classes='data')], titles=df.columns.values, grafica1=grafica1_url, grafica2=grafica2_url)
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
