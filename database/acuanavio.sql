-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-08-2024 a las 15:38:29
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `acuanavio`
--
CREATE DATABASE IF NOT EXISTS `acuanavio` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `acuanavio`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `SP_AlimentacionActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AlimentacionActualizar` (IN `_Id` INT(10), IN `_Fecha` VARCHAR(10), IN `_Cantidad` INT(3), IN `_Insumo` INT(2), IN `_Lotecanal` INT(8), IN `_Usuario` VARCHAR(12))   BEGIN 
 
 UPDATE tblalimentacion
 SET  Fecha = _Fecha,
      Cantidad = _Cantidad,
      Insumo = _Insumo,
      LoteCanal = _Lotecanal,
      Usuario = _Usuario
      
      WHERE IdAlimentacion = _Id;
 
END$$

DROP PROCEDURE IF EXISTS `SP_AlimentacionEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AlimentacionEliminar` (IN `_Id` INT(10))   BEGIN 
     
     
      DELETE FROM tblalimentacion 
      WHERE IdAlimentacion = _Id;
 
END$$

DROP PROCEDURE IF EXISTS `SP_AlimentacionInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AlimentacionInsertar` (IN `_Fecha` VARCHAR(10), IN `_Cantidad` INT(3), IN `_Insumo` INT(2), IN `_Lotecanal` INT(8), IN `_Usuario` VARCHAR(12))   BEGIN 
 
 INSERT INTO tblalimentacion
 VALUES (NULL, _Fecha,_Cantidad,_Insumo,_Lotecanal,_Usuario);
 
END$$

DROP PROCEDURE IF EXISTS `SP_AlimentacionTotalLote`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AlimentacionTotalLote` (IN `_Lote` INT(8))   BEGIN

SELECT LC.Lote, ROUND(SUM(AL.Cantidad*(INS.Costo/40)) ,0) as 'Valor Total Alimentación'

FROM tblinsumos as INS INNER JOIN tblalimentacion as AL
ON INS.IdInsumo = AL.Insumo
INNER JOIN tbllotecanal as LC
ON AL.LoteCanal = LC.IdLoteCanal

WHERE LC.Lote = _Lote
GROUP BY LC.Lote;

END$$

DROP PROCEDURE IF EXISTS `SP_BitacorasLoteActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BitacorasLoteActualizar` (IN `_Id` INT(8), IN `_Fecha` VARCHAR(10), IN `_LoteCanal` INT(8), IN `_Descripcion` VARCHAR(2000), IN `_Usuario` VARCHAR(12))   BEGIN 

UPDATE  tblbitacoraslote 
 SET Fecha = _Fecha, 
     LoteCanal = _LoteCanal,
     Descripcion = _Descripcion,
     Usuario = _Usuario 
     
  WHERE Idbitacora = Id ;

END$$

DROP PROCEDURE IF EXISTS `SP_BitacorasLoteAgregar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BitacorasLoteAgregar` (IN `_Fecha` VARCHAR(10), IN `_LoteCanal` INT(8), IN `_Descripcion` VARCHAR(2000), IN `_Usuario` VARCHAR(12))   BEGIN 

INSERT INTO tblbitacoraslote 
VALUES(NULL,_Fecha, _LoteCanal,_Descripcion,_Usuario );

END$$

DROP PROCEDURE IF EXISTS `SP_BitacorasLoteEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BitacorasLoteEliminar` (IN `_Id` INT(8))   BEGIN 
DELETE FROM  tblbitacoraslote 
WHERE IdBitacora = _Id;

END$$

DROP PROCEDURE IF EXISTS `SP_BucarEstadoLote`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BucarEstadoLote` (IN `_id` INT(1))   BEGIN
SELECT idEstadoLote as 'ID' , descripcion as 'Estado del Lote'

FROM tblestadolote

WHERE IdEstadoLote = _id;
END$$

DROP PROCEDURE IF EXISTS `SP_BuscarAlimentacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BuscarAlimentacion` (IN `_IdAlimentacion` INT(10))   BEGIN

SELECT AL.IdAlimentacion as 'ID', AL.Fecha , INS.Referencia, AL.Cantidad AS 'Cantidad en KG', LC.Lote , LC.Canal, CONCAT(US.DocIdentidad ,' - ', US.Nombres,'  ', US.Apellidos) AS 'Usuario a Cargo'

FROM tblalimentacion as AL INNER JOIN tbllotecanal as LC
ON AL.LoteCanal = LC.IdLoteCanal 
INNER JOIN tblinsumos as INS
ON AL.Insumo = INS.IdInsumo 
INNER JOIN tblusuarios as US
ON AL.Usuario = US.DocIdentidad

WHERE AL.IdAlimentacion = _IdAlimentacion;

END$$

DROP PROCEDURE IF EXISTS `SP_BuscarDepartamentos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BuscarDepartamentos` (IN `_id` VARCHAR(2))   BEGIN 

SELECT idDepartamento as 'ID', Nombre as 'Departamento'

FROM tbldepartamento 

WHERE IdDepartamento = _id;

END$$

DROP PROCEDURE IF EXISTS `SP_BuscarEstadoCuenta`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BuscarEstadoCuenta` (IN `_IdEstadoCuenta` INT(1))   BEGIN

SELECT IdEstado as 'ID', Descripcion as 'Estado de la Cuenta'
FROM tblestadocuenta

WHERE IdEstado = _IdEstadoCuenta;

END$$

DROP PROCEDURE IF EXISTS `SP_BuscarInfoLoteCanal`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BuscarInfoLoteCanal` (IN `_id` INT(8))   BEGIN

SELECT idLotecanal as 'ID', canal , lote , fechaingresocanal as 'Fecha de ingreso al canal '

FROM tbllotecanal

WHERE IdLoteCanal = _id;

END$$

DROP PROCEDURE IF EXISTS `SP_BuscarInfoMuestras`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BuscarInfoMuestras` (IN `_id` INT(5))   BEGIN 

SELECT MUE.IdMuestra as 'ID', MUE.Fecha, MUE.PesoTotal as 'Peso Total', MUE.unidades, MUE.Orservaciones,
LC.Lote , LC.Canal , CONCAT(US.DocIdentidad,' - ', US.Nombre,'  ', US.Apellidos) AS 'Usuario a Cargo'

FROM tblmuestras as MUE INNER JOIN tbllotecanal as LC 
ON MUE.LoteCanal = LC.idLoteCanal
INNER JOIN tblusuarios as US 
ON MUE.Usuario = US.DocIdentidad

WHERE MUE.IdMuestra = _id;
END$$

DROP PROCEDURE IF EXISTS `SP_buscarInsumos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_buscarInsumos` (IN `_IdInsumo` INT(2))   BEGIN

SELECT IdInsumo as 'ID', Descripcion , Costo, Referencia

FROM tblinsumos

WHERE IdInsumo = _IdInsumo ;

END$$

DROP PROCEDURE IF EXISTS `SP_BuscarLote`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BuscarLote` (IN `_idLote` INT(8))   BEGIN

SELECT LO.IdLote as 'Lote', LO.FechaIngresoGranja as 'Fecha de ingreso a la granja',
LO.FechaIngresoPais as 'Fecha de ingreso al pais', LO.Unidades, LO.PromedioGramos
as 'Peso Promedio', LO.Costo, LO.Observaciones, EL.Descripcion as 'Estado del lote',
CONCAT(PR.DocIdentidad,' - ', PR.Nombre) as 'Provedor'

FROM tbllotes as LO INNER JOIN tblestadolote as EL
on LO.EstadoLote = EL.IdEstadoLote
INNER JOIN tblprovedores as PR 
ON LO.Provedor = PR.DocIdentidad

WHERE LO.IdLote = _idLote;
 
END$$

DROP PROCEDURE IF EXISTS `SP_BuscarMunicipios`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BuscarMunicipios` (IN `_id` VARCHAR(5))   BEGIN

SELECT MU.IdMunicipio as 'ID', MU.Nombre as 'Municipio' , DE.Nombre as 'Departamento'

FROM tblMunicipios as MU INNER JOIN tblDepartamentos as DE
on MU.Departamento = DE.IdDepartamento

WHERE MU.idMunicipio = _id;

END$$

DROP PROCEDURE IF EXISTS `SP_BuscarProvedores`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BuscarProvedores` (IN `_DocId` VARCHAR(12))   BEGIN

SELECT PR.DocIdentidad as 'Doc de Identidad', PR.Nombre, PR.Telefono,
PR.Correo, PR.Direccion, concat(MU.Nombre,' - ', DE.Nombre) AS 'Ciudad'

FROM tblprovedores as PR INNER JOIN tblmunicipios as MU
ON PR.Municipio = MU.IdMunicipio 
INNER JOIN tbldepartamentos as DE
ON MU.Departamento = DE.IdDepartamento

WHERE PR.DocIdentidad = _DocId;
END$$

DROP PROCEDURE IF EXISTS `SP_BuscarRoles`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BuscarRoles` (IN `_IdRol` INT(1))   BEGIN

SELECT IdRol as 'ID', Descripcion as 'Rol'
FROM tblrol
WHERE IdRol = _IdRol;

END$$

DROP PROCEDURE IF EXISTS `sp_busquedaDatoUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_busquedaDatoUsuario` (IN `_docidentidad` VARCHAR(12))   BEGIN

SELECT US.DocIdentidad,US.Nombres,US.Apellidos,US.Correo,US.Direccion,US.Contrasena, RO.Descripcion AS 'Rol',EC.Descripcion AS 'Estado Cuenta' FROM tblusuarios as US inner join tblrol as RO ON US.ROL = RO.IdRol INNER JOIN tblestadocuenta as EC ON US.EstadoCuenta = EC.IdEstado

WHERE US.DocIdentidad = _docidentidad;

END$$

DROP PROCEDURE IF EXISTS `SP_BusquedaGranja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BusquedaGranja` (IN `_IdGranja` INT(2))   BEGIN
SELECT GR.IdGranja, GR.Nombre, GR.Direccion, GR.Telefono, MU.Nombre as 'Municipio', DE.Nombre as 'Departamento'
FROM tblgranja as GR INNER JOIN tblmunicipios as MU
ON GR.Municipio = MU.IdMunicipio
INNER JOIN tbldepartamentos as DE
ON MU.Departamento = DE.IdDepartamento
HAVING GR.IdGranja = _IdGranja;
END$$

DROP PROCEDURE IF EXISTS `sp_CanalesActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CanalesActualizar` (IN `_IdCanal` VARCHAR(3), IN `_Largo` DOUBLE(3,1), IN `_Ancho` DOUBLE(3,1), IN `_Profundidad` DOUBLE(3,1), IN `_Oxigeno` DOUBLE(2,1), IN `_Caudal` DOUBLE(3,1), IN `_Temperatura` DOUBLE(3,1), IN `_Turbidez` DOUBLE(3,1), IN `_PH` INT(2), IN `_Granja` INT(2), IN `_EstadoCanal` INT(2))   BEGIN
	UPDATE tblcanales
    SET Largo=_Largo,
    	Ancho=_Ancho,
        Profundidad=_Profundidad,
        Oxigeno=_Oxigeno,
        Caudal=_Caudal,
		Temperatura=_Temperatura,
        Turbidez=_Turbidez,
        Ph=_PH,
        Granja=_Granja,
        EstadoCanal=_EstadoCanal
    WHERE IdCanal=_IdCanal;        
END$$

DROP PROCEDURE IF EXISTS `SP_CanalesAsociadosGranja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CanalesAsociadosGranja` (IN `_IdGranja` INT(2))   BEGIN

SELECT CONCAT(GR.IdGranja,' - ', GR.Nombre) as 'Granja', CA.IdCanal as 'Canal', (CA.Largo*CA.Ancho*CA.Profundidad) as 'Volumen del canal', CA.Oxigeno, CA.Caudal,CA.Temperatura, CA.Turbidez,CA.Ph, EC.Descripcion as 'Estado de Canal'

FROM tblcanales as CA INNER JOIN tblestadocanal as EC
ON CA.EstadoCanal = EC.IdEstado 
INNER JOIN tblgranja as GR
ON CA.Granja = GR.IdGranja

WHERE GR.IdGranja = _IdGranja
ORDER BY GR.IdGranja;

END$$

DROP PROCEDURE IF EXISTS `sp_CanalesEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CanalesEliminar` (IN `_IdCanal` VARCHAR(3))   BEGIN
	DELETE FROM tblcanales
    WHERE IdCanal = _IdCanal;
END$$

DROP PROCEDURE IF EXISTS `sp_CanalesInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_CanalesInsertar` (IN `_IdCanal` VARCHAR(3), IN `_Largo` DOUBLE(3,1), IN `_Ancho` DOUBLE(3,1), IN `_Profundidad` DOUBLE(3,1), IN `_Oxigeno` DOUBLE(2,1), IN `_Caudal` DOUBLE(3,1), IN `_Temperatura` DOUBLE(3,1), IN `_Turbidez` DOUBLE(3,1), IN `_PH` INT(2), IN `_Granja` INT(2), IN `_EstadoCanal` INT(2))   BEGIN
INSERT INTO tblcanales
VALUES(_IdCanal,_Largo,_Ancho,_Profundidad,_Oxigeno,_Caudal,_Temperatura,_Turbidez,_PH,_Granja,_EstadoCanal);
END$$

DROP PROCEDURE IF EXISTS `SP_CanalLoteGranja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CanalLoteGranja` (IN `_idLote` INT(8))   BEGIN

SELECT GR.Nombre as 'Granja',LC.Canal ,LC.Lote

FROM tbllotecanal as LC INNER JOIN tblcanales as CA
ON LC.Canal = CA.IdCanal
INNER JOIN tblgranja as GR 
ON CA.Granja = GR.IdGranja

WHERE LC.Lote = _IdLote 
ORDER BY GR.Nombre;

END$$

DROP PROCEDURE IF EXISTS `sp_DatosCanal`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DatosCanal` (IN `_IdCanal` VARCHAR(6))   BEGIN SELECT CA.IdCanal, CA.Largo, CA.Ancho, CA.Profundidad, CA.Oxigeno, CA.Caudal, CA.Temperatura, CA.Turbidez, CA.Ph, CA.Granja, EC.Descripcion AS 'Estado Canal' FROM tblcanales AS CA INNER JOIN tblestadocanal AS EC ON CA.EstadoCanal = EC.IdEstado WHERE CA.IdCanal = _IdCanal; END$$

DROP PROCEDURE IF EXISTS `sp_DepartamentosActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DepartamentosActualizar` (IN `_Id` VARCHAR(2), IN `_Nombre` VARCHAR(30))   BEGIN
 UPDATE tbldepartamentos
 SET IdDepartamento = Id,
 	 Nombre= _Nombre
   WHERE IdDepartamento = _Id;
END$$

DROP PROCEDURE IF EXISTS `sp_DepartamentosEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DepartamentosEliminar` (IN `_Id` VARCHAR(2))   BEGIN
	DELETE FROM tbldepartamentos
    WHERE IdDepartamento = _Id;
END$$

DROP PROCEDURE IF EXISTS `sp_DepartamentosInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DepartamentosInsertar` (IN `_Id` VARCHAR(2), IN `_Nombre` VARCHAR(30))   BEGIN
INSERT INTO tbldepartamentos
VALUES(_Id,_Nombre);
END$$

DROP PROCEDURE IF EXISTS `sp_EstadoCanalActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_EstadoCanalActualizar` (IN `_ID` INT(1), IN `_Descripcion` VARCHAR(20))   BEGIN
	UPDATE tblestadocanal
    SET Descripcion=_Descripcion
    WHERE IdEstado = _ID;
END$$

DROP PROCEDURE IF EXISTS `sp_EstadoCanalEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_EstadoCanalEliminar` (IN `_ID` INT(1))   BEGIN
	DELETE FROM tblestadocanal
    WHERE IdEstado = _ID;
END$$

DROP PROCEDURE IF EXISTS `sp_EstadoCanalInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_EstadoCanalInsertar` (IN `_Descripcion` VARCHAR(20))   BEGIN
	INSERT INTO tblestadocanal
    VALUES (null,_Descripcion);
END$$

DROP PROCEDURE IF EXISTS `sp_EstadoCanalPorID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_EstadoCanalPorID` (IN `_ID` INT)   BEGIN
SELECT *
FROM tblestadocanal
HAVING tblestadocanal.IdEstado=_ID;
END$$

DROP PROCEDURE IF EXISTS `sp_EstadoCanalTodos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_EstadoCanalTodos` ()   BEGIN
SELECT *
FROM tblestadocanal;
END$$

DROP PROCEDURE IF EXISTS `sp_EstadoCuentaActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_EstadoCuentaActualizar` (IN `_IdEstado` INT(1), IN `_Descripcion` VARCHAR(20))   BEGIN 
	UPDATE tblestadocuenta
    SET Descripcion = _Descripcion
    
    WHERE IdEstado = _IdEstado;
END$$

DROP PROCEDURE IF EXISTS `sp_EstadoCuentaEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_EstadoCuentaEliminar` (IN `_IdEstado` INT(1))   BEGIN
DELETE FROM tblestadocuenta
WHERE IdEstado = _IdEstado;
END$$

DROP PROCEDURE IF EXISTS `sp_EstadoCuentaInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_EstadoCuentaInsertar` (IN `_Descripcion` VARCHAR(20))   BEGIN 
	INSERT INTO tblestadocuenta
    VALUES (null,_Descripcion);
END$$

DROP PROCEDURE IF EXISTS `SP_EstadoLoteActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_EstadoLoteActualizar` (IN `_IdEstado` INT(1), IN `_Descripcion` VARCHAR(30))   BEGIN

UPDATE tblestadolote
SET  Descripcion = _Descripcion

WHERE IdEstadoLote = _IdEstdo;

END$$

DROP PROCEDURE IF EXISTS `SP_EstadoLoteAgregar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_EstadoLoteAgregar` (IN `_Descripcion` VARCHAR(30))   BEGIN

INSERT INTO tblestadolote
VALUES(NULL, _Descripcion);

END$$

DROP PROCEDURE IF EXISTS `SP_EstadoLoteEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_EstadoLoteEliminar` (IN `_IdEstado` INT(1))   BEGIN

DELETE FROM tblestadolote

WHERE IdEstadoLote = _IdEstdo;

END$$

DROP PROCEDURE IF EXISTS `sp_GranjaActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GranjaActualizar` (IN `_Id` INT(2), IN `_Nombre` VARCHAR(30), IN `_Direccion` VARCHAR(80), IN `_Telefono` VARCHAR(10), IN `_Municipio` VARCHAR(5), IN `_Usuario` VARCHAR(12))   BEGIN
 UPDATE tblgranja
 SET Nombre=_Nombre,
 	Direccion=_Direccion,
    Telefono=_Telefono,
    Municipio=_Municipio,
    Usuario=_Usuario
    WHERE IdGranja=_Id;
END$$

DROP PROCEDURE IF EXISTS `sp_GranjaEliminarr`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GranjaEliminarr` (IN `_Id` INT(2))   BEGIN
 DELETE FROM tblgranja
    WHERE IdGranja=_Id;
END$$

DROP PROCEDURE IF EXISTS `sp_GranjaInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GranjaInsertar` (IN `_Nombre` VARCHAR(30), IN `_Direccion` VARCHAR(80), IN `_Telefono` VARCHAR(10), IN `_Municipio` VARCHAR(5), IN `_Usuario` VARCHAR(12))   BEGIN
INSERT INTO tblgranja 
VALUES (null,_Nombre,_Direccion,_Telefono,_Municipio,_Usuario);
END$$

DROP PROCEDURE IF EXISTS `SP_GranjaPorUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GranjaPorUsuario` (IN `_DocId` VARCHAR(12))   BEGIN

SELECT CONCAT(US.DocIdentidad,' - ', US.Nombres, '  ', US.Apellidos) AS ' Nombre Usuario ', GR.Nombre as 'Nombre Granja', 
GR.Direccion , GR.Telefono , CONCAT(MU.Nombre,'  - ', DE.Nombre ) AS 'Ciudad' 

FROM tblgranja AS  GR INNER JOIN tblmunicipios AS MU
ON GR.Municipio = MU.IdMunicipio 
INNER JOIN tbldepartamentos as DE
ON MU.Departamento = DE.IdDepartamento
INNER JOIN tblusuarios as US
ON GR.Usuario = US.DocIdentidad

WHERE US.DocIdentidad = _DocId

ORDER BY CONCAT(US.DocIdentidad,' - ', US.Nombres, '  ', US.Apellidos);

END$$

DROP PROCEDURE IF EXISTS `SP_InsumoActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_InsumoActualizar` (IN `_Id` INT(2), IN `_Descripcion` VARCHAR(1000), IN `_Costo` INT(10), IN `_Refencia` VARCHAR(80))   BEGIN 
  
  UPDATE tblinsumos
  SET Descripcion = _Descripcion,
      Costo = _Costo,
      Referecia = _Refencia
      
  WHERE IdInsumo = _Id;
  
 
END$$

DROP PROCEDURE IF EXISTS `SP_InsumoAgregar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_InsumoAgregar` (IN `_Descripcion` VARCHAR(1000), IN `_Costo` INT(10), IN `_Refencia` VARCHAR(80))   BEGIN 
  
  INSERT INTO tblinsumos
  VALUES (NULL,_Descripcion,_Costo,_Refencia );
  
 
END$$

DROP PROCEDURE IF EXISTS `SP_InsumoEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_InsumoEliminar` (IN `_Id` INT(2))   BEGIN 
  
DELETE FROM tblinsumos
WHERE IdInsumo = _Id;
  
 
END$$

DROP PROCEDURE IF EXISTS `sp_LiquidacionFinalLotePorIDLote`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_LiquidacionFinalLotePorIDLote` (IN `_IDlote` INT(8))   BEGIN
SELECT LO.IdLote,LO.Costo as 'Precio compra del lote', LO.Unidades as 'Unidades compradas',PP.Unidades as 'Unidades vendidas', (AL.Cantidad*(INS.Costo/40)) AS 'COSTO TOTAL EN ALIMENTACION',(LO.Costo+(AL.Cantidad*(INS.Costo/40))) as 'COSTO TOTAL LOTE', PP.PrecioVenta, (PP.PrecioVenta-((LO.Costo+(AL.Cantidad*(INS.Costo/40))))) as 'GANANCIAS', PP.Observaciones as 'Obersevaciones venta', PP.Fecha as 'FECHA VENTA LOTE'
FROM tbllotes as LO INNER JOIN tbllotecanal as LC
ON LO.IdLote = LC.Lote
INNER JOIN tblalimentacion as AL
ON LC.IdLoteCanal = AL.LoteCanal
INNER JOIN tblinsumos as INS
ON AL.Insumo = INS.IdInsumo
INNER JOIN tblpostproduccion as PP
ON LC.idLoteCanal = PP.LoteCanal
GROUP BY LO.IdLote
HAVING LO.IdLote = _IDlote;
END$$

DROP PROCEDURE IF EXISTS `SP_LoteActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LoteActualizar` (IN `_IdLote` INT(8), IN `_FechaInGr` VARCHAR(10), IN `_FechaInPa` VARCHAR(10), IN `_unidades` INT(7), IN `_ProGramos` DECIMAL(5,2), IN `_Costo` INT(7), IN `_Observaciones` INT(8), IN `_EstadoLote` INT(1), IN `_Provedor` VARCHAR(12))   BEGIN

UPDATE tbllotes

SET  FechaIngresoGranja = _FechaInGr,
     FechaIngresoPais = _FechaInPa,
     Unidades = _unidades,
     PromedioGramos = _ProGramos,
     Costo = _Costo,
     Observaciones = _Observaciones,
     EstadoLote =  _EstadoLote,
     Provedor = _Provedor
     
WHERE IdLote = _IdLote;
END$$

DROP PROCEDURE IF EXISTS `SP_LoteAgregar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LoteAgregar` (IN `_FechaInGr` VARCHAR(10), IN `_FechaInPa` VARCHAR(10), IN `_unidades` INT(7), IN `_ProGramos` DECIMAL(5,2), IN `_Costo` INT(7), IN `_Observaciones` INT(8), IN `_EstadoLote` INT(1), IN `_Provedor` VARCHAR(12))   BEGIN

INSERT INTO tbllotes

VALUES (NULL,_FechaInGr, _FechaInPa,_unidades,_ProGramos,_Costo,_Observaciones,
       _EstadoLote,_Provedor);

END$$

DROP PROCEDURE IF EXISTS `SP_LoteCanalActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LoteCanalActualizar` (IN `_Codigo` INT(8), IN `_Lote` INT(8), IN `_Canal` VARCHAR(3), IN `_Fecha` VARCHAR(8))   BEGIN

UPDATE tbllotecanal
SET Lote = _Lote,
    Canal = _Canal,
    FechaIngresoCanal = _Fecha
    
WHERE IdLoteCanal = _Codigo;

END$$

DROP PROCEDURE IF EXISTS `SP_LoteCanalAgregar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LoteCanalAgregar` (IN `_Lote` INT(8), IN `_Canal` VARCHAR(3), IN `_Fecha` VARCHAR(8))   BEGIN

INSERT INTO tbllotecanal
VALUES (NULL, _lote, _Canal,_Fecha);

END$$

DROP PROCEDURE IF EXISTS `SP_LoteCanalEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LoteCanalEliminar` (IN `_Codigo` INT(8))   BEGIN

DELETE FROM tbllotecanal
    
WHERE IdLoteCanal = _Codigo;

END$$

DROP PROCEDURE IF EXISTS `SP_LoteEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_LoteEliminar` (IN `_IdLote` INT(8))   BEGIN

DELETE FROM tbllotes
     
WHERE IdLote = _IdLote;
END$$

DROP PROCEDURE IF EXISTS `SP_MortalidadActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MortalidadActualizar` (IN `_Id` INT(5), IN `_Fecha` VARCHAR(10), IN `_Kilos` DECIMAL(7,2), IN `_UnidadesBuenas` INT(5), IN `_UnidadesMalas` INT(5), IN `_Observaciones` VARCHAR(2000), IN `_LoteCanal` INT(8), IN `_Usuario` VARCHAR(12))   BEGIN 

UPDATE tblmortalidad 
SET  Fecha = _Fecha,
    Kilogramos = _Kilos,
    UnidadesBuenEstado = _UnidadesBuenas,
    UnidadesMalEstado = _UnidadesMalas,
    Observaciones = _Observaciones,
    LoteCanal = _LoteCanal,
    Usuario = _Usuario
    
  WHERE IdMortalidad = _Id;

END$$

DROP PROCEDURE IF EXISTS `SP_MortalidadAgregar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MortalidadAgregar` (IN `_Fecha` VARCHAR(10), IN `_Kilos` DECIMAL(7,2), IN `_UnidadesBuenas` INT(5), IN `_UnidadesMalas` INT(5), IN `_Observaciones` VARCHAR(2000), IN `_LoteCanal` INT(8), IN `_Usuario` VARCHAR(12))   BEGIN 

INSERT INTO tblmortalidad 
VALUES(NULL,_Fecha,_Kilos,_UnidadesBuenas,_UnidadesMalas,_Observaciones,_LoteCanal,_Usuario);

END$$

DROP PROCEDURE IF EXISTS `sp_MortalidadConsultarTodo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_MortalidadConsultarTodo` ()   BEGIN
SELECT MO.IdMortalidad, MO.Fecha, MO.Kilogramos, MO.UnidadesBuenEstado, MO.UnidadesMalEstado, MO.Observaciones, concat (LC.Lote,'-',LC.Canal) as 'Lote Canal',US.DocIdentidad as 'DocID usuario encargado'
FROM tblmortalidad as MO INNER JOIN tbllotecanal as LC
ON MO.LoteCanal = LC.IdLoteCanal
INNER JOIN tblusuarios as US
ON MO.Usuario = US.DocIdentidad;
END$$

DROP PROCEDURE IF EXISTS `SP_MortalidadEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MortalidadEliminar` (IN `_Id` INT(5))   BEGIN 

DELETE FROM tblmortalidad 

WHERE idMortalidad = _Id;

END$$

DROP PROCEDURE IF EXISTS `SP_MortalidadPorGranja`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MortalidadPorGranja` (IN `_IdGranja` INT(8))   BEGIN

SELECT GR.IdGranja as 'ID',GR.Nombre as 'Granja' , SUM(MO.UnidadesBuenEstado+MO.UnidadesMalEstado) as 'Muertes por granja'

FROM tblmortalidad as MO INNER JOIN tbllotecanal as LC
ON MO.LoteCanal = LC.IdLoteCanal
INNER JOIN tblcanales as CA
ON LC.Canal = CA.IdCanal 
INNER JOIN tblgranja as GR 
ON CA.Granja = GR.IdGranja

GROUP BY GR.Nombre

HAVING  GR.IdGranja = _IdGranja ;

END$$

DROP PROCEDURE IF EXISTS `sp_MortalidadPorID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_MortalidadPorID` (IN `_ID` INT(5))   BEGIN
SELECT MO.IdMortalidad, MO.Fecha, MO.Kilogramos, MO.UnidadesBuenEstado, MO.UnidadesMalEstado, MO.Observaciones, concat (LC.Lote,'-',LC.Canal) as 'Lote Canal',US.DocIdentidad as 'DocID usuario encargado'
FROM tblmortalidad as MO INNER JOIN tbllotecanal as LC
ON MO.LoteCanal = LC.IdLoteCanal
INNER JOIN tblusuarios as US
ON MO.Usuario = US.DocIdentidad
HAVING MO.IdMortalidad = _ID;
END$$

DROP PROCEDURE IF EXISTS `SP_MortalidadPorLote`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MortalidadPorLote` (IN `_IdLote` INT(8))   BEGIN

SELECT LC.Lote , LC.Canal , SUM(MO.UnidadesBuenEstado+MO.UnidadesMalEstado) as 'Total Unidades muertas'

FROM tblmortalidad as MO INNER JOIN tbllotecanal as LC
ON MO.LoteCanal = LC.IdLoteCanal

GROUP BY LC.Lote

HAVING LC.Lote = _IdLote;

END$$

DROP PROCEDURE IF EXISTS `SP_MostrarAlimentacion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MostrarAlimentacion` ()   BEGIN

SELECT AL.IdAlimentacion as 'ID', AL.Fecha , INS.Referencia, AL.Cantidad AS 'Cantidad en KG', LC.Lote , LC.Canal, CONCAT(US.DocIdentidad ,' - ', US.Nombres,'  ', US.Apellidos) AS 'Usuario a Cargo'

FROM tblalimentacion as AL INNER JOIN tbllotecanal as LC
ON AL.LoteCanal = LC.IdLoteCanal 
INNER JOIN tblinsumos as INS
ON AL.Insumo = INS.IdInsumo 
INNER JOIN tblusuarios as US
ON AL.Usuario = US.DocIdentidad;

END$$

DROP PROCEDURE IF EXISTS `sp_MostrarDatosCanal`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_MostrarDatosCanal` ()   BEGIN 
SELECT CA.IdCanal, CA.Largo, CA.Ancho, CA.Profundidad, CA.Oxigeno, CA.Caudal, CA.Temperatura, CA.Turbidez, CA.Ph, CA.Granja, EC.Descripcion AS 'Estado Canal' FROM tblcanales AS CA INNER JOIN tblestadocanal AS EC ON CA.EstadoCanal = EC.IdEstado; END$$

DROP PROCEDURE IF EXISTS `sp_MostrarDatosGranjas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_MostrarDatosGranjas` ()   BEGIN
SELECT GR.IdGranja, GR.Nombre, GR.Direccion, GR.Telefono, MU.Nombre as 'Municipio', DE.Nombre as 'Departamento'
FROM tblgranja as GR INNER JOIN tblmunicipios as MU
ON GR.Municipio = MU.IdMunicipio
INNER JOIN tbldepartamentos as DE
ON MU.Departamento = DE.IdDepartamento;
END$$

DROP PROCEDURE IF EXISTS `sp_MostrarDatosUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_MostrarDatosUsuario` ()   BEGIN

 SELECT US.DocIdentidad,US.Nombres,US.Apellidos,US.Correo,US.Direccion,US.Contrasena, RO.Descripcion AS 'Rol',EC.Descripcion AS 'Estado Cuenta' FROM tblusuarios as US inner join tblrol as RO ON US.ROL = RO.IdRol INNER JOIN tblestadocuenta as Ec ON US.EstadoCuenta = EC.IdEstado;
 
END$$

DROP PROCEDURE IF EXISTS `SP_MostrarDepartamentos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MostrarDepartamentos` ()   BEGIN 

SELECT IdDepartamento as 'ID', Nombre as 'Departamento'

FROM tbldepartamento ;

END$$

DROP PROCEDURE IF EXISTS `SP_MostrarEstadoCuenta`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MostrarEstadoCuenta` ()   BEGIN

SELECT IdEstado as 'ID', Descripcion as 'Estado de la Cuenta'
FROM tblestadocuenta;

END$$

DROP PROCEDURE IF EXISTS `SP_MostrarEstadoLote`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MostrarEstadoLote` ()   BEGIN
SELECT idEstadoLote as 'ID' , descripcion as 'Estado del Lote'

FROM tblestadolote;
END$$

DROP PROCEDURE IF EXISTS `SP_MostrarInfoLoteCanal`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MostrarInfoLoteCanal` ()   BEGIN

SELECT idLotecanal as 'ID', canal , lote , fechaingresocanal as 'Fecha de ingreso al canal '

FROM tbllotecanal;

END$$

DROP PROCEDURE IF EXISTS `SP_MostrarInfoMuestras`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MostrarInfoMuestras` ()   BEGIN 

SELECT MUE.IdMuestra as 'ID', MUE.Fecha, MUE.PesoTotal as 'Peso Total', MUE.unidades, MUE.Orservaciones,
LC.Lote , LC.Canal , CONCAT(US.DocIdentidad,' - ', US.Nombre,'  ', US.Apellidos) AS 'Usuario a Cargo'

FROM tblmuestras as MUE INNER JOIN tbllotecanal as LC 
ON MUE.LoteCanal = LC.idLoteCanal
INNER JOIN tblusuarios as US 
ON MUE.Usuario = US.DocIdentidad;

END$$

DROP PROCEDURE IF EXISTS `SP_MostrarInsumos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MostrarInsumos` ()   BEGIN

SELECT IdInsumo as 'ID', Descripcion , Costo, Referencia

FROM tblinsumos;

END$$

DROP PROCEDURE IF EXISTS `SP_MostrarLote`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MostrarLote` ()   BEGIN

SELECT LO.IdLote as 'Lote', LO.FechaIngresoGranja as 'Fecha de ingreso a la granja',
LO.FechaIngresoPais as 'Fecha de ingreso al pais', LO.Unidades, LO.PromedioGramos
as 'Peso Promedio', LO.Costo, LO.Observaciones, EL.Descripcion as 'Estado del lote',
CONCAT(PR.DocIdentidad,' - ', PR.Nombre) as 'Provedor'

FROM tbllotes as LO INNER JOIN tblestadolote as EL
on LO.EstadoLote = EL.IdEstadoLote
INNER JOIN tblprovedores as PR 
ON LO.Provedor = PR.DocIdentidad;

END$$

DROP PROCEDURE IF EXISTS `SP_MostrarMunicipios`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MostrarMunicipios` ()   BEGIN

SELECT MU.idMunicipio as 'ID', MU.Nombre as 'Municipio' , DE.Nombre as 'Departamento'

FROM tblMunicipios as MU INNER JOIN tblDepartamentos as DE
on MU.Departamento = DE.IdDepartamento;

END$$

DROP PROCEDURE IF EXISTS `SP_MostrarProvedores`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MostrarProvedores` ()   BEGIN

SELECT PR.DocIdentidad as 'Doc de Identidad', PR.Nombre, PR.Telefono,
PR.Correo, PR.Direccion, concat(MU.Nombre,' - ', DE.Nombre) AS 'Ciudad'

FROM tblprovedores as PR INNER JOIN tblmunicipios as MU
ON PR.Municipio = MU.IdMunicipio 
INNER JOIN tbldepartamentos as DE
ON MU.Departamento = DE.IdDepartamento;
END$$

DROP PROCEDURE IF EXISTS `SP_MostrarRoles`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MostrarRoles` ()   BEGIN

SELECT IdRol as 'ID', Descripcion as 'Rol'
FROM tblrol;

END$$

DROP PROCEDURE IF EXISTS `SP_MuestrasActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MuestrasActualizar` (IN `_IdMuestra` INT(5), IN `_Fecha` VARCHAR(10), IN `_Peso` DECIMAL(8,2), IN `_Unidades` INT(3), IN `_Observaciones` VARCHAR(500), IN `_LoteCanal` INT(8), IN `_Usuario` VARCHAR(12))   BEGIN 

UPDATE tblmuestras
SET Fecha = _Fecha, 
    PesoTotal = _Peso,
    Unidades = _Unidades,
    Observaciones = _Observaciones,
    LoteCanal = _LoteCanal,
    Usuario = _Usuario
    
    WHERE IdMuestra = _IdMuestra;

END$$

DROP PROCEDURE IF EXISTS `SP_MuestrasEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MuestrasEliminar` (IN `_IdMuestra` INT(5))   BEGIN 

DELETE FROM tblmuestras
    
    WHERE IdMuestra = _IdMuestra;

END$$

DROP PROCEDURE IF EXISTS `SP_MuestrasInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_MuestrasInsertar` (IN `_Fecha` VARCHAR(10), IN `_Peso` DECIMAL(8,2), IN `_Unidades` INT(3), IN `_Observaciones` VARCHAR(500), IN `_LoteCanal` INT(8), IN `_Usuario` VARCHAR(12))   BEGIN 

INSERT INTO tblmuestras
VALUES(NULL,_Fecha, _Peso, _Unidades, _Observaciones, _LoteCanal,_Usuario);

END$$

DROP PROCEDURE IF EXISTS `sp_MunicipiosActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_MunicipiosActualizar` (IN `_IdMunicipio` VARCHAR(5), IN `_Nombre` VARCHAR(30), IN `_Departamento` VARCHAR(2))   BEGIN
	UPDATE tblmunicipios
    SET Nombre=_Nombre,
        Departamento=_Departamento
        WHERE IdMunicipio=_IdMunicipio;
END$$

DROP PROCEDURE IF EXISTS `sp_MunicipiosEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_MunicipiosEliminar` (IN `_IdMunicipio` VARCHAR(5))   BEGIN
	DELETE FROM tblmunicipios
    WHERE IdMunicipio=_IdMunicipio;
END$$

DROP PROCEDURE IF EXISTS `sp_MunicipiosInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_MunicipiosInsertar` (IN `_IdMunicipio` VARCHAR(5), IN `_Nombre` VARCHAR(30), IN `_Departamento` VARCHAR(2))   BEGIN
	INSERT INTO tblmunicipios
    VALUES(_IdMunicipio,_Nombre,_Departamento);
END$$

DROP PROCEDURE IF EXISTS `SP_PostProduccionActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PostProduccionActualizar` (IN `_Id` INT(10), IN `_Fecha` VARCHAR(10), IN `_Peso` DECIMAL(7,2), IN `_Unidades` INT(5), IN `_PrecioVenta` INT(8), IN `_Observaciones` VARCHAR(2000), IN `_LoteCanal` INT(8), IN `_Usuario` VARCHAR(12))   BEGIN 

UPDATE  tblpostproduccion 
SET   Fecha = _Fecha,
      Peso =  _Peso,
      Unidades = _Unidades,
      PrecioVenta = _PrecioVenta,
      Observaciones = _Observaciones,
      LoteCanal = _LoteCanal,
      Usuario = _Usuario 
      
WHERE Id = _Id ;

END$$

DROP PROCEDURE IF EXISTS `SP_PostProduccionAgregar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PostProduccionAgregar` (IN `_Fecha` VARCHAR(10), IN `_Peso` DECIMAL(7,2), IN `_Unidades` INT(5), IN `_PrecioVenta` INT(8), IN `_Observaciones` VARCHAR(2000), IN `_LoteCanal` INT(8), IN `_Usuario` VARCHAR(12))   BEGIN 

INSERT INTO tblpostproduccion 
VALUES(NULL,_Fecha, _Peso,_Unidades,_PrecioVenta,_Observaciones,_LoteCanal,_Usuario );

END$$

DROP PROCEDURE IF EXISTS `sp_PostProduccionConsultarTodo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_PostProduccionConsultarTodo` ()   BEGIN
SELECT PP.Id, PP.Fecha, PP.Peso, PP.Unidades, PP.PrecioVenta, PP.Observaciones, concat(LC.Lote,'-',LC.Canal) as 'Lote Canal',US.DocIdentidad as 'DocID usuario encargado'
FROM tblpostproduccion as PP INNER JOIN tbllotecanal as LC
ON PP.LoteCanal = LC.IdLoteCanal
INNER JOIN tblusuarios as US
ON PP.Usuario = US.DocIdentidad;
END$$

DROP PROCEDURE IF EXISTS `SP_PostProduccionEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PostProduccionEliminar` (IN `_Id` INT(10))   BEGIN 

DELETE FROM tblpostproduccion 

WHERE Id = _Id;

END$$

DROP PROCEDURE IF EXISTS `sp_PostProduccionPorID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_PostProduccionPorID` (IN `_ID` INT(10))   BEGIN
SELECT PP.Id, PP.Fecha, PP.Peso, PP.Unidades, PP.PrecioVenta, PP.Observaciones, concat(LC.Lote,'-',LC.Canal) as 'Lote Canal',US.DocIdentidad as 'DocID usuario encargado'
FROM tblpostproduccion as PP INNER JOIN tbllotecanal as LC
ON PP.LoteCanal = LC.IdLoteCanal
INNER JOIN tblusuarios as US
ON PP.Usuario = US.DocIdentidad
HAVING PP.Id = _ID;
END$$

DROP PROCEDURE IF EXISTS `sp_ProvedoresActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ProvedoresActualizar` (IN `_Doc` VARCHAR(12), IN `_Nombre` VARCHAR(30), IN `_Telefono` VARCHAR(10), IN `_Correo` VARCHAR(30), IN `_Direccion` VARCHAR(80), IN `_Municipio` VARCHAR(5))   BEGIN
 UPDATE tblprovedores
 SET Nombre=_Nombre,
 	Telefono= _Telefono,
    Correo=_Correo,
    Direccion=_Direccion,
    Municipio=_Municipio
    WHERE DocIdentidad=_Doc;
END$$

DROP PROCEDURE IF EXISTS `sp_ProvedoresEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ProvedoresEliminar` (IN `_Doc` VARCHAR(12))   BEGIN
 DELETE FROM tblprovedores
 WHERE DocIdentidad=_Doc;
END$$

DROP PROCEDURE IF EXISTS `sp_ProvedoresInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ProvedoresInsertar` (IN `_Doc` VARCHAR(12), IN `_Nombre` VARCHAR(30), IN `_Telefono` VARCHAR(10), IN `_Correo` VARCHAR(30), IN `_Direccion` VARCHAR(80), IN `_Municipio` VARCHAR(5))   BEGIN
INSERT INTO tblprovedores
VALUES(_Doc,_Nombre,_Telefono,_Correo,_Direccion,_Municipio);
END$$

DROP PROCEDURE IF EXISTS `SP_ProvedorLote`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ProvedorLote` (IN `_Lote` INT(8))   BEGIN

SELECT LO.IdLote as 'Lote' , CONCAT(PR.DocIdentidad ,' - ', PR.Nombre) as 'Provedor'

FROM tbllotes as LO INNER JOIN tblprovedores as PR
ON LO.Provedor = PR.DocIdentidad

WHERE LO.IdLote = _Lote

ORDER BY LO.IdLote;

END$$

DROP PROCEDURE IF EXISTS `SP_RolActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RolActualizar` (IN `_IdRol` INT(1), IN `_Descripcion` VARCHAR(20))   BEGIN
	UPDATE tblrol
    SET Descripcion = _Descripcion
    WHERE IdRol = _IdRol;
END$$

DROP PROCEDURE IF EXISTS `SP_RolEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RolEliminar` (IN `_IdRol` INT(1))   BEGIN
	DELETE FROM tblrol
    WHERE IdRol = _IdRol;
END$$

DROP PROCEDURE IF EXISTS `SP_RolInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RolInsertar` (IN `_Descripcion` VARCHAR(20))   BEGIN
	INSERT INTO tblrol
    VALUES (null,_Descripcion);
END$$

DROP PROCEDURE IF EXISTS `sp_TrasladosActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_TrasladosActualizar` (IN `_IdTraslado` INT(4), IN `_Fecha` DATE, IN `_LoteCanal` INT(8), IN `_CanalDestino` VARCHAR(3), IN `_Observaciones` VARCHAR(2000), IN `_Usuario` VARCHAR(12))   BEGIN
 	UPDATE tbltraslados
    SET Fecha=_Fecha,
    	LoteCanal=_LoteCanal,
        CanalDestino=_CanalDestino,
        Observaciones=_Observaciones,
        Usuario=_Usuario
        WHERE IdTraslado=_IdTraslado;
END$$

DROP PROCEDURE IF EXISTS `sp_TrasladosConsultarTodos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_TrasladosConsultarTodos` ()   BEGIN
SELECT TR.IdTraslado, TR.Fecha as 'Fecha traslado',concat (LC.Lote,'-',LC.Canal) as 'Lote Canal', CA.IdCanal, TR.Observaciones, US.DocIdentidad as 'DocID usuario encargado'
FROM tbltraslados as TR INNER JOIN tbllotecanal as LC
ON TR.LoteCanal = LC.IdLoteCanal
INNER JOIN tblcanales as CA
ON CA.IdCanal = TR.CanalDestino
INNER JOIN tblusuarios as US
ON US.DocIdentidad = TR.Usuario;
END$$

DROP PROCEDURE IF EXISTS `sp_TrasladosEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_TrasladosEliminar` (IN `_IdTraslado` INT(4))   BEGIN
 	DELETE FROM tbltraslados
    WHERE IdTraslado=_IdTraslado;
END$$

DROP PROCEDURE IF EXISTS `sp_TrasladosInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_TrasladosInsertar` (IN `_Fecha` DATE, IN `_LoteCanal` INT(8), IN `_CanalDestino` VARCHAR(3), IN `_Observaciones` VARCHAR(2000), IN `_Usuario` VARCHAR(12))   BEGIN
INSERT INTO tbltraslados
	VALUES(null,_Fecha,_LoteCanal,_CanalDestino,_Observaciones,_Usuario);
END$$

DROP PROCEDURE IF EXISTS `sp_TrasladosPorID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_TrasladosPorID` (IN `_ID` INT(4))   BEGIN
SELECT TR.IdTraslado, TR.Fecha as 'Fecha traslado',concat (LC.Lote,'-',LC.Canal) as 'Lote Canal', CA.IdCanal, TR.Observaciones, US.DocIdentidad as 'DocID usuario encargado'
FROM tbltraslados as TR INNER JOIN tbllotecanal as LC
ON TR.LoteCanal = LC.IdLoteCanal
INNER JOIN tblcanales as CA
ON CA.IdCanal = TR.CanalDestino
INNER JOIN tblusuarios as US
ON US.DocIdentidad = TR.Usuario
HAVING TR.IdTraslado = 5;
END$$

DROP PROCEDURE IF EXISTS `sp_UsuariosActualizar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_UsuariosActualizar` (IN `_DocID` VARCHAR(12), IN `_Nombre` VARCHAR(80), IN `_Apellidos` VARCHAR(80), IN `_Correo` VARCHAR(80), IN `_Direccion` VARCHAR(80), IN `_Contra` VARCHAR(64), IN `_Foto` BLOB, IN `_Rol` INT(1), IN `_EstadoCuenta` INT(1))   BEGIN
	UPDATE tblusuarios
    SET Nombres = _Nombre,
    	Apellidos = _Apellidos,
        Correo = _Correo,
        Direccion = _Direccion,
        Contrasena = _Contra,
        FotoPerfil = _Foto,
        Rol = _Rol,
        EstadoCuenta = _EstadoCuenta
        
	WHERE DocIdentidad = _DocID;
END$$

DROP PROCEDURE IF EXISTS `sp_UsuariosEliminar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_UsuariosEliminar` (IN `_DocID` VARCHAR(12))   BEGIN 
	DELETE FROM tblusuarios
    WHERE DocIdentidad = _DocID;
END$$

DROP PROCEDURE IF EXISTS `sp_UsuariosInsertar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_UsuariosInsertar` (IN `_DocID` VARCHAR(12), IN `_Nombre` VARCHAR(80), IN `_Apellidos` VARCHAR(80), IN `_Correo` VARCHAR(80), IN `_Direccion` VARCHAR(80), IN `_Contra` VARCHAR(64), IN `_Foto` BLOB, IN `_Rol` INT(1), IN `_EstadoCuenta` INT(1))   BEGIN
INSERT INTO tblusuarios
	VALUES(_DocID,_Nombre,_Apellidos,_Correo,_Direccion,_Contra,_Foto,_Rol,_EstadoCuenta);
END$$

DROP PROCEDURE IF EXISTS `sp_ValorTotalAlimentacionPorLotes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ValorTotalAlimentacionPorLotes` (IN `_IDLOTE` INT(8))   BEGIN
SELECT LO.IdLote, LO.Unidades as 'Uds lote', LO.Observaciones, AL.IdAlimentacion, AL.Fecha as 'FECHA DE ALIMENTACION', AL.Cantidad as 'CANTIDAD DE ALIMENTO EN KG', concat(LC.Lote,'-',LC.Canal) as 'Lote Canal', AL.Usuario as 'DocID usuario encargado', INS.IdInsumo, INS.Descripcion as 'Insumo', INS.Referencia as 'Referencia Insumo', INS.Costo as 'Costo por bulto(40kg)',(INS.Costo/40) AS 'Costo por kg',(AL.Cantidad*(INS.Costo/40)) AS 'COSTO TOTAL'
FROM tbllotes as LO INNER JOIN tbllotecanal as LC
ON LO.IdLote = LC.Lote
INNER JOIN tblalimentacion as AL
ON LC.IdLoteCanal = AL.LoteCanal
INNER JOIN tblinsumos as INS
ON AL.Insumo = INS.IdInsumo
GROUP BY LO.IdLote
HAVING LO.IdLote= _IDLOTE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblalimentacion`
--

DROP TABLE IF EXISTS `tblalimentacion`;
CREATE TABLE `tblalimentacion` (
  `IdAlimentacion` int(10) NOT NULL,
  `Fecha` date NOT NULL,
  `Cantidad` int(3) NOT NULL,
  `Insumo` int(2) NOT NULL,
  `LoteCanal` int(8) NOT NULL,
  `Usuario` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblalimentacion`
--

INSERT INTO `tblalimentacion` (`IdAlimentacion`, `Fecha`, `Cantidad`, `Insumo`, `LoteCanal`, `Usuario`) VALUES
(1, '2023-07-23', 10, 2, 1, '1026130194'),
(2, '2023-07-23', 20, 1, 2, '1026130194'),
(3, '2023-07-23', 15, 3, 3, '1026130194'),
(4, '2023-07-23', 13, 2, 4, '1026130194'),
(5, '2023-07-23', 25, 3, 5, '1026130194');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblbitacoraslote`
--

DROP TABLE IF EXISTS `tblbitacoraslote`;
CREATE TABLE `tblbitacoraslote` (
  `IdBitacora` int(8) NOT NULL,
  `Fecha` date NOT NULL,
  `LoteCanal` int(8) NOT NULL,
  `Descripcion` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `Usuario` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblcanales`
--

DROP TABLE IF EXISTS `tblcanales`;
CREATE TABLE `tblcanales` (
  `IdCanal` varchar(3) NOT NULL,
  `Largo` decimal(3,1) NOT NULL,
  `Ancho` decimal(3,1) NOT NULL,
  `Profundidad` decimal(3,1) NOT NULL,
  `Oxigeno` decimal(2,1) NOT NULL,
  `Caudal` decimal(3,1) NOT NULL,
  `Temperatura` decimal(3,1) NOT NULL,
  `Turbidez` decimal(3,1) NOT NULL,
  `Ph` int(2) NOT NULL,
  `Granja` int(2) NOT NULL,
  `EstadoCanal` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblcanales`
--

INSERT INTO `tblcanales` (`IdCanal`, `Largo`, `Ancho`, `Profundidad`, `Oxigeno`, `Caudal`, `Temperatura`, `Turbidez`, `Ph`, `Granja`, `EstadoCanal`) VALUES
('A01', 10.2, 2.0, 1.5, 8.2, 30.0, 15.0, 3.0, 5, 1, 1),
('A02', 10.2, 2.0, 1.5, 8.2, 30.0, 15.0, 3.0, 5, 1, 1),
('A03', 10.2, 2.0, 1.5, 8.2, 30.0, 15.0, 3.0, 5, 1, 1),
('A04', 10.7, 2.3, 1.7, 8.4, 30.1, 15.3, 3.3, 5, 1, 1),
('A05', 10.4, 2.1, 1.6, 8.0, 30.3, 15.5, 3.0, 4, 4, 2),
('A06', 10.9, 2.4, 1.5, 8.2, 30.4, 15.4, 3.1, 8, 2, 1),
('A07', 10.6, 2.0, 1.3, 8.3, 30.6, 15.1, 3.4, 8, 5, 2),
('A08', 10.5, 2.2, 1.6, 8.1, 30.7, 15.2, 3.2, 4, 3, 1),
('A09', 10.3, 2.1, 1.7, 8.0, 30.8, 15.4, 3.0, 6, 4, 2),
('A10', 10.7, 2.3, 1.4, 8.2, 30.9, 15.3, 3.1, 3, 1, 1),
('A11', 10.8, 2.4, 1.5, 8.4, 30.2, 15.5, 3.5, 6, 2, 2),
('A12', 10.9, 2.0, 1.6, 8.3, 30.1, 15.1, 3.4, 4, 5, 1),
('B01', 10.2, 2.0, 1.5, 8.2, 30.0, 15.0, 3.0, 5, 1, 1),
('B02', 10.2, 2.0, 1.5, 8.2, 30.0, 15.0, 3.0, 5, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbldepartamentos`
--

DROP TABLE IF EXISTS `tbldepartamentos`;
CREATE TABLE `tbldepartamentos` (
  `IdDepartamento` varchar(2) NOT NULL,
  `Nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbldepartamentos`
--

INSERT INTO `tbldepartamentos` (`IdDepartamento`, `Nombre`) VALUES
('05', 'Antioquia'),
('08', 'Atlàntico'),
('09', 'Barranquilla'),
('11', 'Bogotà'),
('13', 'Bolìvar');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblestadocanal`
--

DROP TABLE IF EXISTS `tblestadocanal`;
CREATE TABLE `tblestadocanal` (
  `IdEstado` int(1) NOT NULL,
  `Descripcion` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblestadocanal`
--

INSERT INTO `tblestadocanal` (`IdEstado`, `Descripcion`) VALUES
(1, 'Disponible'),
(2, 'Ocupado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblestadocuenta`
--

DROP TABLE IF EXISTS `tblestadocuenta`;
CREATE TABLE `tblestadocuenta` (
  `IdEstado` int(1) NOT NULL,
  `Descripcion` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblestadocuenta`
--

INSERT INTO `tblestadocuenta` (`IdEstado`, `Descripcion`) VALUES
(1, 'Activo'),
(2, 'Inactivo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblestadolote`
--

DROP TABLE IF EXISTS `tblestadolote`;
CREATE TABLE `tblestadolote` (
  `IdEstadoLote` int(1) NOT NULL,
  `Descripcion` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblestadolote`
--

INSERT INTO `tblestadolote` (`IdEstadoLote`, `Descripcion`) VALUES
(1, 'Alevinaje'),
(2, 'Juveniles'),
(3, 'Crecimiento'),
(4, 'Produccion');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblgranja`
--

DROP TABLE IF EXISTS `tblgranja`;
CREATE TABLE `tblgranja` (
  `IdGranja` int(2) NOT NULL,
  `Nombre` varchar(30) NOT NULL,
  `Direccion` varchar(80) NOT NULL,
  `Telefono` varchar(10) NOT NULL,
  `Municipio` varchar(5) NOT NULL,
  `Usuario` varchar(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblgranja`
--

INSERT INTO `tblgranja` (`IdGranja`, `Nombre`, `Direccion`, `Telefono`, `Municipio`, `Usuario`) VALUES
(1, 'Granja la malta', 'VRD La paja', '321589475', '05002', '1026130194'),
(2, 'Granja la playa', 'VRD la lupita', '321589475', '05002', '1026130194'),
(3, 'Granja la teresa', 'VRD La papa', '3215749475', '05002', '1324587748'),
(4, 'Granja mi pez feliz', 'VRD santo domingo', '321589475', '05002', '1324587748'),
(5, 'Granja la pestaña', 'La ceja', '321589475', '05021', '1026130194');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblinsumos`
--

DROP TABLE IF EXISTS `tblinsumos`;
CREATE TABLE `tblinsumos` (
  `IdInsumo` int(2) NOT NULL,
  `Descripcion` varchar(1000) NOT NULL,
  `Costo` int(10) NOT NULL,
  `Referencia` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblinsumos`
--

INSERT INTO `tblinsumos` (`IdInsumo`, `Descripcion`, `Costo`, `Referencia`) VALUES
(1, 'Alimento completo con 45% de proteína como mínimo, diseñado y fabricado para alevinos de trucha “Arco Iris”, cuyos índices de crecimiento incrementan rápidamente. Contiene proteína de óptimo valor biológico, debida a su estricta y rigurosa formulación; permitiendo un rápido crecimiento y una baja mortalidad, lo que refleja al final una mejor conversión alimenticia.', 199200, 'Inicio granulado I'),
(2, 'Alimento de un alto valor energético, con un nivel de 45 y 42,0% de proteínas para crecimiento 1 y crecimiento 2, respectivamente. Fabricado y diseñado exclusivamente para truchas en estadío juvenil (10-18 cm. de longitud); que permiten obtener altas tasas de crecimiento y bajos factores de conversión alimenticia. El rango de crecimiento (20 a 80 gr. de peso) oscila entre 2,5 a 3,0 meses, tiempo que permite una reducción en los costos de producción.', 247600, 'Crecimiento I '),
(3, 'Alimento completo elaborado especialmente para truchas precomerciales y/o comerciales con tallas de 18 a 27 cm. de longitud, equivalentes a un peso de 80 a 250 gr. Los tiempos logrados oscilan entre 1,5 a 2,0 y 2,0 a 3,0 meses para la etapa precomercial (18 a 24 cm. de longitud) y para toda la etapa de engorde, respectivamente. Se dispone del alimento acabado con pigmento el cual esta diseñado especialmente para truchas comerciales con una demanda exigente en la pigmentación del músculo.', 265600, 'Acabado Pigmentado'),
(4, 'Alimento completo con 45% de proteína como mínimo, diseñado y fabricado para alevinos de trucha “Arco Iris”, cuyos índices de crecimiento incrementan rápidamente. Contiene proteína de óptimo valor biológico, debida a su estricta y rigurosa formulación; permitiendo un rápido crecimiento y una baja mortalidad, lo que refleja al final una mejor conversión alimenticia.', 199200, 'Inicio II (Pellets)'),
(5, 'Alimento completo elaborado especialmente para truchas precomerciales y/o comerciales con tallas de 18 a 27 cm. de longitud, equivalentes a un peso de 80 a 250 gr. Los tiempos logrados oscilan entre 1,5 a 2,0 y 2,0 a 3,0 meses para la etapa precomercial (18 a 24 cm. de longitud) y para toda la etapa de engorde, respectivamente. Se dispone del alimento acabado con pigmento el cual esta diseñado especialmente para truchas comerciales con una demanda exigente en la pigmentación del músculo.', 265600, 'Acabado Simple ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbllotecanal`
--

DROP TABLE IF EXISTS `tbllotecanal`;
CREATE TABLE `tbllotecanal` (
  `IdLoteCanal` int(8) NOT NULL,
  `Lote` int(8) NOT NULL,
  `Canal` varchar(3) NOT NULL,
  `FechaIngresoCanal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbllotecanal`
--

INSERT INTO `tbllotecanal` (`IdLoteCanal`, `Lote`, `Canal`, `FechaIngresoCanal`) VALUES
(1, 1, 'A01', '2023-07-21'),
(2, 2, 'A02', '2023-08-21'),
(3, 3, 'A03', '2023-04-21'),
(4, 4, 'B01', '2023-01-21'),
(5, 5, 'B02', '2023-08-21'),
(11, 8, 'A07', '2023-07-20'),
(13, 8, 'A07', '0000-00-00'),
(15, 8, 'A07', '0000-00-00'),
(16, 10, 'A08', '0000-00-00'),
(17, 8, 'A07', '0000-00-00'),
(18, 10, 'A08', '0000-00-00'),
(19, 12, 'A09', '0000-00-00'),
(20, 14, 'A10', '0000-00-00'),
(21, 16, 'A11', '0000-00-00'),
(22, 18, 'A12', '0000-00-00'),
(23, 20, 'B01', '0000-00-00'),
(24, 22, 'B02', '0000-00-00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbllotes`
--

DROP TABLE IF EXISTS `tbllotes`;
CREATE TABLE `tbllotes` (
  `IdLote` int(8) NOT NULL,
  `FechaIngresoGranja` date NOT NULL,
  `FechaIngresoPais` date NOT NULL,
  `Unidades` int(7) NOT NULL,
  `PromedioGramos` decimal(5,2) NOT NULL,
  `PrecioUnidad` int(7) NOT NULL,
  `Observaciones` int(8) DEFAULT NULL,
  `EstadoLote` int(1) NOT NULL,
  `Provedor` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbllotes`
--

INSERT INTO `tbllotes` (`IdLote`, `FechaIngresoGranja`, `FechaIngresoPais`, `Unidades`, `PromedioGramos`, `PrecioUnidad`, `Observaciones`, `EstadoLote`, `Provedor`) VALUES
(1, '2023-07-21', '2023-07-21', 10000, 4.50, 400, NULL, 1, '1033230762'),
(2, '2023-06-21', '2023-05-21', 10000, 4.50, 420, NULL, 1, '1040032972'),
(3, '2023-05-21', '2023-04-21', 9000, 4.50, 390, NULL, 1, '1040029762'),
(4, '2023-04-21', '2023-03-21', 11000, 4.50, 410, NULL, 1, '3922230762'),
(5, '2023-03-21', '2023-02-21', 18000, 4.50, 480, NULL, 1, '3940029762'),
(8, '2023-08-05', '2023-08-03', 8500, 5.20, 370, NULL, 1, '1033230762'),
(9, '2023-08-10', '2023-08-08', 12000, 4.80, 450, NULL, 2, '3940029762'),
(10, '2023-07-28', '2023-07-25', 9500, 4.90, 410, NULL, 1, '3940029762'),
(11, '2023-08-12', '2023-08-10', 13000, 4.60, 430, NULL, 2, '3940029762'),
(12, '2023-07-22', '2023-07-21', 9000, 4.60, 390, NULL, 1, '1033230762'),
(14, '2023-07-22', '2023-07-21', 9000, 4.60, 390, NULL, 1, '1033230762'),
(15, '2023-07-23', '2023-07-22', 10500, 4.75, 405, NULL, 1, '1040029762'),
(16, '2023-07-24', '2023-07-23', 11000, 4.80, 410, NULL, 1, '1040032972'),
(17, '2023-07-25', '2023-07-24', 9500, 4.55, 385, NULL, 1, '3922230762'),
(18, '2023-07-26', '2023-07-25', 10000, 4.70, 400, NULL, 1, '3940029762'),
(19, '2023-07-27', '2023-07-26', 9200, 4.65, 395, NULL, 1, '1033230762'),
(20, '2023-07-28', '2023-07-27', 9700, 4.70, 398, NULL, 1, '1040029762'),
(21, '2023-07-29', '2023-07-28', 9800, 4.75, 399, NULL, 1, '1040032972'),
(22, '2023-07-30', '2023-07-29', 8900, 4.60, 388, NULL, 1, '3922230762'),
(23, '2023-07-31', '2023-07-30', 9500, 4.68, 390, NULL, 1, '3940029762'),
(24, '2023-08-01', '2023-07-31', 10000, 4.80, 410, NULL, 1, '1033230762'),
(25, '2023-08-02', '2023-08-01', 10200, 4.85, 420, NULL, 1, '1040029762'),
(26, '2023-08-03', '2023-08-02', 9600, 4.70, 400, NULL, 1, '1040032972'),
(27, '2023-08-04', '2023-08-03', 9800, 4.60, 405, NULL, 1, '3922230762'),
(28, '2023-08-05', '2023-08-04', 9200, 4.75, 395, NULL, 1, '3940029762'),
(29, '2023-08-06', '2023-08-05', 9500, 4.65, 3970000, NULL, 1, '1033230762'),
(30, '2023-08-07', '2023-08-06', 9400, 4.68, 3960000, NULL, 1, '1040029762'),
(31, '2023-08-08', '2023-08-07', 9900, 4.80, 4100000, NULL, 1, '1040032972'),
(32, '2023-08-09', '2023-08-08', 9300, 4.62, 3920000, NULL, 1, '3922230762'),
(33, '2023-08-10', '2023-08-09', 9700, 4.77, 3990000, NULL, 1, '3940029762');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblmortalidad`
--

DROP TABLE IF EXISTS `tblmortalidad`;
CREATE TABLE `tblmortalidad` (
  `IdMortalidad` int(5) NOT NULL,
  `Fecha` date NOT NULL,
  `Kilogramos` decimal(7,2) NOT NULL,
  `UnidadesBuenEstado` int(5) NOT NULL,
  `UnidadesMalEstado` int(5) NOT NULL,
  `Observaciones` varchar(2000) DEFAULT NULL,
  `LoteCanal` int(8) NOT NULL,
  `Usuario` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblmortalidad`
--

INSERT INTO `tblmortalidad` (`IdMortalidad`, `Fecha`, `Kilogramos`, `UnidadesBuenEstado`, `UnidadesMalEstado`, `Observaciones`, `LoteCanal`, `Usuario`) VALUES
(1, '2023-07-23', 600.00, 3, 0, NULL, 1, '1026130194'),
(2, '2023-07-24', 2000.00, 4, 0, NULL, 2, '4578754454'),
(3, '2023-07-25', 1100.00, 5, 1, 'Muerte causada por calor', 3, '8784445484'),
(4, '2023-07-26', 400.00, 2, 0, NULL, 4, '1026130194'),
(5, '2023-07-27', 200.00, 0, 1, 'Unidad en estado de descomposición', 5, '7854544855');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblmuestras`
--

DROP TABLE IF EXISTS `tblmuestras`;
CREATE TABLE `tblmuestras` (
  `IdMuestra` int(5) NOT NULL,
  `Fecha` date NOT NULL,
  `PesoTotal` decimal(8,2) NOT NULL,
  `Unidades` int(3) NOT NULL,
  `Observaciones` varchar(500) DEFAULT NULL,
  `LoteCanal` int(8) NOT NULL,
  `Usuario` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblmuestras`
--

INSERT INTO `tblmuestras` (`IdMuestra`, `Fecha`, `PesoTotal`, `Unidades`, `Observaciones`, `LoteCanal`, `Usuario`) VALUES
(1, '2023-07-23', 1600.23, 21, 'Peso normal', 1, '1026130194'),
(2, '2023-07-24', 9999.99, 24, 'Peso no acorde al numero de muestras ', 2, '4578754454'),
(3, '2023-07-25', 9999.99, 25, 'Normal', 3, '8784445484'),
(4, '2023-07-26', 4320.34, 15, NULL, 4, '1026130194'),
(5, '2023-07-27', 9999.99, 23, 'Lote requiere mas concentrado', 5, '7854544855');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblmunicipios`
--

DROP TABLE IF EXISTS `tblmunicipios`;
CREATE TABLE `tblmunicipios` (
  `IdMunicipio` varchar(5) NOT NULL,
  `Nombre` varchar(30) NOT NULL,
  `Departamento` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblmunicipios`
--

INSERT INTO `tblmunicipios` (`IdMunicipio`, `Nombre`, `Departamento`) VALUES
('05001', 'Medellìn', '05'),
('05002', 'Abejorral', '05'),
('05004', 'Abriaquì', '05'),
('05021', 'Alejandrìa', '05'),
('05030', 'Amagà', '05');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblpostproduccion`
--

DROP TABLE IF EXISTS `tblpostproduccion`;
CREATE TABLE `tblpostproduccion` (
  `Id` int(10) NOT NULL,
  `Fecha` date NOT NULL,
  `PesoKilos` decimal(8,2) NOT NULL,
  `Unidades` int(5) NOT NULL,
  `PrecioVentaKilo` int(8) NOT NULL,
  `Observaciones` varchar(2000) NOT NULL,
  `LoteCanal` int(8) NOT NULL,
  `Usuario` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblpostproduccion`
--

INSERT INTO `tblpostproduccion` (`Id`, `Fecha`, `PesoKilos`, `Unidades`, `PrecioVentaKilo`, `Observaciones`, `LoteCanal`, `Usuario`) VALUES
(1, '2023-10-23', 220.00, 800, 20000, 'Lote dejo buenas ganancias', 1, '1026130194'),
(2, '2023-12-24', 240.00, 900, 18500, 'Lote con buen promedio de peso y rentable ', 2, '4578754454'),
(3, '2023-11-25', 300.00, 1000, 20000, 'Semilla dejo perdida', 3, '8784445484'),
(4, '2023-09-26', 432.00, 1100, 20000, '', 4, '1026130194'),
(5, '2023-08-27', 260.00, 950, 20000, 'Promedio por debajo de lo previsto', 5, '7854544855'),
(6, '2024-02-15', 280.00, 1100, 26000, 'Lote dejo buenas ganancias', 2, '1324587748'),
(7, '2024-03-20', 320.00, 850, 19000, 'Promedio por debajo de lo previsto', 15, '4578754454');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblprovedores`
--

DROP TABLE IF EXISTS `tblprovedores`;
CREATE TABLE `tblprovedores` (
  `DocIdentidad` varchar(12) NOT NULL,
  `Nombre` varchar(30) NOT NULL,
  `Telefono` varchar(10) NOT NULL,
  `Correo` varchar(30) DEFAULT NULL,
  `Direccion` varchar(80) NOT NULL,
  `Municipio` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblprovedores`
--

INSERT INTO `tblprovedores` (`DocIdentidad`, `Nombre`, `Telefono`, `Correo`, `Direccion`, `Municipio`) VALUES
('1033230762', 'Luis David', '3205783780', 'David_Luis39@hotmail.com', 'crr23 cll21 #40-31', '05002'),
('1040029762', 'Miguel', '3054020327', 'MiguelOroz@gmail.com', 'crr2A', '05021'),
('1040032972', 'Jacob', '3054539782', 'jacob_lopez@soy.sena.edu.co', 'crr20 #20-30', '05021'),
('3922230762', 'Martin', '3154330637', 'Mar320xx@gmail.com', 'crr2A cll34 #20-25', '05001'),
('3940029762', 'Alfonso', '3154320527', 'Alfonso0232@gmail.com', 'crr21 cll32 #20-21', '05030');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblrol`
--

DROP TABLE IF EXISTS `tblrol`;
CREATE TABLE `tblrol` (
  `IdRol` int(1) NOT NULL,
  `Descripcion` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblrol`
--

INSERT INTO `tblrol` (`IdRol`, `Descripcion`) VALUES
(1, 'Administrador'),
(2, 'Usuario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbltraslados`
--

DROP TABLE IF EXISTS `tbltraslados`;
CREATE TABLE `tbltraslados` (
  `IdTraslado` int(4) NOT NULL,
  `Fecha` date NOT NULL,
  `LoteCanal` int(8) NOT NULL,
  `CanalDestino` varchar(3) NOT NULL,
  `Observaciones` varchar(2000) DEFAULT NULL,
  `Usuario` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tbltraslados`
--

INSERT INTO `tbltraslados` (`IdTraslado`, `Fecha`, `LoteCanal`, `CanalDestino`, `Observaciones`, `Usuario`) VALUES
(1, '2023-10-23', 1, 'A01', 'Se realizo traslado por falta de espacio', '1026130194'),
(2, '2023-12-24', 2, 'A02', 'Lote disparejo', '4578754454'),
(3, '2023-11-25', 3, 'A03', 'Sin novedades', '8784445484'),
(4, '2023-09-26', 4, 'B01', 'Sin novedades', '1026130194'),
(5, '2023-08-27', 5, 'B02', 'Lote con signos de hongos', '7854544855');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tblusuarios`
--

DROP TABLE IF EXISTS `tblusuarios`;
CREATE TABLE `tblusuarios` (
  `DocIdentidad` varchar(12) NOT NULL,
  `Nombres` varchar(80) NOT NULL,
  `Apellidos` varchar(80) NOT NULL,
  `Correo` varchar(80) NOT NULL,
  `Direccion` varchar(80) NOT NULL,
  `Contrasena` varchar(64) NOT NULL,
  `FotoPerfil` blob DEFAULT NULL,
  `Rol` int(1) NOT NULL,
  `EstadoCuenta` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tblusuarios`
--

INSERT INTO `tblusuarios` (`DocIdentidad`, `Nombres`, `Apellidos`, `Correo`, `Direccion`, `Contrasena`, `FotoPerfil`, `Rol`, `EstadoCuenta`) VALUES
('1026130194', 'Diego Alejandro', 'Vallejo Rivillas', 'alejandrovallejo@gmail.com', 'cra 43 23-43', '7766d9a33da357cf9620d7a7b52316ca681d83d8', NULL, 2, 1),
('1324587748', 'Jacob', 'Lopez Mejia', 'jacob_lopez@gmail.com', 'cra #3 65-76', 'c22289fcb12f66d070f1e802864d4dc4', NULL, 2, 1),
('4578754454', 'Andres', 'Cespedez', 'A_cespedez@gamil.com', 'cra #43 65-87', 'bcb973bfa191cfe53c01cd444dd3e31d', NULL, 2, 1),
('7854544855', 'Diego', 'Restrepo', 'diego_ares@gmail.com', 'cra #21 43-43', '6e19c1b4ab55e89e8bbbda551930bded', NULL, 2, 1),
('8784445484', 'juan', 'Bedoya', 'j_bedoya@gmail.com', 'cra #32 12-65', '60e1e3d475502340e6d29d9415272b64', NULL, 2, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tblalimentacion`
--
ALTER TABLE `tblalimentacion`
  ADD PRIMARY KEY (`IdAlimentacion`),
  ADD KEY `FK_tblalimentacion_tblinsumos` (`Insumo`),
  ADD KEY `FK_tblalimentacion_tbllotecanal` (`LoteCanal`),
  ADD KEY `FK_tblalimentacion_tblusuarios_1` (`Usuario`);

--
-- Indices de la tabla `tblbitacoraslote`
--
ALTER TABLE `tblbitacoraslote`
  ADD PRIMARY KEY (`IdBitacora`),
  ADD KEY `FK_tblbitacoraslote_tbllotecanal` (`LoteCanal`),
  ADD KEY `FK_tblbitacoraslote_tblusuarios` (`Usuario`);

--
-- Indices de la tabla `tblcanales`
--
ALTER TABLE `tblcanales`
  ADD PRIMARY KEY (`IdCanal`),
  ADD KEY `FK_tblcanales_tblestadocanal` (`EstadoCanal`),
  ADD KEY `FK_tblcanales_tblgranja` (`Granja`);

--
-- Indices de la tabla `tbldepartamentos`
--
ALTER TABLE `tbldepartamentos`
  ADD PRIMARY KEY (`IdDepartamento`);

--
-- Indices de la tabla `tblestadocanal`
--
ALTER TABLE `tblestadocanal`
  ADD PRIMARY KEY (`IdEstado`);

--
-- Indices de la tabla `tblestadocuenta`
--
ALTER TABLE `tblestadocuenta`
  ADD PRIMARY KEY (`IdEstado`);

--
-- Indices de la tabla `tblestadolote`
--
ALTER TABLE `tblestadolote`
  ADD PRIMARY KEY (`IdEstadoLote`);

--
-- Indices de la tabla `tblgranja`
--
ALTER TABLE `tblgranja`
  ADD PRIMARY KEY (`IdGranja`),
  ADD KEY `FK_tblgranja_tblmunicipios` (`Municipio`),
  ADD KEY `FK_tblgranja_tblusuarios` (`Usuario`);

--
-- Indices de la tabla `tblinsumos`
--
ALTER TABLE `tblinsumos`
  ADD PRIMARY KEY (`IdInsumo`);

--
-- Indices de la tabla `tbllotecanal`
--
ALTER TABLE `tbllotecanal`
  ADD PRIMARY KEY (`IdLoteCanal`),
  ADD KEY `FK_tbllotecanal_tblcanales` (`Canal`),
  ADD KEY `FK_tbllotecanal_tbllotes` (`Lote`);

--
-- Indices de la tabla `tbllotes`
--
ALTER TABLE `tbllotes`
  ADD PRIMARY KEY (`IdLote`),
  ADD KEY `FK_tbllotes_tblestadolote` (`EstadoLote`),
  ADD KEY `FK_tbllotes_tblprovedores` (`Provedor`),
  ADD KEY `FK_tbllotes_tblbitacoralote` (`Observaciones`);

--
-- Indices de la tabla `tblmortalidad`
--
ALTER TABLE `tblmortalidad`
  ADD PRIMARY KEY (`IdMortalidad`),
  ADD KEY `FK_tblmortalidad_tblusuarios` (`Usuario`),
  ADD KEY `FK_tblmortalidad_tbllotecanal` (`LoteCanal`);

--
-- Indices de la tabla `tblmuestras`
--
ALTER TABLE `tblmuestras`
  ADD PRIMARY KEY (`IdMuestra`),
  ADD KEY `FK_tblmuestras_tbllotecanal` (`LoteCanal`),
  ADD KEY `FK_tblmuestras_tblusuarios` (`Usuario`);

--
-- Indices de la tabla `tblmunicipios`
--
ALTER TABLE `tblmunicipios`
  ADD PRIMARY KEY (`IdMunicipio`),
  ADD KEY `FK_tblmunicipios_tbldepatamentos` (`Departamento`);

--
-- Indices de la tabla `tblpostproduccion`
--
ALTER TABLE `tblpostproduccion`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_tblpostproduccion_tbllotecanal` (`LoteCanal`),
  ADD KEY `FK_tblpostproduccion_tblusuarios` (`Usuario`);

--
-- Indices de la tabla `tblprovedores`
--
ALTER TABLE `tblprovedores`
  ADD PRIMARY KEY (`DocIdentidad`),
  ADD KEY `FK_tblprovedores_tblmunicipios` (`Municipio`);

--
-- Indices de la tabla `tblrol`
--
ALTER TABLE `tblrol`
  ADD PRIMARY KEY (`IdRol`);

--
-- Indices de la tabla `tbltraslados`
--
ALTER TABLE `tbltraslados`
  ADD PRIMARY KEY (`IdTraslado`),
  ADD KEY `FK_tbltraslados_tbllotecanal` (`LoteCanal`),
  ADD KEY `FK_tbltraslados_tblcanal` (`CanalDestino`),
  ADD KEY `FK_tbltraslados_tblusuarios` (`Usuario`);

--
-- Indices de la tabla `tblusuarios`
--
ALTER TABLE `tblusuarios`
  ADD PRIMARY KEY (`DocIdentidad`),
  ADD KEY `FK_tblusuarios_tblrol` (`Rol`),
  ADD KEY `FK_tblusuarios_tblestadocuenta` (`EstadoCuenta`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tblalimentacion`
--
ALTER TABLE `tblalimentacion`
  MODIFY `IdAlimentacion` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tblbitacoraslote`
--
ALTER TABLE `tblbitacoraslote`
  MODIFY `IdBitacora` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tblestadocanal`
--
ALTER TABLE `tblestadocanal`
  MODIFY `IdEstado` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tblestadocuenta`
--
ALTER TABLE `tblestadocuenta`
  MODIFY `IdEstado` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tblestadolote`
--
ALTER TABLE `tblestadolote`
  MODIFY `IdEstadoLote` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tblgranja`
--
ALTER TABLE `tblgranja`
  MODIFY `IdGranja` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tblinsumos`
--
ALTER TABLE `tblinsumos`
  MODIFY `IdInsumo` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tbllotecanal`
--
ALTER TABLE `tbllotecanal`
  MODIFY `IdLoteCanal` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `tbllotes`
--
ALTER TABLE `tbllotes`
  MODIFY `IdLote` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de la tabla `tblmortalidad`
--
ALTER TABLE `tblmortalidad`
  MODIFY `IdMortalidad` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tblmuestras`
--
ALTER TABLE `tblmuestras`
  MODIFY `IdMuestra` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `tblpostproduccion`
--
ALTER TABLE `tblpostproduccion`
  MODIFY `Id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tblrol`
--
ALTER TABLE `tblrol`
  MODIFY `IdRol` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tbltraslados`
--
ALTER TABLE `tbltraslados`
  MODIFY `IdTraslado` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `tblalimentacion`
--
ALTER TABLE `tblalimentacion`
  ADD CONSTRAINT `FK_tblalimentacion_tblinsumos` FOREIGN KEY (`Insumo`) REFERENCES `tblinsumos` (`IdInsumo`),
  ADD CONSTRAINT `FK_tblalimentacion_tbllotecanal` FOREIGN KEY (`LoteCanal`) REFERENCES `tbllotecanal` (`IdLoteCanal`),
  ADD CONSTRAINT `FK_tblalimentacion_tblusuarios_1` FOREIGN KEY (`Usuario`) REFERENCES `tblusuarios` (`DocIdentidad`);

--
-- Filtros para la tabla `tblbitacoraslote`
--
ALTER TABLE `tblbitacoraslote`
  ADD CONSTRAINT `FK_tblbitacoraslote_tbllotecanal` FOREIGN KEY (`LoteCanal`) REFERENCES `tbllotecanal` (`IdLoteCanal`),
  ADD CONSTRAINT `FK_tblbitacoraslote_tblusuarios` FOREIGN KEY (`Usuario`) REFERENCES `tblusuarios` (`DocIdentidad`);

--
-- Filtros para la tabla `tblcanales`
--
ALTER TABLE `tblcanales`
  ADD CONSTRAINT `FK_tblcanales_tblestadocanal` FOREIGN KEY (`EstadoCanal`) REFERENCES `tblestadocanal` (`IdEstado`),
  ADD CONSTRAINT `FK_tblcanales_tblgranja` FOREIGN KEY (`Granja`) REFERENCES `tblgranja` (`IdGranja`);

--
-- Filtros para la tabla `tblgranja`
--
ALTER TABLE `tblgranja`
  ADD CONSTRAINT `FK_tblgranja_tblmunicipios` FOREIGN KEY (`Municipio`) REFERENCES `tblmunicipios` (`IdMunicipio`),
  ADD CONSTRAINT `FK_tblgranja_tblusuarios` FOREIGN KEY (`Usuario`) REFERENCES `tblusuarios` (`DocIdentidad`);

--
-- Filtros para la tabla `tbllotecanal`
--
ALTER TABLE `tbllotecanal`
  ADD CONSTRAINT `FK_tbllotecanal_tblcanales` FOREIGN KEY (`Canal`) REFERENCES `tblcanales` (`IdCanal`),
  ADD CONSTRAINT `FK_tbllotecanal_tbllotes` FOREIGN KEY (`Lote`) REFERENCES `tbllotes` (`IdLote`);

--
-- Filtros para la tabla `tbllotes`
--
ALTER TABLE `tbllotes`
  ADD CONSTRAINT `FK_tbllotes_tblbitacoralote` FOREIGN KEY (`Observaciones`) REFERENCES `tblbitacoraslote` (`IdBitacora`),
  ADD CONSTRAINT `FK_tbllotes_tblestadolote` FOREIGN KEY (`EstadoLote`) REFERENCES `tblestadolote` (`IdEstadoLote`),
  ADD CONSTRAINT `FK_tbllotes_tblprovedores` FOREIGN KEY (`Provedor`) REFERENCES `tblprovedores` (`DocIdentidad`);

--
-- Filtros para la tabla `tblmortalidad`
--
ALTER TABLE `tblmortalidad`
  ADD CONSTRAINT `FK_tblmortalidad_tbllotecanal` FOREIGN KEY (`LoteCanal`) REFERENCES `tbllotecanal` (`IdLoteCanal`),
  ADD CONSTRAINT `FK_tblmortalidad_tblusuarios` FOREIGN KEY (`Usuario`) REFERENCES `tblusuarios` (`DocIdentidad`);

--
-- Filtros para la tabla `tblmuestras`
--
ALTER TABLE `tblmuestras`
  ADD CONSTRAINT `FK_tblmuestras_tbllotecanal` FOREIGN KEY (`LoteCanal`) REFERENCES `tbllotecanal` (`IdLoteCanal`),
  ADD CONSTRAINT `FK_tblmuestras_tblusuarios` FOREIGN KEY (`Usuario`) REFERENCES `tblusuarios` (`DocIdentidad`);

--
-- Filtros para la tabla `tblmunicipios`
--
ALTER TABLE `tblmunicipios`
  ADD CONSTRAINT `FK_tblmunicipios_tbldepatamentos` FOREIGN KEY (`Departamento`) REFERENCES `tbldepartamentos` (`IdDepartamento`);

--
-- Filtros para la tabla `tblpostproduccion`
--
ALTER TABLE `tblpostproduccion`
  ADD CONSTRAINT `FK_tblpostproduccion_tbllotecanal` FOREIGN KEY (`LoteCanal`) REFERENCES `tbllotecanal` (`IdLoteCanal`),
  ADD CONSTRAINT `FK_tblpostproduccion_tblusuarios` FOREIGN KEY (`Usuario`) REFERENCES `tblusuarios` (`DocIdentidad`);

--
-- Filtros para la tabla `tblprovedores`
--
ALTER TABLE `tblprovedores`
  ADD CONSTRAINT `FK_tblprovedores_tblmunicipios` FOREIGN KEY (`Municipio`) REFERENCES `tblmunicipios` (`IdMunicipio`);

--
-- Filtros para la tabla `tbltraslados`
--
ALTER TABLE `tbltraslados`
  ADD CONSTRAINT `FK_tbltraslados_tblcanal` FOREIGN KEY (`CanalDestino`) REFERENCES `tblcanales` (`IdCanal`),
  ADD CONSTRAINT `FK_tbltraslados_tbllotecanal` FOREIGN KEY (`LoteCanal`) REFERENCES `tbllotecanal` (`IdLoteCanal`),
  ADD CONSTRAINT `FK_tbltraslados_tblusuarios` FOREIGN KEY (`Usuario`) REFERENCES `tblusuarios` (`DocIdentidad`);

--
-- Filtros para la tabla `tblusuarios`
--
ALTER TABLE `tblusuarios`
  ADD CONSTRAINT `FK_tblusuarios_tblestadocuenta` FOREIGN KEY (`EstadoCuenta`) REFERENCES `tblestadocuenta` (`IdEstado`),
  ADD CONSTRAINT `FK_tblusuarios_tblrol` FOREIGN KEY (`Rol`) REFERENCES `tblrol` (`IdRol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
