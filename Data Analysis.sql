
--- *** Step three: Data Analysis ***

--- I would use advanced SQL techniques, including window functions, subqueries, stored procedures, and views,
--- to perform data analysis tasks on the given dataset for the project topic of analyzing customer behaviour and
--- predicting purchase patterns.

--- In the provided SQL query, I have started by calculating customer behaviour metrics using a Common Table Expression (CTE) named customer_metrics.
--- This CTE calculates the average order value, unique orders, total quantity, and total amount for each customer
--- by grouping the transaction data by customer_id and using aggregate functions like AVG and SUM.
--- Next, I have used conditional statements in the SELECT clause to perform customer segmentation.

--- I have defined three segments based on the calculated metrics:
--- customer_segment, purchase_segment, and volume_segment.

--- The "customer_segment" segment categorizes customers as either "High-Value Customer" or "Regular Customer" based on
--- their average order value. This is determined by comparing the average order value of each customer with the overall
--- average order value calculated from the customer_metrics CTE.

--- The "purchase_segment" segment categorizes customers as either "Frequent Buyer" or "Infrequent Buyer" based on
--- the number of unique orders they have placed. This is determined by comparing the number of unique orders of 
--- each customer with the overall average number of unique orders calculated from the customer_metrics CTE.

--- The "volume_segment" segment categorizes customers as either "High-Volume Buyer" or "Low-Volume Buyer" based on
--- the total quantity of products they have purchased. This is determined by comparing the total quantity of products purchased
--- by each customer with the overall average total quantity calculated from the customer_metrics CTE.

--- The result of the query will be a list of customers with their corresponding customer segments,
--- purchase segment, and volume segment, which can provide insights into customer behaviour and purchase patterns. 
--- I must emphasize this information has been used to optimize marketing strategies, improve customer retention,
--- and boost sales.


-------------------------------------------------------------------------------------------------------------------------------------------
-- Create a view to calculate customer behavior metrics
CREATE OR REPLACE VIEW customer_behavior_metrics AS
SELECT
  customer_id,
  AVG(total_amount) AS avg_order_value,
  COUNT(DISTINCT order_id) AS unique_orders,
  SUM(quantity) AS total_quantity,
  SUM(total_amount) AS total_amount,
  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_rank
FROM
  orders
GROUP BY
  customer_id,
  order_id,
  order_date;

-- Create a stored procedure to segment customers based on behavior metrics
DELIMITER //
CREATE PROCEDURE segment_customers()
BEGIN
  -- Customer Segmentation: High-Value Customers
  CREATE TEMPORARY TABLE high_value_customers AS
  SELECT
    customer_id
  FROM
    customer_behavior_metrics
  WHERE
    total_amount > (SELECT AVG(total_amount) FROM customer_behavior_metrics)
  GROUP BY
    customer_id;
  
  -- Customer Segmentation: Frequent Buyers
  CREATE TEMPORARY TABLE frequent_buyers AS
  SELECT
    customer_id
  FROM
    customer_behavior_metrics
  WHERE
    unique_orders > (SELECT AVG(unique_orders) FROM customer_behavior_metrics)
  GROUP BY
    customer_id;
  
  -- Customer Segmentation: Dormant Customers
  CREATE TEMPORARY TABLE dormant_customers AS
  SELECT
    customer_id
  FROM
    customer_behavior_metrics
  WHERE
    order_rank > (SELECT COUNT(DISTINCT order_id) FROM orders) * 0.5
  GROUP BY
    customer_id;
  
  -- Return segmented customers
  SELECT
    'High-Value Customers' AS segment,
    COUNT(*) AS count
  FROM
    high_value_customers
  
  UNION ALL
  
  SELECT
    'Frequent Buyers' AS segment,
    COUNT(*) AS count
  FROM
    frequent_buyers
  
  UNION ALL
  
  SELECT
    'Dormant Customers' AS segment,
    COUNT(*) AS count
  FROM
    dormant_customers;
END //
DELIMITER ;

-- Call the stored procedure to segment customers
CALL segment_customers();



