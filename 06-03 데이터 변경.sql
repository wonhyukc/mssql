--*
--* 6.3 데이터 변경
--*



--*
--* A. INSERT
--*


USE HRDB
GO

-- 1) 기본적인 INSERT 문

-- 대상 열 나열
INSERT INTO dbo.Department(DeptID, DeptName, UnitID, StartDate)
   VALUES('PRD', N'상품', 'A', GETDATE())
GO

SELECT * FROM dbo.Department
GO


-- 대상 열 생략
INSERT INTO dbo.Department
   VALUES('DBA', N'DB관리', 'A', GETDATE())
GO


-- 2) 동시에 여러 행 INSERT 가능(2008부터)

INSERT INTO dbo.Department
   VALUES('OPR', N'운영', 'A', GETDATE()), ('CST', N'고객서비스', NULL, GETDATE())
GO

SELECT * FROM dbo.Department
GO

-- 3) 상위 n 개 INSERT

-- 테이블 만들기
SELECT * 
	INTO dbo.SampleVacation
	FROM dbo.Vacation
	WHERE 1 = 0
GO

-- 상위 5 건만 INSERT
INSERT TOP (5) 
   INTO dbo.SampleVacation
   SELECT EmpID, BeginDate, EndDate, Reason, Duration
      FROM dbo.Vacation
	  ORDER BY BeginDate DESC
GO

SELECT * FROM dbo.SampleVacation
GO


-- 4) 저장 프로시저 결과 INSERT

-- 저장 프로시저 만들기
CREATE PROC dbo.usp_GetVacation
	@EmpID char(5)
AS
	SELECT EmpID, BeginDate, EndDate, Duration
		FROM dbo.Vacation
		WHERE EMpID = @EmpID
GO

-- 임시 테이블 만들기
CREATE TABLE #Vacation (
   EmpID char(5),
   BeginDate datetime,
   EndDate datetime,
   Duration int
)
GO

-- 저장 프로시저 결과 INSERT
INSERT INTO #Vacation EXEC dbo.usp_GetVacation 'S0001'
GO

SELECT * FROM #Vacation
GO


-- 5) IDENTITY 속성에 INSERT

DELETE dbo.Vacation
	WHERE VacationID = 2
GO

SELECT * FROM dbo.Vacation
GO

-- 일반적인 INSERT는 오류 발생
INSERT INTO dbo.Vacation(VacationID, EmpID, BeginDate, EndDate, Reason)
   VALUES(2, 'S0003', '2007-01-02', '2007-01-08', N'신년 맞이 기분 내기')
GO

-- 임의의 값 INSERT 하기
SET IDENTITY_INSERT dbo.Vacation ON
GO
INSERT INTO dbo.Vacation(VacationID, EmpID, BeginDate, EndDate, Reason)
   VALUES(2, 'S0003', '2007-01-02', '2007-01-08', N'신년 맞이 기분 내기')
GO
SET IDENTITY_INSERT dbo.Vacation OFF
GO
SELECT * FROM dbo.Vacation
GO



--*
--* B. UPDATE
--*


-- 1) 기본적인 UPDATE 문

UPDATE dbo.Employee
   SET EmpName = N'홍길퉁'
   WHERE EmpID = 'S0001'
GO

SELECT * 
	FROM dbo.Employee
	WHERE EmpID = 'S0001'
GO


-- 2) FROM 절을 사용한 다양한 조건 지정

UPDATE dbo.Employee
   SET Salary = Salary * 0.8
   FROM dbo.Employee e1
   WHERE (SELECT COUNT (*) 
             	FROM dbo.Vacation 
		WHERE EmpID = e1.EmpID) > 2
GO


--*
--* C. DELETE
--*


-- 1) 기본적인 DELETE문

DELETE dbo.Vacation
   WHERE VacationID = 10
GO

-- TRUNCATE TABLE

TRUNCATE TABLE dbo.Vacation
GO
