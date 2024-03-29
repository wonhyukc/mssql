/*
	전문가로 가는 지름길 1 / 개발자용
	제 9장 소스 스크립트 
	정원혁 2000.1
*/


print '메시지'
select '메시지' 



DECLARE @id	int
,	@name	char(20)
SELECT @id = 10		-- 초기화 한다.
SELECT @id		-- 초기화 한 값을 출력한다.
SELECT @id, 'A' 		--1)
go

DECLARE @id	int
,	@name	char(20)
SELECT @id = 10		-- 초기화 한다.
SELECT @id		-- 초기화 한 값을 출력한다.
PRINT @id, 'A' -- 허용되지 않는다.
GO


declare @var1 varchar(100)
select @var1 = formatmessage(50002, 5, 'table1')
select @var1 +'.....'
go


DECLARE…
SET…
table_loop:                            --1)
.
.
.
IF ……… GOTO table_loop                --2) 
.




IF @begin > @end
	BEGIN
		SELECT '시작일자는 끝 날짜보다 작아야 합니다.'
		RETURN
	END
ELSE 
	SELECT … FROM … WHERE date1 BETWEEN @begin AND @end




while 조건
begin
	while조건을 벗어날 조치
	if ... continue
	if ... break
end



----------
EXECUTE  stored_procedure
exec sp_help



USE pubs
DECLARE 	@sql	VARCHAR(8000)
SET @sql = 'SELECT COUNT(*) FROM '	-- FROM 다음에 한 칸의 빈 칸이 있다.
SET @sql = @sql + 'titles'
select @sql

EXEC(@sql)
go


set nocount on
select * from sales
select @@rowcount
set nocount off



-------------------------
SELECT NULLIF(2,3)	--2를 리턴
SELECT NULLIF(3,3)	--널을 리턴


SELECT COALESCE(NULL, 1, 2)	-- 1을 리턴
SELECT COALESCE(1, NULL, 2)	-- 1을 리턴
SELECT COALESCE(NULL, NULL, 1)	-- 1을 리턴
go
SELECT COALESCE(NULL, NULL, NULL)	-- 이건 얼마일까?
go


SELECT x = 1
GO 5


sqlcmd /Q "SELECT COUNT(*) FROM sales" /d pubs /E /S servername\instance
go


USE tempdb
CREATE TABLE t (id int, name char(1))
GO
ALTER TABLE t
	DROP COLUMN name
--GO가 있어야 한다.
INSERT t VALUES (1)
go

-------------------------
SELECT COUNT(*) FROM table1
SELECT COUNT(*) FROM table2
SELECT COUNT(*) FROM table3


SELECT name FROM sysobjects WHERE type = 'U'	--6.5 방식


SET NOCOUNT ON
DECLARE @name varchar(80)
SELECT @name = ' '	-- 초기화
WHILE @name IS NOT NULL
BEGIN
	SELECT @name = MIN(table_name) FROM information_schema.tables 
	WHERE table_type = 'base table'
-- 1)		AND table_name > @name
 	IF @name IS NOT NULL
	BEGIN		
		SELECT '가져온 테이블 이름 : ' + @name
-- 2)		EXEC ('SELECT COUNT(*) FROM [' + @name+']')
	END
END
go


use tempdb
set nocount on
go

DECLARE @i int, @sql varchar(1000)
SET @i = 0

WHILE @i < 30
BEGIN
	SET @i = @i + 1
	SET @sql = 'CREATE TABLE a' + convert(varchar(3), @i) + ' ( '
	SET @sql = @sql + 'id int)'
	select @sql
	EXEC (@sql)
END
go


select name 
from sysobjects 
where type = 'U' and name like 'a%'
order by name


DECLARE @i	INT
SET @i = 0
SELECT @i	--1)
GO

SELECT @i = @i + 100	--2)
SET @j = 100
SELECT @j = @j + @i	--3)
GO

