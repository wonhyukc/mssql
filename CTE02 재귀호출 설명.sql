use tempdb
go

-- 테이블 만들기
IF OBJECT_ID('dbo.Employee02', 'U') IS NOT NULL
	DROP TABLE dbo.Employee02
GO

CREATE TABLE dbo.Employee02 (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(10) NOT NULL,
	ManagerID char(5) REFERENCES dbo.Employee02(EmpID) NULL,
	EMail varchar(60) NULL
)
GO

INSERT INTO dbo.Employee02 VALUES('S0001', N'홍길동', NULL, 'hong@test.com')
INSERT INTO dbo.Employee02 VALUES('S0002', N'일지매', 'S0001', 'jiemae@test.com')
INSERT INTO dbo.Employee02 VALUES('S0003', N'강우동', 'S0001', 'kang@test.com')
INSERT INTO dbo.Employee02 VALUES('S0004', N'안경태', 'S0002', 'glass@test.com')
INSERT INTO dbo.Employee02 VALUES('S0005', N'김치국', 'S0003', 'kimchi@test.com')
INSERT INTO dbo.Employee02 VALUES('S0006', N'오감자', 'S0002', 'ohoh@test.com')
INSERT INTO dbo.Employee02 VALUES('S0007', N'허무해', 'S0005', 'mumu@test.com')
GO

-- 1 그냥 그대로
WITH Employees_CTE 
	AS (
		SELECT EmpID, ManagerID, EmpName
			FROM dbo.Employee02
			WHERE ManagerID IS NULL
		UNION ALL
		SELECT e.EmpID, e.ManagerID, e.EmpName
			FROM Employees_CTE AS m
			JOIN dbo.Employee02 AS e
			ON m.EmpID = e.ManagerID
	)
	SELECT * FROM Employees_CTE
GO

--2 매니저 이름 구하기
WITH Employees_CTE 
	AS (
		SELECT EmpID, EmpName, ManagerID, empName as 매니저
			FROM dbo.Employee02
			WHERE ManagerID IS NULL
		UNION ALL
		SELECT e.EmpID, e.EmpName, e.ManagerID, m.EmpName
			FROM Employees_CTE AS m
			JOIN dbo.Employee02 AS e
			ON m.EmpID = e.ManagerID
	)
	SELECT * FROM Employees_CTE  order by 매니저, empID
GO

--3.서열 표시

--3.1 레벨 표시를 연습
WITH Employees_CTE 
	AS (
		SELECT EmpID, EmpName, ManagerID, empName as 매니저, 0 as 레벨
			FROM dbo.Employee02
			WHERE ManagerID IS NULL
		UNION ALL
		SELECT e.EmpID, e.EmpName, e.ManagerID, m.EmpName, 1 as 레벨
			FROM Employees_CTE AS m
			JOIN dbo.Employee02 AS e
			ON m.EmpID = e.ManagerID
	)
	SELECT * FROM Employees_CTE
	order by 레벨, empid
GO


--3.2 상사의 레벨 + 1로 표시를 해 보면
WITH Employees_CTE 
	AS (
		SELECT EmpID, EmpName, ManagerID, empName as 매니저, 0 as 레벨
			FROM dbo.Employee02
			WHERE ManagerID IS NULL
		UNION ALL
		SELECT e.EmpID, e.EmpName, e.ManagerID, m.EmpName, m.레벨 + 1	--레벨 증가
			FROM Employees_CTE AS m
			JOIN dbo.Employee02 AS e
			ON m.EmpID = e.ManagerID
	)
	SELECT * FROM Employees_CTE
	order by 레벨, empid
GO


--3.3 sortKey 추가
--개념
select CAST(1 AS VARBINARY(900)) AS SortKey
select CAST(2 AS VARBINARY(900)) AS SortKey
select CAST(1 AS VARBINARY(900)) + CAST( 2 AS VARBINARY(900) )


WITH Employees_CTE ( EmpID, EmpName, ManagerID, 매니저, 레벨, sortKey )	--이젠 컬럼명 반드시 필요하다. 없으면 오류.
	AS (
		SELECT EmpID, EmpName, ManagerID, empName, 0 , CAST(EmpID AS VARBINARY(900)) 
			FROM dbo.Employee02
			WHERE ManagerID IS NULL
		UNION ALL
		SELECT e.EmpID, e.EmpName, e.ManagerID, m.EmpName, m.레벨 + 1
			, CAST(m.EmpID AS VARBINARY(900)) + CAST(e.EmpID AS VARBINARY(900) )
			FROM Employees_CTE AS m
			JOIN dbo.Employee02 AS e
			ON m.EmpID = e.ManagerID
	)
	SELECT * FROM Employees_CTE
	order by 레벨, empid
GO
--메시지 240, 수준 16, 상태 1, 줄 1
--재귀 쿼리 "Employees_CTE"의 열 "sortKey"에 있는 앵커 부분과 재귀 부분 간의 유형이 일치하지 않습니다.

--정상
WITH Employees_CTE ( EmpID, EmpName, ManagerID, 매니저, 레벨, sortKey )	--이젠 컬럼명 반드시 필요하다. 없으면 오류.
	AS (
		SELECT EmpID, EmpName, ManagerID, empName, 0 as 레벨, CAST(EmpID AS VARBINARY(900)) 
			FROM dbo.Employee02
			WHERE ManagerID IS NULL
		UNION ALL
		SELECT e.EmpID, e.EmpName, e.ManagerID, m.EmpName, m.레벨 + 1
			, CAST( sortKey + CAST(e.EmpID AS VARBINARY(900) ) AS VARBINARY(900) )	--엄격한 자료형 일치가 요구된다. 자동 형변환 안 된다.
			FROM Employees_CTE AS m
			JOIN dbo.Employee02 AS e
			ON m.EmpID = e.ManagerID
	)
	SELECT * FROM Employees_CTE
	order by 레벨, empid
GO


select replicate ('반복  | ' , 3)
--과제07 다음 결과를 출력하는 프로시저를 만들자



use tempdb
go
drop table CarParts
go
CREATE TABLE CarParts
(
	CarID	int			NOT NULL
,	Part	varchar(15)
,	SubPart	varchar(15)
,	Qty		int
)
GO

INSERT CarParts VALUES(1 , 'Body' , 'Door' , 4)
INSERT CarParts VALUES(1 , 'Body' , 'Trunk Lid' , 2)
INSERT CarParts VALUES(1 , 'Body' , 'Car Hood' , 1)
INSERT CarParts VALUES(1 , 'Door' , 'Handle' , 1)
INSERT CarParts VALUES(1 , 'Door' , 'Lock' , 1)
INSERT CarParts VALUES(1 , 'Door' , 'Window' , 1)
INSERT CarParts VALUES(1 , 'Body' , 'Rivets' , 1000)
INSERT CarParts VALUES(1 , 'Door' , 'Rivets' , 100)
INSERT CarParts VALUES(1 , 'Door' , 'Mirror' , 1)
INSERT CarParts VALUES(1 , 'Car Hood
' , 'Rivets' , 100)
SELECT * FROM CarParts order by part
go

WITH CarPartsCTE(SubPart , Qty)
AS
(
	-- 앵커 멤버(Anchor Member):
	-- CarPartsCTE 자신을 참조하지 않는 SELECT 쿼리
	SELECT SubPart , Qty
	FROM CarParts
	WHERE Part = 'Body'

	UNION ALL

	-- 재귀 멤버 (Recursive Member):
	-- CTE(CarPartsCTE) 자기 자신을 참조하는 SELECT 쿼리
	SELECT CarParts.SubPart , CarPartsCTE.Qty * CarParts.Qty
	FROM CarPartsCTE INNER JOIN CarParts
		ON CarPartsCTE.SubPart = CarParts.Part
	WHERE CarParts.CarID = 1
)

-- 출력 쿼리
--SELECT * FROM CarPartsCTE order by subPart
SELECT SubPart , SUM(Qty) as q
FROM CarPartsCTE
GROUP BY SubPart;

--과제08 다음 결과를 출력하는 프로시저를 만들자



