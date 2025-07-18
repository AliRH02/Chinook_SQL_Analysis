SELECT 
	CustomerId,
	Full_Name,
	Country,
	Total_Spent
FROM (
	SELECT 
	Customer.CustomerId,
	CONCAT(Customer.FirstName,' ',Customer.LastName) As Full_Name,
	Customer.Country,
	SUM(Invoice.Total) AS Total_spent,
	DENSE_RANK() OVER(ORDER BY SUM(Invoice.Total) DESC) AS rk
FROM Customer
JOIN Invoice	
	ON Customer.CustomerId=Invoice.CustomerId
GROUP BY Customer.CustomerId
)
WHERE rk<=10
