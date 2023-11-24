create table rolePage (
    id int primary key,
    name varchar(256) not null
);
-- insert statements for one to many
insert into rolePage(id, name) values (1, 'user');
insert into rolePage(id, name) values (2, 'admin');
insert into rolePage(id, name) values (0, 'undefined');

create table userLogin (
    name varchar(256) not null,
    password varchar(256) not null,
    status varchar(256) not null,
    vpnVerification int not null
);

create table adminLogin (
    name varchar(256) not null,
    password varchar(256) not null,
    status varchar(256) not null,
    vpnVerification int not null
);

ALTER TABLE userLogin add column id_rolePage int;
ALTER TABLE userLogin add foreign key (id_rolePage) references rolePage(id);
ALTER TABLE adminLogin add column id_rolePage int;
ALTER TABLE adminLogin add foreign key (id_rolePage) references rolePage(id);

-- insert statements
insert into userLogin(name, password, status, vpnVerification)
    values ('user1', '1', 'restricted', 0),
           ('user2', '12', 'not restricted', 0),
           ('user3', '123', 'not restricted', 0),
           ('user4', '1234', 'restricted', 0),
           ('user5', '12345', 'restricted', 1),
           ('user5.1', '12345.1', 'restricted', 0),
           ('user5.12', '12345.2', 'restricted', 0),
           ('user5.3', '12345.3', 'error', 0),
           ('user5.4', '12345.4', 'error', 0);

insert into adminLogin(name, password, status, vpnVerification)
    values ('admin1', 'a1', 'not restricted', 0),
           ('admin2', 'a12', 'not restricted', 0),
           ('admin3', 'a123', 'restricted', 0),
           ('admin4', 'a1234', 'restricted', 1),
           ('admin5', 'a12345', 'restricted', 1),
           ('admin5.1', 'a12345.1', 'undefined', 2),
           ('admin6', 'a123456', 'error code 1', -1),
           ('admin7', 'a1234567', 'error code 1', -1);

-- select statements
select * from userLogin;
select * from adminLogin;
select userLogin.name from userLogin where status = 'restricted';
select adminLogin.name from adminLogin where status = 'undefined';
select adminLogin.name from adminLogin where status = 'error code 1' and vpnVerification= -1;

-- update statements
update userLogin set password = '0' where name LIKE 'user5.1%';
update userLogin set password = '0.e' where status = 'error';
update adminLogin set status = 'not restricted', vpnVerification = '0' where vpnVerification = 2;

-- remove/delete statements
delete from userLogin where password = '0';
delete from userLogin where password = '0.e' and status = 'error';
delete from adminLogin where status = 'restricted' and vpnVerification = 1;
delete from adminLogin where status = 'undefined'; -- !no variable = no deleting!
delete from adminLogin where status = 'error code 1' and vpnVerification = -1;

-- update statements for joins
update userLogin set id_rolePage = 1 where status = 'not restricted';
update adminLogin set id_rolePage = 2 where status = 'not restricted';
update userLogin set id_rolePage = 0 where status = 'restricted';
update adminLogin set id_rolePage = 0 where status = 'restricted';

-- inner joins
select * from userLogin
    INNER JOIN adminLogin ON userLogin.id_rolePage = adminLogin.id_rolePage;

select * from userLogin
    INNER JOIN adminLogin ON userLogin.vpnVerification = adminLogin.vpnVerification;
-- left joins
select * from userLogin u
    LEFT JOIN adminLogin a ON u.id_rolePage = a.id_rolePage;

select * from userLogin u
    LEFT JOIN adminLogin a ON u.vpnVerification = a.vpnVerification;

-- right joins
select * from userLogin u
    RIGHT JOIN adminLogin a ON u.id_rolePage = a.id_rolePage;

select * from userLogin u
    RIGHT JOIN adminLogin a ON u.vpnVerification = a.vpnVerification;

-- full join
select * from userLogin
    FULL JOIN adminLogin ON userLogin.id_rolePage = adminLogin.id_rolePage;

select * from userLogin
    FULL JOIN adminLogin ON userLogin.vpnVerification = adminLogin.vpnVerification;

-- delete tables
drop table userLogin;
drop table adminLogin;
drop table rolePage;