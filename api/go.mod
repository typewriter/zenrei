module github.com/typewriter/zenrei/api

go 1.14

replace (
  github.com/aaaton/golem => ./golem/
)

require (
	github.com/aaaton/golem v0.0.0-20191129093449-a9f1a1b6b185
	github.com/dgrijalva/jwt-go v3.2.0+incompatible // indirect
	github.com/globalsign/mgo v0.0.0-20181015135952-eeefdecb41b8
	github.com/labstack/echo v3.3.10+incompatible
	github.com/labstack/gommon v0.3.0 // indirect
	github.com/mattn/go-sqlite3 v2.0.3+incompatible
	github.com/valyala/fasttemplate v1.1.0 // indirect
	golang.org/x/crypto v0.0.0-20200221231518-2aa609cf4a9d // indirect
)
