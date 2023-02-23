/*
정원혁
2013.11.22 
원본 파일을 pubs..sales 에서 실행되도록 모두 수정

c:\temp 폴더를 기본으로 사용한다. 필요하면 모든 폴더 명을 각자의 환경에 맞게 바꾼다.
*/


--*
--* 14.1 데이터 전송의 필요성과 다양한 방법들
--*



--*
--* A. BCP 유틸리티
--*


-- 1) 트러스트된 연결로 BCP 사용 예

/*
cmd 창에서 실행한다. c:\temp 폴더에서 실행한다. 
(필요하면 
c:
cd \temp 
를 사용한다. 이 스크립트에서는 c:\temp\를 모든 파일에 붙여서 어디서 실행해도 되도록 하였다.)


BCP pubs.dbo.sales out c:\temp\sales.txt -T -c

실행 후에 sales.txt 를 열어서 내용을 확인해 본다.
*/

-- 3) 텍스트 파일에서 테이블로 데이터 복사하기
-- 빈 테이블 만들기
USE pubs
GO

IF OBJECT_ID('dbo.sales빈테이블') IS NOT NULL
	DROP TABLE dbo.sales빈테이블
GO

SELECT *
	INTO dbo.sales빈테이블
	FROM pubs.dbo.sales
	WHERE 1 = 0
GO
SELECT *	FROM dbo.sales빈테이블	--비어 있음을 확인한다.
GO

-- 데이터 전송
/*
BCP pubs.dbo.sales빈테이블 in c:\temp\sales.txt -T -c 
*/

-- 결과 확인
SELECT *	FROM dbo.sales빈테이블	-- 데이터 들어 왔음을 있음을 확인한다.
GO



-- 4) 쿼리문의 결과를 텍스트 파일로 복사하기
TRUNCATE TABLE dbo.sales빈테이블
GO
/*
BCP "SELECT stor_id, title_id, qty FROM pubs.dbo.sales WHERE qty >= 20" queryout c:\temp\sales빈테이블.txt -c  -T
*/
--메모장을 열어 sales빈테이블.txt 의 내용을 확인한다.




--*
--* B. BULK INSERT문
--*


-- 1) 탭으로 구분 된 데이터 가져오기

USE pubs
GO

IF OBJECT_ID('dbo.sales빈테이블') IS NOT NULL
	DROP TABLE dbo.sales빈테이블
GO

SELECT *
	INTO dbo.sales빈테이블
	FROM pubs.dbo.sales
	WHERE 1 = 0
GO

BULK INSERT pubs.dbo.sales빈테이블
   FROM 'c:\temp\sales.txt'
   WITH (
         FIELDTERMINATOR ='\t',
         ROWTERMINATOR ='\n')
GO

SELECT *	FROM dbo.sales빈테이블	-- 데이터 들어 왔음을 있음을 확인한다.
GO


-- 2) 서식 파일 만들어 사용하기

-- 서식 파일 만들기
/*
bcp pubs.dbo.sales format nul -c  -fe:\tmp\sales.fmt -T
*/


-- 서식 파일 사용해 데이터 가져오기
USE pubs
GO

TRUNCATE TABLE dbo.sales빈테이블
GO

BULK INSERT dbo.sales빈테이블 
   FROM 'c:\temp\sales.txt'
   WITH (FORMATFILE = 'c:\temp\sales.fmt');
GO

SELECT *	FROM dbo.sales빈테이블	-- 데이터 들어 왔음을 있음을 확인한다.
GO


--*
--* C. OPENROWSET
--*
SELECT t.* FROM OPENROWSET(BULK 'c:\temp\sales.txt', 
   FORMATFILE = 'c:\temp\sales.fmt') AS t
