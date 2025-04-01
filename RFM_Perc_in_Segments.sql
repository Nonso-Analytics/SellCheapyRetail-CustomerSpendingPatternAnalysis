-- Recency, Frequency and Monetary Analysis
-- What percentage of our customers are in each RFM Segment?
WITH RFM AS (
				SELECT 
					fs.CustomerID,
					DATEDIFF(DAY, MAX(fs.OrderDate), (SELECT MAX(OrderDate) FROM fact_sales_view)) AS Days_Since_Last_Purchase,
					COUNT(DISTINCT fs.SalesOrderID) AS Num_of_Orders,
					SUM(fs.LineTotal) AS Sales
				FROM [dbo].[fact_sales_view] fs
				GROUP BY fs.CustomerID
),
RFM_SCORES AS (
				SELECT 
					RFM.CustomerID,
					RFM.Days_Since_Last_Purchase,
					RFM.Num_of_Orders,
					RFM.Sales,
					NTILE(5) OVER (ORDER BY RFM.Days_Since_Last_Purchase DESC) AS Recency_Score,
					NTILE(5) OVER (ORDER BY RFM.Num_of_Orders) AS Frequency_Score,
					NTILE(5) OVER (ORDER BY RFM.Sales) AS Monetary_Score
				FROM RFM
),
Customer_Segments AS (
						SELECT 
							dcv.CustomerID,
							dcv.FirstName,
							dcv.LastName,
							RFM_SCORES.Days_Since_Last_Purchase,
							RFM_SCORES.Num_of_Orders,
							RFM_SCORES.Sales,
							RFM_SCORES.Recency_Score,
							RFM_SCORES.Frequency_Score,
							RFM_SCORES.Monetary_Score,
							(RFM_SCORES.Recency_Score + RFM_SCORES.Frequency_Score + RFM_SCORES.Monetary_Score) AS RFM_Total_Score,
							CASE 
								WHEN (RFM_SCORES.Recency_Score + RFM_SCORES.Frequency_Score + RFM_SCORES.Monetary_Score) >= 12 THEN 'High-Value Loyal Customer'
								WHEN (RFM_SCORES.Recency_Score + RFM_SCORES.Frequency_Score + RFM_SCORES.Monetary_Score) BETWEEN 8 AND 11 THEN 'Potential Loyal Customer'
								WHEN (RFM_SCORES.Recency_Score + RFM_SCORES.Frequency_Score + RFM_SCORES.Monetary_Score) BETWEEN 5 AND 7 THEN 'At-Risk Customer'
								ELSE 'Dormant Customer'
							END AS Customer_Segment
						FROM RFM_SCORES
						JOIN dim_customer_view dcv ON RFM_SCORES.CustomerID = dcv.CustomerID
)
-- Calculate the total percentage of each segment
SELECT 
    Customer_Segment,
    COUNT(*) AS Segment_Count,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Customer_Segments)) AS Segment_Percentage
FROM Customer_Segments
GROUP BY Customer_Segment
ORDER BY Segment_Percentage DESC;
