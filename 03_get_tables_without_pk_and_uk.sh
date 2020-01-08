#!/bin/sh
BIN_PSQL=/home/postgres/pgsql/bin/psql 
DB_NAME=imos
PG_USER=postgres
TABLE_LIST=/tmp/tables.txt
PSQL_DIR=/home/postgres/pgsql

NO_PK_AND_UK_TABLES=/home/postgres/pgsql/additional_tables.txt

export_dbpasswd
{
	export PGUSER=postgres
	export PGPASSWORD=passwd
}


export_dbpasswd

$BIN_PSQL -U $PG_USER -d $DB_NAME -c "
copy(
select tablename from pg_tables where tablename like 'tbl_%'
except 
select distinct(tablename) from 
	(
		select conrelid::regclass::varchar as tablename 
		FROM pg_constraint 
		where (contype='p' or contype='u') and conrelid::regclass::varchar like 'tbl_%' 
	) t
) to  '${NO_PK_AND_UK_TABLES}';"