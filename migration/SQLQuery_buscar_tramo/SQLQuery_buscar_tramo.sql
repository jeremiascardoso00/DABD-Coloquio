
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
