# Build the default backend binary or image for amd64, arm, arm64 and ppc64le
#
# Usage:
# 	[PREFIX=gcr.io/google_containers/dummy-ingress-controller] [ARCH=amd64] [TAG=1.1] make (server|container|push)

all: push

TAG=0.1
PREFIX?= 10.0.0.10:5000/ktaka/dummy-ingress-ctlr
ARCH?=amd64
GOLANG_VERSION=1.8
TEMP_DIR:=$(shell mktemp -d)

glide.yaml: 
	rm -rf vender
	command -v glide || curl https://glide.sh/get | sh
	glide init --non-interactive

server: server.go glide.yaml
	glide update -v
	CGO_ENABLED=0 GOOS=linux GOARCH=$(ARCH) GOARM=6 go build -a -installsuffix cgo -ldflags '-w' -o server ./server.go

container: server
	docker build --pull -t $(PREFIX):$(TAG) .

push: container
	docker push $(PREFIX):$(TAG)

clean:
	rm -f server

