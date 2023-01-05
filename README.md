# Dockerfile for Gifsicle

- [Gifsicle](https://github.com/kohler/gifsicle)

## Build

### Build with current latest version.

```shell
$ docker build ./ -t gifsicle:latest
```

### Build with specific version.

```shell
$ docker build ./ -t gifsicle:v193 --build-arg VERSION=v1.93
```

## Usage

```shell
$ docker run --rm gifsicle -v
```
