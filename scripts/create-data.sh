#!/bin/bash
set -eu
INPUT_FILE=${1:-statement.txt}
DATABASE=data/data.db
ASSETS_DIR=budgetaar/src/assets
SCRIPTS=$(readlink -f $(dirname $0))

(
cd $(dirname $0)/..

echo "Loading $INPUT_FILE into $DATABASE"

mkdir -p `dirname $DATABASE`
duckdb $DATABASE <<EOF
drop table if exists raw_data;
create table raw_data as select * from read_csv('$INPUT_FILE', header = true);
EOF

duckdb $DATABASE < $SCRIPTS/parse-raw-data.sql
)
