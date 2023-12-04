package controllers

import (
	"errors"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type ViajeController struct {
	Txn *gorm.DB
}

type opciones struct {
	ID                  uint      `gorm:"primarykey"`
	Origen              string    `gorm:"column:Origen"`
	Destino             string    `gorm:"column:Destino"`
	IDTramoOrigen       int       `gorm:"column:IDTramoOrigen"`
	IDTramoDestino      int       `gorm:"column:IDTramoDestino"`
	FechaPartida        time.Time `gorm:"column:Fecha_Partida; not null"`
	FechaLlegada        time.Time `gorm:"column:Fecha_Llegada; not null"`
	Costo               float64   `gorm:"column:Costo; not null"`
	Distancia           int       `gorm:"column:Distancia; not null"`
	IDTransporte        int       `gorm:"column:IDTransporte"`
	CategoriaTransporte string    `gorm:"column:CategoriaTransporte"`
	TipoAtencion        string    `gorm:"column:TipoAtencion"`
	Pisos               string    `gorm:"column:Pisos"`
}

/*
func (vc *ViajeController) GetItinerariosYTramos(c *gin.Context) {
	var opcionesI []opciones
	var opcionesT []opciones

	originCityID := c.Query("origin")
	if originCityID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid origin city 'ID' parameter"})
		return
	}

	destinationCityID := c.Query("destination")
	if destinationCityID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid destination city 'ID' parameter"})
		return
	}

	date := c.Query("date")

	Intenta convertir el timestamp a un entero
	timestampInt, err := strconv.ParseInt(date, 10, 64)
	if err != nil {
		Si hay un error, el timestamp no es válido
		c.JSON(http.StatusBadRequest, gin.H{"error": "Timestamp inválido"})
		return
	}

	Convierte el timestamp Unix a un objeto time.Time
	t := time.Unix(timestampInt, 0)

	formattedTime := t.Format("2006-01-02")

	query := vc.Txn.
		Table("ViajaPlus.dbo.Itinerario").
		Select(`Servicio.ID,
				c_origen.Nombre as Origen,
				c_destino.Nombre as Destino,
				Servicio.Fecha_Partida,
				Servicio.Fecha_Llegada,
				Servicio.Costo_Servicio + t.Costo_Transporte as Costo,
				Itinerario.Distancia,
				t.Categoria as CategoriaTransporte,
				t.Tipo_Atencion as TipoAtencion,
				t.Pisos`).
		Joins("INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_origen ON ixc_origen.ID_Itinerario = Itinerario.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = ixc_origen.ID_Ciudad").
		Joins("INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_destino ON ixc_destino.ID_Itinerario = Itinerario.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = ixc_destino.ID_Ciudad").
		Joins("INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = Itinerario.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Servicio ON Servicio.ID = sxi.ID_Servicio").
		Joins("INNER JOIN ViajaPlus.dbo.Servicio_x_Transporte sxt ON sxt.ID_Servicio  = Servicio.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Transporte t ON t.ID = sxt.ID_Transporte").
		Where("ixc_origen.ID_Ciudad = ? AND ixc_origen.Es_Origen = 1", originCityID).
		Where("ixc_destino.ID_Ciudad = ? AND ixc_destino.Es_Origen = 0", destinationCityID).
		Where("Servicio.Disponibilidad = ?", 1).
		Where("CONVERT(date, Servicio.Fecha_Partida) = ?", formattedTime).
		Find(&opcionesI)

	if query.Error != nil && !errors.Is(query.Error, gorm.ErrRecordNotFound) {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	query = vc.Txn.
		Table("ViajaPlus.dbo.Tramo").
		Select(`Servicio.ID,
				c_origen.Nombre as Origen,
				c_destino.Nombre as Destino,
				Tramo.Fecha_Partida,
				Tramo.Fecha_Llegada,
				Tramo.Costo_Tramo + t.Costo_Transporte as Costo,
				Tramo.Distancia,
				t.Categoria as CategoriaTransporte,
				t.Tipo_Atencion as TipoAtencion,
				t.Pisos`).
		Joins("INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_origen ON txc_origen.ID_Tramo  = Tramo.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = txc_origen.ID_Ciudad").
		Joins("INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_destino ON txc_destino.ID_Tramo = Tramo.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = txc_destino.ID_Ciudad").
		Joins("INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Tramo = Tramo.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Itinerario i ON i.ID  = ixt.ID_Itinerario").
		Joins("INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Servicio ON Servicio.ID = sxi.ID_Servicio").
		Joins("INNER JOIN ViajaPlus.dbo.Servicio_x_Transporte sxt ON sxt.ID_Servicio  = Servicio.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Transporte t ON t.ID = sxt.ID_Transporte").
		Where("txc_origen.ID_Ciudad = ? AND txc_origen.Es_Origen = 1", originCityID).
		Where("txc_destino.ID_Ciudad = ? AND txc_destino.Es_Origen = 0", destinationCityID).
		Where("Servicio.Disponibilidad = ?", 1).
		Where("CONVERT(date, Tramo.Fecha_Partida) = ?", formattedTime).
		Find(&opcionesT)

	if query.Error != nil && !errors.Is(query.Error, gorm.ErrRecordNotFound) {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	opciones := append(opcionesI, opcionesT...)

	c.JSON(http.StatusOK, gin.H{
		"opciones": opciones})
}*/

func (vc *ViajeController) GetItinerariosYTramos(c *gin.Context) {
	//var opcionesI []opciones
	var opcionesT []opciones

	originCityID := c.Query("origin")
	if originCityID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid origin city 'ID' parameter"})
		return
	}

	destinationCityID := c.Query("destination")
	if destinationCityID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid destination city 'ID' parameter"})
		return
	}

	date := c.Query("date")

	// Intenta convertir el timestamp a un entero
	timestampInt, err := strconv.ParseInt(date, 10, 64)
	if err != nil {
		// Si hay un error, el timestamp no es válido
		c.JSON(http.StatusBadRequest, gin.H{"error": "Timestamp inválido"})
		return
	}

	// Convierte el timestamp Unix a un objeto time.Time
	t := time.Unix(timestampInt, 0)

	formattedTime := t.Format("2006-01-02")

	type ResultStep1 struct {
		ID_Itinerario string
		ID_Tramo      string
		Orden         int
	}

	var resultStep1 []ResultStep1

	//obtengo los tramos correspondientes a la ciudad origen y destino junto con su id de itinerario y su orden
	query := vc.Txn.Raw(`
		SELECT 
			Itinerario.ID AS ID_Itinerario,
			ixt.ID_Tramo AS ID_Tramo,
			ixt.Orden 
		FROM 
			"ViajaPlus"."dbo"."Itinerario" 
		INNER JOIN 
			ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID 
		INNER JOIN 
			ViajaPlus.dbo.Tramo_x_Ciudad txc ON txc.ID_Tramo = ixt.ID_Tramo  
		WHERE 
			(txc.ID_Ciudad = ? AND txc.Es_Origen = 1) 
		OR 
			(txc.ID_Ciudad = ? AND txc.Es_Origen = 0)`, originCityID, destinationCityID).
		Scan(&resultStep1)
	if query.Error != nil && !errors.Is(query.Error, gorm.ErrRecordNotFound) {
		c.JSON(http.StatusInternalServerError, gin.H{"error": query.Error.Error()})
		return
	}

	query = vc.Txn.
		Table("ViajaPlus.dbo.Itinerario i").
		Select(`Servicio.ID,
				c_origen.Nombre as Origen,
				c_destino.Nombre as Destino,
				t_origen.ID as IDTramoOrigen,
				t_destino.ID as IDTramoDestino,
				t_origen.Fecha_Partida,
				t_destino.Fecha_Llegada,
				(SELECT 
					SUM(t.Costo_Tramo) as Costo
				FROM 
					"ViajaPlus"."dbo"."Itinerario" 
				INNER JOIN 
					ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID
				INNER JOIN 
					ViajaPlus.dbo.Tramo t ON t.ID = ixt.ID_Tramo 
				WHERE 
					Itinerario.ID = ?
					AND ixt.Orden BETWEEN ? AND ?) + t.Costo_Transporte as Costo,
				(SELECT 
					SUM(t.Distancia) as Distancia
				FROM 
					"ViajaPlus"."dbo"."Itinerario" 
				INNER JOIN 
					ViajaPlus.dbo.Itinerario_x_Tramo ixt ON ixt.ID_Itinerario = Itinerario.ID
				INNER JOIN 
					ViajaPlus.dbo.Tramo t ON t.ID = ixt.ID_Tramo 
				WHERE 
					Itinerario.ID = ?
				AND ixt.Orden BETWEEN ? AND ?) as Distancia,
				t.ID as IDTransporte,
				t.Categoria as CategoriaTransporte,
				t.Tipo_Atencion as TipoAtencion,
				t.Pisos`,
			resultStep1[0].ID_Itinerario,
			resultStep1[0].Orden,
			resultStep1[1].Orden,
			resultStep1[0].ID_Itinerario,
			resultStep1[0].Orden,
			resultStep1[1].Orden).
		Joins("INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_origen ON ixt_origen.ID_Itinerario  = i.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Tramo t_origen ON t_origen.ID = ixt_origen.ID_Tramo").
		Joins("INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_origen ON txc_origen.ID_Tramo = t_origen.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = txc_origen.ID_Ciudad").
		Joins("INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_destino ON ixt_destino.ID_Itinerario = i.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Tramo t_destino ON t_destino.ID = ixt_destino.ID_Tramo").
		Joins("INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_destino ON txc_destino.ID_Tramo = t_destino.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = txc_destino.ID_Ciudad").
		Joins("INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Servicio ON Servicio.ID = sxi.ID_Servicio").
		// Joins("INNER JOIN ViajaPlus.dbo.Servicio_x_Transporte sxt ON sxt.ID_Servicio = Servicio.ID").
		Joins("INNER JOIN ViajaPlus.dbo.Transporte t ON t.ID = Servicio.ID_Transporte").
		Where("(t_origen.ID = ? and txc_origen.Es_Origen = 1)", resultStep1[0].ID_Tramo).
		Where("(t_destino.ID = ? and txc_destino.Es_Origen = 0)", resultStep1[1].ID_Tramo).
		Where("Servicio.Disponibilidad = 1").
		Where("CONVERT(date, t_origen.Fecha_Partida) = ?", formattedTime).
		Find(&opcionesT)

	if query.Error != nil && !errors.Is(query.Error, gorm.ErrRecordNotFound) {
		c.JSON(http.StatusInternalServerError, gin.H{"error": query.Error.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"opciones": opcionesT})
}

func (vc *ViajeController) GetAsientosSegunServicio(c *gin.Context) {

	serviceID := c.Param("sid")
	if serviceID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid service 'ID' parameter"})
		return
	}

	type Result struct {
		IDAsiento        int     `gorm:"column:IDAsiento"`
		Disponibilidad   bool    `gorm:"column:Disponibilidad"`
		Nro_Unidad       int     `gorm:"column:Nro_Unidad"`
		Pisos            int     `gorm:"column:Pisos"`
		Situacion        bool    `gorm:"column:Situacion"`
		Costo_Transporte float64 `gorm:"column:Costo_Transporte"`
		Categoria        string  `gorm:"column:Categoria"`
		Tipo_Atencion    string  `gorm:"column:Tipo_Atencion"`
	}

	var result []Result

	query := vc.Txn.Raw(`
	SELECT a.ID as IDAsiento, a.Disponibilidad,t.Nro_Unidad,t.Pisos,t.Situacion,t.Costo_Transporte,t.Categoria,t.Tipo_Atencion
	from ViajaPlus.dbo.Servicio s 
	INNER join ViajaPlus.dbo.Transporte t on t.ID = s.ID_Transporte 
	inner join ViajaPlus.dbo.Asiento a on a.ID_Transporte = t.ID 
	WHERE s.ID = ?`, serviceID).
		Scan(&result)
	if query.Error != nil && !errors.Is(query.Error, gorm.ErrRecordNotFound) {
		c.JSON(http.StatusInternalServerError, gin.H{"error": query.Error.Error()})
		return
	}

	//opciones := append(opcionesI, opcionesT...)

	c.JSON(http.StatusOK, gin.H{
		"asientos": result})
}

type Reserva struct {
	ID       int
	Nombre   string `gorm:"column:Nombre"`
	Apellido string `gorm:"column:Apellido"`
	DNI      int    `gorm:"column:DNI"`
}

func (Reserva) TableName() string {
	return "ViajaPlus.dbo.Reserva"
}

type ReservaXCiudad struct {
	Reserva   int    `gorm:"column:ID_Reserva"`
	ID_Ciudad int    `gorm:"column:ID_Ciudad"`
	Es_Origen string `gorm:"column:Es_Origen"`
}

func (ReservaXCiudad) TableName() string {
	return "ViajaPlus.dbo.Reserva_x_Ciudad"
}

type TramoXReserva struct {
	ID_Tramo   int `gorm:"column:ID_Tramo"`
	ID_Reserva int `gorm:"column:ID_Reserva"`
	Es_Origen  int `gorm:"column:Es_Origen"`
}

func (TramoXReserva) TableName() string {
	return "ViajaPlus.dbo.Tramo_x_Reserva"
}

func (vc *ViajeController) CreateReserva(c *gin.Context) {

	type RequestBody struct {
		Nombre         string  `json:"nombre"`
		Apellido       string  `json:"apellido"`
		DNI            string  `json:"dni"`
		IDServicio     uint    `json:"service"`
		IDTransporte   uint    `json:"transporte"`
		IDAsiento      uint    `json:"asiento"`
		Origen         int     `json:"origen"`
		Destino        int     `json:"destino"`
		IDTramoOrigen  int     `json:"IDTramoOrigen"`
		IDTramoDestino int     `json:"IDTramoDestino"`
		Costo          float64 `json:"Costo"`
	}

	var requestBody RequestBody

	err := c.BindJSON(&requestBody)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	type Result struct {
		ID uint
	}

	var result Result
	// queryStr := "INSERT INTO Reserva (Nombre, Apellido, DNI) OUTPUT Inserted.ID VALUES (?, ?, ?)"
	queryStr := `INSERT INTO ViajaPlus.dbo.Reserva
	( Nombre, Apellido, DNI, Estado, Costo, ID_Asiento, ID_Transporte) OUTPUT Inserted.ID
	VALUES( ?, ?, ?, ?, ?, ?, ?);`
	err = vc.Txn.Raw(queryStr, requestBody.Nombre,
		requestBody.Apellido,
		requestBody.DNI,
		"Pendiente",
		requestBody.Costo,
		requestBody.IDAsiento,
		requestBody.IDTransporte).
		Scan(&result).Error
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	queryStr = "INSERT INTO ViajaPlus.dbo.Reserva_x_Ciudad (ID_Reserva, ID_Ciudad, Es_Origen) VALUES (?, ?, ?)"
	err = vc.Txn.Exec(queryStr, result.ID, requestBody.Origen, "1").Error
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Insertar en ReservaXCiudad para Destino
	queryStr = "INSERT INTO ViajaPlus.dbo.Reserva_x_Ciudad (ID_Reserva, ID_Ciudad, Es_Origen) VALUES (?, ?, ?)"
	err = vc.Txn.Exec(queryStr, result.ID, requestBody.Destino, "0").Error
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Insertar en TramoXReserva para Origen
	queryStr = "INSERT INTO ViajaPlus.dbo.Tramo_x_Reserva (ID_Tramo, ID_Reserva, Es_Origen) VALUES (?, ?, ?)"
	err = vc.Txn.Exec(queryStr, requestBody.IDTramoOrigen, result.ID, 1).Error
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Insertar en TramoXReserva para Destino
	queryStr = "INSERT INTO ViajaPlus.dbo.Tramo_x_Reserva (ID_Tramo, ID_Reserva, Es_Origen) VALUES (?, ?, ?)"
	err = vc.Txn.Exec(queryStr, requestBody.IDTramoDestino, result.ID, 0).Error
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	//el paso que sigue despues de hacer la reserva es cambiar a le estado de las cosas que reservas a no disponible,
	//algunas de las cosas pueden ser asientos, y en base a eso revisar si todos los asientos de un transporte de un viaje estan ocupados
	//con la nueva reserva/

	// cambiar la disponibilidad del asiento
	queryStr = "UPDATE ViajaPlus.dbo.Asiento SET Disponibilidad=0 WHERE ID=? AND ID_Transporte=?"
	err = vc.Txn.Exec(queryStr, requestBody.IDAsiento, requestBody.IDTransporte).Error
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var countResult int64

	query := vc.Txn.Table("ViajaPlus.dbo.Asiento").
		Where("ID_Transporte=? AND Disponibilidad=1", requestBody.IDTransporte).
		Count(&countResult)
	if query.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if countResult == 0 {
		// cambiar la disponibilidad del transporte
		queryStr = "UPDATE ViajaPlus.dbo.Transporte SET Situacion=0 WHERE ID_Transporte=?"
		err = vc.Txn.Exec(queryStr, requestBody.IDTransporte).Error
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		// cambiar la disponibilidad del servicio
		queryStr = "UPDATE ViajaPlus.dbo.Servicio SET Disponibilidad=0 WHERE ID_Transporte=?"
		err = vc.Txn.Exec(queryStr, requestBody.IDTransporte).Error
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"reserva": result.ID})
}
