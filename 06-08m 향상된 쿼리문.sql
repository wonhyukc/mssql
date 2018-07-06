--*
--* 6.8 향상된 쿼리문
--*


-- 1) TOP

USE HRDB
GO

-- 급여를 많이 받는 상위 5명
SELECT TOP (5) EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO

-- 같은 급여를 갖는 경우 포함 시킴
SELECT TOP (5) WITH TIES EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO

-- 급여를 많이 받는 상위 14.5 퍼센트 
SELECT TOP (14.5) PERCENT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO


-- 2) CASE

-- 퇴사자 정보를 M과 F를 남, 여로 표시해서
SELECT EmpID, EmpName, 
		 CASE WHEN Gender = 'M' THEN N'남'
			     WHEN Gender = 'F' THEN N'여'
				 ELSE '' END AS 'Gender', DeptID, HireDate, EMail 
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO

-- 또는
SELECT EmpID, EmpName, 
		 CASE Gender WHEN 'M' THEN N'남'
						   WHEN 'F' THEN N'여'
						   ELSE '' END AS 'Gender', DeptID, HireDate, EMail 
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO

-- 2007 입사자에 대해 근무, 퇴사로 현재 상태 표시
SELECT EmpID, EmpName, 
		 CASE WHEN RetireDate IS NULL THEN N'근무'
				ELSE N'퇴사' END AS 'Status', DeptID, HireDate, EMail 
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2007-01-01' AND '2007-12-01'
GO


-- 3) CTE

-- 부서 급여의 합이 10,000 이상인 부서 정보
WITH DeptSalary (DeptID, Tot_Salary)
	AS (SELECT DeptID, SUM(Salary)
			FROM dbo.Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID)
SELECT * FROM DeptSalary
	WHERE Tot_Salary >=10000
GO

-- 부서 이름 포함
WITH 
	DeptSalary (DeptID, Tot_Salary)
	AS (
		SELECT DeptID, SUM(Salary)
			FROM dbo.Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID
	)
SELECT s.DeptID, d.DeptName, d.UnitID, s.Tot_Salary 
	FROM DeptSalary AS s
	INNER JOIN dbo.Department AS d ON s.DeptID = d.DeptID
	WHERE s.Tot_Salary >=10000
GO

-- CTE 중첩: 본부 이름 포함
WITH 
	DeptSalary (DeptID, Tot_Salary)
	AS 
	(
		SELECT DeptID, SUM(Salary)
			FROM dbo.Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID
	),
	DeptNameSalary (DeptID,  DeptName, UnitID, Tot_Salary)
	AS 
	(
		SELECT s.DeptID, d.DeptName, d.UnitID, s.Tot_Salary
		FROM DeptSalary AS s
		INNER JOIN dbo.Department AS d ON s.DeptID = d.DeptID
		WHERE s.Tot_Salary >=10000
	)
SELECT s.DeptID, s.DeptName, s.UnitID, u.UnitName, s.Tot_Salary
	FROM DeptNameSalary AS s
	LEFT OUTER JOIN dbo.Unit AS u ON s.UnitID = u.UnitID
GO



-- 6) OVER 

-- 연습용 테이블 만들기
SELECT e.EmpID, e.EmpName, e.DeptID, d.UnitID, e.Salary
	INTO dbo.EmpTest
	FROM dbo.Employee e
	INNER JOIN dbo.Department d ON e.DeptID = d.DeptID
	LEFT OUTER JOIN dbo.Unit u ON d.UnitID = u.UnitID
	WHERE e.DeptID IN ('GEN', 'HRD', 'MKT')
	ORDER BY e.EmpID ASC
GO

SELECT * FROM dbo.EmpTest
GO

-- 전체 집계
SELECT UnitID, DeptID, EmpID, EmpName, Salary,
		COUNT(Salary) OVER(PARTITION BY UnitID) AS 'Emp_Count',
		SUM(Salary) OVER(PARTITION BY UnitID) AS 'Tot_Salary',
		AVG(Salary) OVER(PARTITION BY UnitID) AS 'Avg_Salary',
		MIN(Salary) OVER(PARTITION BY UnitID) AS 'Min_Salary',
		MAX(Salary) OVER(PARTITION BY UnitID) AS 'Max_Salary'
	FROM dbo.EmpTest
	ORDER BY UnitID, DeptID, EmpID
GO

-- 부서별 누적 합, 이동 평균
SELECT DeptID, EmpID, EmpName, Salary,
		SUM(Salary) OVER(PARTITION BY DeptID ORDER BY EmpID) AS 'Cumulative_Total',
		AVG(Salary) OVER(PARTITION BY DeptID ORDER BY EmpID) AS 'Moving_Avg'
	FROM dbo.EmpTest
	ORDER BY DeptID, EmpID
GO

-- 전체 누적 합, 이동 평균
SELECT EmpID, EmpName, DeptID, Salary,
		SUM(Salary) OVER(ORDER BY EmpID) AS 'Cumulative_Total',
		AVG(Salary) OVER(ORDER BY EmpID) AS 'Moving_Avg'
	FROM dbo.EmpTest
	ORDER BY EmpID
GO

-- ROWS 절과 함께 사용
-- ROW 사용해서 현재 행 다음에 나오는 두개 행으로 창 제한
SELECT UnitID, DeptID, EmpID, EmpName, Salary,
		SUM(Salary) OVER(
				PARTITION BY UnitID 
				ORDER BY DeptID 
				ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS 'Cumulative_Total',
		AVG(Salary) OVER(
				PARTITION BY UnitID 
				ORDER BY DeptID 
				ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS 'Moving_Avg'
	FROM dbo.EmpTest
	ORDER BY UnitID, DeptID
GO

-- ROWS 절과 함께 UNBOUNDED PRECEDING을 지정
-- PARTITION 첫번째 행애서 시작
SELECT UnitID, DeptID, EmpID, EmpName, Salary,
		SUM(Salary) OVER(
				PARTITION BY UnitID 
				ORDER BY DeptID 
				ROWS UNBOUNDED PRECEDING) AS 'Cumulative_Total',
		AVG(Salary) OVER(
				PARTITION BY UnitID 
				ORDER BY DeptID 
				ROWS UNBOUNDED PRECEDING) AS 'Moving_Avg'
	FROM dbo.EmpTest
	ORDER BY UnitID, DeptID
GO



-- 7) OFFSET AND FETCH

USE HRDB
GO

-- 조건에 맞는 모든 행 가져오기
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID
GO

-- 처음 3개는 제외하고 가져오기
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID 
	OFFSET 3 ROWS
GO

-- 처음부터 5개 가져오기
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID 
    OFFSET 0 ROWS
    FETCH NEXT 5 ROWS ONLY
GO

-- 식 사용하기 
DECLARE @StartNum tinyint = 2, @EndNum tinyint = 5
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID 
    OFFSET @StartNum - 1  ROWS
    FETCH NEXT @EndNum - @StartNum + 1  ROWS ONLY
GO


-- 