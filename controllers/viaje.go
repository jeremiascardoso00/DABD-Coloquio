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
	FechaPartida        time.Time `gorm:"column:Fecha_Partida; not null"`
	FechaLlegada        time.Time `gorm:"column:Fecha_Llegada; not null"`
	Costo               float64   `gorm:"column:Costo; not null"`
	Distancia           int       `gorm:"column:Distancia; not null"`
	CategoriaTransporte string    `gorm:"column:CategoriaTransporte"`
	TipoAtencion        string    `gorm:"column:TipoAtencion"`
	Pisos               string    `gorm:"column:Pisos"`
}

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
}
