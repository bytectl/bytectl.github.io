---
author: "wuxingzhong"
title: "Mysql测试2"
date: 2019-10-11T19:08:32+08:00
draft: false
tags: ["mysql", "测试"]
categories:  [""]
image: ""
banner: ""
comments: true     # set false to hide Disqus comments
share: true        # set false to share buttons
menu: ""           # set "main" to add this content to the main menu
---


## 批量插入用户

```sql

delimiter $$

drop procedure  if exists `user_proc`;
create procedure `user_proc`( )
begin
    declare uin bigint;
    declare i int;
    set i = 0;
    set uin =0;

    while i < 200000 do
        
        start transaction;
        update id_generate set uid = last_insert_id(uid+1) where tid='user';
        select last_insert_id() into uin;
        # 用户表
        insert into `user` (uin, identity, `level`, selfid, mobile,  passwd, nickname, realname, sex, photo, addr, country, birthday, 
                            occupation, sign, introduction, certstate, vip, `enable`, register_utc) 
		                        values(uin, 1, 1, CONCAT("selfid", uin), CONCAT("135998",uin), uin, CONCAT("wxz",uin), CONCAT("wxz",uin), 
                                    ROUND(RAND()*100, 0)%2 +1, "http:wxz.com/photo.jpg", "深圳", 
		                                "中国", 19930214, "IT", "IT", "IT", 1, 1, 1,  ROUND(RAND()*100000000, 0) ); 
		# 用户状态表
		insert into `user_state`(uin, state) values(uin, ROUND(RAND()*100, 0)%3 );
		# 用户gps表
        insert into `user_gps` (uin, lng, lat, wan_ip, country, province, city,  location) 
		                  values(uin,  (RAND()*100000%18000)/100, (RAND()*100000%9000)/100, "127.0.0.1", "中国", "广东", "深圳", "南山区");
        # 用户推荐表
				insert into `user_recommend` (uin, utc) values(uin, ROUND(RAND()*100000000, 0) );
        # 用户在线表
        insert into `online` (uin, sin, online, ttype,remote_ip,skt_idx,login_utc, logout_utc )
                             values(uin, 0,ROUND(RAND()*10, 0)%2, 1, 123, uin, ROUND(RAND()*100000000, 0), ROUND(RAND()*100000000, 0) );
                             
        # 用户认证表
        insert into `user_certificate` (uin, video_url, status, reason, utc ) values( uin, "http://url.com", 2, "太美了", ROUND(RAND()*100000000, 0) );
        # 用户收费视频设置
        insert into `user_payvideo_setting` (uin, price, freetime) values(uin, ROUND(RAND()*100, 0), ROUND(RAND()*100, 0)%2 );
        # 用户动态信息
        insert into `user_variable_info` (uin, tags, contribution, charm, focus_count, fans_count, signin_count, fav_count, devtype )
                  values(uin, "大大|御姐", 1,  1, 1, 1, 1, ROUND(RAND()*100000, 0), 1 );
        # 用户相册
        insert into `user_photo` (uin, photos) values(uin, "['http://127.0.0.1/image/1.jpg','http://127.0.0.1/image/2.jpg' ]" );
        
        commit;
        
        set i = i +1;
    end while;
     
end $$
delimiter ;

call user_proc;

-- InnoDB 20w 耗时 时间: 648.849s
-- MyISAM 20w 耗时 时间: 320.738s 

```

## 多次查询

```sql
delimiter $$
drop procedure  if exists `select_proc`;
create procedure `select_proc`( )
begin
    declare i int;
    set i = 0;
    start transaction;
    while i < 1000 do
		select uin, lat, lng from user_gps where user_gps.lng > 170  and user_gps.lat < 20;
        set i = i +1;
    end while;
    commit; 
    
end $$
delimiter ;

call select_proc;

```

### 测试过程(InnoDB)

1. count 测试

```sql
-- 无事务情况下(加事务情况相同)

select count(*) from user;                   # 20w 1000 次   时间: 70.699s
select count(uin) from user;                 # 20w 1000 次   时间: 76.744s
select count(*) from user where sex = 1;     # 20w 1000 次   时间: 141.966s  143.361s
select count(uin) from user where sex = 1;   # 20w 1000 次   时间: 161.654s  160.867s

```

1. select 字段数

```sql

select * from user where sex = 2;     # 20w 50次 时间: 58.896s
select uin from user where sex = 2;   # 20w 50次 时间: 9.753s

-- 子查询字段数
select uin, register_utc from (select uin, register_utc from user where sex = 2) as user_tmp  where register_utc > 9255225;  # 20w 100次  时间: 24.404s
select uin, register_utc from (select * from user where sex = 2) as user_tmp  where register_utc > 9255225;                  # 20w 100次  时间: 24.077s

```

1. sql连表查询测试

附近的人

```sql

delimiter $$
drop procedure  if exists `select_proc`;
create procedure `select_proc`( )
begin
    declare i int;
    set i = 0;
    while i < 1 do

        select user.uin as uin, nickname, sex, photo, birthday, sign, occupation, identity, level, vip, 
        certstate,  focus_count, fans_count, contribution, charm, fav_count, tags,
        state as camstate, photos,lng as distance 
        from (select uin, lng from user_gps where lng > 170  and lat < 20 order by lng limit 0, 100 ) as gps_tmp 
        left join user               on user.uin = gps_tmp.uin 
        left join user_state         on user.uin = user_state.uin 
        left join user_photo         on user.uin = user_photo.uin  
        left join user_variable_info on user.uin = user_variable_info.uin
        order by state desc;
       
        set i = i +1;
    end while;

end $$
delimiter ;

call select_proc;


# InnoDB 20w 耗时  平均时间: 0.1304s
# MyISAM 20w 耗时  平均时间: 0.0988s
```

推荐的人

```sql
        select user.uin as uin, nickname, sex, photo, birthday, sign, occupation, identity, level, vip, 
        certstate,  focus_count, fans_count, contribution, charm, fav_count, tags,
        state as camstate, photos,  register_utc,  u_tmp.utc from 
        (select user_recommend.*, state from user_recommend inner join user_state on user_recommend.uin = user_state.uin  order by user_state.state asc, utc desc limit 0, 100 ) as u_tmp 
        inner join user               on user.uin = u_tmp.uin
		inner join user_variable_info on user.uin = user_variable_info.uin
		inner join online             on user.uin = online.uin
        left join user_photo          on user.uin = user_photo.uin
        order by state, utc desc,  login_utc desc;
        
# InnoDB 20w 耗时 平均时间: 0.6955s
# MyISAM 20w 耗时 平均时间: 1.4944s
```

认证通过的人

```sql
        select user.uin as uin, nickname, sex, photo, birthday, sign, occupation, identity, level, vip, 
        certstate,  focus_count, fans_count, contribution, charm, fav_count, tags,
        IFNULL(state,2) as camstate, photos,  register_utc from 
        ((select u_ca.*, state from user_certificate as u_ca inner join user_state on u_ca.uin = user_state.uin order by user_state.state asc limit 0, 100 ) as u_tmp )
        inner join user               on user.uin = u_tmp.uin 
        inner join user_variable_info on user.uin = user_variable_info.uin
        inner join online             on user.uin = online.uin
        left join  user_photo         on user.uin = user_photo.uin
        order by state,  login_utc desc;

# InnoDB 20w 耗时 平均时间: 0.1450s
# MyISAM 20w 耗时 平均时间: 0.0831s
```

视频免费的人

```sql
    select user.uin as uin, nickname, sex, photo, birthday, sign, occupation, identity, level, vip, 
    certstate,  focus_count, fans_count, contribution, charm, fav_count, tags,
    state as camstate, photos,  register_utc from 
    ((select u_ps.*, state from user_payvideo_setting as u_ps inner join user_state on u_ps.uin = user_state.uin where u_ps.price=0 or u_ps.freetime > 0 order by state limit 0, 100 ) as u_tmp )
    inner join user               on user.uin = u_tmp.uin 
    inner join user_variable_info on user.uin = user_variable_info.uin
    inner join online             on user.uin = online.uin
    left join  user_photo         on user.uin = user_photo.uin
    order by state,  login_utc desc;

# InnoDB 20w 耗时 平均时间: 0.5943s
# MyISAM 20w 耗时 平均时间: 0.8501s       
    # 查询2 
    select u_tmp.uin as uin, nickname, sex, photo, birthday, sign, occupation, identity, level, vip, 
    certstate,  focus_count, fans_count, contribution, charm, fav_count, tags,
    state as camstate, photos,  register_utc from 
    ( (select user.*, state, ifnull(u_ps.price, 0) as price from user left join user_payvideo_setting as u_ps on u_ps.uin = user.uin 
        left join  user_state on u_ps.uin = user_state.uin where u_ps.price = 0 or u_ps.freetime > 0 order by state asc limit 0, 100) as u_tmp
    )
    inner join user_variable_info on u_tmp.uin = user_variable_info.uin
    inner join online             on u_tmp.uin = online.uin
    left join  user_photo         on u_tmp.uin = user_photo.uin
    order by state,  login_utc desc;

# InnoDB 20w 耗时 平均时间: 3.2311s
# MyISAM 20w 耗时 平均时间: 3.2021s
```

热门的人

```sql
    select user.uin as uin, nickname, sex, photo, birthday, sign, occupation, identity, level, vip, 
    certstate,  focus_count, fans_count, contribution, charm, fav_count, tags,
    state as camstate, photos,  register_utc from 
    ((select u_vi.*, state from user_variable_info as u_vi inner join user_state on u_vi.uin = user_state.uin order by state, fav_count desc limit 0, 100 ) as u_tmp )
    inner join user               on user.uin = u_tmp.uin 
    inner join online             on user.uin = online.uin
    left join  user_photo         on user.uin = user_photo.uin
    order by state, fav_count desc, login_utc desc;

# InnoDB 20w 耗时 平均时间: 2.4758s
# MyISAM 20w 耗时 平均时间: 3.5042s
```

新秀

```sql
    select user.uin as uin, nickname, sex, photo, birthday, sign, occupation, identity, level, vip, 
    certstate,  focus_count, fans_count, contribution, charm, fav_count, tags,
    state as camstate, photos,  register_utc from 
    ((select online.*, state from online inner join user_state on online.uin = user_state.uin order by state asc limit 0, 100 ) as u_tmp )
    inner join user               on user.uin = u_tmp.uin 
    inner join user_variable_info on user.uin = user_variable_info.uin
    left join  user_photo         on user.uin = user_photo.uin
    order by state, register_utc desc, login_utc desc;

# InnoDB 20w 耗时 平均时间: 0.1509s
# MyISAM 20w 耗时 平均时间: 0.0782s
```

## 数据批量插入

### 测试用户表

```sql
-- 用户基本信息
drop table if exists `user`;
create table `user`
(
  -- 用户ID，主键，配合id_generate表生成，保证全局唯一性
  uin         bigint unsigned not null,
  -- 用户身份 (1-普通用户(粉丝),2-男神,3-女神，99-机器人)
  identity tinyint not null default 1,
  -- 用户级别(根据用户的贡献值自动换算)
  level tinyint not null default 0,
  -- 自定义（全局唯一索引，可作为登陆凭据）
  selfid      char(128),
  -- 手机号（全局唯一，可作为登陆凭据）
  mobile      char(16),
  -- email（全局唯一，可作为登陆凭据）
  email       varchar(128),
  -- 密码
  passwd      char(32)  not null,
  -- 昵称
  nickname    varchar(128) default '',
  -- 真实姓名
  realname    varchar(128) default '',
  -- 性别 0-未知 1-男 2-女
  sex         tinyint      default 0,
  -- 头像
  photo       varchar(255) default '',
  -- 住址
  addr        varchar(255) default '',
  -- 国家
  country     varchar(128) default '',
  -- 生日, 格式：yyyyMMdd 8位整数
  birthday    int unsigned default 0,
  -- 职业
  occupation varchar(32) not null default '',
  -- 个性签名
  sign varchar(255) not null default '',
  -- 个人介绍，有字数限制
  introduction varchar(512) not null default "",
  -- 认证标志 0-未认证，1-已认证
  certstate tinyint not null default 0,
  -- 会员标志 0-非会员， 1-会员
  vip tinyint not null default 0,
  -- 开通状态 0-禁用 1-启用
  enable      char         default 0,
  -- 注册时间
  register_utc  bigint       default 0,
  -- 主键
  primary key (uin),
  -- 唯一索引
  unique key (selfid),
  unique key (mobile),
  unique key (email)
) ENGINE = InnoDB default charset = utf8;
```

### InnoDB 引擎

测试数据量 200000 (20万)

1. 不使用事务
  
```sql
delimiter $$
drop procedure  if exists `user_proc`;
create procedure `user_proc`( )
begin
    declare uin bigint;
    declare i int;
    set i = 1;
    set uin =0;
    while i < 200000 do
				set uin = i;
        insert into `user` (uin, identity, `level`, selfid, mobile,  passwd, nickname, realname, sex, photo, addr, country, birthday, 
occupation, sign, introduction, certstate, vip, `enable`, register_utc) 
		values(uin, 1, 1, CONCAT("selfid", uin), CONCAT("135998",uin), uin, CONCAT("wxz",uin), CONCAT("wxz",uin), 2, "http://wxz.com/photo.jpg", "深圳", 
		"中国", 19930214, "IT", "IT", "IT", 1, 1, 1, 1501234567);
        set i = i +1;
    end while;
end $$
delimiter ;
call user_proc;

-- 耗时
271.285s

```

1. 使用事务
  
```sql
delimiter $$
drop procedure  if exists `user_proc`;
create procedure `user_proc`( )
begin
    declare uin bigint;
    declare i int;
    set i = 1;
    set uin =0;
    start transaction;
    while i < 200000 do
				set uin = i;
        insert into `user` (uin, identity, `level`, selfid, mobile,  passwd, nickname, realname, sex, photo, addr, country, birthday, 
occupation, sign, introduction, certstate, vip, `enable`, register_utc) 
		values(uin, 1, 1, CONCAT("selfid", uin), CONCAT("135998",uin), uin, CONCAT("wxz",uin), CONCAT("wxz",uin), 2, "http:wxz.com/photo.jpg", "深圳", 
		"中国", 19930214, "IT", "IT", "IT", 1, 1, 1, 1501234567); 
        set i = i +1;
    end while;
    commit;
end $$
delimiter ;
call user_proc;

-- 耗时
51.919s

```

### MyISAM 引擎

测试数据量 200000 (20万)

1. 不使用事务(不支持事务)

耗时: 63.914s


```sql
select tmp.uin, ifnull(user.uin,0)  from 
(select 10006 as uin  
union select  10007  
union select 10008 
union select 10009 )as tmp 
left join user on tmp.uin=user.uin;

```

## 使用临时表

```sql
create temporary    table tmp_table(uin bigint);
insert into tmp_table values(10004),(10005),(10006),(10007),(10008),(10009);
select * from tmp_table;

select tmp.uin, ifnull(user.uin,0) as uin2    from  tmp_table as tmp left join user on tmp.uin=user.uin;

```

日期生成

```sql

set @i = -1;

set @sql = repeat(" select 1 union all",-datediff('2021-01-01','2030-12-31')+1);

set @sql = left(@sql,length(@sql)-length(" union all"));

set @sql = concat("select date_add('2021-01-01',interval @i:=@i+1 day) as date from (",@sql,") as tmp");

prepare stmt from @sql;

execute stmt;
deallocate  prepare  stmt;

```

```sql

set @i:=0; select date_add('2008-02-27 00:00:01',interval @i:=@i+1 day) as date, uin from user ;

```
