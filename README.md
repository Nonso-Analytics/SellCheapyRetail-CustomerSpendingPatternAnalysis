# SellCheapyRetail-CustomerSpendingPatternAnalysis

![DA Scenario 2](https://github.com/user-attachments/assets/23e4941d-912b-4e9f-9b8a-da2bade3221e)

## PROBLEM STATEMENT
**SellCheapy Retail** is a chain of department stores that sells a wide range of products, including bikes and different components. Despite having a large customer base, the company has been struggling to increase sales in recent years. The management team is looking to use data analysis to understand customer spending patterns and make changes to their sales and marketing strategies to improve performance and so have brought me on as a Data Analyst.
<br>
The company collected data on customer demographics, purchasing history, and other relevant information over the course of a year. The data includes information on the products purchased, the price paid, and the date of purchase, etc.

 

**Dataset :** Adventureworks Dataset 2019 OLTP https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak <br>
<br>
**Entity Relationship Diagram**
![AdventureWorksERD](https://github.com/user-attachments/assets/b835abd2-c811-4da3-a4c5-96aec99150f7)

## METHODOLOGY
Exploring the ERD and the relationship between each tables;<br>
I was able to create four new business views pertaining to customer spend analysis<br>
The scripts to create the four views are <br>
- Cleaned_Customers,<br>
- Cleaned Products,<br>
- Cleaned Sales Territory, and <br>
- Cleaned Sales.<br>

## ANALYSIS AND INSIGHTS
**RFM (Recency, Frequency, Monetary) Analysis** <br>
RFM analysis is proven method for identifying and categorizing customers based on their purchasing behavior. By assigning scores to each RFM metric and classifying customers into meaningful segments (e.g., High-Value Loyal Customer, Potential Loyal Customers, At Risk Customer, Dormant Customer), businesses can optimize marketing strategies, improve customer retention, and drive revenue growth.<br>

**RFM Customer Segmentation**

| RFM Score | Customer Segment              |
|-----------|--------------------------------|
| 12 - 15   | High-Value Loyal Customers    |
| 8 - 11    | Potential Loyal Customers     | 
| 5 - 7     | At-Risk Customers             | 
| 1 - 4     | Dormant Customers             | 

**Some questions RFM helps answer**
- Who are our highest-value customers?
- Which customers are at risk of churning?
- Which formerly frequent buyers have stopped purchasing?
- Which customers should be targeted for re-engagement campaigns?
- How can we tailor loyalty programs to different customer segments for maximum impact?

- Taking a look at our customer segments created based on RFM  What percentage of our customers are in each RFM Segment?

**Customer Segment Breakdown**

| Customer_Segment             | Segment_Count | Segment_Count(%) | Description |
|------------------------------|--------------|------------------|-------------|
| **Potential Loyal Customer**  | 7,417        | 40.13%           | Engaged customers with strong potential to become high-value loyal customers. |
| **High-Value Loyal Customer** | 4,711        | 25.49%           | The most profitable and engaged customers, key drivers of revenue. |
| **At Risk Customer**          | 4,611        | 24.95%           | Customers showing signs of disengagement, at risk of churning. |
| **Dormant Customer**          | 1,745        | 9.44%            | Customers who have stopped purchasing and require re-engagement efforts. |

### Key Insights:
- **65.6% of customers (Potential Loyal + High-Value)** are **key revenue drivers**. Retention strategies should focus on personalized engagement and upselling opportunities.
- **34.4% of customers (At Risk + Dormant)** require **proactive intervention** to prevent churn and re-engage them.
- **Targeted marketing campaigns** based on these segments can **boost customer lifetime value (CLV) and retention rates**.

### Suggested Strategies for each customer segment:
- **Potential Loyal Customers:** Exclusive promotions, loyalty incentives, and personalized offers.
- **High-Value Loyal Customers:** VIP programs, personalized experiences, and early access to new products.
- **At Risk Customers:** Re-engagement emails, retention discounts, and proactive customer support outreach.
- **Dormant Customers:** Retargeting ads, win-back campaigns, and surveys to understand reasons for inactivity.




