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
BINARY_NAME=$(shell node -p "require('./package.json').name")
VERSION := $(shell node -p "require('./package.json').version")
DESCRIPTION := $(shell node -p "require('./package.json').description")
HOMEPAGE := $(shell node -p "require('./package.json').homepage")
AUTHOR=stephendltg
NODE=v14.16.1
NVM=v0.38.0
PKG_LINUX=build/${BINARY_NAME}-linux
PKG_RASP=build/${BINARY_NAME}-rasp

all: deps tool build-linux build-rasp build-darwin build-darwin-arm build-win

pre-install: 
	@echo "Installing project ${BINARY_NAME}..."
	. ${NVM_DIR}/nvm.sh && nvm install ${NODE} && nvm use ${NODE}

dev:
	GIN_MODE=release $(GORUN) main.go -debug

build:
	GIN_MODE=release $(GOBUILD) -v .

build-linux:
	GIN_MODE=release GOOS=linux $(GOBUILD) -v -o build/$(BINARY_NAME)-linux .

build-rasp:
	GIN_MODE=release GOOS=linux GOARCH=arm GOARM=5 $(GOBUILD) -v -o build/$(BINARY_NAME)-rasp .

build-darwin:
	mkdir -p build/$(BINARY_NAME)-amd64.app/Contents/Macos
	GIN_MODE=release GOOS=darwin GOARCH=amd64 $(GOBUILD) -v -o build/$(BINARY_NAME).app/Contents/MacOS/$(BINARY_NAME) .
	# GIN_MODE=release GOOS=darwin GOARCH=amd64 $(GOBUILD) -v -o build/$(BINARY_NAME)-darwin-amd64 .

build-darwin-arm:
	mkdir -p build/$(BINARY_NAME)-arm64.app/Contents/Macos
	GIN_MODE=release GOOS=darwin GOARCH=arm64 $(GOBUILD) -v -o build/$(BINARY_NAME).app/Contents/MacOS/$(BINARY_NAME) .
	# GIN_MODE=release GOOS=darwin GOARCH=arm64 $(GOBUILD) -v -o build/$(BINARY_NAME)-darwin-arm64 .

build-win:
	GIN_MODE=release GOOS=windows GOARCH=amd64 $(GOBUILD) -v -o build/$(BINARY_NAME)-win-amd64.exe .

build-deb:
	mkdir -p $(PKG_LINUX)/DEBIAN
	mkdir -p $(PKG_LINUX)/usr/bin/
	echo "Package: $(BINARY_NAME)" > $(PKG_LINUX)/DEBIAN/control
	echo "Version: $(VERSION)" >> $(PKG_LINUX)/DEBIAN/control
	echo "Section: custom" >> $(PKG_LINUX)/DEBIAN/control
	echo "Architecture: all" >> $(PKG_LINUX)/DEBIAN/control
	echo "Essential: no" >> $(PKG_LINUX)/DEBIAN/control
	echo "Maintainer: $(AUTHOR)" >> $(PKG_LINUX)/DEBIAN/control
	echo "Description: $(DESCRIPTION)" >> $(PKG_LINUX)/DEBIAN/control
	echo "Homepage: ${HOMEPAGE}" >> $(PKG_LINUX)/DEBIAN/control
	GOOS=linux $(GOBUILD) -v -o $(PKG_LINUX)/usr/bin/$(BINARY_NAME) .
	sudo dpkg-deb --build $(PKG_LINUX)
	rm -r $(PKG_LINUX)/*
	rmdir $(PKG_LINUX)

build-deb-rasp:
	mkdir -p $(PKG_RASP)/DEBIAN
	mkdir -p $(PKG_RASP)/usr/bin/
	echo "Package: $(BINARY_NAME)" > $(PKG_RASP)/DEBIAN/control
	echo "Version: $(VERSION)" >> $(PKG_RASP)/DEBIAN/control
	echo "Section: custom" >> $(PKG_RASP)/DEBIAN/control
	echo "Architecture: all" >> $(PKG_RASP)/DEBIAN/control
	echo "Essential: no" >> $(PKG_RASP)/DEBIAN/control
	echo "Maintainer: $(AUTHOR)" >> $(PKG_RASP)/DEBIAN/control
	echo "Description: $(DESCRIPTION)}" >> $(PKG_RASP)/DEBIAN/control
	echo "Homepage: ${HOMEPAGE}" >> $(PKG_RASP)/DEBIAN/control
	GOOS=linux $(GOBUILD) -v -o $(PKG_RASP)/usr/bin/$(BINARY_NAME) .
	GOOS=linux GOARCH=arm GOARM=5 $(GOBUILD) -v -o $(PKG_RASP)/usr/bin/$(BINARY_NAME) .
	sudo dpkg-deb --build $(PKG_RASP)
	rm -r $(PKG_RASP)/*
	rmdir $(PKG_RASP)

tool:
	$(GOVET) ./...; true
	$(GOFMT) -w .

clean:
	go clean -i .
	rm -f moomin.log
	rm -f $(BINARY_NAME)
	rm -r build/*

deps:
	go mod tidy
	go mod vendor
	go mod verify

# docker run --rm -v "$(pwd)/public:/app/public" -p 5000:5000 ${BINARY_NAME}:latest 
docker-build: clean
	docker build -t $(AUTHOR)/$(BINARY_NAME) .
 	docker run --rm $(AUTHOR)/$(BINARY_NAME):latest

docker-push:
	docker push stephendltg/moomin:latest

nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM}/install.sh | bash

help:
	@echo "make: compile packages and dependencies"
	@echo "make tool: run specified go tool"
	@echo "make clean: remove object files and cached files"
	@echo "make nvm: insall nvm"
	@echo "make pre-install: Pre install nodejs"
	@echo "make deps: get the deployment tools"
	@echo "make docker: Build docker"
