FROM alpine:latest

RUN apk add --no-cache bash curl jq wget
RUN adduser -S echojson
WORKDIR /srv

RUN mkdir bin
ADD echojson-linux-amd64 bin/echojson

USER echojson

EXPOSE 8080/tcp

ENTRYPOINT ["/srv/bin/echojson"]

ARG builddate=unknown
LABEL echojson.build=${builddate}
