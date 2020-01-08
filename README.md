# 局点数据库有问题单的服务器
* 上传文件 
		- 01_exp_tables.sh;(将需要的表导出为csv文件，文件名为表名)
		- 02_rm_emptyl_files.sh;(删除空的csv文件(大小为0))
		- 03_get_tables_without_pk_and_uk.sh;(获取)
		- 04_rm_additional_tables
* 分别执行这四个文件
		- sh ./01_exp_tables.sh
		- sh ./02_rm_emptyl_files.sh
		- sh ./03_get_tables_without_pk_and_uk.sh
		- sh ./04_rm_additional_tables.sh
		
* 将在 /home/postgres/pgsql/目录下生成的 csv文件下载下来
	

# 新环境
* 将 从旧服务器获取的 csv 文件,放到新环境中 /home/postgres/pgsql/目录下
	
* chwon -R postgres.postgres /home/postgres/pgsql/*csv
	
* 将 05_imp_tables_without_pk_and_uk.sh; 06_imp_other_tables.sh文件上传的新服务器
	
* 重复执行如下命令
```
		export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '
		sh -x ./05_imp_tables_without_pk_and_uk.sh 
		sh -x ./06_imp_other_tables.sh 
```
* 每次执行之前之前设置好输出日志,使用新的日志文件
	
* 正常情况下,一般执行三到四次即可
* 实际判断方法:
  当前执行之后,生成的日志文件中 搜索 foreign 关键字,如果没有,说明没有外键约束了,说明可以不用重复执行(导入数据了)

	