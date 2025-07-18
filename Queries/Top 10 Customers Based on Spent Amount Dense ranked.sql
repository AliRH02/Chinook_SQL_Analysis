SELECT 
	Full_Name,
	Total_Spent,
	rk AS dense_rank
FROM(
	SELECT 
		CONCAT(Customer.FirstName,' ', Customer.LastName) AS Full_Name,
		Customer.CustomerId, 
		Invoice.Total, Invoice.InvoiceId,
		SUM(Invoice.Total) AS Total_Spent,
		DENSE_RANK() OVER(ORDER BY SUM(Invoice.Total) DESC) AS rk
	FROM Customer
	JOIN Invoice
		ON Customer.CustomerId=Invoice.CustomerId
	GROUP BY Customer.CustomerId
)
WHERE rk<=10