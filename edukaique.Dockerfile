# Fonte: https://oneuptime.com/blog/post/2026-01-07-rust-minimal-docker-images/view

FROM rust:1.75-alpine AS builder

RUN apk add --no-cache musl-dev openssl-dev openssl-libs-static

WORKDIR /app

COPY ./Cargo.toml ./

RUN mkdir src && \
    echo "fn main() {}" > src/main.rs

RUN cargo build --release --target x86_64-unknown-linux-musl && \
    rm -rf src

COPY src ./src

RUN RUSTFLAGS="-C target-feature=+crt-static" \
    cargo build --release --target x86_64-unknown-linux-musl


FROM scratch

COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/calculadora_api /calculadora_api

EXPOSE 3000

ENTRYPOINT ["/calculadora_api"]
