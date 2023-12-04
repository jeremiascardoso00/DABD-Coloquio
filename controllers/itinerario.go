package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jeremiascardoso00/DABD-COLOQUIO/models"
	"gorm.io/gorm"
)

type ItinerarioController struct {
	Txn *gorm.DB
}

func (tc *ItinerarioController) GetItinerarios(c *gin.Context) {
	var itinerario models.Itinerario

	query := tc.Txn.Find(&itinerario)
	if query.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": itinerario})

}

func (tc *ItinerarioController) GetItinerarioByID(c *gin.Context) {
	itinerarioID := c.Param("id")
	var itinerario models.Itinerario

	query := tc.Txn.First(&itinerario, itinerarioID)
	if query.Error != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Itinerario not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": itinerario})
}

func (tc *ItinerarioController) DeleteItinerarioByID(c *gin.Context) {
	itinerarioID := c.Param("id")
	var itinerario models.Itinerario

	query := tc.Txn.First(&itinerario, itinerarioID)
	if query.Error != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Itinerario not found"})
		return
	}

	// Eliminar el itinerario
	tc.Txn.Delete(&itinerario)

	c.JSON(http.StatusOK, gin.H{"message": "Itinerario deleted successfully"})
}

func (tc *ItinerarioController) UpdateItinerarioByID(c *gin.Context) {
	itinerarioID := c.Param("id")
	var itinerario models.Itinerario

	// Verificar si el itinerario existe
	if err := tc.Txn.First(&itinerario, itinerarioID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Itinerario not found!"})
		return
	}

	// Actualizar el itinerario con los nuevos datos (puedes ajustar esto según tus necesidades)
	if err := c.ShouldBindJSON(&itinerario); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Guardar la actualización en la base de datos
	if err := tc.Txn.Save(&itinerario).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update Itinerario"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": itinerario})
}
