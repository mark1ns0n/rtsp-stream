## Build stage
FROM golang:1.15.2-alpine3.12 AS build-env
WORKDIR /go/src/rtsp-stream
COPY . .
RUN go mod tidy
RUN go build -o server

## Creating potential production image
FROM alpine:3.12
RUN apk update && apk add bash ca-certificates ffmpeg && rm -rf /var/cache/apk/*
WORKDIR /app
COPY --from=build-env /go/src/rtsp-stream/server /app/
COPY ./build/rtsp-stream.yml /app/rtsp-stream.yml

ENTRYPOINT [ "/app/server" ]
