# syntax=docker/dockerfile:1
FROM ubuntu:24.04 AS builder

ARG VERSION=""
ARG AUTOCONF_VERSION=""

WORKDIR /workspace

RUN apt-get update -y && apt-get upgrade -y \
  && apt-get install -y autoconf binutils git make texinfo help2man libtool

RUN git clone http://git.sv.gnu.org/r/autoconf.git \
  && cd autoconf \
  ; if [ "$AUTOCONF_VERSION" = "" ]; then \
    VERSION=$(git describe --tags `git rev-list --tags --max-count=1`) \
  ; fi \
  ; git checkout ${AUTOCONF_VERSION} \
  && autoreconf -i && ./configure && make && make install

RUN git clone https://github.com/kohler/gifsicle.git \
  && cd gifsicle \
  ; if [ "$VERSION" = "" ]; then \
    VERSION=$(git describe --tags `git rev-list --tags --max-count=1`) \
  ; fi \
  ; git checkout ${VERSION} \
  && autoreconf -i && ./configure && make

FROM gcr.io/distroless/base-debian12

COPY --from=builder /workspace/gifsicle/src/gifsicle /usr/local/bin/gifsicle

ENTRYPOINT [ "gifsicle" ]
