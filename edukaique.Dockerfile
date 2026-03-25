# Fonte: https://oneuptime.com/blog/post/2026-01-07-rust-minimal-docker-images/view
FROM rust:alpine3.21 AS builder

RUN apk add --no-cache musl-dev upx

WORKDIR /usr/src/app

COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release --target x86_64-unknown-linux-musl

COPY src ./src

RUN RUSTFLAGS="-C link-arg=-s -C target-feature=+crt-static" \
    cargo build --release --target x86_64-unknown-linux-musl

RUN upx --ultra-brute --lzma /usr/src/app/target/x86_64-unknown-linux-musl/release/calculadora_api

FROM scratch

COPY --from=builder /usr/src/app/target/x86_64-unknown-linux-musl/release/calculadora_api /calculadora_api

EXPOSE 8080

ENTRYPOINT ["/calculadora_api"]
