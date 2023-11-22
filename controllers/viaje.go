package controllers

import (
	"errors"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/jeremiascardoso00/DABD-COLOQUIO/models"
	"gorm.io/gorm"
)

type ViajeController struct {
	Txn *gorm.DB
}

func (vc *ViajeController) GetItinerariosYTramos(c *gin.Context) {
	var servicios []models.Servicio

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
		Table("Itinerario").
		Select("Servicio.*").
		Joins("INNER JOIN Itinerario_x_Ciudad ixc_origen ON ixc_origen.ID_Itinerario = Itinerario.ID").
		Joins("INNER JOIN Itinerario_x_Ciudad ixc_destino ON ixc_destino.ID_Itinerario = Itinerario.ID").
		Joins("INNER JOIN Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = Itinerario.ID").
		Joins("RIGHT JOIN Servicio ON Servicio.ID = sxi.ID_Servicio").
		Where("ixc_origen.ID_Ciudad = ? AND ixc_origen.Es_Origen = 1", originCityID).
		Where("ixc_destino.ID_Ciudad = ? AND ixc_destino.Es_Origen = 0", destinationCityID).
		Where("Servicio.Disponibilidad = ?", 1).
		Where("CONVERT(date, Servicio.Fecha_Partida) = ?", formattedTime).
		Find(&servicios)

	if errors.Is(query.Error, gorm.ErrRecordNotFound) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}
	if query.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Unexpected error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"itinerarios": servicios,
		"tramos":      ""})
}
