package main

import (
	"log"

	"github.com/fredporter/uDOS-shell/internal/app"
)

func main() {
	if err := app.Run(); err != nil {
		log.Fatal(err)
	}
}
