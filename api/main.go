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

type Suggest struct {
	Name       string `bson:"name"`
	Type       int    `bson:"type"`
	Count      int    `bson:"count"`
}

var collection *mgo.Collection
var countCollection *mgo.Collection

func main() {
	echo := echo.New()

	session, _ := mgo.Dial("mongo")
	collection       = session.DB("zenrei").C("names")
	countCollection  = session.DB("zenrei").C("counters")

	echo.GET("/search", search)
	echo.GET("/suggest", suggest)

	echo.Logger.Fatal(echo.Start(":8080"))
}

func suggest(c echo.Context) error {
  q := c.QueryParam("q")

	var results []Suggest
	_ = countCollection.Find(
		bson.M{ "$and": []bson.M {
			bson.M{"name": bson.RegEx{"^" + q, "i"}},
			bson.M{"type": nil},
		}},
	).Sort("-count").Limit(100).All(&results)

	return c.JSON(http.StatusOK, results)
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

