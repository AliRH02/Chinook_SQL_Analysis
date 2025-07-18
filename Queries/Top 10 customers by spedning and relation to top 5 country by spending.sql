WITH 
	CountrySpending AS (
		SELECT 
			BillingCountry AS Country, 
			ROUND(SUM(Total),2) AS Amount_Spent
		FROM Invoice
		GROUP BY BillingCountry
		ORDER BY Amount_Spent DESC
		LIMIT 5
	),
	CustomerSpending AS (
		SELECT 
			CustomerId,
			Full_Name,
			Country,
			Total_Spent,
			rk
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
	)
	
SELECT 
	CustomerId,
	Full_Name,
	CustomerSpending.Country,
	CustomerSpending.rk,
	CASE 
		WHEN CustomerSpending.Country IN (
			SELECT Country
			FROM CountrySpending
			) 
		THEN 'TRUE'
		ELSE 'FALSE'
	END AS In_TOP_5_Country
FROM CustomerSpending

	