# Build the default backend binary or image for amd64, arm, arm64 and ppc64le
#
# Usage:
# 	[PREFIX=gcr.io/google_containers/dummy-ingress-controller] [ARCH=amd64] [TAG=1.1] make (server|container|push)

all: push

TAG=0.1
ME?= localhost
PREFIX?= $(ME):5000/ktaka/ipvs-controller
ARCH?=amd64
GOLANG_VERSION=1.9
#export GOPATH := $HOME/go

install-glide: 
	rm -rf vendor
	command -v glide || curl https://glide.sh/get | sh

init-vendor: install-glide
	glide init --non-interactive
	glide update -v

update-vendor: install-glide
	glide update -v

vendor: glide.yaml glide.lock install-glide
	glide install -v

server: src/server.go vendor
	CGO_ENABLED=0 GOOS=linux GOARCH=$(ARCH) GOARM=6 go build -a -installsuffix cgo -ldflags '-w' -o server ./src

container: server
	sudo docker build --pull -t $(PREFIX):$(TAG) .

push: container
	sudo docker push $(PREFIX):$(TAG)

clean:
	rm -f server

