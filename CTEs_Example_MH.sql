/**First, #Sales is created with four columns: OrderDate, OrderMonth, TotalDue, and OrderRank. OrderDate and TotalDue columns are populated with data from the SalesOrderHeader table in the AdventureWorks2019 database. The OrderMonth column is calculated from the OrderDate column using the DATEFROMPARTS function to extract the year and month and create a new date with the first day of that month. The OrderRank column is assigned a ranking value based on the TotalDue column for each month, using the ROW_NUMBER() function and partitioning by the OrderMonth column.

Next, #Top10Sales is created with two columns: OrderMonth and Top10Total. The Top10Total column is calculated as the sum of TotalDue from #Sales table, but only for the top 10 rows in each month based on the OrderRank column.

Finally, a SELECT statement is executed to retrieve data from #Top10Sales, joining it with itself to retrieve the Top10Total value for the previous month using the DATEADD function. The results are ordered by OrderMonth. Another SELECT statement is executed to retrieve data from #Sales table where OrderRank is less than or equal to 10. At the end of the script, both temporary tables are dropped using the DROP TABLE command.**/




/**  CTEs **/


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
