
--- *** Step four: Performance Optimization ***

--- I would like to explain the optimized SQL query for analyzing customer behaviour and predicting purchase patterns step by step:

--- 1- Indexing for Performance Optimization: The query starts by creating two indexes using the CREATE INDEX statement.
--- In this case, I have created indexes on the customer_id column in the orders table and the product_id column
--- in the order_details table to optimize performance and speed up the query execution.

--- 2- Common Table Expression (CTE): The query then uses a CTE, which is a temporary named result set that can be used within
--- a larger SQL statement. In this case, I have defined a CTE named customer_order_metrics to calculate various metrics for
--- each customer, including the total number of orders, total revenue, average order value, and unique products purchased.

--- 3- Join and Group By: Within the CTE, I have used an inner join to combine data from the orders and order_details tables
--- based on the order_id column, and then I have grouped the results by customer_id. 
--- This allows me to aggregate the data at the customer level and calculate the required metrics.

--- 4- CASE Statements: The query uses two CASE statements to calculate additional metrics. The first CASE statement determines 
--- if a customer has made repeat purchases by checking if the total number of orders (total_orders) is greater than 1. 
--- If a customer has made repeat purchases, the CASE statement assigns a value of 1, otherwise 0, to the repeat_purchase column.
--- The second CASE statement calculates the repeat purchase rate by dividing the total number of repeat orders (total_orders - 1) 
--- by the total number of orders minus one plus 1.0, to ensure a decimal result.

--- 5- SELECT Statement: Finally, the query retrieves the calculated metrics for each customer from the CTE, 
--- including the customer_id, total_orders, total_revenue, avg_order_value, total_unique_products, repeat_purchase,
--- and repeat_purchase_rate columns. The results are ordered by total revenue in descending order using the ORDER BY clause.


--- This optimized SQL query uses indexing, query aggregation, and CASE statements to efficiently analyze customer behaviour 
--- and predict purchase patterns from the provided dataset, providing valuable insights for business decision-making.

----------------------------------------------------------------------------------------------------------------------------------------

-- Enable indexing for performance optimization
CREATE INDEX idx_customer_id ON orders (customer_id);
CREATE INDEX idx_product_id ON order_details (product_id);

-- Calculate average order value and repeat purchase rate
WITH customer_order_metrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(total_amount) AS total_revenue,
        AVG(total_amount) AS avg_order_value,
        COUNT(DISTINCT product_id) AS total_unique_products
    FROM
        orders
    INNER JOIN
        order_details ON orders.order_id = order_details.order_id
    GROUP BY
        customer_id
)
SELECT
    customer_id,
    total_orders,
    total_revenue,
    avg_order_value,
    total_unique_products,
    CASE
        WHEN total_orders > 1 THEN 1
        ELSE 0
    END AS repeat_purchase,  -- 1 for repeat purchase, 0 for first-time purchase
    CASE
        WHEN total_orders > 1 THEN (total_orders - 1) / (total_orders - 1 + 1.0)
        ELSE 0
    END AS repeat_purchase_rate  -- repeat purchase rate
FROM
    customer_order_metrics
ORDER BY
    total_revenue DESC;
