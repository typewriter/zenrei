package main

import (
	"database/sql"
	"strings"
	"regexp"
	"net/http"
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
	"github.com/globalsign/mgo"
	"github.com/globalsign/mgo/bson"
	"github.com/aaaton/golem"
	"github.com/aaaton/golem/dicts/en"
	_ "github.com/mattn/go-sqlite3"
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

type Synonym struct {
	Synset string
  Lang   string
	Name   string
}

var collection *mgo.Collection
var countCollection *mgo.Collection

var wordnet *sql.DB
var lemmatizer *golem.Lemmatizer

func main() {
	echo := echo.New()
	echo.Use(middleware.CORS())

	session, _ := mgo.Dial("mongo")
	collection       = session.DB("zenrei").C("names")
	countCollection  = session.DB("zenrei").C("counters")

	wordnet, _ = sql.Open("sqlite3", "./wnjpn.db")
	lemmatizer, _ = golem.New(en.New())

	echo.GET("/v1/search", search)
	echo.GET("/v1/suggest", suggest)
	echo.GET("/v1/counter", counter)
	echo.GET("/v1/synonym", synonym)

	echo.Logger.Fatal(echo.Start(":8080"))
}

func suggest(c echo.Context) error {
  q := c.QueryParam("q")

	var results []Suggest
	_ = countCollection.Find(
		bson.M{ "$and": []bson.M {
			bson.M{"name": bson.RegEx{"^" + regexp.QuoteMeta(q), "i"}},
			bson.M{"type": nil},
		}},
	).Sort("-count").Limit(50).All(&results)

	return c.JSON(http.StatusOK, results)
}

func counter(c echo.Context) error {
  q := strings.Split(c.QueryParam("q"), ",")

	var results []Suggest
	_ = countCollection.Find(
		bson.M{ "$and": []bson.M {
			bson.M{"name": bson.M{"$in": q}},
			bson.M{"type": nil},
		}},
	).All(&results)

	return c.JSON(http.StatusOK, results)
}

func search(c echo.Context) error {
	q := strings.Split(c.QueryParam("q"), ",")

	results := make(map[string][]Name)
	for _, value := range q {
		var items []Name
		_ = collection.Find(
			bson.M{ "$and": []bson.M {
				bson.M{"name": bson.RegEx{"^" + regexp.QuoteMeta(value), ""}},
				bson.M{"filename": bson.M{"$not": bson.RegEx{"test/|spec/", ""}}},
			}}).
			Limit(101).All(&items)
		results[value] = items
	}

	return c.JSON(http.StatusOK, results)
}

func synonym(c echo.Context) error {
  q := c.QueryParam("q")
	lemma := lemmatizer.Lemma(q)

	rows, _ := wordnet.Query("select s2.synset, w2.lang, w2.lemma from word inner join sense on sense.wordid = word.wordid inner join sense s2 on s2.synset = sense.synset inner join word w2 on w2.wordid = s2.wordid where word.lemma = ?", lemma)
	// rows, _ := wordnet.Query("select synset.synset from word inner join sense on sense.wordid = word.wordid inner join synset on synset.synset = sense.synset where lemma = ?", q)
	defer rows.Close()
	var synsets []Synonym
	for rows.Next() {
		var s Synonym
		rows.Scan(&s.Synset, &s.Lang, &s.Name)
		synsets = append(synsets, s)
  }
	return c.JSON(http.StatusOK, synsets)
}

