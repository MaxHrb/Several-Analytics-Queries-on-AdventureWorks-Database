
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

 /** Exercise 1


Write a query that outputs all records from the Purchasing.PurchaseOrderHeader table. Include the following columns from the table:

PurchaseOrderID

VendorID

OrderDate

TotalDue

Add a derived column called NonRejectedItems which returns, for each purchase order ID in the query output, the number of line items from the Purchasing.PurchaseOrderDetail table which did not have any rejections (i.e., RejectedQty = 0). Use a correlated subquery to do this.



Exercise 2


Modify your query to include a second derived field called MostExpensiveItem.

This field should return, for each purchase order ID, the UnitPrice of the most expensive item for that order in the Purchasing.PurchaseOrderDetail table.

Use a correlated subquery to do this as well.



Hint: Think of the most appropriate aggregate function to use in the correlated subquery for this scenario.

**/



  --Exercise 1 Solution:
  
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