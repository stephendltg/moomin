package main

import (
	"flag"
	"fmt"
	"io"
	"net"
	"os"
	"strings"

	nocache "github.com/alexander-melentyev/gin-nocache"
	helmet "github.com/danielkov/gin-helmet"
	static "github.com/gin-contrib/static"
	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	log "github.com/sirupsen/logrus"
)

// Constants
const VERSION = "0.0.4"

// Vars cli
var (
	port  = flag.String("p", "5000", "Port http server")
	debug = flag.Bool("debug", false, "Mode debug")
	cache = flag.Bool("cache", false, "Mode cache")
	dir   = flag.String("d", "./public", "Dir site web")
)

// Init
func init() {

	// Datetime format logger
	customFormatter := new(logrus.TextFormatter)
	customFormatter.TimestampFormat = "2006-01-02T15:04:05.000Z"
	logrus.SetFormatter(&log.JSONFormatter{})
	logrus.SetFormatter(customFormatter)
	customFormatter.FullTimestamp = true

	// Parse cli
	flag.Parse()

	// Debug mode
	if !*debug {
		log.SetLevel(log.WarnLevel)
	}

}

// function to get the public ip address
func GetOutboundIP() (string, error) {
	conn, err := net.Dial("udp", "8.8.8.8:80")
	if err != nil {
		return "127.0.0.1", err
	}
	defer conn.Close()
	localAddr := conn.LocalAddr().String()
	idx := strings.LastIndex(localAddr, ":")
	return localAddr[0:idx], nil
}

func main() {

	ip, err := GetOutboundIP()
	if err != nil {
		fmt.Printf("⚠ %s\n", err)
	}
	fmt.Printf("✔ Moomin start .... http://%s:%s\n", ip, *port)

	// debugger
	debugger := log.WithFields(log.Fields{"package": "MOOMIN"})
	debugger.Info("✔ Connecting ... ", *dir)

	// Debug mode
	if !*debug {
		gin.DisableConsoleColor()

		// Logging to a file.
		f, _ := os.Create("moomin.log")
		gin.DefaultWriter = io.MultiWriter(f)
	}

	// Gin instance
	r := gin.Default()

	// Security middleware
	r.Use(helmet.Default())

	// Cache enable/disable
	if !*cache {
		r.Use(nocache.NoCache())
		fmt.Println("ℹ No cache ....")
	}

	// Route: Ping
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
			"version": VERSION,
		})
	})

	// Static server
	r.Use(static.Serve("/", static.LocalFile(*dir, true)))

	r.Run(":" + *port)
}
