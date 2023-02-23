USE [master]
GO

--이미 있고 삭제를 하고 싶다면
--EXEC master.dbo.sp_dropserver @server=N'x1', @droplogins='droplogins'
GO

EXEC master.dbo.sp_addlinkedserver @server = N'x1', @srvproduct=N'..', @provider=N'Microsoft.ACE.OLEDB.12.0', @datasrc=N'd:\tmp\excel.xlsx', @provstr=N'Excel 12.0'

GO
EXEC master.dbo.sp_serveroption @server=N'x1', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'x1', @optname=N'data access', @optvalue=N'true'
GO

GO
EXEC master.dbo.sp_serveroption @server=N'x1', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'x1', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'x1', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'x1', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'x1', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'x1', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'x1', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO
USE [master]
GO
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'x1', @locallogin = NULL , @useself = N'False'
GO

--확인: x1 이 있어야 한다.
sp_helpserver