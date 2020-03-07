FROM golang:latest

WORKDIR /go/src

RUN apt-get update && apt-get install -y git-lfs && git lfs install --skip-repo
RUN curl http://compling.hss.ntu.edu.sg/wnja/data/1.1/wnjpn.db.gz > wnjpn.db.gz && gunzip wnjpn.db.gz
RUN mkdir -p /go/src && git clone https://github.com/aaaton/golem.git /go/src/golem

ADD . /go/src

RUN go build

