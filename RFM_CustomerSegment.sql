-- Recency, Frequency and Monetary Analysis
-- Group our customers into different RFM Segment
WITH RFM AS (
				SELECT 
					fs.CustomerID,
					-- Calculate Days Since Last Purchase
					DATEDIFF(DAY, MAX(fs.OrderDate), (SELECT MAX(OrderDate) FROM fact_sales_view)) AS Days_Since_Last_Purchase,
					-- Count Unique Orders
					COUNT(DISTINCT fs.SalesOrderID) AS Num_of_Orders,
					-- Total Sales per Customer
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
					-- Assign Recency, Frequency, and Monetary Scores (Higher is Better)
					NTILE(5) OVER (ORDER BY RFM.Days_Since_Last_Purchase DESC) AS Recency_Score, -- More recent = higher score
					NTILE(5) OVER (ORDER BY RFM.Num_of_Orders) AS Frequency_Score, -- More orders = higher score
					NTILE(5) OVER (ORDER BY RFM.Sales) AS Monetary_Score -- More sales = higher score
				FROM RFM
)
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
    -- Customer Segmentation Based on RFM Score
    CASE 
        WHEN (RFM_SCORES.Recency_Score + RFM_SCORES.Frequency_Score + RFM_SCORES.Monetary_Score) >= 12 THEN 'High-Value Loyal Customer'
        WHEN (RFM_SCORES.Recency_Score + RFM_SCORES.Frequency_Score + RFM_SCORES.Monetary_Score) BETWEEN 8 AND 11 THEN 'Potential Loyal Customer'
        WHEN (RFM_SCORES.Recency_Score + RFM_SCORES.Frequency_Score + RFM_SCORES.Monetary_Score) BETWEEN 5 AND 7 THEN 'At-Risk Customer'
        ELSE 'Dormant Customer'
    END AS Customer_Segment
FROM RFM_SCORES
JOIN dim_customer_view dcv ON RFM_SCORES.CustomerID = dcv.CustomerID
ORDER BY RFM_SCORES.Sales DESC;
