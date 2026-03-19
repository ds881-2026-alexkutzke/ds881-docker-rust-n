# Builder stage
FROM rust:alpine3.21 as builder

RUN apk add --no-cache musl-dev gcc

WORKDIR /usr/src/app
COPY . .

RUN RUSTFLAGS="-C link-arg=-s" cargo build --release

# Runtime stage
# Distroless
FROM scratch

COPY --from=builder /usr/src/app/target/release/calculadora_api /calculadora_api

EXPOSE 8080
ENTRYPOINT ["/calculadora_api"]