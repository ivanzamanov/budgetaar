use std::fs;

use duckdb::params;
use duckdb::Connection;
use iban::*;
use serde::Serialize;

fn open_connection() -> Connection {
    Connection::open("../data.db").expect("Could not open connection to DB")
}

pub fn rebuild() -> anyhow::Result<()> {
    fs::remove_file("../data.db")?;
    let conn = open_connection();

    prepare_schema(&conn)?;
    read_statements(&conn)?;

    update_counterparty_ibans(&conn)?;

    update_transaction_streams(&conn)?;

    Ok(())
}

fn prepare_schema(conn: &Connection) -> anyhow::Result<()> {
    Ok(conn.execute_batch(include_str!("../sql/init.sql"))?)
}

fn update_counterparty_ibans(conn: &Connection) -> anyhow::Result<()> {
    struct Transaction {
        id: i32,
        description: String,
    }
    let mut stmt =
        conn.prepare("select id, description from transactions where counterparty_iban is null")?;
    let transactions = stmt
        .query_map([], |row| {
            std::result::Result::Ok(Transaction {
                id: row.get("id")?,
                description: row.get("description")?,
            })
        })?
        .filter_map(|t| Some(t.unwrap()))
        .collect::<Vec<Transaction>>();

    let mut set_counterparty_stmt =
        conn.prepare("update transactions set counterparty_iban = $1 where id = $2")?;
    for t in transactions {
        if let Some(counterparty_iban) = find_valid_iban(&t.description) {
            set_counterparty_stmt.execute(params![counterparty_iban, t.id])?;
        }
    }

    Ok(())
}

fn read_statements(conn: &Connection) -> anyhow::Result<()> {
    let read_dir = std::fs::read_dir("../statements")?;
    for file in read_dir.into_iter() {
        let file_path = file?.path();
        let path_str = file_path.to_str().unwrap();
        println!("Reading {}", path_str);

        let iban = file_path
            .file_stem()
            .and_then(|n| n.to_str())
            .unwrap()
            .split_whitespace()
            .find(|part| part.parse::<Iban>().is_ok())
            .expect("Could not find IBAN in file name");

        println!("Inferred IBAN: {}", iban);

        conn.execute(
            include_str!("../sql/transactions-from-raw-data.sql"),
            params![path_str, iban],
        )?;

        println!("Done");
    }
    Ok(())
}

fn find_valid_iban(description: &str) -> Option<String> {
    description
        .replace("/", " ")
        .replace("|", " ")
        .split_whitespace()
        .find(|part| part.parse::<Iban>().is_ok())
        .map(|s| s.to_owned())
}

fn update_transaction_streams(conn: &Connection) -> anyhow::Result<()> {
    conn.execute_batch(include_str!("../sql/update-heuristic-streams.sql"))?;
    Ok(())
}

#[derive(Serialize)]
pub struct MonthlySpend {
    date: String,
    outflow: f32,
    inflow: f32,
    total: f32,
    events_outflow: f32,
}

pub fn get_monthly_spend(ibans: Option<String>, streams: Option<String>, subtract_major_events: bool) -> anyhow::Result<Vec<MonthlySpend>> {
    let conn = open_connection();

    Ok(conn
        .prepare(include_str!("../sql/compute-monthly-aggregate.sql"))?
        .query_map(params![ibans, streams, subtract_major_events], |row| {
            Ok(MonthlySpend {
                date: row.get("date")?,
                outflow: row.get("outflow")?,
                inflow: row.get("inflow")?,
                total: row.get("total")?,
                events_outflow: row.get("events_outflow")?,
            })
        })?
        .map(|r| r.unwrap())
        .collect::<Vec<MonthlySpend>>())
}

#[derive(Serialize)]
pub struct AvailableFilters {
    ibans: Vec<String>,
    streams: Vec<String>,
}

pub fn get_available_filters() -> anyhow::Result<AvailableFilters> {
    let conn = open_connection();

    let ibans = conn
        .prepare("select * from ibans where is_family = true;")?
        .query_map([], |row| Ok(row.get("iban")?))?
        .map(|r| r.unwrap())
        .collect::<Vec<String>>();

    let streams = conn
        .prepare("select distinct stream from transactions where stream is not null;")?
        .query_map([], |row| Ok(row.get("stream")?))?
        .map(|r| r.unwrap())
        .collect::<Vec<String>>();

    Ok(AvailableFilters { ibans, streams })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_find_iban() {
        assert_eq!(
            find_valid_iban("Нареден SEPA превод 9011194434 - 1004 /SK6111000000002945045506|Такса за Нареден SEPA превод"),
            Some("SK6111000000002945045506".to_owned())
        );
    }
}
