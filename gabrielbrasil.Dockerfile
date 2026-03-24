FROM rust:alpine AS builder

RUN apk add --no-cache musl-dev

WORKDIR /app

COPY Cargo.toml ./

RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -rf src

COPY src ./src

RUN touch src/main.rs && cargo build --release

FROM alpine:latest

RUN apk add --no-cache ca-certificates

COPY --from=builder /app/target/release/calculadora_api /calculadora_api

EXPOSE 8080

# Definir o comando de arranque
ENTRYPOINT ["/calculadora_api"]