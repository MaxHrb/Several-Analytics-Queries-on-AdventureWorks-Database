/** 
--> Identify the top 10 sales orders per month
--> Aggregate these into a sum total, by month
--> Compare each month´s total to the previous months´, on the same row

**/


SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM (
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)-- Datefromparts (year, month, day) returns a date-value assigned to year, month and day
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
) X
WHERE OrderRank <= 10
GROUP BY OrderMonth



--Subquery approach:

SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total

FROM (
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM (
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
) X
WHERE OrderRank <= 10
GROUP BY OrderMonth
) A

LEFT JOIN (
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM (
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
) X
WHERE OrderRank <= 10
GROUP BY OrderMonth
) B
ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)

ORDER BY 1




--Refactored using CTE:

WITH Sales AS
(
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
)

,Top10Sales AS
(
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM Sales
WHERE OrderRank <= 10
GROUP BY OrderMonth
)


SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total

FROM Top10Sales A
	LEFT JOIN Top10Sales B
		ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)

ORDER BY 1