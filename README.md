# Chinook_SQL_Analysis

## Overview
This project explores sales and customer trends in a fictional music store using the Chinook database. The goal was to strengthen SQL querying, data validation, and data storytelling skills using real world questions and visualization tools.

## Key Questions:
1. What are the average sales per year?
2. What are the 5 most popular music genres by quantity sold?
3. What are the top 10 customers based on total spending?
4. Which countries generated the most revenue?
5. How do the top 10 customers relate to the top 5 revenue generating countries?


## Sample Queries

### Average Sales Per Year
```sql
SELECT strftime('%Y', Invoice.InvoiceDate) AS Year, 
       ROUND(AVG(Invoice.Total), 2) AS Average_Sales
FROM Invoice 
GROUP BY Year
ORDER BY Year;
```
📄 [Average Sales Per Year (CSV)](https://github.com/AliRH02/Chinook_SQL_Analysis/blob/main/OutputTables/Average%20Sales%20Per%20Year.csv)  

### Top 5 Most Popular Genres By Quantity Sold
```sql
SELECT Genre.Name AS Genre, SUM(InvoiceLine.Quantity) AS Quantity_Sold
FROM InvoiceLine 
JOIN Track 
	ON InvoiceLine.TrackId = Track.TrackId
JOIN Genre
	ON Track.GenreId = Genre.GenreId
GROUP BY Genre.Name
ORDER BY Quantity_Sold DESC
LIMIT 5;
``` 
📄 [Top 5 Most Popular Genres By Quantity Sold (CSV)](https://github.com/AliRH02/Chinook_SQL_Analysis/blob/main/OutputTables/Top%205%20Genre%20By%20Quantity%20Sold.csv)  


### Top 10 Customers by Total Spending (Dense ranked)
```sql
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
```
📄 [Top 10 Customers by Total Spending (CSV)](https://github.com/AliRH02/Chinook_SQL_Analysis/blob/main/OutputTables/Top%2010%20Customers%20Based%20on%20Spent%20Amount%20Dense%20ranked.csv) 


### Top 5 Countries Based on Revenue
```sql
SELECT 
	BillingCountry AS Country, 
	ROUND(SUM(Total),2) AS Amount_Spent
FROM Invoice
GROUP BY BillingCountry
ORDER BY Amount_Spent DESC
LIMIT 5;
```
📄 [Top 10 Countries Based on Revenue (CSV)](https://github.com/AliRH02/Chinook_SQL_Analysis/blob/main/OutputTables/Top%2010%20Country%20by%20Amount%20Spent.csv) 


### Top 10 Customers and their Relation to the Top 5 Countries
```sql
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

	
```
📄 [Top 10 Countries Based on Revenue (CSV)](https://github.com/AliRH02/Chinook_SQL_Analysis/blob/main/OutputTables/Top%2010%20customers%20by%20spedning%20and%20relation%20to%20top%205%20country%20by%20spending.csv) 

## Power BI Dashboard Summary
The following visualizations were created using Power BI:

- Pie Chart: Top 5 genres by total revenue.

- Bar Chart: Top 10 customers by total spending (with DENSE_RANK).

- Bar Chart: Top 5 countries by total customer spending.

- Stacked Bar Chart: For each of the top 5 countries, displays the contribution of top 10 customers to that country’s total revenue.
	- Example: For the USA, only the top 10 customers located there are shown; total is less than full country total due to excluded customers.

- Multi-Row Card: To display number of top customers within the top countries
	- These visualizations provide insight into revenue concentration by geography and customer segment.

## Final Thoughts

This project was an opprotnutiy to practice with real world data analysis using SQL and to enhance data storytelling through Power BI. Beyond identifying top customers and popular genres, the analysis helped me uncover how revenue is geographically distributed. 

By connecting the top spending customers and the top 5 revenue generating countries, the project revealed that many high value customers are concentrated in these key regions. This offered insight into hoe locationinfluences custoemrs bahavior and overall sales performance. 

## Tools Used
- **SQLite** via DB Browser
- **Power BI** for data visualization
