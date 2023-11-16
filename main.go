package main

import (
	"log"
	"time"

	"github.com/gin-gonic/gin" // Asegúrate de que esta ruta de importación es correcta
	"github.com/jeremiascardoso00/DABD-COLOQUIO/controllers"
	"gorm.io/driver/sqlserver"
	"gorm.io/gorm"
)

func main() {

	var db *gorm.DB
	var err error

	dsn := "sqlserver://sa:Password1@sql-server-db:1433?database=ViajaPlus"

	// Try to connect to the database every second until the connection is successful
	for i := 0; i < 30; i++ {
		db, err = gorm.Open(sqlserver.Open(dsn), &gorm.Config{})
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

	r.GET("/administradores", ac.GetAdministradores) // new

	r.Run()
	// Rest of your code...

}
