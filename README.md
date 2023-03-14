# Several-Analytics-Queries-on-AdventureWorks-Database
## Those queries where created to showcase several ways of queries a database with opensource (non confidential) data





### These SQL queries use Common Table Expressions (CTEs) to simplify and improve the readability of the code.

The first query uses a subquery to compute the Top10Total for each OrderMonth, and then joins the subquery with itself to compute the PrevTop10Total for each month.

The second query refactors the subquery into a CTE named "Sales", which calculates the OrderMonth, TotalDue, and OrderRank for each row in the SalesOrderHeader table. The second CTE named "Top10Sales" then uses the Sales CTE to calculate the Top10Total for each OrderMonth where the OrderRank is less than or equal to 10.

Finally, the main query joins the Top10Sales CTE with itself to compute the PrevTop10Total for each month, and returns the OrderMonth, Top10Total, and PrevTop10Total columns for each row. The result set is sorted by OrderMonth in ascending order.
