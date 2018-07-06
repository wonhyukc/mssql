--*
--* 6.6 하위 쿼리
--*


-- 1) 일반 하위 쿼리

-- 가장 많은 급여를 받는 직원 정보
USE HRDB
GO

SELECT EmpID, EmpName, Salary
   FROM dbo.Employee
   WHERE Salary = (SELECT MAX(Salary) FROM dbo.Employee)
GO

-- 휴가를 간 적이 있는 직원 정보
SELECT EmpID, EmpName, DeptID, EMail
   FROM dbo.Employee
   WHERE EmpID IN (SELECT EmpID FROM dbo.Vacation)
GO


-- 2) 상관 하위 쿼리

-- 부서 이름 가져오기
SELECT EmpID, EmpName, DeptID, (SELECT DeptName FROM dbo.Department
	  WHERE DeptID = e.DeptID) AS 'DeptName', Salary
   FROM dbo.Employee AS e
   WHERE Salary > 7000
GO


-- 3) EXISTS

-- 휴가를 간 적이 있는 직원 정보
SELECT EmpID, EmpName, EMail
   FROM dbo.Employee e
   WHERE EXISTS(SELECT * 
                   FROM dbo.Vacation 
                   WHERE EmpID = e.EmpID);
GO

-- 휴가를 간 적이 없는 직원 정보
SELECT EmpID, EmpName, EMail 
   FROM dbo.Employee e
   WHERE NOT EXISTS(SELECT * 
                      FROM dbo.Vacation 
                      WHERE EmpID = e.EmpID)
GO