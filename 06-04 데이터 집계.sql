--*
--* 6.4 데이터 집계
--*



--*
--* A. 기본적인 데이터 집계
--*


-- 1) 집계 함수 사용

USE HRDB
GO

-- 근무 중인 직원들의 급여의 합 구하기
SELECT SUM(Salary) AS 'Tot_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
GO

--  근무 중인 직원들의 급여의 최대값, 최소값, 최대값 - 최소값을 구하는 쿼리를 작성하자.

SELECT MAX(Salary) AS 'Max_Salary', MIN(Salary) AS ' Min_Salary',
			 MAX(Salary) - MIN(Salary) AS ' Diff_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
GO


-- 2) 집계 함수와 NULL 값 예제

UPDATE dbo.Employee
	SET Salary = NULL
	WHERE EmpID = 'S0020'
GO

SELECT COUNT(*) AS 'EmpCount'
	FROM dbo.Employee
	WHERE RetireDate IS NULL --> 16
GO

SELECT COUNT(EmpID) AS 'EmpCount'
	FROM dbo.Employee
	WHERE RetireDate IS NULL --> 16
GO
	
SELECT COUNT(Salary) AS 'EmpCount'
	FROM dbo.Employee
	WHERE RetireDate IS NULL --> 15
GO
/*
경고: 집계 또는 다른 SET 작업에 의해 Null 값이 제거되었습니다.
*/

-- 근무 중인 직원들의 급여의 평균을 구하는 쿼리를 작성하고 있다. 
-- 다음 두 쿼리의 차이점을 설명하자.

SELECT SUM(Salary) / COUNT(EmpID) AS 'Avg_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL --> 5,681
GO

SELECT SUM(Salary) / COUNT(Salary) AS 'Avg_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL --> 6,060
GO

-- 참고 
SELECT AVG(Salary) AS 'Avg_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL --> 6,060
GO
 

-- 3) 그룹별 집계: GROUP BY

-- 부서별 근무 중인 직원 수 구하기
SELECT DeptID, COUNT(*) AS 'Emp_Count'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO

-- 실패하는 GROUP BY 문
SELECT DeptID, EmpName, COUNT(*) AS 'Emp_Count'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO
/*
메시지 8120, 수준 16, 상태 1, 줄 2
열 'dbo.Employee.EmpName'이(가) 집계 함수나 GROUP BY 절에 없으므로 SELECT 목록에서 사용할 수 없습니다.
*/

-- 부서별 근무하는 직원의 급여의 합을 구하자.
SELECT DeptID, SUM(Salary) AS 'Tot_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID 
GO

-- 부서별 근무하는 직원의 최대값, 최소값, 최대값 - 최소값을 구하자
SELECT DeptID, MAX(Salary) AS 'Max_Salary', MIN(Salary) AS ' Min_Salary',
			 MAX(Salary) - MIN(Salary) AS ' Diff_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO

--  부서별 근무하는 직원중 급여가 5000 이상인 직원의 수를구하자
SELECT DeptID, COUNT(EmpID) AS 'Max_Salary'
	FROM dbo.Employee
	WHERE Salary > 5000
	GROUP BY DeptID;
GO


-- 4) 그룹핑 결과에 대한 필터링: HAVING

SELECT DeptID, COUNT(*) AS 'Emp_Count'
	FROM dbo.Employee
	GROUP BY DeptID
	HAVING COUNT(*) >= 3
GO

-- 부서별로 현재 근무 중인 직원의 평균 급여를 얻는 쿼리를 작성하자.
SELECT DeptID, AVG(Salary) AS 'Avg_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO

-- 위에서 얻은 부서 평균 급여가 전사 평균 급여보다 많은 부서의 평균 급여는?
SELECT DeptID, AVG(Salary) AS 'Avg_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
	HAVING AVG(Salary) > (SELECT AVG(Salary) FROM dbo.Employee WHERE RetireDate IS NULL)
GO


-- 5) 새로운 그룹 별 집계 방법: GROUPING SETS

SELECT DeptID, SUM(Salary) AS 'Tot_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO

SELECT Gender, SUM(Salary) AS 'Tot_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY Gender
GO

-- 결과 결합
SELECT DeptID, NULL AS 'Gender', SUM(Salary) AS 'Tot_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID

UNION

SELECT NULL, Gender, SUM(Salary) AS 'Tot_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY Gender
	ORDER BY Gender, DeptID
GO

-- GROUPING SETS 사용
SELECT DeptID, Gender, SUM(Salary) AS 'Tot_Salary'
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY GROUPING SETS(DeptID, Gender)
	ORDER BY Gender, DeptID
GO

-- 전체 집계만 보여주기
SELECT DeptID, Gender, SUM(Salary) AS 'Tot_Salary'
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS((DeptID, Gender), ())
GO

-- 부서 소계 + 전체 집계 보여주기
SELECT DeptID, Gender, SUM(Salary) AS 'Tot_Salary'
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS((DeptID, Gender), (DeptID), ())
GO

-- 부서 소계만 보여주기(전체 집계 생략)
SELECT DeptID, Gender, SUM(Salary) AS 'Tot_Salary'
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS((DeptID, Gender), (DeptID))
GO



--*
--* B. 순위 구하기
--*


-- 1) 순위 표시: RANK

-- 전체 순위
SELECT EmpID, EmpName, Gender, Salary, RANK() OVER(ORDER BY Salary DESC) AS 'Rnk'
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO

-- 영역별 순위
SELECT EmpID, EmpName, Gender, Salary, 
	RANK() OVER(PARTITION BY Gender ORDER BY Salary DESC) AS 'Rnk'
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO


-- 2) 순위 표시: DENSE_RANK

-- 전체 순위
SELECT EmpID, EmpName, Gender, Salary,  DENSE_RANK() OVER(ORDER BY Salary DESC) AS 'Rnk'
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO

-- 영역별 순위
SELECT EmpID, EmpName, Gender, Salary, 
	DENSE_RANK() OVER(PARTITION BY Gender ORDER BY Salary DESC) AS 'Rnk'
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO


-- 3) 번호 표시: ROW_NUMBER

-- 전체 번호
SELECT ROW_NUMBER() OVER(ORDER BY EmpName DESC) AS 'Num',
			 EmpName, EmpID, Gender, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO

-- 영역별 번호
SELECT ROW_NUMBER() OVER(PARTITION BY DeptID
			 ORDER BY EmpName DESC) AS 'Num',
			 DeptID, EmpName, Empid, Gender, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO


-- 4) 범위 표시: NTILE

-- 전체 범위
SELECT EmpID, EmpName, Gender, Salary, NTILE(3) OVER(ORDER BY Salary DESC) AS 'Band'
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO

-- 영역별 범위
SELECT EmpID, EmpName, Gender, Salary, 
			 NTILE(3) OVER(PARTITION BY Gender ORDER BY Salary DESC) AS 'Band'
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO



--*
--* C. PIVOT과 UNPIVOT
--*


-- 1) PIVOT

-- 부서 코드를 포함한 직원들의 휴가 현황
SELECT v.EmpID, e.DeptID, Year(v.BeginDate) AS 'Year', v.Duration
	FROM dbo.Vacation AS v
	INNER JOIN  dbo.Employee AS e ON v.EmpID = e.EmpID
GO

-- 부서별 +연도별 휴가 현황 집계
SELECT e.DeptID, Year(v.BeginDate) AS 'Year', SUM(v.Duration) AS 'Duration'
	FROM dbo.Vacation AS v
	INNER JOIN  dbo.Employee AS e ON v.EmpID = e.EmpID
	GROUP BY e.DeptID, Year(BeginDate) 
GO

-- 피벗 형태로 표시하기
SELECT DeptID, [2007], [2008], [2009], [2010], [2011]
	FROM (
		SELECT e.DeptID, Year(v.BeginDate) AS 'Year', SUM(v.Duration) AS 'Duration'
			FROM dbo.Vacation AS v
			INNER JOIN  dbo.Employee AS e ON v.EmpID = e.EmpID
			GROUP BY e.DeptID, Year(BeginDate) 
	) AS Src
	PIVOT(SUM(Duration) 
	FOR Year IN([2007], [2008], [2009], [2010], [2011])) AS Pvt
GO

-- 피벗 형태로 표시하기(NULL 값 처리)
SELECT DeptID, ISNULL([2007], 0) AS '2007', ISNULL([2008], 0) AS '2008', ISNULL([2009], 0) AS '2009', ISNULL([2010], 0) AS '2010', ISNULL([2011], 0) AS '2011'
	FROM (
		SELECT e.DeptID, Year(v.BeginDate) AS 'Year', SUM(v.Duration) AS 'Duration'
			FROM dbo.Vacation AS v
			INNER JOIN  dbo.Employee AS e ON v.EmpID = e.EmpID
			GROUP BY e.DeptID, Year(BeginDate) 
	) AS Src
	PIVOT(SUM(Duration) 
	FOR Year IN([2007], [2008], [2009], [2010], [2011])) AS Pvt
GO


-- 2) UNPIVOT

 -- 피벗 형태 테이블 만들기
 SELECT DeptID, [2007], [2008], [2009], [2010], [2011]
	INTO dbo.YearVacation
	FROM (
		SELECT e.DeptID, Year(v.BeginDate) AS 'Year', SUM(v.Duration) AS 'Duration'
			FROM dbo.Vacation AS v
			INNER JOIN  dbo.Employee AS e ON v.EmpID = e.EmpID
			GROUP BY e.DeptID, Year(BeginDate) 
	) AS Src
	PIVOT(SUM(Duration) 
	FOR Year IN([2007], [2008], [2009], [2010], [2011])) AS Pvt
GO

SELECT * FROM dbo.YearVacation
GO

-- UNPIVOT
SELECT DeptID, Year, Duration
	FROM dbo.YearVacation
	UNPIVOT (Duration FOR Year IN ([2007], [2008], [2009], [2010], [2011])) AS uPvt
GO