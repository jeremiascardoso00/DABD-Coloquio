package controllers

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jeremiascardoso00/DABD-COLOQUIO/models"
	"gorm.io/gorm"
)

type CiudadController struct {
	Txn *gorm.DB
}

func (cc *CiudadController) GetCiudades(c *gin.Context) {
	var ciudades []models.Ciudad

	cityName := c.Param("name")
	if cityName == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid city 'name' parameter"})
		return
	}

	query := cc.Txn.Where("Nombre LIKE ?", "%"+cityName+"%").
		Find(&ciudades)

	if errors.Is(query.Error, gorm.ErrRecordNotFound) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}
	if query.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Unexpected error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": ciudades})
}
