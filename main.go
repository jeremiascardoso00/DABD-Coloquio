package main

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"gorm.io/driver/sqlserver"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	Name  string
	Email string
}

func main() {

	// Set up the connection string
	server := "localhost"
	port := 1433
	user := "sa"
	password := "super_password"
	database := "master"
	connectionString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s", server, user, password, port, database)

	db, err := gorm.Open(sqlserver.Open(connectionString), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}

	// Migrate the schema
	db.AutoMigrate(&User{})

	// Create a new Gin router
	r := gin.Default()

	// Define the routes
	r.GET("/users", func(c *gin.Context) {
		var users []User
		db.Find(&users)
		c.JSON(200, users)
	})

	r.POST("/users", func(c *gin.Context) {
		var user User
		c.BindJSON(&user)
		db.Create(&user)
		c.JSON(200, user)
	})

	r.GET("/users/:id", func(c *gin.Context) {
		var user User
		db.First(&user, c.Param("id"))
		c.JSON(200, user)
	})

	r.PUT("/users/:id", func(c *gin.Context) {
		var user User
		db.First(&user, c.Param("id"))
		c.BindJSON(&user)
		db.Save(&user)
		c.JSON(200, user)
	})

	r.DELETE("/users/:id", func(c *gin.Context) {
		var user User
		db.Delete(&user, c.Param("id"))
		c.JSON(200, gin.H{"message": "User deleted"})
	})

	// Run the server
	r.Run(":8080")
}
