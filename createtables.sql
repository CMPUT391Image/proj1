drop table users;
drop table persons;
drop table groups;
drop table group_lists;
drop table images;

create table users(user_name varchar(30),password varchar(30),date_registered date, primary key(user_name));

create table persons(user_name varchar(30), first_name varchar(30),last_name varchar(30), address varchar(30), email varchar(50),phone varchar(10),primary key(user_name));

create table groups(group_id int, user_name varchar(30),group_name varchar(30),date_created date, primary key(group_id));

create table group_lists(group_id int, friend_id int,date_added date, notice varchar(30), primary key(group_id)); 