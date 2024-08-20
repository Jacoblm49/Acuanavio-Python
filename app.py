# app.py
from flask import Flask, render_template
#conexion bd
from db_conexion import conexion_db

#Consultas generales DF
from consultas import obtener_todos_canales, obtener_todos_lotes, obtener_todos_proveedores, obtener_todos_alimentacion

#Subconsultas, tablas y graficas
from consultas_graficas.lotes import obtener_PGL, grafica_PGL, obtener_PCL, grafica_PCL;
from consultas_graficas.canales import obtener_POCtabla ,obtener_POC, grafica_POC;
from consultas_graficas.proveedores import obtener_UV,grafica_UV
from consultas_graficas.alimentacion import obtener_CICL, grafica_CICL

app = Flask("Acuanavio_python")

@app.route('/')
def index():
    return render_template("index.html")



@app.route('/Lotes')
def lotes():
    conexion = conexion_db()
    if conexion:
        df_lotes = obtener_todos_lotes(conexion)
        df_PGL = obtener_PGL(conexion)
        df_PCL = obtener_PCL(conexion)
        conexion.close()
        if df_lotes is not None and df_PGL is not None:
            graficaUrl_PGL, promedio_PGL, estadoPeso_PGL = grafica_PGL(df_PGL)
            graficaUrl_PCL, promedio_PCL = grafica_PCL(df_PCL)
            tabla_PGL = df_PGL.to_html(classes='data')
            tabla_PCL = df_PCL.to_html(classes='data')
            return render_template('lotes.html', 
                                   tables=[df_lotes.to_html(classes='data')],
                                   titles=df_lotes.columns.values, 
                                   grafica_PGL=graficaUrl_PGL,
                                   tabla_PGL=tabla_PGL,
                                   promedio_PGL= promedio_PGL,
                                   estadoPeso_PGL= estadoPeso_PGL,
                                   tabla_PCL=tabla_PCL,
                                   grafica_PCL= graficaUrl_PCL,
                                   promedio_PCL= promedio_PCL,
                                   )
        
        return "Error en la consulta tbllotes a la base de datos"
    
@app.route('/Canales')
def canales():
    conexion = conexion_db()
    if conexion:
        df_canales = obtener_todos_canales(conexion)
        df_POCtabla= obtener_POCtabla(conexion)
        df_POC= obtener_POC(conexion)
        conexion.close()
        if df_canales is not None and df_POC is not None:
            tabla_POCtabla = df_POCtabla.to_html(classes='data')
            graficaUrl_POC = grafica_POC(df_POC)
            return render_template('canales.html', 
                                   tables=[df_canales.to_html(classes='data')],
                                   titles=df_canales.columns.values,
                                   tabla_POC=tabla_POCtabla,
                                   grafica_POC=graficaUrl_POC,
                                   )
        return "Error en la consulta tblcanales a la base de datos"




@app.route('/Proveedores')
def proveedores():
    conexion = conexion_db()
    if conexion:
        df_proveedores = obtener_todos_proveedores(conexion)
        df_UV = obtener_UV(conexion)
        conexion.close()
        if df_proveedores is not None and df_UV is not None:
            tabla_UV = df_UV.to_html(classes='data')
            graficaUrl_UV, promedio_UV, max_UV, nombre_max_UV= grafica_UV(df_UV)
            return render_template('proveedores.html',
                                    tables=[df_proveedores.to_html(classes='data')],
                                    titles= df_proveedores.columns.values,
                                    tabla_UV=tabla_UV,
                                    grafica_UV=graficaUrl_UV,
                                    promedio_UV=promedio_UV,
                                    max_UV=max_UV,
                                    nombre_max_UV= nombre_max_UV
                                    )
        return "Error en la consulta tblproveedores a la base de datos"
    
@app.route('/Alimentacion')
def alimentacion():
    conexion = conexion_db()
    if conexion:
        df_alimentacion = obtener_todos_alimentacion(conexion)
        df_CICL = obtener_CICL(conexion)
        if df_alimentacion is not None and df_CICL is not None:
            tabla_CICL = df_CICL.to_html(classes='data')
            graficaUrl_CICL, max_CICL,nombre_max_CICL = grafica_CICL(df_CICL)
            return render_template('alimentacion.html',
                                   tables=[df_alimentacion.to_html(classes='data')],
                                   titles=df_alimentacion.columns.values,
                                   tabla_CICL=tabla_CICL,
                                   grafica_CICL= graficaUrl_CICL,
                                   max_CICL= max_CICL,
                                   nombre_max_CICL=nombre_max_CICL
                                   ) 
        return "Error en la consulta tblalimentacion a la base de datos"
    
if __name__ == "__main__":
    app.run(debug=True)
