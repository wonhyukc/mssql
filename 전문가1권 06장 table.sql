/*
	전문가로 가는 지름길 1 / 개발자용
	제 6장 소스 스크립트 
	정원혁 2000.12.
*/



SELECT * FROM williamc1.pubs.dbo.titles

SELECT * FROM pubs.dbo.titles

use pubs
SELECT * FROM dbo.titles

use master
SELECT * FROM dbo.titles
SELECT * FROM titles



SELECT PARSENAME('pubs..authors', 4) AS 'Server Name'


SELECT *
FROM ::fn_helpcollations()

create table a (
	KorName char(10) collate Korean_Wansung_CI_AS
,	NKorName char(10) collate Korean_Wansung_CI_AS
,	usNme char(10) collate Latin1_General_CI_AI
)


CREATE TABLE tempdb.dbo.empl (
	id	INT
,	name	CHAR(10)
)


CREATE TABLE tempdb.dbo.empl (
	id	INT	NOT NULL
,	name	CHAR(10)	NULL
)


ALTER TABLE sales
	ALTER COLUMN title_id CHAR(5) NOT NULL




DROP TABLE table_name


CREATE TABLE pk_test ( 
id 	INT	PRIMARY KEY
)


CREATE TABLE a ( 
	id INT NOT NULL
) 
GO
ALTER TABLE a ADD 
	CONSTRAINT PK_id PRIMARY KEY (id)


CREATE TABLE 사원 (
	id	INT
,	name	CHAR(10)
)

ALTER TABLE 사원
ADD dept_id VARCHAR(20) NULL

INSERT 사원 VALUES (1, '정세화', 1)
SELECT * FROM 사원

ALTER TABLE 사원
	ADD city CHAR(10) NOT NULL DEFAULT '서울'
SELECT * FROM 사원

ALTER TABLE 사원 ADD 
	CONSTRAINT PK_id PRIMARY KEY (id)

DROP TABLE 사원
CREATE TABLE 사원 ( 
	id 	INT	NOT NULL
,	name	CHAR(10) NOT NULL
,	city 	CHAR(10)	NOT NULL 	DEFAULT '서울'
) 
ALTER TABLE 사원 ADD 
	CONSTRAINT PK_id PRIMARY KEY (id)
go


exec sp_help 사원

exec sp_helpindex 사원


DROP TABLE 사원
CREATE TABLE 사원 ( 
	id 	INT	NOT NULL
		CONSTRAINT PK_사원	PRIMARY KEY
,	name	CHAR(10)	NOT NULL
,	city 	CHAR(10)	NOT NULL 	DEFAULT '서울'
) 
go
sp_help 사원


DROP TABLE 사원
CREATE TABLE 사원 ( 
	id 	INT	NOT NULL	PRIMARY KEY
,	name	CHAR(10)	NOT NULL
,	city 	CHAR(10)	NOT NULL 	DEFAULT '서울'
) 
go
exec sp_help 사원

DROP TABLE 사원


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[사원]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[사원]
GO


CREATE TABLE [dbo].[사원] (
	[사번] [int] NOT NULL ,
	[이름] [char] (10) COLLATE Korean_Wansung_CI_AS NOT NULL ,
	[시] [char] (10) COLLATE Korean_Wansung_CI_AS NOT NULL 
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[사원] WITH NOCHECK ADD 
	CONSTRAINT [PK_사원] PRIMARY KEY  CLUSTERED 
	(
		[사번]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[사원] WITH NOCHECK ADD 
	CONSTRAINT [DF_사원_시] DEFAULT ('서울') FOR [시]
GO



CREATE TABLE a (
	KORNAME CHAR(10) COLLATE KOREAN_WANSUNG_CI_AS
,	NKORNAME CHAR(10) COLLATE KOREAN_WANSUNG_CS_AS
,	USNME CHAR(10) COLLATE LATIN1_GENERAL_CI_AI
)
GO



insert a values ('aAa', 'aAa', 'aAa')
insert a values ('한글', '한글', '한글')
insert a values (N'한글', N'한글', N'한글')
go

select * from a where KorName = '한글'
select * from a where KorName = N'한글'
select * from a where NKorName = '한글'
select * from a where NKorName = N'한글'


select * from a where NKorName = 'aaa'
select * from a where NKorName = N'aAa'
select * from a where NKorName = 'aAa'


select * from a where KorName = 'aaa'
select * from a where KorName = N'aAa'
select * from a where KorName = 'aAa'

