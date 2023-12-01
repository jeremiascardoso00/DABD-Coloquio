CREATE PROCEDURE VerificarReservasPorExpiracion
    AS
    BEGIN
        UPDATE R
        SET Estado = 'Cancelada'
            FROM Reserva R
            INNER JOIN Reserva_x_Ciudad RC ON RC.ID_Reserva = R.ID
            INNER JOIN Ciudad C ON C.ID = RC.ID_Ciudad
            INNER JOIN Itinerario_x_Ciudad IC ON IC.ID_Ciudad = C.ID
            INNER JOIN Itinerario I ON I.ID = IC.ID_Itinerario
            INNER JOIN Servicio_x_Itinerario SI ON SI.ID_Itinerario = I.ID
            INNER JOIN Servicio S ON S.ID = SI.ID_Servicio
            WHERE R.Estado LIKE 'Pendiente' AND GETDATE() < DATEADD(MINUTE, -30, s.Fecha_Llegada)
    END

USE ViajaPlus

EXEC msdb.dbo.sp_add_job
    @job_name = N'ActualizarReservasJob',
    @enabled = 1,
    @start_step_id = 1,
    @owner_login_name = N'tu_usuario';

EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'ActualizarReservasJob',
    @step_id = 1,
    @subsystem = N'TSQL',
    @command = N'EXEC ActualizarEstadoReservas',
    @database_name = N'ViajaPlus';

EXEC msdb.dbo.sp_add_schedule
    @job_name = N'ActualizarReservasJob',
    @name = N'UnaVezCadaMinuto',
    @freq_type = 4,
    @freq_interval = 1;

EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'ActualizarReservasJob',
    @server_name = N'(tu_servidor)';