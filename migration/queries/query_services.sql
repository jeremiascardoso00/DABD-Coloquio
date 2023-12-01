USE ViajaPlus

SELECT
    Servicio.ID AS ID,
    Servicio.Disponibilidad AS Disponibilidad,
    Servicio.Fecha_Partida AS FechaPartida,
    Servicio.Fecha_Llegada AS FechaLlegada,
    Servicio.Calidad_Servicio AS Calidad,
    Servicio.Costo_Servicio AS Costo,

    I.ID AS IdItinerario,
    T.Nro_Unidad AS NroUnidadTransporte
FROM Servicio
INNER JOIN Servicio_x_Itinerario SI ON SI.ID_Servicio = Servicio.ID
INNER JOIN Itinerario I ON I.ID = SI.ID_Itinerario
INNER JOIN Servicio_x_Transporte ST ON ST.ID_Servicio = Servicio.ID
INNER JOIN Transporte T ON T.ID = ST.ID_Transporte

--get itinerarios
SELECT 
    Itinerario.ID AS IdItinerario,
    CO.Nombre AS NombreCiudadOrigen,
    CD.Nombre AS NombreCiudadDestino
FROM Itinerario
INNER JOIN Itinerario_x_Ciudad ICO ON ICO.ID_Itinerario = Itinerario.ID AND ICO.Es_Origen = 1
INNER JOIN Ciudad CO ON CO.ID = ICO.ID_Ciudad
INNER JOIN Itinerario_x_Ciudad ICD ON ICD.ID_Itinerario = Itinerario.ID AND ICD.Es_Origen = 0
INNER JOIN Ciudad CD ON CD.ID = ICD.ID_Ciudad

--save data new servicio
USE ViajaPlus

INSERT INTO Servicio (Disponibilidad, Fecha_Llegada, Fecha_Partida, Costo_Servicio, Calidad_Servicio)
VALUES (@disponibilidad, @fecha_llegada, @fecha_partida, @costo_servicio, @calidad_servicio)

INSERT INTO Servicio_x_Itinerario (ID_Servicio, ID_Itinerario)
VALUES (@idNewServicio, @idItinerario)

INSERT INTO Servicio_x_Transporte (ID_Servicio, ID_Transporte)
VALUES (@idNewServicio, @transporte)

--update data
USE ViajaPlus

UPDATE Servicio
SET Disponibilidad = @disponibilidad,
    Fecha_Partida = @fecha_partida,
    Fecha_Llegada = @fecha_llegada,
    Costo_Servicio = @costo_servicio,
    Calidad_Servicio = @calidad_servicio
WHERE ID = @idServicio