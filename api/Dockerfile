FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

RUN go install github.com/pressly/goose/v3/cmd/goose@latest

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ./cmd/api

FROM alpine:latest

RUN apk --no-cache add ca-certificates tzdata postgresql-client
WORKDIR /root/

COPY --from=builder /app/main .
COPY --from=builder /go/bin/goose /usr/local/bin/goose
COPY migrations/ /migrations/

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

CMD ["sh", "-c", "goose -dir /migrations postgres \"host=${DB_HOST} port=${DB_PORT} user=${DB_USER} password=${DB_PASSWORD} dbname=${DB_NAME} sslmode=require\" up && ./main"]
