package main

import (
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

func main() {
  e := echo.New()
  e.GET("/", func(c echo.Context) error {
    session, _ := mgo.Dial("mongo")
    collection := session.DB("zenrei").C("names")

    var items []Name
    //_ = collection.Find(nil).Limit(10000).All(&items)
    //_ = collection.Find(bson.M{"repository":"ruby/ruby"}).Limit(100).All(&items)
    _ = collection.Find(bson.M{"name":"hoge"}).Limit(100).All(&items)
    return c.JSON(http.StatusOK, items)
  })
  e.Logger.Fatal(e.Start(":8080"))
}

