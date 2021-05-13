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
AUTHOR=stephendltg

all: deps tool build-linux build-rasp build-darwin build-darwin-arm build-win

dev:
	GIN_MODE=release $(GORUN) main.go -debug

build:
	GIN_MODE=release $(GOBUILD) -v .

build-linux:
	GIN_MODE=release GOOS=linux $(GOBUILD) -v -o build/$(BINARY_NAME)-linux .

build-rasp:
	GIN_MODE=release GOOS=linux GOARCH=arm GOARM=5 $(GOBUILD) -v -o build/$(BINARY_NAME)-rasp .

build-darwin:
	GIN_MODE=release GOOS=darwin GOARCH=amd64 $(GOBUILD) -v -o build/$(BINARY_NAME)-darwin-amd64 .

build-darwin-arm:
	GIN_MODE=release GOOS=darwin GOARCH=arm64 $(GOBUILD) -v -o build/$(BINARY_NAME)-darwin-arm64 .

build-win:
	GIN_MODE=release GOOS=windows GOARCH=amd64 $(GOBUILD) -v -o build/$(BINARY_NAME)-win-amd64.exe .

tool:
	$(GOVET) ./...; true
	$(GOFMT) -w .

clean:
	go clean -i .
	rm -f moomin.log
	rm -f $(BINARY_NAME)
	rm -f build/$(BINARY_NAME)-linux
	rm -f build/$(BINARY_NAME)-rasp
	rm -f build/$(BINARY_NAME)-win-amd64.exe
	rm -f build/$(BINARY_NAME)-darwin-amd64
	rm -f build/$(BINARY_NAME)-darwin-arm64

deps:
	go mod tidy
	go mod verify

# docker run --rm -v "$(pwd)/public:/app/public" -p 5000:5000 ${BINARY_NAME}:latest 
docker-build: clean
	docker build -t $(AUTHOR)/$(BINARY_NAME) .
 	docker run --rm $(AUTHOR)/$(BINARY_NAME):latest

docker-push:
	docker push stephendltg/moomin:latest
	

help:
	@echo "make: compile packages and dependencies"
	@echo "make tool: run specified go tool"
	@echo "make clean: remove object files and cached files"
	@echo "make deps: get the deployment tools"
	@echo "make docker: Build docker"
