---
author: "wuxingzhong"
title: "Sql操作"
date: 2019-10-11T19:08:35+08:00
draft: false
tags: [""]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---

## 导出数据库

```sql
mysqldump -u root -p -h xxx -P 3306  数据库 [表名] >xxx.sql
```

## 导入数据

```sql
create database 数据库名称;
use 数据库;
source xxx.sql

```

## 自定义排序

```sql
SELECT * FROM `user_contacts` ORDER BY initial REGEXP '^[a-z]' desc, initial
```

## 不存在则插入, 存在则更新

```sql
insert into `user_third`(id, qq_id, qq_name) values(?,?,?) 
on duplicate key update qq_id=?, qq_name =? " ;

```

## 添加字段

```sql
alter table table_name add field_info .... ;
```

## 更新

```sql
update user_variable_info set focus_count= (select count(uin) from user_focus where uin=10023) + (select count(uin) from user_focus_anchor where uin=10023)
```

## 授权远程访问

```sql
GRANT ALL PRIVILEGES ON 数据库名.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION

flush privileges;

# 查看权限
use mysql;
select host,user from user;

```

## 格式化 utc

```sql
SELECT FROM_UNIXTIME(utc/1000, '%Y-%m-%d') as utc , from user ;

SELECT uin, nickname, FROM_UNIXTIME(register_utc/1000, '%Y-%m-%d %H:%i:%s') as utc FROM user ;

```

## mysql 锁事务

```sql
show processlist;

select * from information_schema.innodb_trx;

```

## 操作日志查看

```bash
mysqlbinlog --no-defaults --database=moyu   mysql-bin.000004 > log.txt

# 有base64编码的
mysqlbinlog --base64-output=decode-rows -v  /var/lib/mysql/log-bin.000015 |more
```

开启 查询日志 (查询日志需要手动开启)

```sql
show variables like '%general_log%';

-- 开启通用日志查询
set global general_log=on;
-- 关闭通用日志查询
set global general_log=off;
-- 设置通用日志输出为表方式
set global log_output='TABLE';

-- 设置通用日志输出为文件方式
set global log_output='FILE';

-- 设置通用日志输出为表和文件方式
set global log_output='FILE,TABLE';

-- 注意：上述命令只对当前生效，当MySQL重启失效，如果要永久生效，需要配置my.cnf

select * from mysql.general_log;
```

## 清理日志

```bash

# mysql -u root -p
> purge master logs to 'mysql-bin.010’; //清除mysql-bin.010日志
> purge master logs before '2016-02-28 13:00:00'; //清除2016-02-28 13:00:00前的日志
> purge master logs before date_sub(now(), interval 3 day); //清除3天前的bin日志

```

```sql

# 设置日志过期时间
show binary logs;
show variables like '%log%';
set global expire_logs_days = 7;

```

## 连接数

```sql

# 查看连接数
show status like 'Threads%';

+-------------------+-------+
| Variable_name     | Value |
+-------------------+-------+
| Threads_cached    | 58    |
| Threads_connected | 57    |   # 打开的连接数
| Threads_created   | 3676  |
| Threads_running   | 4     |   # 激活的连接数，一般远低于connected
+-------------------+-------+


# 查看
show variables like '%max_connections%';

# 设置的最大连接数
set global max_connections=1000;

```

## 锁表情况

```sql
show status like 'Table%';
show status like 'innodb_row_lock%';
show processlist;
show open TABLES;
```

## 存储过程

```sql

delimiter $$
drop procedure  if exists `id_gen`;
create procedure `id_gen`(in tableName char(64) )
begin
    set @id = 0;
    update id_generate set uid = last_insert_id(uid+1) where tid=tableName;
    select last_insert_id() into @id; 
    select @id;

end $$
delimiter ;
call id_gen('user')

```
