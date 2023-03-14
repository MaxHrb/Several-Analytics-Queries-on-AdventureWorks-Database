# Several-Analytics-Queries-on-AdventureWorks-Database
## Those queries where created to showcase several ways of queries a database with opensource (non confidential) data





### These SQL queries use Common Table Expressions (CTEs) to simplify and improve the readability of the code.

The first query uses a subquery to compute the Top10Total for each OrderMonth, and then joins the subquery with itself to compute the PrevTop10Total for each month.

The second query refactors the subquery into a CTE named "Sales", which calculates the OrderMonth, TotalDue, and OrderRank for each row in the SalesOrderHeader table. The second CTE named "Top10Sales" then uses the Sales CTE to calculate the Top10Total for each OrderMonth where the OrderRank is less than or equal to 10.

Finally, the main query joins the Top10Sales CTE with itself to compute the PrevTop10Total for each month, and returns the OrderMonth, Top10Total, and PrevTop10Total columns for each row. The result set is sorted by OrderMonth in ascending order.


### Correlated Subquerries
This SQL script demonstrates the use of correlated subqueries to extract additional information from related tables in a database. Correlated subqueries are subqueries that reference a column from the main query, allowing for more dynamic and contextual data retrieval.

In the first example, the query retrieves sales order information from the SalesOrderHeader table, and also counts the number of orders that have more than one item in the SalesOrderDetail table using a correlated subquery. The same approach is taken in the second example, where purchase order information is retrieved from the PurchaseOrderHeader table, and the number of non-rejected items is counted using a correlated subquery.

In the third example, additional data is extracted from the PurchaseOrderDetail table, by finding the maximum unit price for each purchase order using another correlated subquery. Overall, the script demonstrates the flexibility and power of correlated subqueries in SQL.
