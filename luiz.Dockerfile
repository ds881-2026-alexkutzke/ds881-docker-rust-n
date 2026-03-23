# Builder stage
FROM rust:alpine3.21 as builder

RUN apk add --no-cache musl-dev gcc upx

WORKDIR /usr/src/app
COPY . .

RUN RUSTFLAGS="-C link-arg=-s" cargo build --release

RUN upx --ultra-brute --lzma /usr/src/app/target/release/calculadora_api

# Runtime stage
FROM scratch
COPY --from=builder /usr/src/app/target/release/calculadora_api /calculadora_api

EXPOSE 8080
ENTRYPOINT ["/calculadora_api"]