--*
--* 6.1 HRDB 데이터베이스
--*


-- 1) 데이터베이스 만들기

USE master
GO

IF DB_ID('HRDB') IS NOT NULL
BEGIN
    ALTER DATABASE HRDB
		SET SINGLE_USER 
		WITH ROLLBACK IMMEDIATE
	DROP DATABASE HRDB
END
GO

CREATE DATABASE HRDB
GO


-- 2) 테이블 만들기

USE HRDB
GO

SET NOCOUNT ON
GO

-- Unit 테이블 만들기
CREATE TABLE dbo.Unit (
	UnitID char(1) PRIMARY KEY,
	UnitName nvarchar(10) NOT NULL
)
GO

INSERT INTO dbo.Unit VALUES('A', N'제1본부')
INSERT INTO dbo.Unit VALUES('B', N'제2본부')
INSERT INTO dbo.Unit VALUES('C', N'제3본부')
GO

-- Department 테이블 만들기
CREATE TABLE dbo.Department (
	DeptID char(3) PRIMARY KEY,
	DeptName nvarchar(10) NOT NULL,
	UnitID char(1) REFERENCES dbo.Unit(UnitID) NULL,
	StartDate date NOT NULL
)
GO

INSERT INTO dbo.Department VALUES('SYS', N'정보시스템', 'A', '2007-01-01')
INSERT INTO dbo.Department VALUES('MKT', N'영업', 'C', '2006-05-01')
INSERT INTO dbo.Department VALUES('HRD', N'인사', 'B', '2006-05-01')
INSERT INTO dbo.Department VALUES('GEN', N'총무', 'B', '2007-03-01')
INSERT INTO dbo.Department VALUES('ACC', N'회계', 'B', '2006-04-01')
INSERT INTO dbo.Department VALUES('ADV', N'홍보', 'C', '2009-06-01')
INSERT INTO dbo.Department VALUES('STG', N'전략기획', NULL, '2009-06-01')
GO

-- Employee 테이블 만들기
CREATE TABLE dbo.Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(4) NOT NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) REFERENCES Department(DeptID) NOT NULL,
	EMail varchar(50) NOT NULL,
	Salary int NULL
)
GO

-- 데이터 추가
INSERT INTO dbo.Employee VALUES('S0001', N'홍길동', 'M', '2006-01-01', NULL, 'SYS', 'hong@itforum.co.kr', 8500)
INSERT INTO dbo.Employee VALUES('S0002', N'일지매', 'M', '2006-01-12', NULL, 'GEN', 'jimae@itforum.co.kr', 8200)
INSERT INTO dbo.Employee VALUES('S0003', N'강우동', 'M', '2006-04-01', NULL, 'SYS', 'hodong@itforum.co.kr', 6500)
INSERT INTO dbo.Employee VALUES('S0004', N'김삼순', 'F', '2006-08-01', NULL, 'MKT', 'samsoon@itforum.co.kr',	7000)
INSERT INTO dbo.Employee VALUES('S0005', N'오삼식', 'M', '2007-01-01', '2009-01-31','MKT', 'samsik@itforum.co.kr', 6400)
INSERT INTO dbo.Employee VALUES('S0006', N'김치국', 'M', '2007-03-01', NULL, 'HRD', 'chikook@itforum.co.kr',	6000)
INSERT INTO dbo.Employee VALUES('S0007', N'안경태', 'M', '2007-05-01', NULL, 'ACC', 'ahn@itforum.co.kr', 6000)
INSERT INTO dbo.Employee VALUES('S0008', N'박여사', 'F', '2007-08-01', '2007-09-30','HRD', 'yeosa@itforum.co.kr', 6300)
INSERT INTO dbo.Employee VALUES('S0009', N'최사모', 'F', '2007-10-01', NULL, 'SYS', 'samo@itforum.co.kr', 5800)
INSERT INTO dbo.Employee VALUES('S0010', N'정효리', 'F', '2008-01-01', NULL, 'MKT', 'hyori@itforum.co.kr', 5000)
INSERT INTO dbo.Employee VALUES('S0011', N'오감자', 'M', '2008-02-01', NULL, 'SYS', 'gamja@itforum.co.kr',4700)
INSERT INTO dbo.Employee VALUES('S0012', N'최일국', 'M', '2008-02-01', NULL, 'GEN', 'ilkook@itforum.co.kr', 6500)
INSERT INTO dbo.Employee VALUES('S0013', N'한국인', 'M', '2008-04-01', NULL, 'SYS', 'hankook@itforum.co.kr', 4500)
INSERT INTO dbo.Employee VALUES('S0014', N'이최고', 'M', '2008-04-01', NULL, 'MKT', 'one@itforum.co.kr', 5000)
INSERT INTO dbo.Employee VALUES('S0015', N'박치기', 'M', '2008-06-01', '2009-05-31','MKT', 'chichi@itforum.co.kr', 4700)
INSERT INTO dbo.Employee VALUES('S0016', N'한사랑', 'F', '2008-06-01', NULL, 'HRD', 'love@itforum.co.kr', 7200)
INSERT INTO dbo.Employee VALUES('S0017', N'나도야', 'M', '2008-12-01', NULL, 'ACC', 'yaya@itforum.co.kr', 4000)
INSERT INTO dbo.Employee VALUES('S0018', N'이리와', 'M', '2009-01-01', '2009-06-30','HRD', 'comeon@itforum.co.kr', 5300)
INSERT INTO dbo.Employee VALUES('S0019', N'정주고', 'M', '2009-01-01', NULL, 'SYS', 'give@itforum.co.kr', 6000)
INSERT INTO dbo.Employee VALUES('S0020', N'고소해', 'F', '2009-04-01', NULL, 'STG', 'haha@itforum.co.kr', 5000)
GO

-- Vacation 테이블 만들기
CREATE TABLE dbo.Vacation (
	VacationID int IDENTITY PRIMARY KEY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID),
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'개인사유',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate)
)
GO

INSERT INTO dbo.Vacation VALUES('S0001', '2006-12-24', '2006-12-26', N'크리스마스 기념 가족 여행')
INSERT INTO dbo.Vacation VALUES('S0003', '2007-01-01', '2007-01-07', N'신년 맞이 기분 내기')
INSERT INTO dbo.Vacation VALUES('S0001', '2007-05-04', '2007-05-04', N'어린이날 이벤트 준비')
INSERT INTO dbo.Vacation VALUES('S0011', '2009-03-01', '2009-03-02', DEFAULT)
INSERT INTO dbo.Vacation VALUES('S0014', '2009-06-05', '2009-06-06', N'부모님 환갑잔치')
INSERT INTO dbo.Vacation VALUES('S0019', '2010-10-08', '2010-10-16', N'신종플루')
INSERT INTO dbo.Vacation VALUES('S0001', '2010-12-02', '2010-12-05', N'율도국 관광')
INSERT INTO dbo.Vacation VALUES('S0012', '2010-12-15', '2010-12-18', N'감기몸살')
INSERT INTO dbo.Vacation VALUES('S0009', '2010-12-26', '2010-12-26', N'크리스마스 후유증')
INSERT INTO dbo.Vacation VALUES('S0016', '2011-01-03', '2011-01-15', N'달나라 여행')
GO 

SET NOCOUNT OFF
GO