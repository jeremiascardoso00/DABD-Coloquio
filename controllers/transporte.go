package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jeremiascardoso00/DABD-COLOQUIO/models"
	"gorm.io/gorm"
)

type TransporteController struct {
	Txn *gorm.DB
}

func (tc *TransporteController) GetTransportes(c *gin.Context) {
	var transporte models.Transporte

	query := tc.Txn.Find(&transporte)
	if query.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": transporte})
}

func (tc *TransporteController) GetTransporteByID(c *gin.Context) {
	transporteID := c.Param("id")
	var transporte models.Transporte

	query := tc.Txn.First(&transporte, transporteID)
	if query.Error != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Transporte not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": transporte})
}

func (tc *TransporteController) DeleteTransporteByID(c *gin.Context) {
	transporteID := c.Param("id")
	var transporte models.Transporte

	query := tc.Txn.First(&transporte, transporteID)
	if query.Error != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Transporte not found"})
		return
	}

	// Eliminar el Transporte
	tc.Txn.Delete(&transporte)

	c.JSON(http.StatusOK, gin.H{"message": "Transporte deleted successfully"})
}

func (tc *TransporteController) UpdateTransporteByID(c *gin.Context) {
	transporteID := c.Param("id")
	var transporte models.Transporte

	// Verificar si el Transporte existe
	if err := tc.Txn.First(&transporte, transporteID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Transporte not found"})
		return
	}

	// Actualizar el Transporte con los nuevos datos (puedes ajustar esto según tus necesidades)
	if err := c.ShouldBindJSON(&transporte); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Guardar la actualización en la base de datos
	if err := tc.Txn.Save(&transporte).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update transporte"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": transporte})
}
