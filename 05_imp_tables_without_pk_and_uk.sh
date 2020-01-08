#!/bin/sh

PSQL_DIR=/home/postgres/pgsql
PSQL_BIN=${PSQL_DIR}/bin/psql
PG_USER=postgres
DB_NAME=imos
NO_PK_AND_UK_TABLES=/home/postgres/pgsql/additional_tables.txt
dbpasswd_conf_file=/usr/local/svconfig/server/conf/dbpasswd.conf
my_logfile=/var/log/imoslog/common.log
my_passwd=/usr/local/bin/univpasswd
my_unipd=/usr/local/bin/unipd


export_dbpasswd()
{
    if [ $# = 0 ]; then
        logfile=${my_logfile}
    else
        logfile=$1
    fi

    read_passwd_old()
    {
       if [ -e $dbpasswd_conf_file ] && [ -f  $dbpasswd_conf_file  ]
       then
           . $dbpasswd_conf_file
           $my_passwd "2" "$dbpasswd"

           if [ -e dbpasswd_temp.conf ] && [ -f dbpasswd_temp.conf  ]
           then
               var_path=`pwd`
               . ${var_path}/dbpasswd_temp.conf
               export PGUSER=postgres
               export PGPASSWORD=$dbpasswd
               rm -rf dbpasswd_temp.conf
           else
               echo " `date +"%Y-%m-%d %H:%M:%S"` --> error: do passwd error, file dbpasswd_tmp.conf does not exist" >> $my_logfile 2>&1
               export PGUSER=postgres
               export PGPASSWORD=passwd
           fi
        else
            export PGUSER=postgres
            export PGPASSWORD=passwd
        fi
    }

    if [ -e $my_unipd ] && [ -f $my_unipd ]
    then
        if [  -f  /usr/local/svconfig/server/conf/imos.cfg  ]
        then
            dbpasswd=`cat /usr/local/svconfig/server/conf/imos.cfg | grep DBPassword |  awk -F "=" '{ print $2}'`
            dbpasswd=`$my_unipd 1 ${dbpasswd}`
            if [ ""x = "$dbpasswd"x ]
            then
                echo " `date +"%Y-%m-%d %H:%M:%S"` --> error: do passwd error, DBPassword not in imos.cfg" >> ${logfile} 2>&1
                #失败的情况下先尝试用安全向导合入前的方式读取数据库密码
                read_passwd_old
            else
                export PGUSER=postgres
                export PGPASSWORD=$dbpasswd
            fi
        elif [  -f  /usr/local/svconfig/server/conf/imos_cds.cfg  ]
        then
            #兼容合主线前的CDM
            dbpasswd=`cat /usr/local/svconfig/server/conf/imos_cds.cfg | grep DBPassword |  awk -F "=" '{ print $2}'`
            dbpasswd=`$my_unipd 1 ${dbpasswd}`
            if [ ""x = "$dbpasswd"x ]
            then
                echo " `date +"%Y-%m-%d %H:%M:%S"` --> error: do passwd error, DBPassword not in imos_cds.cfg" >> ${logfile} 2>&1
                #失败的情况下先尝试用安全向导合入前的方式读取数据库密码
                read_passwd_old
            else
                export PGUSER=postgres
                export PGPASSWORD=$dbpasswd
            fi
        else
            #失败的情况下先尝试用安全向导合入前的方式读取数据库密码
            read_passwd_old
        fi
    else
        #失败的情况下先尝试用安全向导合入前的方式读取数据库密码
        read_passwd_old
    fi
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