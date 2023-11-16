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

	query := tc.Txn.First(&transporte)
	if query.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": transporte})
}
