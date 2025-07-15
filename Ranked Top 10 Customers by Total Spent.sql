WITH Ranked_Customers AS(
	SELECT 
		Concat(Customer.FirstName,' ',Customer.LastName) AS Name, 
		ROUND(SUM(Invoice.Total), 2) AS Total_Spent,
		DENSE_RANK() OVER(ORDER BY SUM(Invoice.Total) DESC) AS rk
	FROM Invoice
	JOIN Customer
		ON Invoice.CustomerId = Customer.CustomerId
	GROUP BY Customer.CustomerId
)

SELECT Name, Total_Spent
FROM Ranked_Customers
Where rk<=10;