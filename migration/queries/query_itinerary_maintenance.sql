USE ViajaPlus

SELECT *
FROM Itinerario
--WHERE Itinerario.ID = @idItinerario

SELECT T.ID, C.Nombre
FROM Tramo_x_Ciudad
INNER JOIN Tramo T ON T.ID = Tramo_x_Ciudad.ID_Tramo
INNER JOIN Ciudad C ON C.ID = Tramo_x_Ciudad.ID_Ciudad

SELECT *
FROM Ciudad

--update itinerary (add column "Es_Destino" to table "Itinerario_x_Ciudad")
USE ViajaPlus

SELECT
    I.ID AS IdItinerario,
    CO.Nombre AS CiudadOrigen,
    CD.Nombre AS CiudadDestino,
    T_O.Fecha_Partida AS Fecha_Partida,
    T_D.Fecha_Llegada AS Fecha_Llegada
FROM
    Itinerario I
    INNER JOIN Itinerario_x_Ciudad ICI_O ON ICI_O.ID_Itinerario = I.ID AND ICI_O.Es_Origen = 1
    INNER JOIN Ciudad CO ON CO.ID = ICI_O.ID_Ciudad
    INNER JOIN Itinerario_x_Ciudad ICI_D ON ICI_D.ID_Itinerario = I.ID AND ICI_D.Es_Origen = 0
    INNER JOIN Ciudad CD ON CD.ID = ICI_D.ID_Ciudad

    INNER JOIN Tramo_x_Ciudad TC_O ON TC_O.ID_Ciudad = CO.ID
    INNER JOIN Tramo T_O ON T_O.ID = TC_O.ID_Tramo
    INNER JOIN Tramo_x_Ciudad TC_D ON TC_D.ID_Ciudad = CD.ID
    INNER JOIN Tramo T_D ON T_D.ID = TC_D.ID_Tramo

--Get midway city
USE ViajaPlus

SELECT
    Itinerario.ID,
    Ciudad.Nombre
FROM Itinerario
INNER JOIN Itinerario_x_Ciudad IT_C ON IT_C.ID_Itinerario = Itinerario.ID AND IT_C.Es_Origen = 0 AND IT_C.Es_Destino = 0
INNER JOIN Ciudad ON Ciudad.ID = IT_C.ID_Ciudad

--Save data new itinerario
INSERT INTO Itinerario (Distancia)
VALUES (@Distancia)

--save origin city and destiny city
INSERT INTO Itinerario_x_Ciudad (ID_Itinerario, ID_Ciudad, Es_Origen, Es_Destino)
VALUEs (@idItinerario, @idCiudadOrigen, 1, 0),
        (@idItinerario, @idCiudadDestino, 0, 1)
--save midway city
INSERT INTO Itinerario_x_Ciudad (ID_Itinerario, ID_Ciudad, Es_Origen, Es_Destino)
VALUEs (@idItinerario, @idCiudadOrigen, 0, 0)

--hablar el tema de los itinerarios