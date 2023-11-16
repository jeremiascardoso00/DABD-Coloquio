package main

import (
	"fmt"
	"log"
	"time"

	"gorm.io/driver/sqlserver"
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

type CategoriaTransporte struct {
	ID           int `gorm:"primaryKey"`
	IDTransporte int
	Categoria    string
	Transporte   Transporte `gorm:"foreignKey:IDTransporte"`
}

type TipoAtencionTransporte struct {
	ID           int `gorm:"primaryKey"`
	IDTransporte int
	Tipo         string
	Transporte   Transporte `gorm:"foreignKey:IDTransporte"`
}

type Tramo struct {
	gorm.Model
	Distancia   int
	HoraPartida time.Time
	HoraLlegada time.Time
	CostoTramo  float64
}

type Itinerario struct {
	gorm.Model
	Distancia     int
	CiudadPartida string
	CiudadLlegada string
}

type Ciudad struct {
	gorm.Model
	Nombre string
}

type Pasaje struct {
	gorm.Model
	IDServicio int
	Costo      float64
	Servicio   Servicio `gorm:"foreignKey:IDServicio"`
}

type Reserva struct {
	gorm.Model
	Nombre   string
	Apellido string
	DNI      int
}

type EstadoReserva struct {
	ID        int `gorm:"primaryKey"`
	IDReserva int
	Estado    string
	Reserva   Reserva `gorm:"foreignKey:IDReserva"`
}

type ServicioItinerario struct {
	IDServicio   int        `gorm:"primaryKey"`
	IDItinerario int        `gorm:"primaryKey"`
	Servicio     Servicio   `gorm:"foreignKey:IDServicio"`
	Itinerario   Itinerario `gorm:"foreignKey:IDItinerario"`
}

type ItinerarioTramo struct {
	IDTramo      int        `gorm:"primaryKey"`
	IDItinerario int        `gorm:"primaryKey"`
	Tramo        Tramo      `gorm:"foreignKey:IDTramo"`
	Itinerario   Itinerario `gorm:"foreignKey:IDItinerario"`
}

type ServicioTransporte struct {
	IDServicio   int        `gorm:"primaryKey"`
	IDTransporte int        `gorm:"primaryKey"`
	Servicio     Servicio   `gorm:"foreignKey:IDServicio"`
	Transporte   Transporte `gorm:"foreignKey:IDTransporte"`
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

type AdministradorTransporte struct {
	IDAdministrador int                    `gorm:"primaryKey"`
	IDTransporte    int                    `gorm:"primaryKey"`
	Administrador   AdministradorServicios `gorm:"foreignKey:IDAdministrador"`
	Transporte      Transporte             `gorm:"foreignKey:IDTransporte"`
}

type AdministradorServicio struct {
	IDAdministrador int                    `gorm:"primaryKey"`
	IDServicio      int                    `gorm:"primaryKey"`
	Administrador   AdministradorServicios `gorm:"foreignKey:IDAdministrador"`
	Servicio        Servicio               `gorm:"foreignKey:IDServicio"`
}

type AdministradorItinerario struct {
	IDAdministrador int                    `gorm:"primaryKey"`
	IDItinerario    int                    `gorm:"primaryKey"`
	Administrador   AdministradorServicios `gorm:"foreignKey:IDAdministrador"`
	Itinerario      Itinerario             `gorm:"foreignKey:IDItinerario"`
}

type AdministradorTramo struct {
	IDAdministrador int                    `gorm:"primaryKey"`
	IDTramo         int                    `gorm:"primaryKey"`
	Administrador   AdministradorServicios `gorm:"foreignKey:IDAdministrador"`
	Tramo           Tramo                  `gorm:"foreignKey:IDTramo"`
}

type AdministradorCiudad struct {
	IDAdministrador int                    `gorm:"primaryKey"`
	IDCiudad        int                    `gorm:"primaryKey"`
	Administrador   AdministradorServicios `gorm:"foreignKey:IDAdministrador"`
	Ciudad          Ciudad                 `gorm:"foreignKey:IDCiudad"`
}

func main() {

	// Set up the connection string
	server := "sql-server-db"
	port := 1433
	user := "sa"
	password := "Password1"
	database := "ViajaPlus"
	connectionString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s", server, user, password, port, database)

	var db *gorm.DB
	var err error

	// Try to connect to the database every second until the connection is successful
	for i := 0; i < 30; i++ {
		db, err = gorm.Open(sqlserver.Open(connectionString), &gorm.Config{})
		if err == nil {
			sqlDB, err := db.DB()
			if err == nil {
				err = sqlDB.Ping()
				if err == nil {
					break
				}
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

	// Migraciones
	// err = db.AutoMigrate(
	// 	&AdministradorServicios{},
	// 	&Servicio{},
	// 	&CalidadServicio{},
	// 	&Transporte{},
	// 	&Asiento{},
	// 	&Tramo{},
	// 	&Ciudad{},
	// 	&Reserva{},
	// 	&Itinerario{},
	// 	&Pasaje{},
	// 	&CategoriaTransporte{},
	// 	&TipoAtencionTransporte{},
	// 	&EstadoReserva{},
	// 	&ServicioItinerario{},
	// 	&ItinerarioTramo{},
	// 	&ServicioTransporte{},
	// 	&TramoCiudad{},
	// 	&ReservaCiudad{},
	// 	&AdministradorTransporte{},
	// 	&AdministradorItinerario{},
	// 	&AdministradorTramo{},
	// 	&AdministradorCiudad{},
	// 	&AdministradorServicio{},
	// )

	// if err != nil {
	// 	log.Fatalf("error in migration: %v", err)
	// }

}
