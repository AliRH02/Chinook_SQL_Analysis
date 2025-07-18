SELECT 
	BillingCountry AS Country, 
	ROUND(SUM(Total),2) AS Amount_Spent
FROM Invoice
GROUP BY BillingCountry
ORDER BY Amount_Spent DESC
LIMIT 5;