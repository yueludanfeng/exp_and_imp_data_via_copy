#!/bin/sh

PSQL_DIR=/home/postgres/pgsql
PSQL_BIN=${PSQL_DIR}/bin/psql
PG_USER=postgres
DB_NAME=imos
NO_PK_AND_UK_TABLES=/home/postgres/pgsql/additional_tables.txt



export_dbpasswd
{
	export PGUSER=postgres
	export PGPASSWORD=passwd
}

imp_tables()
{
	for line in `cat $NO_PK_AND_UK_TABLES`
	do
		file_name=`ls $PSQL_DIR/*.csv | grep $line`
		if [[ -n "$file_name" ]];then
			file_name="`basename $file_name`"
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