--//상관관계의 하위 질의(Correlated subquery)

SELECT stor_name, 'Title' = convert(char(30),t.title), qty
FROM sales s, titles t, stores st
WHERE s.title_id = t.title_id
	AND s.stor_id = st.stor_id
	AND qty = (
		SELECT MAX(qty) FROM sales s2
		WHERE s2.stor_id = s.stor_id
	)
ORDER BY stor_name, Title




SELECT 	stor_name, 'Title' = convert(char(30),t.title), qty
FROM 	sales s JOIN titles t 	ON s.title_id = t.title_id
	JOIN stores st 		ON s.stor_id = st.stor_id
WHERE 	qty = (	SELECT MAX(qty) FROM sales s2
			WHERE s2.stor_id = s.stor_id
	)
ORDER BY stor_name, Title



SELECT 	stor_id, title_id, qty
FROM 	sales s
WHERE 	qty = (	SELECT MAX(qty) FROM sales s2
			WHERE s2.stor_id = s.stor_id
	)
ORDER BY stor_id, title_id



SELECT 	stor_id, title_id, qty
FROM 	sales s
ORDER BY stor_id, title_id, qty


SELECT 	stor_id, title_id, qty
FROM 	sales s
WHERE 	qty = (	SELECT MAX(qty) FROM sales s2
			WHERE s2.stor_id = '6380'
	)
ORDER BY stor_id, title_id, qty
 

--// IN / EXISTS
SELECT title
FROM titles
WHERE title_id IN (
	SELECT title_id FROM sales
)
---
SELECT DISTINCT title
FROM titles t JOIN  sales s 
	ON t.title_id = s.title_id



SELECT title
FROM titles
WHERE title_id IN (
	SELECT DISTINCT title_id FROM sales
)

SELECT pub_name
FROM publishers
WHERE EXISTS
   (SELECT * 
   FROM titles
   WHERE pub_id = publishers.pub_id
AND type = 'business')

SELECT DISTINCT pub_name
FROM publishers p JOIN titles t
	ON t.pub_id = p.pub_id
WHERE type = 'business'


SELECT au_lname, au_fname
FROM authors
WHERE 100 IN
	(SELECT royaltyper
	FROM titleauthor
	WHERE titleauthor.au_ID = authors.au_id)



SELECT DISTINCT au_lname, au_fname
FROM authors a JOIN titleauthor ta  	    ON a.au_id = ta.au_id
WHERE royaltyper = 100


SELECT * FROM sales
SELECT * INTO sales_temp FROM sales


SELECT * FROM sales_temp


DROP TABLE sales_temp


SELECT * INTO #sales FROM sales
SELECT * INTO ##sales FROM sales
SELECT * FROM #sales
SELECT * FROM ##sales



SELECT * FROM #sales


SELECT * FROM ##sales


SELECT stor_name, convert(char(30),t.title), qty
INTO #bestSeller
FROM sales s, titles t, stores st
WHERE s.title_id = t.title_id
	AND s.stor_id = st.stor_id
	AND qty = (
		SELECT MAX(qty) FROM sales s2
		WHERE s2.stor_id = s.stor_id
	)
ORDER BY stor_name, Title



SELECT stor_name, convert(char(30),t.title) AS title, qty


SELECT * INTO tempdb..sales FROM sales



--//UNION

SELECT region, count(*) FROM hot_members GROUP BY region
UNION
SELECT region, count(*) FROM members GROUP BY region


select  au_id, au_fname, phone, city, state, 'author' as 구분
from authors
UNION ALL
select pub_id, pub_name, null, city, state, 'publisher' as 구분
from publishers


