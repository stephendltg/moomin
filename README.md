# SERVER HTTP STATIC


## USAGE

Get binary moomin

> for linux
> chmod +x moomin
> ./moomin -p=8080 -debug -d=$HOME/public

|   params              | value                 |   Description     |
|   :---------          | :-------------------  | :---------------- |
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

> sudo ~/go/bin/moomin

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
__ref__: https://github.com/gin-gonic/contrib

### DOCKER PUSH

```
docker login
```

```
docker push stephendltg/moomin:latest
```

## GENERATE DEBIAN PACKAGE

__ref:__ http://sdz.tdct.org/sdz/creer-un-paquet-deb.html

__ref:__ https://github.com/practice-golang/hello-cmake

__ref:__ https://stackoverflow.com/questions/61507209/creating-a-go-binary-as-debian-binary-package-for-a-custom-repository


## INSTALL AND REMOVE DEB

```
sudo dpkg -i nom_du_paquet.deb
sudo apt-get remove nom_du_paquet
```

