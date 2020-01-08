#!/bin/sh

PSQL_DIR=/home/postgres/pgsql
PSQL_BIN=${PSQL_DIR}/bin/psql
PG_USER=postgres
DB_NAME=imos


export_dbpasswd
{
	export PGUSER=postgres
	export PGPASSWORD=passwd
}

# 备份文件并删不需要导入的表
[ -f ${PSQL_DIR}/additional_tables.txt_bak  ] || cp -bf ${PSQL_DIR}/additional_tables.txt ${PSQL_DIR}/additional_tables.txt_bak
for file in `cat ${PSQL_DIR}/additional_tables.txt`
do
	ls ${PSQL_DIR}/*csv |grep $file
	if [[ $? -ne 0 ]]; then
		sed -i "/${file}/d" ${PSQL_DIR}/additional_tables.txt
	fi
done

