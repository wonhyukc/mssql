/*
	case 와 pivot 이해
	정원혁 / 2014.11. 재작성
*/

use pubs
select stor_id, year(ord_date) as yr, qty
from sales
order by 1, 2

/*
case when  조건 then 참 else 거짓 end 
case 조건 when 조건값  then 참 else 거짓 end 
*/

select stor_id, year(ord_date) as yr, qty
	, case 
			when qty>=50 then 'A' 
			when qty>=20 then 'B' 
			else 'C'
		end  as 등급
from sales
order by 1, 2


select stor_id, year(ord_date) as yr, qty
from sales
order by 1, 2

select stor_id 
	, case year(ord_date)	when 1992	then qty	else 0	end as y92
	, case year(ord_date)	when 1993	then qty	else 0	end as y93
	, case year(ord_date)	when 1994	then qty	else 0	end as y94
from sales

select stor_id 
	, sum( case year(ord_date)	when 1992	then qty	else 0	end ) as y92
	, sum( case year(ord_date)	when 1993	then qty	else 0	end ) as y93
	, sum( case year(ord_date)	when 1994	then qty	else 0	end ) as y94
from sales
group by stor_id

select stor_id, isnull([1992],0) as [1992],[1993],[1994]
from 
(
	select stor_id, year(ord_date) as yr, qty
	from sales
) src
PIVOT (
	sum(qty) for yr IN ([1992],[1993],[1994])
) pvt

