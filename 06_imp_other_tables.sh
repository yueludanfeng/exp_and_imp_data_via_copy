#!/bin/sh
BIN_PSQL=/home/postgres/pgsql/bin/psql 
DB_NAME=imos
PG_USER=postgres
PSQL_DIR=/home/postgres/pgsql


export_dbpasswd
{
	export PGUSER=postgres
	export PGPASSWORD=passwd
}

imp_tables()
{
	for line in `ls $PSQL_DIR/*.csv`
	do
		if [[ -n "$line" ]];then
			file_name="`basename $line`"
			table_name=${file_name%.csv}
			$BIN_PSQL -U $PG_USER -d $DB_NAME -qAt -c "copy ${table_name} from '$line' csv delimiter ';'"
		fi
	done
}


main()
{
	export_dbpasswd
	imp_tables
}

main
