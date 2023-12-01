USE ViajaPlus

SELECT

    P.Costo AS CostoPasaje,
    I.ID AS idItinerario,
    T.ID AS idTransporte

FROM Pasaje P
INNER JOIN Servicio_x_Itinerario SI ON SI.ID_Servicio = P.ID_Servicio
INNER JOIN Itinerario I ON I.ID = SI.ID_Itinerario
INNER JOIN Servicio_x_Transporte ST ON ST.ID_Servicio = P.ID_Servicio
INNER JOIN Transporte T ON T.ID = ST.ID_Transporte

--sales tickets by unit

--

USE ViajaPlus

SELECT

    COUNT(P.ID) AS CantidadPasajesPorUnidad,
    T.Nro_Unidad AS Unidad

FROM Pasaje P
INNER JOIN Servicio S ON S.ID = P.ID_Servicio
INNER JOIN Servicio_x_Itinerario SI ON SI.ID_Servicio = P.ID_Servicio
INNER JOIN Itinerario I ON I.ID = SI.ID_Itinerario
INNER JOIN Servicio_x_Transporte ST ON ST.ID_Servicio = P.ID_Servicio
INNER JOIN Transporte T ON T.ID = ST.ID_Transporte

GROUP BY T.Nro_Unidad

--sales tickets by itinerary
USE ViajaPlus

SELECT

    COUNT(P.ID) AS CantidadPasajesPorItinerario,
    I.ID AS Itinerario

FROM Pasaje P
INNER JOIN Servicio S ON S.ID = P.ID_Servicio
INNER JOIN Servicio_x_Itinerario SI ON SI.ID_Servicio = P.ID_Servicio
INNER JOIN Itinerario I ON I.ID = SI.ID_Itinerario
INNER JOIN Servicio_x_Transporte ST ON ST.ID_Servicio = P.ID_Servicio
INNER JOIN Transporte T ON T.ID = ST.ID_Transporte

GROUP BY I.ID

-- sales tickets by day
USE ViajaPlus

SELECT

    COUNT(P.ID) AS CantidadPasajesPorDía,
    CAST(P.Fecha_Compra AS date) AS FechaCompra

FROM Pasaje P

GROUP BY CAST(P.Fecha_Compra AS date)

-- sales tickets by month
USE ViajaPlus

SELECT

    COUNT(P.ID) AS CantidadPasajesPorDía,
    MONTH(P.Fecha_Compra) AS FechaCompra

FROM Pasaje P

GROUP BY YEAR(P.Fecha_Compra), MONTH(P.Fecha_Compra)

-- sales tickets by year
USE ViajaPlus

SELECT

    COUNT(P.ID) AS CantidadPasajesPorDía,
    YEAR(P.Fecha_Compra) AS FechaCompra

FROM Pasaje P

GROUP BY YEAR(P.Fecha_Compra)