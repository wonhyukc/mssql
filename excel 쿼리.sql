/*
http://sqlsrv4living.blogspot.kr/2013/12/read-excel-file-excel-2010-2013.html
엑셀 2007, sql 2008 이후 부터 이상 현상 발생
주로 64bit에서 발생.


엑셀 2007 이하 버전에서 2010 버전을 연결하려면 
다운로드(ACCESS 2010 엔진)
http://www.microsoft.com/ko-kr/download/details.aspx?id=13255



SSMS 를 관리자 권한으로 실행해야 해결되기도 한다.
가끔 엑셀 파일이 아예 깨어지는 경우도 발생한다. 그렇다면, 엑셀 파일을 새로 만들어야 한다.
*/
sp_configure 'show advanced options', 1
go
reconfigure
go
sp_configure 'Ad Hoc Distributed Queries', 1
go
reconfigure
go




/*
아래와 같은 오류가 생기면 프로바이더를 재 등록 해야 한다.
Msg 7399, Level 16, State 1, Line 1

The OLE DB provider "Microsoft.ACE.OLEDB.12.0" for linked server "(null)" reported an error. The provider did not give any information about the error. 
*/
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO

--Excel 2007 이후
SELECT * 
--INTO #myTalbe
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
    'Excel 12.0 Xml;HDR=YES;Database=d:\tmp\excel.xlsx',
    'SELECT * FROM [sheet1$]');
go

--csv 읽기, SQL 2008 64bit에서
select * 
from OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Text;Database=d:\tmp;', 'SELECT * FROM excel_csv.csv')
go



--이후 쿼리는 엑셀 서버를 연결된서버로 등록한 후에 가능 ("excel 등록.sql")

--현재값 확인
select * from x1...sheet1$
where DATE <= '01/19/2004 22:07:37.228'
go

--엑셀을 쿼리로 업데이트 한다.
update a
set sent = sent + 1
from OPENROWSET('Microsoft.ACE.OLEDB.12.0',
				'Excel 12.0 Xml;HDR=YES;Database=d:\tmp\excel.xlsx',
				'SELECT * FROM [sheet1$]'
	) a 
where DATE <= '01/19/2004 22:07:37.228'
go

--확인: 필요하면 엑셀 파일을 직접 열어 확인해도 된다.
select * from x1...sheet1$
where DATE <= '01/19/2004 22:07:37.228'
go
