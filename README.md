# GATEWAY BLE


## USAGE

Get binary moomin

> for linux
> chmod +x moomin
> ./moomin -p=8080 -debug -$HOME/public

|   params              | value                 |   Description     |
|   ==========          | ====================  | ================= |
|   p                   | string                | Http port         |
|   debug               | boolean               | Mode debug        |  
|   d                   | string                | Path web static   |  

__Create dir public next binary and push your files__


---


## WORKFLOW DEV

### GOLANG

#### GOLANG
> cd /usr/local
> sudo wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz
> sudo rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz

> nano $HOME/.profile

Add /usr/local/go/bin to the PATH environment variable
> export PATH=$PATH:/usr/local/go/bin
Apply change
>. ~/.profile

> go version

---

#### PROJET

**INSTALL DEPENDANCES**
>go mod tidy

**ENV**
>go env

**RUN GO**
> go run main.go
>./main

**BUILD GO**
> go build .
>./main

**Clean**
> go clean -i

**Install**
Install app 
> go install .
> sudo ~/go/bin/gateway-ble

---

```tips golang
make ~/go/src/<project>

# initializing dependencies file (go.mod)
$ go mod init

# installing a module
$ go get github.com/go-shadow/moment

# updating a module
$ go get -u github.com/go-shadow/moment

# removing a module
$ rm -rf $GOPATH/pkg/mod/github.com/go-shadow/moment@v<tag>-<checksum>/

# pruning modules (removing unused modules from dependencies file)
$ go mod tidy

# download modules being used to local vendor directory (equivalent of downloading node_modules locally)
$ go mod vendor

# download modules being used
$ go mod download
```

---

### REFERENCES

__ref__: https://awesomeopensource.com/project/miguelmota/golang-for-nodejs-developers


---

### DOCKER PUSH

```
docker login
```

```
docker push stephendltg/moomin:latest
```



