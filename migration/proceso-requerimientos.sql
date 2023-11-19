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

SELECT s.* FROM Tramo t 
inner join Tramo_x_Ciudad txc ON txc.ID_Tramo = t.ID AND txc.ID_Ciudad = 1 
inner join Itinerario_x_Tramo ixt ON ixt.ID_Tramo = t.ID 
inner join Itinerario i ON i.ID = ixt.ID_Itinerario 
inner join Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID 
inner join Servicio s ON s.ID = sxi.ID_Servicio 
where '2024-01-01 12:00:00.000' BETWEEN s.Fecha_Partida AND s.Fecha_Llegada 

--necesitamos cambiar el tipo de dato de los tramos y poner fecha en vez de horario





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