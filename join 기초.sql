use tempdb
go

create table 학생(학번 int, 학과 int)
go
create table 학과 (학과 int)
go

insert 학생 values (1, 1)
insert 학생 values (2, 1)
insert 학생 values (3, 2)
insert 학생 values (99, 4)
go


insert 학과 values (1)
insert 학과 values (2)
insert 학과 values (3)
go

select *
from 학생 s	inner join 학과 m	on s.학과 = m.학과



select *
from 학생 s	right outer join 학과 m	on s.학과 = m.학과

select *
from 학생 s	left outer join 학과 m	on s.학과 = m.학과
where m.학과 is null

select *
from 학생 s	left outer join 학과 m	on s.학과 = m.학과
where s.학과 is null





select *
from 학생 s	full outer join 학과 m	on s.학과 = m.학과
