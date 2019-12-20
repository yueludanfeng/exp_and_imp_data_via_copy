#!/bin/sh

PSQL_DIR=/home/postgres/pgsql
	
rm_additional_files()
{
	for file in `ls ${PSQL_DIR}/*csv`
	do
		file_size=`ls -s $file |awk '{print $1}'`
		if [[ $file_size -eq 0 ]];then
			rm -f ${file}
		fi
	done
}

rm_additional_files