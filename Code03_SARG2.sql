
select * from titles WHERE price BETWEEN 10 AND 20
select * from titles WHERE price >= 10 AND price <= 20

[pubs].[dbo].[titles].[price]>=CONVERT_IMPLICIT(money,[@1],0) AND [pubs].[dbo].[titles].[price]<=CONVERT_IMPLICIT(money,[@2],0)


[pubs].[dbo].[titles].[price]>=CONVERT_IMPLICIT(money,[@1],0) AND [pubs].[dbo].[titles].[price]<=CONVERT_IMPLICIT(money,[@2],0)



WHERE name BETWEEN '성대중' AND '이재범'

WHERE name IN ('june', 'joy', 'soul')
WHERE name = 'june' OR name = 'joy' OR name = 'soul'

WHERE name LIKE '%병길'
WHERE name LIKE '김%'
WHERE name >= '김' AND name < '깁'


