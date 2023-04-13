
--- *** Step two: Data Cleaning ***


--- The dataset was thoroughly cleaned to handle missing values, inconsistencies, and duplicates,
--- ensuring data accuracy and integrity.


--- I would explain the SQL query for data cleaning on the e-commerce transaction data in more detail:

--- 1- Removing duplicate records: The first part of the query uses a common table expression (CTE) called duplicate_records to identify
--- and assign a row number to each record within groups of records with the same values for customer_id, order_id, product_id,
--- order_date, product_name, product_category, quantity, price, discount, total_amount, payment_method, and shipping_country columns,
--- ordered by transaction_id. The ROW_NUMBER() function is used for this purpose. The CTE is then used in a DELETE statement to
--- remove records where the row number is greater than 1, effectively deleting duplicate records from the transactions table.

--- 2- Updating missing values: The second part of the query uses an UPDATE statement to set the value of payment_method column
--- to 'Unknown' for records where the payment_method is NULL, effectively updating the missing values with 
--- an appropriate default value.

--- 3- Correcting inconsistencies in product names: The third part of the query uses another UPDATE statement to set the value
--- of product_name column to 'Unknown' for records where the product_name is an empty string (''),
--- effectively correcting inconsistencies in the product names by replacing empty product names with a default value.

--- 4- Identifying and handling outliers in total_amount column: The fourth part of the query uses a CTE called outliers
--- to identify records where the total_amount column has outlier values, defined as values less than 0 or greater than 1,000,000.
--- The CTE is then used in an UPDATE statement to set the value of total_amount column to the average total_amount value 
--- for all records in the transactions table excluding the records with outlier values, effectively handling outliers in
--- the total_amount column by replacing them with the calculated average value.

------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove duplicate records
WITH duplicate_records AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY customer_id, order_id, product_id, order_date, product_name, product_category, quantity, price, discount, total_amount, payment_method, shipping_country
    ORDER BY transaction_id
  ) AS row_num
  FROM transactions
)
DELETE FROM duplicate_records
WHERE row_num > 1;

-- Update missing values with appropriate default values
UPDATE transactions
SET payment_method = 'Debit Card'
WHERE payment_method IS NULL;

-- Correct inconsistencies in product names
UPDATE transactions
SET product_name = 'ID Num 1'
WHERE product_name = '';

-- Identify and handle outliers in total_amount column
WITH outliers AS (
  SELECT transaction_id, total_amount
  FROM transactions
  WHERE total_amount < 0 OR total_amount > 1000000
)
UPDATE transactions
SET total_amount = (
  SELECT AVG(total_amount)
  FROM transactions
  WHERE transaction_id NOT IN (SELECT transaction_id FROM outliers)
)
WHERE transaction_id IN (SELECT transaction_id FROM outliers);


