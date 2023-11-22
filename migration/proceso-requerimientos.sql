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

--query para obtener las opciones disponibles segun las entradas
--Resistencia - id: 1
--Buenos Aires - id: 2
--2024-01-01 12:00:00.000 
--(es posible que la entrada solo sea dia, 
--el horario lo elegira el cliente desde las opciones de la query de abajo)

SELECT s.* FROM Ciudad c
right join Tramo_x_Ciudad txc ON txc.ID_Ciudad = c.ID and txc.Es_origen = 1
inner join Tramo t ON t.ID  = txc.ID_Tramo 
inner join Itinerario_x_Tramo ixt ON ixt.ID_Tramo = t.ID 
inner join Itinerario i ON i.ID = ixt.ID_Itinerario 
inner join Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID 
inner join Servicio s ON s.ID = sxi.ID_Servicio 
inner join Itinerario_x_Ciudad ixc ON ixc.ID_Itinerario  = i.ID and ixc.Es_origen = 1
where c.ID = 1 and s.Disponibilidad = 1

--contemplar ciudad de destino 



-------------------------------------------------------------------------------------------------------------

--2. Venta de Pasajes: Facilita la compra de pasajes para itinerarios o tramos en función de la disponibilidad.
--3. Cancelación de Reservas a Pedido: Los clientes pueden cancelar sus reservas antes de la fecha de partida 
--programada.
--4. Cancelación Automática de Reservas por Expiración: Las reservas se cancelan automáticamente si no se 
--efectúa la venta dentro de los treinta minutos previos al horario de partida.
--5. Mantenimiento de Itinerarios: Permite a "ViajaPlus" administrar y actualizar los itinerarios, incluyendo 
--horarios, ciudades y puntos intermedios.
--6. Gestión de Unidades: Facilita el mantenimiento y la gestión de las unidades de transporte, incluyendo su 
--categoría y disponibilidad.
--7. Gestión de Servicios: Permite al programador de servicios asignar itinerarios, fechas, unidades y calidad de 
--servicio para programar los viajes
--8. Estadísticas de Pasajes Vendidos: Proporciona informes y estadísticas sobre la cantidad de pasajes vendidos en 
--función de diferentes criterios, como itinerarios, fechas y categorías de unidades.