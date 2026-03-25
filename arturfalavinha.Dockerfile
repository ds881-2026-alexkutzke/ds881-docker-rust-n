FROM rust:alpine3.21 AS builder

RUN apk add --no-cache musl-dev

WORKDIR /app

COPY Cargo.toml Cargo.lock ./
RUN mkdir src \
    && printf 'fn main() {}\n' > src/main.rs \
    && RUSTFLAGS="-C strip=symbols" cargo build --release \
    && rm -rf src

COPY src ./src
RUN touch src/main.rs && RUSTFLAGS="-C strip=symbols" cargo build --release

FROM scratch

COPY --from=builder /app/target/release/calculadora_api /calculadora_api

EXPOSE 8080

USER 10001

ENTRYPOINT ["/calculadora_api"]
