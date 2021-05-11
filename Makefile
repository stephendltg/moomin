# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GORUN=$(GOCMD) run
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GOVET=$(GOCMD) vet
GOFMT=gofmt
GOLINT=golint
BINARY_NAME=moomin

all: deps tool build build-linux build-rasp build-darwin build-darwin-arm build-win

dev:
	GIN_MODE=release $(GORUN) main.go -debug

build:
	GIN_MODE=release $(GOBUILD) -v .

build-linux:
	GIN_MODE=release GOOS=linux $(GOBUILD) -v -o $(BINARY_NAME)-linux .

build-rasp:
	GIN_MODE=release GOOS=linux GOARCH=arm GOARM=5 $(GOBUILD) -v -o $(BINARY_NAME)-rasp .

build-darwin:
	GIN_MODE=release GOOS=darwin GOARCH=amd64 $(GOBUILD) -v -o $(BINARY_NAME)-darwin-amd64.app .

build-darwin-arm:
	GIN_MODE=release GOOS=darwin GOARCH=arm64 $(GOBUILD) -v -o $(BINARY_NAME)-darwin-arm64.app .

build-win:
	GIN_MODE=release GOOS=windows GOARCH=amd64 $(GOBUILD) -v -o $(BINARY_NAME)-win-amd64.exe .

tool:
	$(GOVET) ./...; true
	$(GOFMT) -w .

clean:
	go clean -i .
	rm -f moomin.log
	rm -f $(BINARY_NAME)
	rm -f $(BINARY_NAME)-linux
	rm -f $(BINARY_NAME)-rasp
	rm -f $(BINARY_NAME)-win-amd64.exe
	rm -f $(BINARY_NAME)-darwin-amd64.app
	rm -f $(BINARY_NAME)-darwin-arm64.app

deps:
	go mod tidy
	go mod verify

docker: clean build
	docker build -t $(BINARY_NAME) .
 	docker run --rm $(BINARY_NAME):latest

help:
	@echo "make: compile packages and dependencies"
	@echo "make tool: run specified go tool"
	@echo "make clean: remove object files and cached files"
	@echo "make deps: get the deployment tools"
	@echo "make docker: Build docker"
