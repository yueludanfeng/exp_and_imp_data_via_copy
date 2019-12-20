-- 为了模拟实际环境,在"实验室老环境"中执行了如下操作(模拟有数据的无约束的表以及有主键与外键约束的表)
create table ta(id int) ;
create table tb(id int, name varchar);
insert into ta select n from generate_series(1,10) n;
insert into tb select n as id, n ||'name' as name from generate_series(1,10) n;

drop table t1 cascade;
drop table t2 cascade;
drop table t3 cascade;

create table t3(id int primary key, name varchar);
create table t2(id int primary key, name varchar unique, fid int , constraint fk_t2_fid foreign key(fid) references t3(id));
create table t1(id int primary key, name varchar , constraint fk_t1_name foreign key(name) references t2(name)) ;
insert into t3 values(1,'a'),(2,'b');
insert into t2 values(1,'a',1),(2,'b',2);
insert into t1 values(1,'a','a'),(2,'b','a');



-- 为了模拟实际环境,在"实验室新环境"中执行了如下操作(模拟空表)
create table ta(id int) ;
create table tb(id int, name varchar);

create table t3(id int primary key, name varchar);
create table t2(id int primary key, name varchar unique, fid int , constraint fk_t2_fid foreign key(fid) references t3(id));
create table t1(id int primary key, name varchar , constraint fk_t1_name foreign key(name) references t2(name)) ;