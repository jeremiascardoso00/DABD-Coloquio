package main

import (
	"log"
	"time"

	"github.com/gin-gonic/gin" // Asegúrate de que esta ruta de importación es correcta
	"github.com/jeremiascardoso00/DABD-COLOQUIO/controllers"
	"gorm.io/driver/sqlserver"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func main() {

	var db *gorm.DB
	var err error

	dsn := "sqlserver://sa:Password1@sql-server-db:1433?database=ViajaPlus"

	for i := 0; i < 30; i++ {
		db, err = gorm.Open(sqlserver.Open(dsn), &gorm.Config{
			Logger: logger.Default.LogMode(logger.Info),
		})
		if err == nil {
			sqlDB, err := db.DB()
			if err == nil {
				err = sqlDB.Ping()
				if err == nil {
					log.Println("successfull ping to database")
					break
				}
			}
		}
		log.Println("Could not connect to database, waiting 1 second before retrying")
		time.Sleep(time.Second)
	}

	log.Println("Connected to database")

	r := gin.Default()

	// Crea una instancia de AdministradorController
	ac := &controllers.AdministradorController{Txn: db}
	tc := &controllers.TransporteController{Txn: db}
	cc := &controllers.CiudadController{Txn: db}

	r.GET("/administradores", ac.GetAdministradores)
	r.GET("/transportes", tc.GetTransportes)

	//ciudad
	r.GET("/ciudad/:name", cc.GetCiudades)

	r.Run(":3000")
	// Rest of your code...

}

// docker-compose up -d --no-deps --build dabdcoloquio
