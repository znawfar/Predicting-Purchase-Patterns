
--- *** Step three: Data Integration ***


--- Data integration has been done by joining and transforming data from multiple tables to create
--- a consolidated dataset for analysis:

--- In this query, I have joined four tables: customers, orders, order_items, and products.
--- The customers table contains information about customers, the orders table contains information about orders,
--- the order_items table contains information about individual items within an order, and the products table contains
--- information about products.

--- The JOIN statements are used to combine the data from these tables based on common columns,
--- such as customer_id, order_id, and product_id. The ON clause specifies the conditions for joining the tables.
--- The selected columns include relevant data from each table, such as customer ID, order ID, product ID, 
--- order date, product name, product category, quantity, price, discount, total amount (calculated as quantity multiplied
--- by the price minus discount), payment method, and shipping country.

--- By using this SQL query, I have integrated data from multiple tables into a consolidated dataset, 
--- which can then be used for further analysis, such as customer segmentation, customer behaviour metrics analysis,
--- and purchase pattern prediction, to gain insights into customer behaviour and purchase patterns.

----------------------------------------------------------------------------------------------------------------------------------------

SELECT 
    c.customer_id,
    o.order_id,
    p.product_id,
    o.order_date,
    p.product_name,
    p.product_category,
    oi.quantity,
    oi.price,
    oi.discount,
    oi.quantity * (oi.price - oi.discount) AS total_amount,
    o.payment_method,
    o.shipping_country
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id;

