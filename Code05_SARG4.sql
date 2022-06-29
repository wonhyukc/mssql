select * into c from charge
create index ix on c (charge_amt)

select * from c where charge_amt not between 1 and 4999

WHERE 부서코드 = 3	--부서코드: char(3) 

drop table m
select * into m from member
update m set city = '3' where member_no < 10
create index ix on m (city)
go

                     [Credit].[dbo].[m].city = 스칼라 연산자('3')
CONVERT_IMPLICIT(int,[Credit].[dbo].[m].[city],0)=(3)

select * from m where city = '3'
select * from m where city = N'3'
select * from m where convert(int, city) = 3



WHERE 부서코드 = 3	--부서코드: char(3) 

WHERE char_type = N'유니코드'

WHERE 구분코드 = 1	--구분코드: bit

WHERE 날짜 = 19790314	--날짜: char(8)

WHERE 날짜 = '19790314'
@sql = '… WHERE 날짜 = ' + @검색일 
@sql = '… WHERE 날짜= ' + '''@검색일'''
select SQRT(3)
SELECT * FROM charge WHERE charge_amt < SQRT(3)
SELECT * FROM charge WHERE charge_amt < CONVERT(money, SQRT(3))
SELECT * FROM charge WHERE charge_amt < 1.73


/*
CONVERT_IMPLICIT(float(53),[Credit].[dbo].[charge].[charge_amt],0)<sqrt(CONVERT_IMPLICIT(float(53),[@1],0))

[Credit].[dbo].[charge].[charge_amt]<CONVERT(money,sqrt(CONVERT_IMPLICIT(float(53),[@1],0)),0)

검색 키[1]: 시작: [Credit].[dbo].[charge].charge_amt > 스칼라 연산자([Expr1004]), 끝: [Credit].[dbo].[charge].charge_amt < 스칼라 연산자([Expr1005])
*/



DECLARE @명령문 varchar(3000)
,	@시작일 varchar(8)
SET @시작일 = '20061024'
SET @명령문 = 'SELECT ... FROM ... WHERE 판매일 = '
SET @명령문 = @명령문 + @시작일
SET @명령문 = @명령문 + '''+ @시작일+ '''





select * from c
create index cx on c (charge_dt)
dbcc show_statistics (c, cx)


select * from c where charge_dt < '2005-11-14 17:09:48'

declare @시작일 datetime = '2005-11-14 17:09:48'
select * from c where charge_dt < @시작일

select * from c where charge_dt between '2004.1.1' and '2005-11-14 17:09:48'
select DATEDIFF(s, '2004.1.1' , '2005-11-14 17:09:48')

select * from c where charge_dt between '2004.1.1' and DATEADD (s, 59072988, '2004.1.1')



declare @시작일 datetime = '2005-11-14 17:09:48'
select * from c where charge_dt between @시작일 and @시작일 + 7

select * from c where charge_dt >= GETDATE() - 7