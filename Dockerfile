FROM ubuntu:20.04 AS builder
ARG VERSION=""

WORKDIR /workspace

RUN apt-get update -y && apt-get upgrade -y \
  && apt-get install -y git autoconf make libtool

RUN git clone https://github.com/kohler/gifsicle.git \
  && cd gifsicle \
  ; if [ "$VERSION" = "" ]; then \
    VERSION=$(git describe --tags `git rev-list --tags --max-count=1`) \
  ; fi \
  ; git checkout ${VERSION} \
  && autoreconf -i && ./configure && make

FROM gcr.io/distroless/base
COPY --from=builder /workspace/gifsicle/src/gifsicle /usr/local/bin/gifsicle
ENTRYPOINT [ "gifsicle" ]
