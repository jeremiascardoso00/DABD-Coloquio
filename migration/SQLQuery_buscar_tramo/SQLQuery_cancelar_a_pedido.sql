--3. Cancelación de Reservas a Pedido: Los clientes pueden cancelar sus reservas antes de la fecha de partida
Use	ViajaPlus
UPDATE Reserva 
	SET Estado='Cancelado'
	WHERE Reserva.ID=1 AND Reserva.DNI_Cliente=11111111
-- cambiar 1 y 1111 por @id y @dni_cliente

