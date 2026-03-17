use axum::{routing::post, Json, Router};
use serde::{Deserialize, Serialize};
use gethostname::gethostname;
use std::net::SocketAddr;

#[derive(Deserialize)]
struct CalcReq {
    operador: String,
    op1: f64,
    op2: f64,
}

#[derive(Serialize)]
struct CalcRes {
    container_host: String,
    resultado: f64,
}

async fn calcular(Json(payload): Json<CalcReq>) -> Json<CalcRes> {
    let res = match payload.operador.as_str() {
        "soma" => payload.op1 + payload.op2,
        "subtracao" => payload.op1 - payload.op2,
        "multiplicacao" => payload.op1 * payload.op2,
        "divisao" => if payload.op2 != 0.0 { payload.op1 / payload.op2 } else { 0.0 },
        _ => 0.0,
    };

    let host = gethostname().into_string().unwrap_or_default();
    Json(CalcRes { container_host: host, resultado: res })
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/calcular", post(calcular));
    let addr = SocketAddr::from(([0, 0, 0, 0], 8080));
    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    
    axum::serve(listener, app).await.unwrap();
}
