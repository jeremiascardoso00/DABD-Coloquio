USE ViajaPlus

INSERT INTO Administrador_Servicios(DNI, Email, Contrasena)
VALUES (12312344, 'asd@asd.com', 'Pedro123'),
		(12312344, 'hola@hola.com', '123Pedro')

INSERT INTO Ciudad(Nombre)
VALUES ('Resistencia'),
		('Buenos Aires'),
		('Reconquista'),
		('Santa fe'),
		('Rosario'),
		('Parana'),
		('Villa Ocampo'),
		('Bariloche'),
		('Mar Del Plata'),
		('Corrientes'),
		('Cordoba'),
		('Salta'),
		('Mendoza')

INSERT INTO Administrador_x_Ciudad(ID_Administrador, ID_Ciudad)
VALUES (1, 1),
		(1, 2),
		(1, 3),
		(1, 4),
		(1, 5),
		(1, 6),
		(2, 7),
		(2, 8),
		(2, 9),
		(2, 10),
		(2, 11),
		(2, 12),
		(2, 13)

-- Se asumen todas las distancias en Km y los tiempos en formato de 24 horas
-- El precio por km es de 100 pesos
INSERT INTO Tramo(Distancia, Hora_Partida, Hora_Llegada, Costo_Tramo)
VALUES (137, '12:00:00', '13:45:00', 1985),--Resistencia a Villa Ocampo
		(86, '14:00:00', '15:00:00', 1246),--Villa Ocampo a Reconquista
		(325, '15:15:00', '19:00:00', 4708),--Reconquista a Santa fe
		(360, '19:15:00', '23:15:00', 5215),--Santa fe a Rosario
		(300, '23:30:00', '02:15:00', 4346)--Rosario a Buenos Aires

UPDATE Tramo
SET Costo_Tramo = 
    CASE Id
        WHEN 1 THEN '$1985'
        WHEN 2 THEN '$1246'
		WHEN 3 THEN '$4708'
		WHEN 4 THEN '$5215'
		WHEN 5 THEN '$4346'
    END
WHERE Id IN (1,2,3,4,5);

SELECT *
FROM Tramo

INSERT INTO Tramo_x_Ciudad(ID_Tramo, ID_Ciudad)
VALUES (1, 1),
		(1, 7),--Resistencia a Villa Ocampo
		(2, 7),
		(2, 3),--Villa Ocampo a Reconquista
		(3, 3),
		(3, 4),--Reconquista a Santa fe
		(4, 4),
		(4, 5),--Santa fe a Rosario
		(5, 5),
		(5, 2)--Rosario a Buenos Aires

INSERT INTO Itinerario (Distancia, Ciudad_Partida, Ciudad_Llegada)
VALUES (1208, 'Resistencia', 'Buenos Aires')

SELECT 17500 / 5

INSERT INTO Itinerario_x_Tramo(ID_Itinerario, ID_Tramo)
VALUES (1, 1),
		(1, 2),
		(1, 3),
		(1, 4),
		(1, 5)

INSERT INTO Administrador_x_Itinerario(ID_Administrador, ID_Itinerario)
VALUES (1, 1)

INSERT INTO Administrador_x_Tramo(ID_Administrador, ID_Tramo)
VALUES (1, 1),
		(1, 2),
		(1, 3),
		(1, 4),
		(1, 5)

--Disponibilidad bit = 0 Está disponible, bit = 1 no está disponible
INSERT INTO Servicio(Disponibilidad, Fecha_Partida, Fecha_Llegada, Costo_Servicio)
VALUES (0, '20240101 12:00:00.0000000', '20240102 02:15:00.0000000', '$17500')

INSERT INTO Servicio_x_Itinerario(ID_Servicio, ID_Itinerario)
VALUES (1, 1)

--Disponibilidad bit = 0 Está disponible, bit = 1 no está disponible
INSERT INTO Transporte(Nro_Unidad, Pisos, Situacion, Costo_Transporte, Categoria, Tipo_Atencion)
VALUES (1001, 1, 0, '$1000', 'Comun', 'Comun'),
		(1002, 1, 0, '$1000', 'Comun', 'Comun'),
		(1003, 1, 0, '$1000', 'Comun', 'Comun'),
		(1004, 1, 0, '$1000', 'Comun', 'Comun'),
		(1005, 2, 0, '$1500', 'Semi cama', 'Comun'),
		(1006, 2, 0, '$1500', 'Semi cama', 'Comun'),
		(1007, 2, 0, '$2000', 'Coche cama', 'Ejecutivo'),
		(1008, 2, 0, '$2000', 'Coche cama', 'Ejecutivo')

SELECT *
FROM Transporte

--Disponibilidad bit = 0 Está disponible, bit = 1 no está disponible
INSERT INTO Asiento(ID_Transporte, Disponibilidad)
VALUES (15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0),
		(15,0),(10,0)

INSERT INTO Administrador_x_Servicio(ID_Administrador, ID_Servicio)
VALUES (1,1)

INSERT INTO Administrador_x_Transporte(ID_Administrador, ID_Transporte)
VALUES (1,9),
		(1,10),
		(1,11),
		(1,12),
		(2,13),
		(2,14),
		(2,15),
		(2,16)

INSERT INTO Servicio_x_Transporte(ID_Servicio, ID_Transporte)
VALUES (1, 15)

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