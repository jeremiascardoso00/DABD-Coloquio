USE ViajaPlus

DROP TABLE IF EXISTS Administrador_Servicios

CREATE TABLE Administrador_Servicios
(
ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
DNI INT NOT NULL,
Email VARCHAR(50) NOT NULL,
Contrasena VARCHAR(50) NOT NULL
);
-------------------------------------------------------------------------------------------------------
USE ViajaPlus

DROP TABLE IF EXISTS Servicio

CREATE TABLE Servicio
(
ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Disponibilidad BIT NOT NULL,
Fecha_Partida DATETIME2 NOT NULL,
Fecha_Llegada DATETIME2 NOT NULL,
Costo_Servicio MONEY NOT NULL
);
-----------------------------------------
--USE ViajaPlus
--
--DROP TABLE IF EXISTS Calidad_Servicio
--
--CREATE TABLE Calidad_Servicio
--(
--ID INT IDENTITY(1,1) NOT NULL,
--ID_Servicio INT NOT NULL,
--PRIMARY KEY(ID, ID_Servicio),
--
--Calidad VARCHAR NOT NULL,
--
--FOREIGN KEY (ID_Servicio) REFERENCES dbo.Servicio(ID)
--);
-------------------------------------------------------------------------------------------------------
USE ViajaPlus

DROP TABLE IF EXISTS Transporte

CREATE TABLE ViajaPlus.dbo.Transporte (
	ID int IDENTITY(1,1) NOT NULL,
	Nro_Unidad int NOT NULL,
	Pisos int NOT NULL,
	Situacion bit NOT NULL,
	Costo_Transporte money NOT NULL,
	Categoria varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Tipo_Atencion varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK__Transpor__3214EC27D05AFFB0 PRIMARY KEY (ID)
);

USE ViajaPlus

DROP TABLE IF EXISTS Asiento

CREATE TABLE Asiento
(
ID INT IDENTITY(1,1) NOT NULL,
ID_Transporte INT NOT NULL,
PRIMARY KEY(ID, ID_Transporte),

Disponibilidad BIT NOT NULL,

FOREIGN KEY (ID_Transporte) REFERENCES dbo.Transporte(ID)
);
---------------------------------------
--USE ViajaPlus
--
--DROP TABLE IF EXISTS Categoria_Transporte
--
--CREATE TABLE Categoria_Transporte
--(
--ID INT IDENTITY(1,1) NOT NULL,
--ID_transporte INT NOT NULL,
--PRIMARY KEY(ID, ID_Transporte),
--
--Categoria VARCHAR NOT NULL,
--
--FOREIGN KEY (ID_Transporte) REFERENCES dbo.Transporte(ID)
--);
---------------------------------------
--USE ViajaPlus
--
--DROP TABLE IF EXISTS Tipo_Atencion_Transporte
--
--CREATE TABLE Tipo_Atencion_Transporte
--(
--ID INT IDENTITY(1,1) NOT NULL,
--ID_transporte INT NOT NULL,
--PRIMARY KEY(ID, ID_Transporte),
--
--Tipo VARCHAR NOT NULL,
--
--FOREIGN KEY (ID_Transporte) REFERENCES dbo.Transporte(ID)
--);
-------------------------------------------------------------------------------------------------------

USE ViajaPlus

DROP TABLE IF EXISTS Tramo

CREATE TABLE Tramo
(
ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Distancia INT NOT NULL,
Fecha_Partida DATETIME2 NOT NULL,
Fecha_Llegada DATETIME2 NOT NULL,
Costo_Tramo MONEY NOT NULL
);

USE ViajaPlus

DROP TABLE IF EXISTS Itinerario

CREATE TABLE Itinerario
(
ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Distancia INT NOT NULL,
--Ciudad_Partida VARCHAR(50) NOT NULL,
--Ciudad_Llegada VARCHAR(50) NOT NULL,
);

USE ViajaPlus

DROP TABLE IF EXISTS Ciudad

CREATE TABLE Ciudad
(
ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Nombre VARCHAR(30) NOT NULL,
);

USE ViajaPlus

DROP TABLE IF EXISTS Itinerario_x_Ciudad

CREATE TABLE Itinerario_x_Ciudad
(
ID_Itinerario INT NOT NULL,
ID_Ciudad INT NOT NULL,
Es_Origen BIT NOT NULL,

PRIMARY KEY(ID_Itinerario, ID_Ciudad),

FOREIGN KEY (ID_Itinerario) REFERENCES dbo.Itinerario(ID),
FOREIGN KEY (ID_Ciudad) REFERENCES dbo.Ciudad(ID)
);


-------------------------------------------------------------------------------------------------------
USE ViajaPlus

DROP TABLE IF EXISTS Pasaje

CREATE TABLE Pasaje
(
ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
ID_Servicio INT NOT NULL,
Costo MONEY NOT NULL,

FOREIGN KEY (ID_Servicio) REFERENCES dbo.Servicio(ID)
);

USE ViajaPlus

DROP TABLE IF EXISTS Reserva

CREATE TABLE Reserva
(
ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Nombre VARCHAR(50) NOT NULL,
Apellido VARCHAR(50) NOT NULL,
DNI INT NOT NULL,
Estado VARCHAR(50) NOT NULL,
Costo MONEY NOT NULL,

);
-----------------------------------------
-- USE ViajaPlus

-- DROP TABLE IF EXISTS Estado_Reserva

-- CREATE TABLE Estado_Reserva
-- (
-- ID INT IDENTITY(1,1) NOT NULL,
-- ID_Reserva INT NOT NULL,
-- PRIMARY KEY(ID, ID_Reserva),

-- Estado VARCHAR NOT NULL,

-- FOREIGN KEY (ID_Reserva) REFERENCES dbo.Reserva(ID)
-- );
-----------------------------------------------------------------------------------------------------
USE ViajaPlus

DROP TABLE IF EXISTS Servicio_x_Itinerario

CREATE TABLE Servicio_x_Itinerario
(
ID_Servicio INT NOT NULL,
ID_Itinerario INT NOT NULL,
PRIMARY KEY(ID_Servicio, ID_Itinerario),

FOREIGN KEY (ID_Servicio) REFERENCES dbo.Servicio(ID),
FOREIGN KEY (ID_Itinerario) REFERENCES dbo.Itinerario(ID)
);

USE ViajaPlus

DROP TABLE IF EXISTS Itinerario_x_Tramo

CREATE TABLE Itinerario_x_Tramo
(
ID_Tramo INT NOT NULL,
ID_Itinerario INT NOT NULL,
Orden INT,

PRIMARY KEY(ID_Tramo, ID_Itinerario),

FOREIGN KEY (ID_Tramo) REFERENCES dbo.Tramo(ID),
FOREIGN KEY (ID_Itinerario) REFERENCES dbo.Itinerario(ID)
);

USE ViajaPlus

DROP TABLE IF EXISTS Servicio_x_Transporte

CREATE TABLE Servicio_x_Transporte
(
ID_Servicio INT NOT NULL,
ID_Transporte INT NOT NULL,
PRIMARY KEY(ID_Servicio, ID_Transporte),

FOREIGN KEY (ID_Servicio) REFERENCES dbo.Servicio(ID),
FOREIGN KEY (ID_Transporte) REFERENCES dbo.Transporte(ID)
);

USE ViajaPlus

DROP TABLE IF EXISTS Tramo_x_Ciudad

CREATE TABLE Tramo_x_Ciudad
(
ID_Tramo INT NOT NULL,
ID_Ciudad INT NOT NULL,
Es_Origen BIT NOT NULL,
PRIMARY KEY(ID_Tramo, ID_Ciudad),

FOREIGN KEY (ID_Tramo) REFERENCES dbo.Tramo(ID),
FOREIGN KEY (ID_Ciudad) REFERENCES dbo.Ciudad(ID)
);

USE ViajaPlus

DROP TABLE IF EXISTS Reserva_x_Ciudad

CREATE TABLE Reserva_x_Ciudad
(
ID_Reserva INT NOT NULL,
ID_Ciudad INT NOT NULL,
PRIMARY KEY(ID_Reserva, ID_Ciudad),

Es_Origen BIT NOT NULL,

FOREIGN KEY (ID_Reserva) REFERENCES dbo.Reserva(ID),
FOREIGN KEY (ID_Ciudad) REFERENCES dbo.Ciudad(ID)
);
-----------------------------------------
USE ViajaPlus

DROP TABLE IF EXISTS Administrador_x_Transporte

CREATE TABLE Administrador_x_Transporte
(
ID_Administrador INT NOT NULL,
ID_Transporte INT NOT NULL,
PRIMARY KEY(ID_Administrador, ID_Transporte),

FOREIGN KEY (ID_Administrador) REFERENCES dbo.Administrador_Servicios(ID),
FOREIGN KEY (ID_Transporte) REFERENCES dbo.Transporte(ID)
);

USE ViajaPlus

DROP TABLE IF EXISTS Administrador_x_Servicio

CREATE TABLE Administrador_x_Servicio
(
ID_Administrador INT NOT NULL,
ID_Servicio INT NOT NULL,
PRIMARY KEY(ID_Administrador, ID_Servicio),

FOREIGN KEY (ID_Administrador) REFERENCES dbo.Administrador_Servicios(ID),
FOREIGN KEY (ID_Servicio) REFERENCES dbo.Servicio(ID)
);

USE ViajaPlus

DROP TABLE IF EXISTS Administrador_x_Itinerario

CREATE TABLE Administrador_x_Itinerario
(
ID_Administrador INT NOT NULL,
ID_Itinerario INT NOT NULL,
PRIMARY KEY(ID_Administrador, ID_Itinerario),

FOREIGN KEY (ID_Administrador) REFERENCES dbo.Administrador_Servicios(ID),
FOREIGN KEY (ID_Itinerario) REFERENCES dbo.Itinerario(ID)
);

USE ViajaPlus

DROP TABLE IF EXISTS Administrador_x_Tramo

CREATE TABLE Administrador_x_Tramo
(
ID_Administrador INT NOT NULL,
ID_Tramo INT NOT NULL,
PRIMARY KEY(ID_Administrador, ID_Tramo),

FOREIGN KEY (ID_Administrador) REFERENCES dbo.Administrador_Servicios(ID),
FOREIGN KEY (ID_Tramo) REFERENCES dbo.Tramo(ID)
);

USE ViajaPlus

DROP TABLE IF EXISTS Administrador_x_Ciudad

CREATE TABLE Administrador_x_Ciudad
(
ID_Administrador INT NOT NULL,
ID_Ciudad INT NOT NULL,
PRIMARY KEY(ID_Administrador, ID_Ciudad),

FOREIGN KEY (ID_Administrador) REFERENCES dbo.Administrador_Servicios(ID),
FOREIGN KEY (ID_Ciudad) REFERENCES dbo.Ciudad(ID)
);

USE ViajaPlus

DROP TABLE IF EXISTS Tramo_x_Reserva

CREATE TABLE Tramo_x_Reserva(
    ID_Tramo INT NOT NULL,
    ID_Reserva INT NOT NULL,
	Es_Origen BIT NOT NULL,

    PRIMARY KEY(ID_Tramo, ID_Reserva),

    FOREIGN KEY (ID_Tramo) REFERENCES dbo.tramo(ID),
    FOREIGN KEY (ID_Reserva) REFERENCES dbo.Reserva(ID)
)

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

-- -- CREATE PROCEDURE VerificarReservasPorExpiracion
-- --     AS
-- --     BEGIN
-- --         UPDATE R
-- --         SET Estado = 'Cancelada'
-- --             FROM Reserva R
-- --             INNER JOIN Reserva_x_Ciudad RC ON RC.ID_Reserva = R.ID
-- --             INNER JOIN Ciudad C ON C.ID = RC.ID_Ciudad
-- --             INNER JOIN Itinerario_x_Ciudad IC ON IC.ID_Ciudad = C.ID
-- --             INNER JOIN Itinerario I ON I.ID = IC.ID_Itinerario
-- --             INNER JOIN Servicio_x_Itinerario SI ON SI.ID_Itinerario = I.ID
-- --             INNER JOIN Servicio S ON S.ID = SI.ID_Servicio
-- --             WHERE R.Estado LIKE 'Pendiente' AND GETDATE() < DATEADD(MINUTE, -30, s.Fecha_Llegada)
-- --     END

-- -- USE ViajaPlus

-- -- EXEC msdb.dbo.sp_add_job
-- --     @job_name = N'ActualizarReservasJob',
-- --     @enabled = 1,
-- --     @start_step_id = 1,
-- --     @owner_login_name = N'tu_usuario';

-- -- EXEC msdb.dbo.sp_add_jobstep
-- --     @job_name = N'ActualizarReservasJob',
-- --     @step_id = 1,
-- --     @subsystem = N'TSQL',
-- --     @command = N'EXEC ActualizarEstadoReservas',
-- --     @database_name = N'ViajaPlus';

-- -- EXEC msdb.dbo.sp_add_schedule
-- --     @job_name = N'ActualizarReservasJob',
-- --     @name = N'UnaVezCadaMinuto',
-- --     @freq_type = 4,
-- --     @freq_interval = 1;

-- -- EXEC msdb.dbo.sp_add_jobserver
-- --     @job_name = N'ActualizarReservasJob',
-- --     @server_name = N'(tu_servidor)';


ALTER TABLE Servicio
ALTER COLUMN Calidad_Servicio VARCHAR(20) NOT NULL;

UPDATE Servicio
SET Calidad_Servicio = ISNULL(Calidad_Servicio, 'Premium')
WHERE Calidad_Servicio IS NULL;

ALTER TABLE Reserva
ADD Estado VARCHAR(20) NOT NULL

ALTER TABLE Reserva
ADD Nombre_Cliente VARCHAR(20), 
	Apellido_Cliente VARCHAR(20),
	DNI_Cliente INT

UPDATE Reserva
SET Nombre_Cliente = 'Fernando',
	Apellido_Cliente = 'Zalazar',
	DNI_Cliente = 22222222
WHERE ID = 2;

SELECT *
FROM Reserva

ALTER TABLE Reserva
ADD CONSTRAINT DF_ValorPorDefecto DEFAULT 'Espera' FOR Estado;--estados posibles Espera, Pagado, Cancelado

INSERT INTO Reserva
DEFAULT VALUES

--Es_Origen bit = 0 Es Origen, bit = 1 Llegada
INSERT INTO Reserva_x_Ciudad(ID_Reserva, ID_Ciudad, Es_Origen)
VALUES (1, 1, 0),
		(1, 2, 1)

INSERT INTO Pasaje(ID_Servicio,Costo)
VALUES (1, '$19500')

ALTER TABLE ViajaPlus.dbo.Asiento ADD  DEFAULT 0 FOR Disponibilidad;


INSERT INTO ViajaPlus.dbo.Ciudad
(Nombre, deleted_at)
VALUES( 'Posadas', NULL);

--insert to test query
INSERT INTO ViajaPlus.dbo.Tramo
(Distancia, Fecha_Partida, Fecha_Llegada, Costo_Tramo, deleted_at)
VALUES(40, '2024-01-01 12:00:00.000', '2024-01-01 13:45:00.000', 1000.0000, NULL);

-- agrego un nuevo tramo de resistencia a corrientes
INSERT INTO ViajaPlus.dbo.Tramo_x_Ciudad
(ID_Tramo, ID_Ciudad, Es_Origen, deleted_at)
VALUES(6, 1, 1, NULL);
INSERT INTO ViajaPlus.dbo.Tramo_x_Ciudad
(ID_Tramo, ID_Ciudad, Es_Origen, deleted_at)
VALUES(6, 10, 0, NULL);

INSERT INTO ViajaPlus.dbo.Tramo
( Distancia, Fecha_Partida, Fecha_Llegada, Costo_Tramo, deleted_at)
VALUES( 301, '2024-01-01 12:00:00.000', '2024-01-01 13:45:00.000', 1000.0000, NULL);

INSERT INTO ViajaPlus.dbo.Tramo_x_Ciudad
(ID_Tramo, ID_Ciudad, Es_Origen, deleted_at)
VALUES(7, 10, 1, NULL);
INSERT INTO ViajaPlus.dbo.Tramo_x_Ciudad
(ID_Tramo, ID_Ciudad, Es_Origen, deleted_at)
VALUES(7, 14, 0, NULL);


--insert nuevo itinerario con 2 tramos
--resistencia - corrientes - corrientes - posadas
INSERT INTO ViajaPlus.dbo.Itinerario
(Distancia, deleted_at)
VALUES(341, NULL);
INSERT INTO ViajaPlus.dbo.Itinerario_x_Ciudad
(ID_Itinerario, ID_Ciudad, Es_Origen)
VALUES(2, 1, 1);
INSERT INTO ViajaPlus.dbo.Itinerario_x_Ciudad
(ID_Itinerario, ID_Ciudad, Es_Origen)
VALUES(2, 14, 0);
