package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jeremiascardoso00/DABD-COLOQUIO/models"
	"gorm.io/gorm"
)

type AdministradorController struct {
	Txn *gorm.DB
}

func (ac *AdministradorController) GetAdministradores(c *gin.Context) {
	var admServicios models.AdministradorServicios

	query := ac.Txn.Find(&admServicios)
	if query.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": admServicios})
}
