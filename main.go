package main

import (
	"database/sql"
	"fmt"
	"log"
	"time"

	"gorm.io/gorm"
)

type AdministradorServicios struct {
	gorm.Model
	DNI        int
	Email      string
	Contrasena string
}

type Servicio struct {
	gorm.Model
	Disponibilidad bool
	FechaPartida   time.Time
	FechaLlegada   time.Time
	CostoServicio  float64
}

type CalidadServicio struct {
	ID         int `gorm:"primaryKey"`
	IDServicio int
	Calidad    string
	Servicio   Servicio `gorm:"foreignKey:IDServicio"`
}

type Transporte struct {
	gorm.Model
	NroUnidad       int
	Pisos           int
	Situacion       bool
	CostoTransporte float64
}

type Asiento struct {
	ID             int `gorm:"primaryKey"`
	IDTransporte   int
	Disponibilidad bool
	Transporte     Transporte `gorm:"foreignKey:IDTransporte"`
}

type ServicioTransporte struct {
	IDServicio   int        `gorm:"primaryKey"`
	IDTransporte int        `gorm:"primaryKey"`
	Servicio     Servicio   `gorm:"foreignKey:IDServicio"`
	Transporte   Transporte `gorm:"foreignKey:IDTransporte"`
}
type Tramo struct {
	gorm.Model
	Distancia   int
	HoraPartida time.Time
	HoraLlegada time.Time
	CostoTramo  float64
}

type Ciudad struct {
	gorm.Model
	Nombre string
}

type Reserva struct {
	gorm.Model
}

type TramoCiudad struct {
	IDTramo  int    `gorm:"primaryKey"`
	IDCiudad int    `gorm:"primaryKey"`
	Tramo    Tramo  `gorm:"foreignKey:IDTramo"`
	Ciudad   Ciudad `gorm:"foreignKey:IDCiudad"`
}

type ReservaCiudad struct {
	IDReserva int `gorm:"primaryKey"`
	IDCiudad  int `gorm:"primaryKey"`
	EsOrigen  bool
	Reserva   Reserva `gorm:"foreignKey:IDReserva"`
	Ciudad    Ciudad  `gorm:"foreignKey:IDCiudad"`
}

func main() {

	// Set up the connection string
	server := "sql-server-db"
	port := 1433
	user := "sa"
	password := "Password1"
	database := "master"
	connectionString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s", server, user, password, port, database)

	var db *sql.DB
	var err error

	// Try to connect to the database every second until the connection is successful
	for i := 0; i < 30; i++ {
		db, err = sql.Open("mssql", connectionString)
		if err == nil {
			err = db.Ping()
			if err == nil {
				break
			}
		}
		log.Println("Could not connect to database, waiting 1 second before retrying")
		time.Sleep(time.Second)
	}

	if err != nil {
		log.Fatalf("Could not connect to database: %v", err)
	}

	log.Println("Connected to database")

	// Rest of your code...

}
