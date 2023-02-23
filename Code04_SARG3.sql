FROM table1 WITH (INDEX(0))

WHERE au_lname LIKE ‘박미%'	
WHERE SUBSTRING (au_lname,1,2)='박미'
WHERE LEFT(au_lname,2)='박미'

WHERE titles.title_id = sales.title_id 
WHERE salary = commission
WHERE salary <= 500

WHERE salary != 3000

@이름 = '현중균'
WHERE 이름 = @이름