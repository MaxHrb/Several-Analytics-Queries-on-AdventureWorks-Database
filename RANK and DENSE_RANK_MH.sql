/**

RANK and DENSE_RANK

**/


--ROW_NUMBER, RANK, AND DENSE_RANK, compared

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	Ranking = ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC),
	RankingWithRank = RANK() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC),
	RankingWithDenseRank = DENSE_RANK() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)

FROM AdventureWorks2019.Sales.SalesOrderDetail

ORDER BY SalesOrderID, LineTotal DESC

-------------------------------------------------------------------------------


SELECT * FROM AdventureWorks2019.Production.Product
SELECT * FROM AdventureWorks2019.Production.ProductSubcategory
SELECT * FROM AdventureWorks2019.Production.ProductCategory


SELECT 
  ProductName = A.Name,
  A.ListPrice,
  ProductSubcategory = B.Name,
  ProductCategory = C.Name,
  PriceRank = ROW_NUMBER() OVER(ORDER BY A.ListPrice desc),
  CategoryPriceRank = ROW_NUMBER() OVER(PARTITION BY C.Name ORDER BY A.ListPrice DESC),
  CategoryPriceRankWithRank = RANK() OVER(PARTITION BY C.Name ORDER BY A.ListPrice DESC),
  CategoryPriceRankWithDenseRank = DENSE_RANK() OVER(PARTITION BY C.Name ORDER BY A.ListPrice DESC),
  
  Top5PriceInCategory = 
	CASE
		WHEN ROW_NUMBER() OVER(PARTITION BY C.Name ORDER BY A.ListPrice DESC) <=5 THEN 'Yes'
		ELSE 'No'
	END

FROM AdventureWorks2019.Production.Product A
  JOIN AdventureWorks2019.Production.ProductSubcategory B
    ON A.ProductSubcategoryID = B.ProductSubcategoryID
  JOIN AdventureWorks2019.Production.ProductCategory C
    ON B.ProductCategoryID = C.ProductCategoryID

