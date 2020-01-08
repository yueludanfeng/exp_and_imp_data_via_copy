#!/bin/sh
BIN_PSQL=/home/postgres/pgsql/bin/psql 
DB_NAME=imos
PG_USER=postgres
TABLE_LIST=/tmp/tables.txt
PSQL_DIR=/home/postgres/pgsql

export_dbpasswd
{
	export PGUSER=postgres
	export PGPASSWORD=passwd
}

exp_tables()
{
	$BIN_PSQL -U $PG_USER -d $DB_NAME -qAt -c "select tablename from pg_tables where tablename like 'tbl_%' order by tablename;" > $TABLE_LIST

	for line in `cat $TABLE_LIST`
	do
		if [[ -n "$line" ]];then
			file=${PSQL_DIR}/${line}.csv
			$BIN_PSQL -U $PG_USER -d $DB_NAME -qAt -c "copy ${line} to '$file' csv delimiter ';'"
		fi
	done
}


main()
{
	export_dbpasswd
	exp_tables
}

main
