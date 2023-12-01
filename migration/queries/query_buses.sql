--get info transporte
USE ViajaPlus

SELECT
    Transporte.ID AS IdTransporte,
    Transporte.Nro_Unidad AS NumeroUnidad,
    Transporte.Pisos AS CantidadPisos,
    Transporte.Situacion AS Sutiacion,
    Transporte.Costo_Transporte AS Coste,
    Transporte.Categoria AS Categoría,
    Transporte.Tipo_Atencion AS TipoAtencion,
    Transporte.Capacidad AS CapacidadTransporte

FROM Transporte

--load info new transporte
INSERT INTO Transporte (Nro_Unidad, Pisos, Situacion, Costo_Transporte, Categoria, Capacidad, Tipo_Atencion)
VALUES (@nro_transporte, @pisos, @situacion, @costo_transporte, @categoria, @capacidad, @tipo_atencion)

--load
UPDATE Transporte
SET Pisos = @pisos,
    situacion = @situacion,
    Costo_Transporte = @costo_transporte,
    Categoria = @categoria,
    Capacidad = @capacidad,
    Tipo_Atencion = @tipo_atencion
WHERE Nro_Unidad = @nro_transporte