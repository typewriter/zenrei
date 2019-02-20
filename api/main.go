package main

import (
	"strings"
	"net/http"
	"github.com/labstack/echo"
	"github.com/globalsign/mgo"
	"github.com/globalsign/mgo/bson"
)

type Name struct {
	Repository string `bson:"repository"`
	Filename   string `bson:"filename"`
	Type       int    `bson:"type"`
	Name       string `bson:"name"`
}

var collection *mgo.Collection

func main() {
	echo := echo.New()

	session, _ := mgo.Dial("mongo")
	collection  = session.DB("zenrei").C("names")

	echo.GET("/search", search)

	echo.Logger.Fatal(echo.Start(":8080"))
}

func search(c echo.Context) error {
	q := strings.Split(c.QueryParam("q"), ",")

	results := make(map[string][]Name)
	for _, value := range q {
		var items []Name
		_ = collection.Find(
			bson.M{ "$and": []bson.M {
				bson.M{"name": value},
				bson.M{"filename": bson.M{"$not": bson.RegEx{"test/|spec/", ""}}},
			}}).
			Limit(1000).All(&items)
		results[value] = items
	}

	return c.JSON(http.StatusOK, results)
}

