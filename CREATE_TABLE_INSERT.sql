-- Create a temporary table called #Sales with columns for OrderDate, OrderMonth, TotalDue, and OrderRank
CREATE TABLE #Sales
(
       OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
)

-- The code inserts data into #Sales by selecting OrderDate, OrderMonth, TotalDue, and OrderRank from the SalesOrderHeader table in AdventureWorks2019 database
-- OrderMonth is calculated by extracting the year and month from OrderDate and setting the day to 1
-- OrderRank is calculated by assigning a rank to each record based on TotalDue, partitioned by OrderMonth, and sorted in descending order
INSERT INTO #Sales
(
       OrderDate
	  ,OrderMonth
      ,TotalDue
	  ,OrderRank
)
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader

-- another temporary table 
CREATE TABLE #Top10Sales
(
OrderMonth DATE,
Top10Total MONEY
)

-- The code inserts data into #Top10Sales by selecting OrderMonth and summing TotalDue from #Sales for records where OrderRank is less than or equal to 10, grouped by OrderMonth
INSERT INTO #Top10Sales
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM #Sales
WHERE OrderRank <= 10
GROUP BY OrderMonth

-- Select data from #Top10Sales and joins it with the previous month's Top10Total
-- Sor the data by OrderMonth in ascending order
SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total
FROM #Top10Sales A
	LEFT JOIN #Top10Sales B
		ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)
ORDER BY 1

-- Select data from #Sales where OrderRank is less than or equal to 10
SELECT * FROM #Sales WHERE OrderRank <= 10

-- Drop the temporary tables #Sales and #Top10Sales
DROP TABLE #Sales
DROP TABLE #Top10Sales
