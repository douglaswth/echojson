SHELL:=$(shell which bash)

EXE:=echojson
STATIC_LINUX_AMD64_EXE:=$(patsubst %,%-linux-amd64,$(EXE))
EXE:=$(patsubst %,%$(shell go env GOEXE),$(EXE))
GO_FILES:=$(shell find -name '*.go')

REGISTRY?=douglaswth
IMAGE_NAME=echojson

export GO111MODULE=on

TAG?=latest

.PHONY: default test build build-static-linux-amd64 clean docker-build docker-push

default: build

test:
	go test ./...

build: $(EXE)

build-static-linux-amd64: $(STATIC_LINUX_AMD64_EXE)

$(EXE): $(GO_FILES)
	go build -o $@

$(STATIC_LINUX_AMD64_EXE): $(GO_FILES)
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $@ -ldflags '-extldflags "-static"'

clean:
	rm -f $(EXE) $(STATIC_LINUX_AMD64_EXE)

docker-build: build-static-linux-amd64
	docker build --no-cache --build-arg builddate=$(shell date -u '+%Y%m%d%H%M') -t $(REGISTRY)/$(IMAGE_NAME):$(TAG) .

docker-push:
	docker push $(REGISTRY)/$(IMAGE_NAME):$(TAG)
