use api::{AvailableFilters, MonthlySpend};
use axum::{extract::Query, routing::get, Json, Router};
use serde::*;
use tower_http::trace::TraceLayer;
use tracing::Level;
use tracing_subscriber::FmtSubscriber;

mod api;

#[tokio::main]
async fn main() {
    let subscriber = FmtSubscriber::builder()
        .compact()
        .with_max_level(Level::DEBUG)
        .finish();
    tracing::subscriber::set_global_default(subscriber).expect("Could not configure tracing");

    let app = Router::new()
        .route("/api/monthly-spend", get(monthly_spend))
        .route("/api/available-filters", get(available_filters))
        .route("/api/stream-breakdown", get(stream_breakdown))
        .layer(TraceLayer::new_for_http());

    api::rebuild().unwrap();

    let address = "0.0.0.0:3001";
    let listener = tokio::net::TcpListener::bind(address).await.unwrap();
    tracing::info!("Listening on {}", address);
    axum::serve(listener, app).await.unwrap();
}

#[derive(Deserialize, Debug)]
struct TimeInterval {
    from: Option<String>,
    to: Option<String>,
}

#[derive(Deserialize, Debug)]
struct MonthlySpendParams {
    ibans: Option<String>,
    streams: Option<String>,
    subtract_major_events: Option<bool>,
}

async fn monthly_spend(
    q: Query<MonthlySpendParams>,
    time: Query<TimeInterval>,
) -> Json<Vec<MonthlySpend>> {
    let query = q.0;
    let interval = time.0;
    tracing::info!("{:?} {:?}", query, interval);

    let ibans = query
        .ibans
        .clone()
        .map(|str| str.replace("{", "").replace("}", ""));
    let streams = query
        .streams
        .clone()
        .map(|str| str.replace("{", "").replace("}", ""));
    let subtract_major_events = query.subtract_major_events.clone().or(Some(false)).unwrap();

    Json(
        api::get_monthly_spend(
            interval.from,
            interval.to,
            ibans,
            streams,
            subtract_major_events,
        )
        .unwrap(),
    )
}

#[derive(Deserialize, Debug)]
struct StreamBreakdownParams {
    ibans: Option<String>,
}

async fn stream_breakdown(
    query: Query<StreamBreakdownParams>,
    time: Query<TimeInterval>,
) -> Json<std::collections::HashMap<String, f32>> {
    let interval = time.0;
    let ibans = to_csv_list(query.ibans.clone());
    Json(api::get_stream_breakdown(interval.from, interval.to, ibans).unwrap())
}

fn to_csv_list(str: Option<String>) -> Option<String> {
    str.map(|str| str.replace("{", "").replace("}", ""))
}

async fn available_filters() -> Json<AvailableFilters> {
    Json(api::get_available_filters().unwrap())
}
