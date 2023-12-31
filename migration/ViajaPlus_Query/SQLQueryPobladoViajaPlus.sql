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
INSERT INTO Tramo(Distancia, Fecha_Partida, Fecha_Llegada, Costo_Tramo)
VALUES (137, '2024-01-01T12:00:00', '2024-01-01T13:45:00', 1985),--Resistencia a Villa Ocampo
		(86, '2024-01-01T14:00:00', '2024-01-01T15:00:00', 1246),--Villa Ocampo a Reconquista
		(325, '2024-01-01T15:15:00', '2024-01-01T19:00:00', 4708),--Reconquista a Santa fe
		(360, '2024-01-01T19:15:00', '2024-01-01T23:15:00', 5215),--Santa fe a Rosario
		(300, '2024-01-01T23:30:00', '2024-01-02T02:15:00', 4346)--Rosario a Buenos Aires

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

INSERT INTO Tramo_x_Ciudad(ID_Tramo, ID_Ciudad, Es_Origen)
VALUES (1, 1, 1),
		(1, 7, 0),--Resistencia a Villa Ocampo
		(2, 7, 1),
		(2, 3, 0),--Villa Ocampo a Reconquista
		(3, 3, 1),
		(3, 4, 0),--Reconquista a Santa fe
		(4, 4, 1),
		(4, 5, 0),--Santa fe a Rosario
		(5, 5, 1),
		(5, 2, 0)--Rosario a Buenos Aires

INSERT INTO Itinerario (Distancia)
VALUES (1208)

INSERT INTO Itinerario_x_Ciudad(ID_Itinerario, ID_Ciudad, Es_Origen)
VALUES (1, 1, 1),
		(1, 2, 0)--Resistencia a Buenos Aires


SELECT 17500 / 5

INSERT INTO Itinerario_x_Tramo(ID_Itinerario, ID_Tramo, Orden)
VALUES (1, 1, 1),
		(1, 2, 2),
		(1, 3, 3),
		(1, 4, 4),
		(1, 5, 5)

INSERT INTO Administrador_x_Itinerario(ID_Administrador, ID_Itinerario)
VALUES (1, 1)

INSERT INTO Administrador_x_Tramo(ID_Administrador, ID_Tramo)
VALUES (1, 1),
		(1, 2),
		(1, 3),
		(1, 4),
		(1, 5)

--Disponibilidad bit = 1 Est� disponible, bit = 0 no est� disponible
INSERT INTO Transporte(Nro_Unidad, Pisos, Situacion, Costo_Transporte, Categoria, Tipo_Atencion)
VALUES (1001, 1, 1, '$1000', 'Comun', 'Comun'),
		(1002, 1, 1, '$1000', 'Comun', 'Comun'),
		(1003, 1, 1, '$1000', 'Comun', 'Comun'),
		(1004, 1, 1, '$1000', 'Comun', 'Comun'),
		(1005, 2, 1, '$1500', 'Semi cama', 'Comun'),
		(1006, 2, 1, '$1500', 'Semi cama', 'Comun'),
		(1007, 2, 1, '$2000', 'Coche cama', 'Ejecutivo'),
		(1008, 2, 1, '$2000', 'Coche cama', 'Ejecutivo')
		
--Disponibilidad bit = 1 Est� disponible, bit = 0 no est� disponible
INSERT INTO Servicio(Disponibilidad, Fecha_Partida, Fecha_Llegada, Costo_Servicio, ID_Transporte)
VALUES (1, '20240101 12:00:00.0000000', '20240102 02:15:00.0000000', '$17500',1)

INSERT INTO Servicio_x_Itinerario(ID_Servicio, ID_Itinerario)
VALUES (1, 1)

--Disponibilidad bit = 1 Est� disponible, bit = 0 no est� disponible
INSERT INTO Asiento(ID_Transporte, Disponibilidad)
VALUES (1,1),
(1,1),(1,1),(1,1),(1,1),(1,1),(1,1),(1,1),(1,1),(1,1),(1,1),(1,1),
(3,1),(3,1),(3,1),(3,1),(3,1),(3,1),(3,1),(3,1),(3,1),(3,1),(3,1),
(4,1),(4,1),(4,1),(4,1),(4,1),(4,1),(4,1),(4,1),(4,1),(4,1),(4,1),
(1,1),(1,1),(1,1),(1,1),(1,1),(1,1),(1,1),(1,1),(1,1),(1,1),(1,1)


INSERT INTO Administrador_x_Servicio(ID_Administrador, ID_Servicio)
VALUES (1,1)

INSERT INTO Administrador_x_Transporte(ID_Administrador, ID_Transporte)
VALUES (1,8),
		(1,2),
		(1,3),
		(1,4),
		(2,5),
		(2,6),
		(2,7),
		(2,8)

-- INSERT INTO Servicio_x_Transporte(ID_Servicio, ID_Transporte)
-- VALUES (1, 1)


--agrego los campos de gorm para el soft, delete, nada importante
ALTER TABLE Administrador_Servicios
ADD deleted_at DATETIME2;
ALTER TABLE Administrador_x_Ciudad
ADD deleted_at DATETIME2;
ALTER TABLE Administrador_x_Itinerario
ADD deleted_at DATETIME2;
ALTER TABLE Administrador_x_Servicio
ADD deleted_at DATETIME2;
ALTER TABLE Administrador_x_Tramo
ADD deleted_at DATETIME2;
ALTER TABLE Administrador_x_Transporte
ADD deleted_at DATETIME2;
ALTER TABLE Asiento
ADD deleted_at DATETIME2;
ALTER TABLE Ciudad
ADD deleted_at DATETIME2;
-- ALTER TABLE Estado_Reserva
-- ADD deleted_at DATETIME2;
ALTER TABLE Itinerario
ADD deleted_at DATETIME2;
ALTER TABLE Itinerario_x_Tramo
ADD deleted_at DATETIME2;
ALTER TABLE Pasaje
ADD deleted_at DATETIME2;
ALTER TABLE Reserva
ADD deleted_at DATETIME2;
ALTER TABLE Reserva_x_Ciudad
ADD deleted_at DATETIME2;
ALTER TABLE Servicio
ADD deleted_at DATETIME2;
ALTER TABLE Servicio_x_Itinerario
ADD deleted_at DATETIME2;
-- ALTER TABLE Servicio_x_Transporte
-- ADD deleted_at DATETIME2;
ALTER TABLE Tramo
ADD deleted_at DATETIME2;
ALTER TABLE Tramo_x_Ciudad
ADD deleted_at DATETIME2;
ALTER TABLE Transporte
ADD deleted_at DATETIME2;








