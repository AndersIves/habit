create database habit;
use habit;
create table if not exists user_photo (
    photo_id int auto_increment primary key,
    photo mediumblob
);
create table if not exists coin (
    coin_id int auto_increment primary key,
    coins int not null
);
create table if not exists user_info (
    info_id int auto_increment primary key,
    photo_id int not null,
    coin_id int not null,
    user_name varchar(128),
    gender varchar(128),
    birthday varchar(128),
    foreign key(photo_id) references user_photo(photo_id),
    foreign key(coin_id) references coin(coin_id)
);
create table if not exists user (
    uid int auto_increment primary key,
    info_id int not null,
    email varchar(128) unique not null,
    pwd varchar(128) not null,
    foreign key(info_id) references user_info(info_id)
);
create table if not exists follow (
    id int auto_increment primary key,
    uid int not null,
    follow_uid int not null,
    foreign key(uid) references user(uid),
    foreign key(follow_uid) references user(uid)
);
create table if not exists goods (
    goods_id int auto_increment primary key,
    name varchar(128),
    price int,
    count int not null,
    description text,
    goods_token varchar(128)
);
create table if not exists purchased (
    id int auto_increment primary key,
    uid int not null,
    goods_id int not null,
    foreign key(uid) references user(uid),
    foreign key(goods_id) references goods(goods_id)
);