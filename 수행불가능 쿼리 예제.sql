/*
	미완성인 쿼리를 완성하자. 쿼리는 완전하게 수행 가능해야 한다.
*/
use pubs
go
--1. note에 recipe 라는 글자가 있고 가격이 10이상 20이하.
select * from titles
where notes like '%recipe%' and price between 10 and 20
go 


--2. 출판일이 1991년 7월 이후이고, 요리에 관련된 책 (type 이 cook 으로 끝난다)
select * from titles
where pubdate > '1991-07-01' and type like '%cook'
go


--3. 판매 가격이 NULL 인 것을 가져오되, 원래 가격(price)와 null 값을 0으로 바꾼 '가격'을 아래 결과와 같이 출력한다. 
/*
책번호	price	가격		title
MC3026	NULL	0.00	The Psychology of Computer Cooking
PC9999	NULL	0.00	Net Etiquette
*/

select  책번호, price, title from titles
select 책번호, price ,ISNULL (price,0) as 가격 , title from titles
where price is NULL
go

--4. 판매 수량 20권 이상이고, 결재조건(payterms)이 Net 60 이거나, ON invoice 인 것
select * from sales
where 20 <= qty and payterms like 'Net 60'
or 20 <= qty and payterms like 'on invoice'
go

--5. 서점별 많이 팔린 순서대로 출력한다. 결과는 아래와 똑 같아야 한다.
/*
stor_id	qty	title_id
6380	5	BU1032
6380	3	PS2091
7066	75	PS2091
7066	50	PC8888
7067	40	TC3218
7067	20	TC4203
7067	20	TC7777
7067	10	PS2091
7131	25	MC3021
7131	25	PS2106
7131	25	PS7777
7131	20	PS1372
7131	20	PS2091
7131	15	PS3333
7896	35	BU2075
7896	15	BU7832
7896	10	MC2222
8042	30	PC1035
8042	25	BU1111
8042	15	MC3021
8042	10	BU1032
*/
select * from sales
SELECT stor_id,qty,title_id from sales
order by stor_id
go
