use anyhow::{Ok, Result};
use duckdb::{params, Connection};
use iban::*;

fn main() {
    run().unwrap();
}

fn run() -> Result<()> {
    let conn = Connection::open("../data.db")?;

    prepare_schema(&conn)?;
    read_statements(&conn)?;

    update_counterparty_ibans(&conn)?;

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

fn update_counterparty_ibans(conn: &Connection) -> Result<()> {
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

fn read_statements(conn: &Connection) -> Result<()> {
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
