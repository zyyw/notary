FROM golang:1.14.1

RUN apt-get update && apt-get install -y \
	curl \
	clang \
	libsqlite3-dev \
	patch \
	tar \
	xz-utils \
	python \
	python-pip \
	python-setuptools \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash notary \
    && pip install codecov

ENV GO111MODULE=on

# Locked go cyclo on this commit as newer commits depend on Golang 1.16 io/fs
RUN go get golang.org/x/lint/golint \
    github.com/client9/misspell/cmd/misspell \
    github.com/gordonklaus/ineffassign \
    github.com/securego/gosec/cmd/gosec/... \
    github.com/fzipp/gocyclo@ffe36aa317dcbb421a536de071660261136174dd

ENV GOFLAGS=-mod=vendor \
    NOTARYDIR=/go/src/github.com/theupdateframework/notary

COPY . ${NOTARYDIR}
RUN chmod -R a+rw /go && chmod 0600 ${NOTARYDIR}/fixtures/database/*

WORKDIR ${NOTARYDIR}
