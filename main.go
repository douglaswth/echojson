package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		rb, err := ioutil.ReadAll(req.Body)
		if err != nil {
			w.WriteHeader(500)
			log.Print(err)
			fmt.Fprint(w, err)
			return
		}
		b, err := json.Marshal(&map[string]interface{}{
			"method":            req.Method,
			"url":               req.URL.String(),
			"proto":             []interface{}{req.Proto, req.ProtoMajor, req.ProtoMinor},
			"headers":           req.Header,
			"body":              string(rb),
			"content_length":    req.ContentLength,
			"transfer_encoding": req.TransferEncoding,
			"close":             req.Close,
			"host":              req.Host,
			"trailer":           req.Trailer,
			"remote_addr":       req.RemoteAddr,
			"request_uri":       req.RequestURI,
		})
		if err != nil {
			w.WriteHeader(500)
			log.Print(err)
			fmt.Fprint(w, err)
			return
		}
		log.Printf("%s", b)
		w.Write(b)
	})
	log.Fatal(http.ListenAndServe(":8080", nil))
}
