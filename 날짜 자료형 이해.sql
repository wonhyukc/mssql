create table #a (
	사번	int		identity,
	입사일자	date
)
go
select getdate()
go

insert #a values (1, getdate())
select * from #a
go

insert #a values (getdate())
select * from #a
go

insert #a values ('20140410')
select * from #a
go
insert #a values ('2014.04.09')
select * from #a
go
insert #a values ('2014-04-09')
select * from #a
go


create table #a (
	사번	int		identity,
	입사일자	datetime
)
go
select getdate()
go

insert #a values (1, getdate())
select * from #a
go

insert #a values (getdate())
select * from #a
go 10

insert #a values ('20140410')
select * from #a
go
insert #a values ('2014.04.09 11:30:40.000')
select * from #a
go
insert #a values ('2014-04-09 11:20:41')
select * from #a
go
