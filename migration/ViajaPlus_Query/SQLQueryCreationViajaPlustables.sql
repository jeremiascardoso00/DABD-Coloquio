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
Hora_Partida TIME NOT NULL,
Hora_Llegada TIME NOT NULL,
Costo_Tramo MONEY NOT NULL
);

USE ViajaPlus

DROP TABLE IF EXISTS Itinerario

CREATE TABLE Itinerario
(
ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Distancia INT NOT NULL,
Ciudad_Partida VARCHAR(50) NOT NULL,
Ciudad_Llegada VARCHAR(50) NOT NULL,
);

USE ViajaPlus

DROP TABLE IF EXISTS Ciudad

CREATE TABLE Ciudad
(
ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Nombre VARCHAR(30) NOT NULL,
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
);
-----------------------------------------
USE ViajaPlus

DROP TABLE IF EXISTS Estado_Reserva

CREATE TABLE Estado_Reserva
(
ID INT IDENTITY(1,1) NOT NULL,
ID_Reserva INT NOT NULL,
PRIMARY KEY(ID, ID_Reserva),

Estado VARCHAR NOT NULL,

FOREIGN KEY (ID_Reserva) REFERENCES dbo.Reserva(ID)
);
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

