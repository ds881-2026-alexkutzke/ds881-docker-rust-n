# Builder stage
FROM rust:alpine3.21 as builder

RUN apk add --no-cache musl-dev gcc

WORKDIR /usr/src/app
COPY . .

RUN RUSTFLAGS="-C link-arg=-s" cargo build --release

# Runtime stage
FROM alpine:3.21.6

WORKDIR /app

COPY --from=builder /usr/src/app/target/release/calculadora_api /app/calculadora_api

EXPOSE 8080

CMD ["./calculadora_api"]