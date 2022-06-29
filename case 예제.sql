/*
	제 9장 연습3
	정원혁 / 99.5.1.
*/

--1.1
USE tempdb

CREATE TABLE wages
(
	emp_id	tinyint	identity
,	hourly_wage	decimal	NULL
,	salary	decimal	NULL
,	commission	decimal	NULL
,	num_sales	tinyint	NULL
)
GO

--1.2
INSERT wages VALUES(10.00, NULL, NULL, NULL)
INSERT wages VALUES(20.00, NULL, NULL, NULL)
INSERT wages VALUES(30.00, NULL, NULL, NULL)

INSERT wages VALUES(NULL, 10000.00, NULL, NULL)
INSERT wages VALUES(NULL, 20000.00, NULL, NULL)
INSERT wages VALUES(NULL, 30000.00, NULL, NULL)

INSERT wages VALUES(NULL, NULL, 15000, 3)
INSERT wages VALUES(NULL, NULL, 25000, 2)
INSERT wages VALUES(NULL, NULL, 20000, 6)
GO

--1.3
SELECT * FROM wages

--1.4
SELECT emp_id, [연봉] =
	CASE
	     WHEN hourly_wage IS NOT NULL 
		THEN 	CONVERT(money,(hourly_wage * 40 * 52))
	     WHEN salary IS NOT NULL 
		THEN 	CONVERT(money,salary)
	     ELSE 	CONVERT(money,(commission * num_sales))
	END
FROM wages


--1.5
SELECT emp_id
, [연봉] = CAST ( COALESCE( 
	 hourly_wage * 40 * 52
	,salary
	,commission * num_sales ) AS money)
FROM wages


--1.6
SELECT emp_id
, CAST ( COALESCE( 
	 hourly_wage * 40 * 52
	,salary
	,commission * num_sales ) AS money) AS [연봉]
FROM wages










--함수  NULLIF, COALESCE
SELECT AVG( ISNULL (price, 0) ) FROM pubs..titles	--1)
SELECT AVG( price ) FROM pubs..titles			--2)

SELECT SUM(price) / 18 	FROM pubs..titles	--1)
SELECT SUM(price) / 16 	FROM pubs..titles	--2)

--
SELECT NULLIF(2,3)	--2를 리턴
SELECT NULLIF(3,3)	--널을 리턴

--
SELECT COALESCE(NULL, 1, 2)	-- 1을 리턴
SELECT COALESCE(1, NULL, 2)	-- 1을 리턴
SELECT COALESCE(NULL, NULL, 1)	-- 1을 리턴

--
SELECT	title_id AS '책번호'
,	qty AS '수량'
,	'등급' =  
CASE 
            	WHEN qty >= 50 THEN 'A'
            	WHEN qty >= 30 THEN 'B'
ELSE 'C'
        END
FROM pubs..sales

--
