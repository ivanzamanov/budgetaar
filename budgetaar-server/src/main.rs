use api::{AvailableFilters, MonthlySpend};
use axum::{
    extract::Query,
    routing::{get, put},
    Json, Router,
};
use serde::*;
use tower_http::trace::TraceLayer;
use tracing::Level;
use tracing_subscriber::FmtSubscriber;

mod api;

#[tokio::main]
async fn main() {
    let subscriber = FmtSubscriber::builder()
        .compact()
        .with_max_level(Level::INFO)
        .finish();
    tracing::subscriber::set_global_default(subscriber).expect("Could not configure tracing");

    let app = Router::new()
        .route("/api/rebuild", put(rebuild))
        .route("/api/monthly-spend", get(monthly_spend))
        .route("/api/available-filters", get(available_filters))
        .layer(TraceLayer::new_for_http());

    rebuild().await;

    let address = "0.0.0.0:3001";
    let listener = tokio::net::TcpListener::bind(address).await.unwrap();
    tracing::info!("Listening on {}", address);
    axum::serve(listener, app).await.unwrap();
}

async fn rebuild() {
    api::rebuild().unwrap();
}

#[derive(Deserialize)]
struct MonthlySpendParams {
    ibans: Option<String>,
    streams: Option<String>,
    subtract_major_events: Option<bool>,
}

async fn monthly_spend(q: Query<MonthlySpendParams>) -> Json<Vec<MonthlySpend>> {
    let ibans = q
        .ibans
        .clone()
        .map(|str| str.replace("{", "").replace("}", ""));
    let streams = q
        .streams
        .clone()
        .map(|str| str.replace("{", "").replace("}", ""));
    let subtract_major_events = q.subtract_major_events.clone().or(Some(false)).unwrap();

    tracing::info!(ibans);
    Json(api::get_monthly_spend(ibans, streams, subtract_major_events).unwrap())
}

async fn available_filters() -> Json<AvailableFilters> {
    Json(api::get_available_filters().unwrap())
}
