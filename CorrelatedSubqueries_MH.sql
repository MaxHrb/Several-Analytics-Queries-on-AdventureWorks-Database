
/** Correlated Subqueries

**/

SELECT * FROM AdventureWorks2019.Sales.SalesOrderHeader

SELECT 
       SalesOrderID
      ,OrderDate
      ,SubTotal
      ,TaxAmt
      ,Freight
      ,TotalDue
	  ,MultiOrderCount = --correlated subquery
	  (
		  SELECT
		  COUNT(*)
		  FROM AdventureWorks2019.Sales.SalesOrderDetail B
		  WHERE A.SalesOrderID = B.SalesOrderID
		  AND B.OrderQty > 1
	  )

  FROM AdventureWorks2019.Sales.SalesOrderHeader A


  --Nr1
  
  SELECT * FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader


  SELECT 
        PurchaseOrderID
	   ,VendorID
	   ,OrderDate
	   ,TotalDue
	   ,NonRejectedItems = --correlated subquery
	  (
		  SELECT
		  COUNT(*)
		  FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
		  WHERE A.PurchaseOrderID = B.PurchaseOrderID
		  AND B.RejectedQty = 0
		  
	  )

  FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A

Nr1.1

  SELECT 
        PurchaseOrderID
	   ,VendorID
	   ,OrderDate
	   ,TotalDue
	   ,NonRejectedItems = --correlated subquery
	  (
		  SELECT
		  COUNT(*)
		  FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
		  WHERE A.PurchaseOrderID = B.PurchaseOrderID
		  AND B.RejectedQty = 0
		  
	  )
	  ,MostExpensiveItem = --correlated subquery
	  
	  (
		SELECT
			MAX(B.UnitPrice)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
		WHERE A.PurchaseOrderID = B.PurchaseOrderID
		)


  FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A
