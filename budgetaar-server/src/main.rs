use anyhow::{Ok, Result};
use duckdb::{params, Connection};

fn main() {
    run().unwrap();
}

fn run() -> Result<()> {
    let conn = Connection::open("../duckdb.db")?;

    prepare_schema(&conn)?;
    read_statements(&conn)?;

    update_monthly_aggregate(&conn)?;

    export_data(&conn, "../budgetaar/src/assets/monthly.json")?;

    Ok(())
}

fn export_data(conn: &Connection, output_path: &str) -> Result<usize> {
    Ok(conn.execute(
        format!(
            "copy monthly_aggregate to '{}' (FORMAT JSON, ARRAY true);",
            output_path
        )
        .as_str(),
        params![],
    )?)
}

fn update_monthly_aggregate(conn: &Connection) -> Result<()> {
    Ok(conn.execute_batch(include_str!("../sql/update-monthly-aggregate.sql"))?)
}

fn prepare_schema(conn: &Connection) -> Result<()> {
    Ok(conn.execute_batch(include_str!("../sql/init.sql"))?)
}

fn read_statements(conn: &Connection) -> Result<()> {
    let read_dir = std::fs::read_dir("../statements")?;
    for file in read_dir.into_iter() {
        let file_path = file?.path();
        let path_str = file_path.to_str().unwrap();
        println!("Reading {}", path_str);

        let name_parts = file_path
            .file_stem()
            .and_then(|n| n.to_str())
            .unwrap()
            .split_whitespace()
            .collect::<Vec<&str>>();

        let iban = name_parts[1].to_owned();
        println!("Inferred IBAN: {}", iban);

        conn.execute(
            "create or replace table raw_data as select * from read_csv(?, header = true);",
            params![path_str],
        )?;

        conn.execute_batch(include_str!("../sql/transactions-from-raw-data.sql"))?;

        println!("Imported {}", path_str);
    }
    Ok(())
}
