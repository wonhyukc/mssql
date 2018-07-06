WHERE convert(char(112), ³¯Â¥) = ' 20041029'

WHERE pubdate = 2001
WHERE year(pubdate) = 2001
WHERE datepart(yy, pubdate) = 2001
WHERE pubdate between '2001.1.1' and 
		 '2001.12.31 23:59:59.997'
WHERE pubdate >= '2001.1.1' and 
		pubdate < '2002.1.1'
