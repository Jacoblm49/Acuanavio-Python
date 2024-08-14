# consulta.py
import pandas as pd

def obtener_datos(conexion, query):
    try:
        cursor = conexion.cursor()
        cursor.execute(query)
        resultado = cursor.fetchall()
        columnas = [i[0] for i in cursor.description]
        df = pd.DataFrame(resultado, columns=columnas)
        cursor.close()
        return df
    except Exception as e:
        print(f"Error al obtener datos :( {e}")
        return None

def obtener_todos_canales(conexion):
    query = """
            SELECT CA.IdCanal, CA.Largo, CA.Ancho, CA.Profundidad, CA.Oxigeno, CA.Caudal, CA.Temperatura, CA.Turbidez, CA.Ph, CA.Granja, EC.Descripcion AS 'Estado Canal' FROM tblcanales AS CA INNER JOIN tblestadocanal AS EC ON CA.EstadoCanal = EC.IdEstado;
            """
    return obtener_datos(conexion, query)

def obtener_todos_lotes(conexion):
    query = """
            SELECT LO.IdLote as 'Id Lote', LO.FechaIngresoGranja as 'Fecha de ingreso a la granja',
            LO.FechaIngresoPais as 'Fecha de ingreso al pais', LO.Unidades, LO.PromedioGramos
            as 'Peso Promedio', LO.PrecioUnidad, LO.Observaciones, EL.Descripcion as 'Estado del lote',
            CONCAT(PR.DocIdentidad,' - ', PR.Nombre) as 'Provedor'
            FROM tbllotes as LO 
            INNER JOIN tblestadolote as EL on LO.EstadoLote = EL.IdEstadoLote
            INNER JOIN tblprovedores as PR ON LO.Provedor = PR.DocIdentidad
            ORDER BY LO.IdLote ASC
            """
    return obtener_datos(conexion, query)

def obtener_todos_proveedores(conexion):
    query = """
            SELECT PR.DocIdentidad as 'Doc de Identidad', PR.Nombre, PR.Telefono,
            PR.Correo, PR.Direccion, concat(MU.Nombre,' - ', DE.Nombre) AS 'Ciudad'
            FROM tblprovedores as PR 
            INNER JOIN tblmunicipios as MU ON PR.Municipio = MU.IdMunicipio 
            INNER JOIN tbldepartamentos as DE ON MU.Departamento = DE.IdDepartamento;
            """
    return obtener_datos(conexion, query)
