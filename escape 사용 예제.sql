use tempdb
go
drop table a
go
create table  a(a varchar(30))
go
insert a values ('a''b')
insert a values ('a%c')
insert a values ('c%d')
insert a values ('%%')
go
select * from a where a like 'a!%c' escape '!'
select * from a where a like '%!%%' escape '!'
select * from a where a like '%%%%' escape '%'
