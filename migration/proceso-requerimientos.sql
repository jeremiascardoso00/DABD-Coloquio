--Para estas consignas se toma en cuenta que el usuario 
--mediante nuestro codigo en backend y frontend pueda ingresar ciertos datos

-------------------------------------------------------------------------------------------------------------

--1. Reserva de Pasajes: Permite a los clientes reservar pasajes para itinerarios o tramos específicos, siempre que 
--haya disponibilidad.

--pasos a seguir
--el cliente debe acceder a la pagina y alli se le dara la posibilidad de escribir su ciudad de origen, destino y la fecha
--el cliente debe ingresar su busqueda en un input y el back deberia realizar una consulta a su base de datos 
--para devolver las ciudades que se encuentren disponibles y puedan coincidir con la busqueda

SELECT * FROM "Ciudad" WHERE Nombre  LIKE '%re%' AND "Ciudad"."deleted_at" IS NULL

--una vez que el cliente obtenga esas ciudades, puede elegir alguna de ellas
--Esta consulta al endpoint r.GET("/ciudad/:name", cc.GetCiudades) se tiene que hacer para poblar las opciones del input de ciudad de origen y para el input de ciudad destino
--Una vez que se tengan origen y destino se debe elegir una fecha de partida (esto se deberia hacer solo en frontend con un input de calendario)
--tenemos origen, destino y fecha

--por ejemplo: 
--Resistencia - id: 1
--Buenos Aires - id: 2
--2024-01-01 12:00:00.000

--necesitamos cambiar el tipo de dato de los tramos y poner fecha en vez de horario

--ALTER TABLE Tramo
--ADD Fecha_Partida DATETIME2 NOT NULL
--CONSTRAINT DF_Fecha_Partida DEFAULT GETDATE(),
--Fecha_Llegada DATETIME2 NOT NULL
--CONSTRAINT DF_Fecha_Llegada DEFAULT GETDATE()
--
--UPDATE Tramo
--SET Fecha_Partida = CAST(Hora_Partida AS DATETIME2),
--Fecha_Llegada = CAST(Hora_Llegada AS DATETIME2)
--
--ALTER TABLE Tramo
--DROP COLUMN Hora_Partida
--
--ALTER TABLE Tramo
--DROP COLUMN Hora_Llegada
--
--UPDATE Tramo
--SET Fecha_Partida = DATEADD(HOUR, DATEPART(HOUR, Fecha_Partida), DATEADD(MINUTE, DATEPART(MINUTE, Fecha_Partida), DATEADD(SECOND, DATEPART(SECOND, Fecha_Partida), CAST('2024-01-01' AS DATETIME2)))),
--Fecha_Llegada = DATEADD(HOUR, DATEPART(HOUR, Fecha_Llegada), DATEADD(MINUTE, DATEPART(MINUTE, Fecha_Llegada), DATEADD(SECOND, DATEPART(SECOND, Fecha_Llegada), CAST('2024-01-01' AS DATETIME2))))

--necesitamos modificar nuestra tabla itinerario para que utilice la tabla ciudad
--tenemos que eliminar los campos Ciudad_Partida y Ciudad_Llegada y hacer uan tabla intermedia como con tramoxciudad

--USE ViajaPlus
--
--DROP TABLE IF EXISTS Itinerario_x_Ciudad
--
--CREATE TABLE Itinerario_x_Ciudad
--(
--ID_Itinerario INT NOT NULL,
--ID_Ciudad INT NOT NULL,
--PRIMARY KEY(ID_Itinerario, ID_Ciudad),
--
--FOREIGN KEY (ID_Itinerario) REFERENCES dbo.Itinerario(ID),
--FOREIGN KEY (ID_Ciudad) REFERENCES dbo.Ciudad(ID)
--);
--
--ALTER TABLE Itinerario
--DROP COLUMN Ciudad_Partida
--ALTER TABLE Itinerario
--DROP COLUMN Ciudad_Llegada
--
--INSERT INTO Itinerario_x_Ciudad(ID_Itinerario, ID_Ciudad)
--VALUES (1, 1),
--		(1, 2)--Resistencia a Buenos Aires

-- es posible que en nuestras tablas Tramo_x_Ciudad e Itinerario_x_Ciudad tengamos que agregar algo como tipo

--ALTER TABLE Tramo_x_Ciudad
--ADD Es_Origen BIT 
--
--ALTER TABLE Itinerario_x_Ciudad
--ADD Es_Origen BIT 
--
--UPDATE ViajaPlus.dbo.Itinerario_x_Ciudad
--SET Es_Origen=1
--WHERE ID_Itinerario=1 AND ID_Ciudad=1;
--UPDATE ViajaPlus.dbo.Itinerario_x_Ciudad
--SET Es_Origen=0
--WHERE ID_Itinerario=1 AND ID_Ciudad=2;
--
--UPDATE ViajaPlus.dbo.Tramo_x_Ciudad
--SET deleted_at=NULL, Es_Origen=1
--WHERE ID_Tramo=1 AND ID_Ciudad=1;
--UPDATE ViajaPlus.dbo.Tramo_x_Ciudad
--SET deleted_at=NULL, Es_Origen=0
--WHERE ID_Tramo=1 AND ID_Ciudad=7;
--UPDATE ViajaPlus.dbo.Tramo_x_Ciudad
--SET deleted_at=NULL, Es_Origen=1
--WHERE ID_Tramo=2 AND ID_Ciudad=3;
--UPDATE ViajaPlus.dbo.Tramo_x_Ciudad
--SET deleted_at=NULL, Es_Origen=0
--WHERE ID_Tramo=2 AND ID_Ciudad=7;
--UPDATE ViajaPlus.dbo.Tramo_x_Ciudad
--SET deleted_at=NULL, Es_Origen=1
--WHERE ID_Tramo=3 AND ID_Ciudad=3;
--UPDATE ViajaPlus.dbo.Tramo_x_Ciudad
--SET deleted_at=NULL, Es_Origen=0
--WHERE ID_Tramo=3 AND ID_Ciudad=4;
--UPDATE ViajaPlus.dbo.Tramo_x_Ciudad
--SET deleted_at=NULL, Es_Origen=1
--WHERE ID_Tramo=4 AND ID_Ciudad=4;
--UPDATE ViajaPlus.dbo.Tramo_x_Ciudad
--SET deleted_at=NULL, Es_Origen=0
--WHERE ID_Tramo=4 AND ID_Ciudad=5;
--UPDATE ViajaPlus.dbo.Tramo_x_Ciudad
--SET deleted_at=NULL, Es_Origen=0
--WHERE ID_Tramo=5 AND ID_Ciudad=2;
--UPDATE ViajaPlus.dbo.Tramo_x_Ciudad
--SET deleted_at=NULL, Es_Origen=1
--WHERE ID_Tramo=5 AND ID_Ciudad=5;

--UPDATE ViajaPlus.dbo.Servicio
--SET Disponibilidad=1, Fecha_Partida='2024-01-01 12:00:00.000', Fecha_Llegada='2024-01-02 02:15:00.000', Costo_Servicio=17500.0000, deleted_at=NULL
--WHERE ID=1;


-- si nuestros bool se llaman "disponibilidad" lo logico es que 0(false) y 1(true)

--UPDATE ViajaPlus.dbo.Transporte
--SET Situacion=1
--WHERE ID=1;
--UPDATE ViajaPlus.dbo.Transporte
--SET Situacion=1
--WHERE ID=2;
--UPDATE ViajaPlus.dbo.Transporte
--SET Situacion=1
--WHERE ID=3;
--UPDATE ViajaPlus.dbo.Transporte
--SET Situacion=1
--WHERE ID=4;
--UPDATE ViajaPlus.dbo.Transporte
--SET Situacion=1
--WHERE ID=5;
--UPDATE ViajaPlus.dbo.Transporte
--SET Situacion=1
--WHERE ID=6;
--UPDATE ViajaPlus.dbo.Transporte
--SET Situacion=1
--WHERE ID=7;
--UPDATE ViajaPlus.dbo.Transporte
--SET Situacion=1
--WHERE ID=8;
--
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=1 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=2 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=3 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=4 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=5 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=6 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=7 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=8 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=9 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=10 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=11 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=12 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=13 AND ID_Transporte=3;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=14 AND ID_Transporte=3;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=15 AND ID_Transporte=3;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=16 AND ID_Transporte=3;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=17 AND ID_Transporte=3;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=18 AND ID_Transporte=3;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=19 AND ID_Transporte=3;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=20 AND ID_Transporte=3;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=21 AND ID_Transporte=3;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=22 AND ID_Transporte=3;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=23 AND ID_Transporte=3;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=24 AND ID_Transporte=4;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=25 AND ID_Transporte=4;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=26 AND ID_Transporte=4;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=27 AND ID_Transporte=4;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=28 AND ID_Transporte=4;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=29 AND ID_Transporte=4;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=30 AND ID_Transporte=4;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=31 AND ID_Transporte=4;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=32 AND ID_Transporte=4;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=33 AND ID_Transporte=4;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=34 AND ID_Transporte=4;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=35 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=36 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=37 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=38 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=39 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=40 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=41 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=42 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=43 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=44 AND ID_Transporte=1;
--UPDATE ViajaPlus.dbo.Asiento
--SET Disponibilidad=1
--WHERE ID=45 AND ID_Transporte=1;

------------------------------------

--
--INSERT INTO ViajaPlus.dbo.Ciudad
--(Nombre, deleted_at)
--VALUES( 'Posadas', NULL);
--
--insert to test query
--INSERT INTO ViajaPlus.dbo.Tramo
--(Distancia, Fecha_Partida, Fecha_Llegada, Costo_Tramo, deleted_at)
--VALUES(40, '2024-01-01 12:00:00.000', '2024-01-01 13:45:00.000', 1000.0000, NULL);
--
-- agrego un nuevo tramo de resistencia a corrientes
--INSERT INTO ViajaPlus.dbo.Tramo_x_Ciudad
--(ID_Tramo, ID_Ciudad, Es_Origen, deleted_at)
--VALUES(6, 1, 1, NULL);
--INSERT INTO ViajaPlus.dbo.Tramo_x_Ciudad
--(ID_Tramo, ID_Ciudad, Es_Origen, deleted_at)
--VALUES(6, 10, 0, NULL);
--
--INSERT INTO ViajaPlus.dbo.Tramo
--( Distancia, Fecha_Partida, Fecha_Llegada, Costo_Tramo, deleted_at)
--VALUES( 301, '2024-01-01 12:00:00.000', '2024-01-01 13:45:00.000', 1000.0000, NULL);
--
--INSERT INTO ViajaPlus.dbo.Tramo_x_Ciudad
--(ID_Tramo, ID_Ciudad, Es_Origen, deleted_at)
--VALUES(7, 10, 1, NULL);
--INSERT INTO ViajaPlus.dbo.Tramo_x_Ciudad
--(ID_Tramo, ID_Ciudad, Es_Origen, deleted_at)
--VALUES(7, 14, 0, NULL);
--
--
--insert nuevo itinerario con 2 tramos
--resistencia - corrientes - corrientes - posadas
--INSERT INTO ViajaPlus.dbo.Itinerario
--(Distancia, deleted_at)
--VALUES(341, NULL);
--INSERT INTO ViajaPlus.dbo.Itinerario_x_Ciudad
--(ID_Itinerario, ID_Ciudad, Es_Origen)
--VALUES(2, 1, 1);
--INSERT INTO ViajaPlus.dbo.Itinerario_x_Ciudad
--(ID_Itinerario, ID_Ciudad, Es_Origen)
--VALUES(2, 14, 0);

--query para obtener las opciones disponibles segun las entradas
--Resistencia - id: 1
--Buenos Aires - id: 2
--2024-01-01 12:00:00.000 
--(es posible que la entrada solo sea dia, 
--el horario lo elegira el cliente desde las opciones de la query de abajo)

--con este select se puede traer los itinerarios que coincidan con la busqueda de ciudades
-- origen y destino
SELECT x.* FROM ViajaPlus.dbo.Itinerario x

--trae itinerarios
SELECT s.* 
FROM ViajaPlus.dbo.Itinerario i 
INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_origen ON ixc_origen.ID_Itinerario = i.ID 
INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_destino ON ixc_destino.ID_Itinerario = i.ID 
inner join ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID 
right join ViajaPlus.dbo.Servicio s ON s.ID = sxi.ID_Servicio 
WHERE ixc_origen.ID_Ciudad = 1 AND ixc_origen.Es_Origen = 1
AND ixc_destino.ID_Ciudad = 2 AND ixc_destino.Es_Origen = 0
AND s.Disponibilidad = 1
AND CONVERT(date, s.Fecha_Partida) = '2024-01-01'

------------------------------------------
--trae tramos
SELECT t.* 
FROM ViajaPlus.dbo.Tramo t
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_origen ON txc_origen.ID_Tramo  = t.ID 
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_destino ON txc_destino.ID_Tramo = t.ID 
INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Tramo = t.ID 
INNER JOIN ViajaPlus.dbo.Itinerario i ON i.ID  = ixt.ID_Itinerario 
INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID 
INNER JOIN ViajaPlus.dbo.Servicio s ON s.ID = sxi.ID_Servicio 
WHERE txc_origen.ID_Ciudad = 1 AND txc_origen.Es_Origen = 1
AND txc_destino.ID_Ciudad = 7 AND txc_destino.Es_Origen = 0
AND CONVERT(date, t.Fecha_Partida) = '2024-01-01'
AND s.Disponibilidad = 1

--todo para el endpoint de opciones, tengo que devolver tambien la calidad
-- en el de tramos y en el de itinerario
-- agregar tambien origen y destino en tramo


--------------------------------------------------

SELECT 
	Servicio.ID, 
	Servicio.Disponibilidad, 
	c_origen.Nombre as Origen,
	c_destino.Nombre as Destino,
	Servicio.Fecha_Partida, 
	Servicio.Fecha_Llegada,
	Servicio.Costo_Servicio + t.Costo_Transporte as Costo,
	Itinerario.Distancia,
	t.Categoria as CategoriaTransporte,
	t.Tipo_Atencion as TipoAtencion,
	t.Pisos
FROM "ViajaPlus"."dbo"."Itinerario" 
INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_origen ON ixc_origen.ID_Itinerario = Itinerario.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID  = ixc_origen.ID_Ciudad 
INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_destino ON ixc_destino.ID_Itinerario = Itinerario.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID  = ixc_destino.ID_Ciudad 
INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = Itinerario.ID 
INNER JOIN ViajaPlus.dbo.Servicio ON Servicio.ID = sxi.ID_Servicio 
INNER JOIN ViajaPlus.dbo.Servicio_x_Transporte sxt ON sxt.ID_Servicio  = Servicio.ID
INNER JOIN ViajaPlus.dbo.Transporte t ON t.ID = sxt.ID_Transporte 
WHERE (ixc_origen.ID_Ciudad = '1' AND ixc_origen.Es_Origen = 1) 
AND (ixc_destino.ID_Ciudad = '2' AND ixc_destino.Es_Origen = 0) 
AND Servicio.Disponibilidad = 1 
AND CONVERT(date, Servicio.Fecha_Partida) = '2024-01-01' 
AND "ViajaPlus"."dbo"."Itinerario"."deleted_at" IS NULL

------------------------------------------
SELECT 
	Servicio.ID, 
	c_origen.Nombre as Origen,
	c_destino.Nombre as Destino,
	Tramo.Fecha_Partida, 
	Tramo.Fecha_Llegada,
	Tramo.Costo_Tramo + t.Costo_Transporte as Costo,
	Tramo.Distancia ,
	t.Categoria as CategoriaTransporte,
	t.Tipo_Atencion as TipoAtencion,
	t.Pisos
FROM "ViajaPlus"."dbo"."Tramo" 
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_origen ON txc_origen.ID_Tramo = Tramo.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = txc_origen.ID_Ciudad 
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_destino ON txc_destino.ID_Tramo = Tramo.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = txc_destino.ID_Ciudad 
INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Tramo = Tramo.ID 
INNER JOIN ViajaPlus.dbo.Itinerario i ON i.ID  = ixt.ID_Itinerario 
INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID 
INNER JOIN ViajaPlus.dbo.Servicio ON Servicio.ID = sxi.ID_Servicio 
INNER JOIN ViajaPlus.dbo.Servicio_x_Transporte sxt ON sxt.ID_Servicio = Servicio.ID
INNER JOIN ViajaPlus.dbo.Transporte t ON t.ID = sxt.ID_Transporte 
WHERE (txc_origen.ID_Ciudad = '1' AND txc_origen.Es_Origen = 1) 
AND (txc_destino.ID_Ciudad = '7' AND txc_destino.Es_Origen = 0) 
AND Servicio.Disponibilidad = 1 
AND CONVERT(date, Tramo.Fecha_Partida) = '2024-01-01'
-------------------------------------------------------------------------------------------------------------
--mismas queries pero en una union
SELECT 
	Servicio.ID, 
	c_origen.Nombre as Origen,
	c_destino.Nombre as Destino,
	Tramo.Fecha_Partida, 
	Tramo.Fecha_Llegada,
	Tramo.Costo_Tramo + t.Costo_Transporte as Costo,
	Tramo.Distancia ,
	t.Categoria as CategoriaTransporte,
	t.Tipo_Atencion as TipoAtencion,
	t.Pisos
FROM "ViajaPlus"."dbo"."Tramo" 
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_origen ON txc_origen.ID_Tramo = Tramo.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = txc_origen.ID_Ciudad 
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_destino ON txc_destino.ID_Tramo = Tramo.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = txc_destino.ID_Ciudad 
INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Tramo = Tramo.ID 
INNER JOIN ViajaPlus.dbo.Itinerario i ON i.ID  = ixt.ID_Itinerario 
INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID 
INNER JOIN ViajaPlus.dbo.Servicio ON Servicio.ID = sxi.ID_Servicio 
INNER JOIN ViajaPlus.dbo.Servicio_x_Transporte sxt ON sxt.ID_Servicio = Servicio.ID
INNER JOIN ViajaPlus.dbo.Transporte t ON t.ID = sxt.ID_Transporte 
WHERE (txc_origen.ID_Ciudad = '1' AND txc_origen.Es_Origen = 1) 
AND (txc_destino.ID_Ciudad = '7' AND txc_destino.Es_Origen = 0) 
AND Servicio.Disponibilidad = 1 
AND CONVERT(date, Tramo.Fecha_Partida) = '2024-01-01'
UNION
SELECT 
	Servicio.ID, 
	c_origen.Nombre as Origen,
	c_destino.Nombre as Destino,
	Servicio.Fecha_Partida, 
	Servicio.Fecha_Llegada,
	Servicio.Costo_Servicio + t.Costo_Transporte as Costo,
	Itinerario.Distancia,
	t.Categoria as CategoriaTransporte,
	t.Tipo_Atencion as TipoAtencion,
	t.Pisos
FROM "ViajaPlus"."dbo"."Itinerario" 
INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_origen ON ixc_origen.ID_Itinerario = Itinerario.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID  = ixc_origen.ID_Ciudad 
INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_destino ON ixc_destino.ID_Itinerario = Itinerario.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID  = ixc_destino.ID_Ciudad 
INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = Itinerario.ID 
INNER JOIN ViajaPlus.dbo.Servicio ON Servicio.ID = sxi.ID_Servicio 
INNER JOIN ViajaPlus.dbo.Servicio_x_Transporte sxt ON sxt.ID_Servicio  = Servicio.ID
INNER JOIN ViajaPlus.dbo.Transporte t ON t.ID = sxt.ID_Transporte 
WHERE (ixc_origen.ID_Ciudad = '1' AND ixc_origen.Es_Origen = 1) 
AND (ixc_destino.ID_Ciudad = '2' AND ixc_destino.Es_Origen = 0) 
AND Servicio.Disponibilidad = 1 
AND CONVERT(date, Servicio.Fecha_Partida) = '2024-01-01' 
AND "ViajaPlus"."dbo"."Itinerario"."deleted_at" IS NULL

-------------------------------------------------------------------------------------

--estoy pensando que posiblemente para contemplar la posibilidad de 
--que un usuario pueda elegir un origen y un destino que combine varios tramos parte de un itinerario pero que no sea 
--un itinerario completo, vamos a necesitar que la tabla Itinerario_x_Tramo tenga un nuevo campo llamado orden
--ALTER TABLE ViajaPlus.dbo.Itinerario_x_Tramo ADD Orden int;

--todos los tramos que coincidan con la ciudad de origen

select * FROM 
(
	SELECT Itinerario.ID, txc_origen.ID_Ciudad, txc_origen.Es_Origen, c_origen.Nombre, ixt.Orden
	FROM "ViajaPlus"."dbo"."Itinerario" 
	INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID 
	INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_origen ON txc_origen.ID_Tramo = ixt.ID_Tramo  
	INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = txc_origen.ID_Ciudad 
	WHERE (txc_origen.ID_Ciudad = '1' AND txc_origen.Es_Origen = 1) and Itinerario.ID in (1)
	UNION
	SELECT Itinerario.ID, txc_destino.ID_Ciudad, txc_destino.Es_Origen, c_destino.Nombre, ixt.Orden
	FROM "ViajaPlus"."dbo"."Itinerario" 
	INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID 
	INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_destino ON txc_destino.ID_Tramo = ixt.ID_Tramo 
	INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = txc_destino.ID_Ciudad 
	WHERE (txc_destino.ID_Ciudad = '5' AND txc_destino.Es_Origen = 0) and Itinerario.ID in (1)
) as tramos
where 

---
--
--WITH ItinerariosRSA AS (
--    SELECT Itinerario.ID
--    FROM "ViajaPlus"."dbo"."Itinerario" 
--    INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID 
--    INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc ON txc.ID_Tramo = ixt.ID_Tramo  
--    WHERE (txc.ID_Ciudad = '1' AND txc.Es_Origen = 1) 
--    INTERSECT
--    SELECT Itinerario.ID
--    FROM "ViajaPlus"."dbo"."Itinerario" 
--    INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID 
--    INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc ON txc.ID_Tramo = ixt.ID_Tramo  
--    WHERE (txc.ID_Ciudad = '2' AND txc.Es_Origen = 0) 
--)
--
--SELECT * FROM 
--(
--    SELECT Itinerario.ID, txc_origen.ID_Ciudad, txc_origen.Es_Origen, c_origen.Nombre, ixt.Orden
--    FROM "ViajaPlus"."dbo"."Itinerario" 
--    INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID 
--    INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_origen ON txc_origen.ID_Tramo = ixt.ID_Tramo  
--    INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = txc_origen.ID_Ciudad 
--    WHERE Itinerario.ID IN (SELECT ID FROM ItinerariosRSA)
--    UNION
--    SELECT Itinerario.ID, txc_destino.ID_Ciudad, txc_destino.Es_Origen, c_destino.Nombre, ixt.Orden
--    FROM "ViajaPlus"."dbo"."Itinerario" 
--    INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID 
--    INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_destino ON txc_destino.ID_Tramo = ixt.ID_Tramo 
--    INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = txc_destino.ID_Ciudad 
--    WHERE Itinerario.ID IN (SELECT ID FROM ItinerariosRSA)
--) as tramos



--obtengo el id del itinerario y los tramos de la ciudad origen y la ciudad destino
SELECT 
    Itinerario.ID AS ID_Itinerario,
    ixt.ID_Tramo AS ID_Tramo,
    ixt.Orden 
FROM 
    "ViajaPlus"."dbo"."Itinerario" 
INNER JOIN 
    ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID 
INNER JOIN 
    ViajaPlus.dbo.Tramo_x_Ciudad txc ON txc.ID_Tramo = ixt.ID_Tramo  
WHERE 
    (txc.ID_Ciudad = '1' AND txc.Es_Origen = 1) 
    OR 
    (txc.ID_Ciudad = '5' AND txc.Es_Origen = 0)
    
--ahora en base al id de itinerario, id de tramos y id de ciudades y el orden de los tramos
SELECT 
	SUM(t.Costo_Tramo)
FROM 
    "ViajaPlus"."dbo"."Itinerario" 
INNER JOIN 
    ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID
INNER JOIN 
    ViajaPlus.dbo.Tramo t ON t.ID = ixt.ID_Tramo 
WHERE 
    Itinerario.ID = 1
    AND ixt.Orden BETWEEN '1' AND '4'

------------------------------------------------------------------------

    
SELECT 
	Servicio.ID, 
	c_origen.Nombre as Origen,
	c_destino.Nombre as Destino,
	t_origen.Fecha_Partida, 
	t_destino.Fecha_Llegada,
--	Tramo.Costo_Tramo + t.Costo_Transporte as Costo,
	t.Costo_Transporte as Costo,
--	Tramo.Distancia ,
	t.Categoria as CategoriaTransporte,
	t.Tipo_Atencion as TipoAtencion,
	t.Pisos
FROM "ViajaPlus"."dbo".Itinerario i
INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_origen ON ixt_origen.ID_Itinerario  = i.ID 
INNER JOIN ViajaPlus.dbo.Tramo t_origen ON t_origen.ID = ixt_origen.ID_Tramo  
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_origen ON txc_origen.ID_Tramo = t_origen.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = txc_origen.ID_Ciudad 

INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_destino ON ixt_destino.ID_Itinerario = i.ID 
INNER JOIN ViajaPlus.dbo.Tramo t_destino ON t_destino.ID = ixt_destino.ID_Tramo  
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_destino ON txc_destino.ID_Tramo = t_destino.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = txc_destino.ID_Ciudad 

INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID 
INNER JOIN ViajaPlus.dbo.Servicio ON Servicio.ID = sxi.ID_Servicio 
--INNER JOIN ViajaPlus.dbo.Servicio_x_Transporte sxt ON sxt.ID_Servicio = Servicio.ID
INNER JOIN ViajaPlus.dbo.Transporte t ON t.ID = Servicio.ID_Transporte 
WHERE (t_origen.ID = 1 and txc_origen.Es_Origen = 1) AND (t_destino.ID = 4 and txc_destino.Es_Origen = 0)

AND Servicio.Disponibilidad = 1 
AND CONVERT(date, t_origen.Fecha_Partida) = '2024-01-01'

-------------------------------------------------------------------------------------

    
SELECT 
	Servicio.ID, 
	c_origen.Nombre as Origen,
	c_destino.Nombre as Destino,
	t_origen.ID as IDTramoOrigen,
	t_destino.ID as IDTramoDestino,
	t_origen.Fecha_Partida, 
	t_destino.Fecha_Llegada,
	(SELECT 
			SUM(t.Costo_Tramo) as Costo
		FROM 
			"ViajaPlus"."dbo"."Itinerario" 
		INNER JOIN 
			ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID
		INNER JOIN 
			ViajaPlus.dbo.Tramo t ON t.ID = ixt.ID_Tramo 
		WHERE 
			Itinerario.ID = 1
			AND ixt.Orden BETWEEN 1 AND 4) + t.Costo_Transporte as Costo,
	(SELECT 
			SUM(t.Distancia) as Distancia
		FROM 
			"ViajaPlus"."dbo"."Itinerario" 
		INNER JOIN 
			ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID
		INNER JOIN 
			ViajaPlus.dbo.Tramo t ON t.ID = ixt.ID_Tramo 
		WHERE 
			Itinerario.ID = 1
		AND ixt.Orden BETWEEN 1 AND 4) as Distancia,
	t.ID as IDTransporte,
	t.Categoria as CategoriaTransporte,
	t.Tipo_Atencion as TipoAtencion,
	t.Pisos
FROM "ViajaPlus"."dbo".Itinerario i
INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_origen ON ixt_origen.ID_Itinerario  = i.ID 
INNER JOIN ViajaPlus.dbo.Tramo t_origen ON t_origen.ID = ixt_origen.ID_Tramo  
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_origen ON txc_origen.ID_Tramo = t_origen.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = txc_origen.ID_Ciudad 

INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_destino ON ixt_destino.ID_Itinerario = i.ID 
INNER JOIN ViajaPlus.dbo.Tramo t_destino ON t_destino.ID = ixt_destino.ID_Tramo  
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_destino ON txc_destino.ID_Tramo = t_destino.ID 
INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = txc_destino.ID_Ciudad 

INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID 
INNER JOIN ViajaPlus.dbo.Servicio ON Servicio.ID = sxi.ID_Servicio 
--INNER JOIN ViajaPlus.dbo.Servicio_x_Transporte sxt ON sxt.ID_Servicio = Servicio.ID
INNER JOIN ViajaPlus.dbo.Transporte t ON t.ID = Servicio.ID_Transporte 
WHERE (t_origen.ID = 1 and txc_origen.Es_Origen = 1) AND (t_destino.ID = 4 and txc_destino.Es_Origen = 0)

AND Servicio.Disponibilidad = 1 
AND CONVERT(date, t_origen.Fecha_Partida) = '2024-01-01'

-------------------------------------------------------------------------------------


--query para traer los asientos disponibles en un viaje

--en este punto contamos con todo el objeto opciones, sea tramo o itinerario
--se obtienen todos los asientos segun service id

SELECT a.ID as IDAsiento, a.Disponibilidad,t.Nro_Unidad,t.Pisos,t.Situacion,t.Costo_Transporte,t.Categoria,t.Tipo_Atencion
from ViajaPlus.dbo.Servicio s 
--inner join ViajaPlus.dbo.Servicio_x_Transporte sxt on sxt.ID_Servicio = s.ID 
INNER join ViajaPlus.dbo.Transporte t on t.ID = s.ID_Transporte 
inner join ViajaPlus.dbo.Asiento a on a.ID_Transporte = t.ID 
WHERE s.ID = 1


-------------------------------------------------------------------------------------


--Venta de pasajes
Use ViajaPlus
;WITH DatosCiudad AS (
    SELECT
		O.ID AS IdCiudadOrigen,
        D.ID AS IdCiudadDestino,
        T.ID AS IdTramo,
        I.ID AS IdItinerario
    FROM Tramo_x_Ciudad CT
    INNER JOIN Ciudad O ON CT.Id_Ciudad = O.ID
    INNER JOIN Tramo T ON CT.Id_Tramo = T.ID
    INNER JOIN Tramo_x_Ciudad CD ON T.ID = CD.Id_Tramo
    INNER JOIN Ciudad D ON CD.ID_Ciudad = D.ID
    INNER JOIN Itinerario_x_Tramo TI ON T.ID = TI.ID_Tramo
    INNER JOIN Itinerario I ON TI.ID_Itinerario = I.ID
)
SELECT
    DC.IdCiudadOrigen,
    DC.IdCiudadDestino,
    DC.IdTramo,
    DC.IdItinerario
FROM DatosCiudad DC
WHERE
    (DC.IdCiudadOrigen = 1 AND DC.IdCiudadDestino = 2)
    OR
    (DC.IdItinerario IS NOT NULL AND EXISTS (
        SELECT 1
        FROM DatosCiudad SubDC
        WHERE
            SubDC.IdCiudadOrigen = 1
            AND SubDC.IdCiudadDestino = 2
            AND SubDC.IdItinerario = DC.IdItinerario
    ));

--buscar nombre ciudad, obtener id ciudad
--con id_ciudad en tramox_ciudad

-----------------------------------------------------------------------------------
   
--USE ViajaPlus
--
--DROP TABLE IF EXISTS Tramo_x_Reserva
--
--CREATE TABLE Tramo_x_Reserva(
--    ID_Tramo INT NOT NULL,
--    ID_Reserva INT NOT NULL,
--		Es_Origen BIT NOT NULL,
--
--    PRIMARY KEY(ID_Tramo, ID_Reserva),
--
--    FOREIGN KEY (ID_Tramo) REFERENCES dbo.tramo(ID),
--    FOREIGN KEY (ID_Reserva) REFERENCES dbo.Reserva(ID)
--)
   -------------------------------------------------------------------------------

   --crear una nueva reserva
   --
   
   select t.ID from ViajaPlus.dbo.Transporte t
	inner join ViajaPlus.dbo.Servicio s ON s.ID = 1
	
	  select * from ViajaPlus.dbo.Transporte t
	inner join ViajaPlus.dbo.Servicio s ON s.ID = 1

   INSERT INTO ViajaPlus.dbo.Reserva
	( Nombre, Apellido, DNI)
	VALUES('Nombre', 'Apellido', 40000000);

INSERT INTO "ViajaPlus"."dbo"."Reserva" ("Nombre","Apellido","DNI") 
OUTPUT INSERTED."id" VALUES ('Juan','Perez',12345678);
--     
--	INSERT INTO ViajaPlus.dbo.Reserva_x_Ciudad
--	(Reserva, ID_Ciudad, Es_Origen)
--	VALUES( 0, 0, '');
--   
--	INSERT INTO ViajaPlus.dbo.Tramo_x_Reserva
--	(ID_Tramo, ID_Reserva, Es_Origen)
--	VALUES(0, 0, 0);
--		INSERT INTO ViajaPlus.dbo.Tramo_x_Reserva
--	(ID_Tramo, ID_Reserva, Es_Origen)
--	VALUES(0, 0, 0);

------------se deben actualizar el estdo de los aseitnos y de transporte
UPDATE ViajaPlus.dbo.Asiento
SET Disponibilidad=0
WHERE ID=1 AND ID_Transporte=1;

--//si este count viene vacio 
SELECT COUNT(*) FROM ViajaPlus.dbo.Asiento
WHERE ID_Transporte=1 AND Disponibilidad=1

--//se actualiza el estado del transporte a ocupado
UPDATE ViajaPlus.dbo.Transporte 
SET Situacion=0
WHERE ID_Transporte=1;

--//si el estado del transporte del servicio es no disponible entonces el Servicio tambien deberia serlo
UPDATE ViajaPlus.dbo.Servicio  
SET Disponibilidad =0
WHERE ID_Transporte=1;




   -------------------------------------------------------------------------------
   USE ViajaPlus

   
   SELECT R.ID AS idReserva, R.Nombre AS nombreReserva, R.Apellido AS apellidoReserva, R.DNI AS DNIReserva, R.Estado AS estadoReserva, R.Costo AS costeReserva,
        C.ID AS idCiudad, C.Nombre AS nombreCiudad,
        T.ID AS idTramo, T.Fecha_Partida AS fechaPartidaTramo, T.Fecha_Llegada AS fechaLlegadaTramo, T.Distancia AS distanciaTramo, T.Costo_Tramo AS costeTramo,
        I.ID AS idItinerario,
        S.ID AS idServicio, S.Fecha_Partida AS fechaPartidaServicio, S.Fecha_Llegada AS fechaLlegadaServicio, S.Disponibilidad AS disponibilidadServicio, S.Calidad_Servicio AS calidadServicio, S.Costo_Servicio AS costeServicio,
        TRA.ID AS idTransporte, TRA.Nro_Unidad AS nroUnidad, TRA.Situacion AS situacionTransporte, TRA.Tipo_Atencion AS atencionTransporte, TRA.Categoria AS categoriaTransporte, TRA.Capacidad AS capacidadTransporte, TRA.Costo_Transporte AS costeTransporte,
        A.ID AS idAsiento, A.Disponibilidad AS disponibilidadAsiento, A.ID_Transporte AS transporteAsociado

FROM Reserva R
INNER JOIN Reserva_x_Ciudad RC ON RC.ID_Ciudad = R.ID
INNER JOIN Ciudad C ON C.ID = RC.ID_Ciudad
INNER JOIN Tramo_x_Reserva TR ON TR.ID_Reserva = R.ID
INNER JOIN Tramo T ON T.ID = TR.ID_Tramo
INNER JOIN Itinerario_x_Tramo IT ON IT.ID_Tramo = T.ID
INNER JOIN Itinerario I ON I.ID = IT.ID_Itinerario
INNER JOIN Servicio_x_Itinerario SI ON SI.ID_Itinerario = I.ID
INNER JOIN Servicio S ON S.ID = SI.ID_Servicio
INNER JOIN Servicio_x_Transporte ST ON ST.ID_Servicio = S.ID
INNER JOIN Transporte TRA ON TRA.ID = ST.ID_Transporte
INNER JOIN Asiento A ON A.ID_Transporte = TRA.ID
   --------------------------------------------------------------------------------

ALTER TABLE ViajaPlus.dbo.Reserva
ADD ID_Asiento INT;
ALTER TABLE ViajaPlus.dbo.Reserva
ADD ID_Transporte INT;

 ALTER TABLE ViajaPlus.dbo.Reserva
ADD CONSTRAINT FK_Reserva_Asiento
    FOREIGN KEY (ID_Asiento, ID_Transporte)
    REFERENCES ViajaPlus.dbo.Asiento(ID, ID_Transporte);
   
  ALTER TABLE ViajaPlus.dbo.Servicio ADD Calidad_Servicio varchar(40) NULL;
ALTER TABLE ViajaPlus.dbo.Transporte ADD Capacidad int NULL;

--ALTER TABLE ViajaPlus.dbo.Servicio ADD Calidad_Servicio varchar(40) NULL;
--ALTER TABLE ViajaPlus.dbo.Transporte ADD Capacidad int NULL;
   

--2. Venta de Pasajes: Facilita la compra de pasajes para itinerarios o tramos en función de la disponibilidad.

--//solo se peuden comprar viajes previamente reservados
--para comprar primero se tienen que listar las reservas, como no tenemos usuarios, se listan todas las reservas
--

--query para obtener las reservas
SELECT 
    r.ID, r.Nombre, r.Apellido, r.DNI, r.Estado, r.Costo, r.ID_Asiento, r.ID_Transporte,
    origen.Nombre AS Ciudad_Origen,
    destino.Nombre AS Ciudad_Destino,
    origen.ID_Ciudad AS IDCiudad_Origen,
    destino.ID_Ciudad AS IDCiudad_Destino
FROM 
    ViajaPlus.dbo.Reserva r 
INNER JOIN 
    (
    	SELECT rxc.ID_Reserva, rxc.ID_Ciudad, c.Nombre
    	FROM ViajaPlus.dbo.Reserva_x_Ciudad rxc
    	INNER JOIN ViajaPlus.dbo.Ciudad c ON c.ID = rxc.ID_Ciudad
    	WHERE rxc.Es_Origen = 1
	) origen 
ON 
    origen.ID_Reserva = r.ID
INNER JOIN 
    (
    	SELECT rxc.ID_Reserva, rxc.ID_Ciudad, c.Nombre
    	FROM ViajaPlus.dbo.Reserva_x_Ciudad rxc
    	INNER JOIN ViajaPlus.dbo.Ciudad c ON c.ID = rxc.ID_Ciudad
    	WHERE rxc.Es_Origen = 0
	) destino 
ON 
    destino.ID_Reserva = r.ID
where r.deleted_at is null


--una vez que se tiene la lista de reservas se puede o borrar la reserva o confirmar la compra 

SELECT  s.ID as IDServicio, r.Costo  FROM ViajaPlus.dbo.Reserva r
INNER JOIN ViajaPlus.dbo.Servicio s ON s.ID_Transporte  = r.ID_Transporte 
WHERE r.ID=1
--retorna esto 1	100.5000

UPDATE ViajaPlus.dbo.Reserva
SET Estado='Vendida'
WHERE ID=1;

INSERT INTO ViajaPlus.dbo.Pasaje
(ID_Servicio, Costo)
VALUES(1, 100.5000);
--------------------------------------------------------
    
  
--3. Cancelación de Reservas a Pedido: Los clientes pueden cancelar sus reservas antes de la fecha de partida 
--programada.
--4. Cancelación Automática de Reservas por Expiración: Las reservas se cancelan automáticamente si no se 
--efectúa la venta dentro de los treinta minutos previos al horario de partida.

--no funciona en migracion

CREATE PROCEDURE VerificarReservasPorExpiracion
    AS
    BEGIN
        UPDATE R
        SET Estado = 'Cancelada'
            FROM Reserva R
            INNER JOIN Reserva_x_Ciudad RC ON RC.ID_Reserva = R.ID
            INNER JOIN Ciudad C ON C.ID = RC.ID_Ciudad
            INNER JOIN Itinerario_x_Ciudad IC ON IC.ID_Ciudad = C.ID
            INNER JOIN Itinerario I ON I.ID = IC.ID_Itinerario
            INNER JOIN Servicio_x_Itinerario SI ON SI.ID_Itinerario = I.ID
            INNER JOIN Servicio S ON S.ID = SI.ID_Servicio
            WHERE R.Estado LIKE 'Pendiente' AND GETDATE() < DATEADD(MINUTE, -30, s.Fecha_Llegada)
    END

EXEC msdb.dbo.sp_add_job
    @job_name = N'ActualizarReservasJob',
    @enabled = 1,
    @start_step_id = 1,
    @owner_login_name = N'tu_usuario';

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'ActualizarReservasJob',
    @step_id = 1,
    @subsystem = N'TSQL',
    @command = N'EXEC ActualizarEstadoReservas',
    @database_name = N'ViajaPlus';

EXEC msdb.dbo.sp_add_schedule
    @job_name = N'ActualizarReservasJob',
    @name = N'UnaVezCadaMinuto',
    @freq_type = 4,
    @freq_interval = 1;

EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'ActualizarReservasJob',
    @server_name = N'(tu_servidor)';

--5. Mantenimiento de Itinerarios: Permite a "ViajaPlus" administrar y actualizar los itinerarios, incluyendo 
--horarios, ciudades y puntos intermedios.
   
SELECT 
		i.ID AS ID_Itinerario,
		ixt_origen.ID_Tramo AS ID_Tramo_Origen,
		ixt_destino.ID_Tramo AS ID_Tramo_Destino,
		c_origen.Nombre as NombreCiudadOrigen,
		c_destino.Nombre as NombreCiudadDestino
FROM ViajaPlus.dbo.Itinerario i

INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_origen 
ON ixc_origen.ID_Itinerario = i.ID AND ixc_origen.Es_Origen = 1
INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = ixc_origen.ID_Ciudad 

INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_origen 
ON ixt_origen.ID_Itinerario = i.ID
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_origen 
ON txc_origen.ID_Tramo = ixt_origen.ID_Tramo AND txc_origen.Es_Origen = 1 


INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_destino 
ON ixc_destino.ID_Itinerario = i.ID AND ixc_destino.Es_Origen = 0
INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = ixc_destino.ID_Ciudad 

INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_destino 
ON ixt_destino.ID_Itinerario = i.ID
INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_destino 
ON txc_destino.ID_Tramo = ixt_destino.ID_Tramo AND txc_destino.Es_Origen = 0
			
WHERE txc_origen.ID_Ciudad = c_origen.ID 
AND txc_destino.ID_Ciudad = c_destino.ID
			
			
--------------------------------------------------_____
   
SELECT
		i.ID as IDItinerario,
		i.Distancia,      
		s.ID as IDServicio,             
		s.Disponibilidad, 
		s.Fecha_Partida, 
		s.Fecha_Llegada,  
		ixt_origen.ID_Tramo as IDTramoOrigen,
		ixt_destino.ID_Tramo as IDTramoDestino,
		c_origen.Nombre as NombreCiudadOrigen,
		c_destino.Nombre as NombreCiudadDestino,
		s.Costo_Servicio,
		s.ID_Transporte, 
		s.Calidad_Servicio  
FROM ViajaPlus.dbo.Itinerario i
INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID 
INNER JOIN ViajaPlus.dbo.Servicio s  ON s.ID  = sxi.ID_Servicio
INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_origen 
ON ixt_origen.ID_Itinerario = i.ID and ixt_origen.ID_Tramo = 1
INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_origen 
ON ixc_origen.ID_Itinerario = i.ID AND ixc_origen.Es_Origen = 1
INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = ixc_origen.ID_Ciudad 
INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_destino 
ON ixt_destino.ID_Itinerario = i.ID and ixt_destino.ID_Tramo = 5
INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_destino 
ON ixc_destino.ID_Itinerario = i.ID AND ixc_destino.Es_Origen = 0
INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = ixc_destino.ID_Ciudad 



----------------

  
--6. Gestión de Unidades: Facilita el mantenimiento y la gestión de las unidades de transporte, incluyendo su 
--categoría y disponibilidad.
   
   
--7. Gestión de Servicios: Permite al programador de servicios asignar itinerarios, fechas, unidades y calidad de 
--servicio para programar los viajes
--8. Estadísticas de Pasajes Vendidos: Proporciona informes y estadísticas sobre la cantidad de pasajes vendidos en 
--función de diferentes criterios, como itinerarios, fechas y categorías de unidades.