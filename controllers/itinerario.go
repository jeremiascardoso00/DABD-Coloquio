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

	type ResultadoParteUno struct {
		IDItinerario   int    `gorm:"column:ID_Itinerario"`
		IDTramoOrigen  int    `gorm:"column:ID_Tramo_Origen"`
		IDTramoDestino int    `gorm:"column:ID_Tramo_Destino"`
		NombreOrigen   string `gorm:"column:NombreCiudadOrigen"`
		NombreDestino  string `gorm:"column:NombreCiudadDestino"`
	}

	var resultadoParteUno ResultadoParteUno
	consulta := `
			SELECT 
				i.ID AS ID_Itinerario,
				ixt_origen.ID_Tramo AS ID_Tramo_Origen,
				ixt_destino.ID_Tramo AS ID_Tramo_Destino,
				c_origen.Nombre as NombreCiudadOrigen,
				c_destino.Nombre as NombreCiudadDestino
			FROM ViajaPlus.dbo.Itinerario i

			INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_origen 
			ON ixc_origen.ID_Itinerario = i.ID AND ixc_origen.Es_Origen = 1
			INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = ixc_origen.ID_Ciudad 

			INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_origen 
			ON ixt_origen.ID_Itinerario = i.ID
			INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_origen 
			ON txc_origen.ID_Tramo = ixt_origen.ID_Tramo AND txc_origen.Es_Origen = 1 

			INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_destino 
			ON ixc_destino.ID_Itinerario = i.ID AND ixc_destino.Es_Origen = 0
			INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = ixc_destino.ID_Ciudad 

			INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_destino 
			ON ixt_destino.ID_Itinerario = i.ID
			INNER JOIN ViajaPlus.dbo.Tramo_x_Ciudad txc_destino 
			ON txc_destino.ID_Tramo = ixt_destino.ID_Tramo AND txc_destino.Es_Origen = 0
						
			WHERE txc_origen.ID_Ciudad = c_origen.ID 
			AND txc_destino.ID_Ciudad = c_destino.ID
			`
	query := tc.Txn.
		Raw(consulta).
		Scan(&resultadoParteUno)
	if query.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}

	type Resultado struct {
		IDItinerario    int     `gorm:"column:IDItinerario"`
		Distancia       int     `gorm:"column:Distancia"`
		IDServicio      int     `gorm:"column:IDServicio"`
		Disponibilidad  bool    `gorm:"column:Disponibilidad"`
		FechaPartida    string  `gorm:"column:Fecha_Partida"`
		FechaLlegada    string  `gorm:"column:Fecha_Llegada"`
		IDTramoOrigen   string  `gorm:"column:IDTramoOrigen"`
		IDTramoDestino  string  `gorm:"column:IDTramoDestino"`
		NombreOrigen    string  `gorm:"column:NombreCiudadOrigen"`
		NombreDestino   string  `gorm:"column:NombreCiudadDestino"`
		CostoServicio   float64 `gorm:"column:Costo_Servicio"`
		IDTransporte    int     `gorm:"column:ID_Transporte"`
		CalidadServicio string  `gorm:"column:Calidad_Servicio"`
	}

	var itinerario []Resultado
	consulta = `
	SELECT
		i.ID as IDItinerario,
		i.Distancia,      
		s.ID as IDServicio,             
		s.Disponibilidad, 
		s.Fecha_Partida, 
		s.Fecha_Llegada,  
		ixt_origen.ID_Tramo as IDTramoOrigen,
		ixt_destino.ID_Tramo as IDTramoDestino,
		c_origen.Nombre as NombreCiudadOrigen,
		c_destino.Nombre as NombreCiudadDestino,
		s.Costo_Servicio,
		s.ID_Transporte, 
		s.Calidad_Servicio  
	FROM ViajaPlus.dbo.Itinerario i
	INNER JOIN ViajaPlus.dbo.Servicio_x_Itinerario sxi ON sxi.ID_Itinerario = i.ID 
	INNER JOIN ViajaPlus.dbo.Servicio s  ON s.ID  = sxi.ID_Servicio
	INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_origen 
	ON ixt_origen.ID_Itinerario = i.ID and ixt_origen.ID_Tramo = ?
	INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_origen 
	ON ixc_origen.ID_Itinerario = i.ID AND ixc_origen.Es_Origen = 1
	INNER JOIN ViajaPlus.dbo.Ciudad c_origen ON c_origen.ID = ixc_origen.ID_Ciudad 
	INNER JOIN ViajaPlus.dbo.Itinerario_x_Tramo ixt_destino 
	ON ixt_destino.ID_Itinerario = i.ID and ixt_destino.ID_Tramo = ?
	INNER JOIN ViajaPlus.dbo.Itinerario_x_Ciudad ixc_destino 
	ON ixc_destino.ID_Itinerario = i.ID AND ixc_destino.Es_Origen = 0
	INNER JOIN ViajaPlus.dbo.Ciudad c_destino ON c_destino.ID = ixc_destino.ID_Ciudad  
	WHERE i.deleted_at is null
	`
	query = tc.Txn.
		Raw(consulta, resultadoParteUno.IDTramoOrigen, resultadoParteUno.IDTramoDestino).
		Scan(&itinerario)
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

	c.JSON(http.StatusOK, gin.H{"itinerario": itinerario.ID})
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
