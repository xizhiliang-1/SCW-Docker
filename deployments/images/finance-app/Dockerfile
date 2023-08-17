FROM golang:1.15.4 AS builder

ENV CGO_ENABLED=0 \
    GOOS=linux

RUN mkdir -p /build 

WORKDIR /build

COPY src/code/ .

RUN go build -o server .


FROM alpine:latest

WORKDIR /app

RUN adduser -D nonroot \
    && chown -R nonroot /app

COPY --from=builder /build/server .

COPY src/assets/ .

COPY run.sh /

USER nonroot

ENV SERVER_PORT=8081

EXPOSE ${SERVER_PORT}

CMD ["/bin/sh", "/run.sh"]
