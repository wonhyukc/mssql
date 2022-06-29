--*
--* 6.7 결과 집합 병합하기
--*


-- 1) UNION

USE HRDB
GO

-- 2008년 입사한 직원
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2008-01-01' AND '2008-12-31' 
GO

-- 급여를 7,000 이상 받는 직원
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO

-- 2008년에 입사 했거나 급여를 7,000 이상 받는 직원
-- UNION(중복 행 한번만 표시)
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2008-01-01' AND '2008-12-31' 

UNION

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO

-- UNION(중복 모두 표시)
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2008-01-01' AND '2008-12-31' 

UNION ALL

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO


-- 2) INTERSECT

-- 2008년에 입사했으며 급여를 7,000 이상 받는 직원
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2008-01-01' AND '2008-12-31' 

INTERSECT

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO


-- 3) EXCEPT

-- 2008년에 입사했지만 급여을 7,000 이상 받으면 제외
SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2008-01-01' AND '2008-12-31' 

EXCEPT

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO