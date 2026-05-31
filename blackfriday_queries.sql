CREATE DATABASE IF NOT EXISTS blackfriday_db;
USE blackfriday_db;

CREATE TABLE blackfriday (
  transaction_id VARCHAR(50),
  customer_id VARCHAR(50),
  age_group VARCHAR(20),
  gender VARCHAR(10),
  city VARCHAR(50),
  customer_segment VARCHAR(50),
  product_id VARCHAR(50),
  product_category VARCHAR(50),
  original_price DECIMAL(10,2),
  discount_pct DECIMAL(5,2),
  final_price DECIMAL(10,2),
  quantity INT,
  purchase_amount DECIMAL(10,2),
  payment_method VARCHAR(50),
  purchase_date DATE,
  purchase_hour INT,
  is_weekend INT,
  is_black_friday INT,
  month_year VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Black_Friday_sales.csv'
INTO TABLE blackfriday
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM blackfriday LIMIT 10;

-- Q-1 Which product categories generate the most revenue?

select product_category, Sum(Purchase_amount) as total_Revenue
From blackfriday
group by product_category
order by total_Revenue desc;

-- Q-2 Do higher discounts always lead to higher sales?

SELECT
  CASE
    WHEN discount_pct = 0 THEN 'No discount'
    WHEN discount_pct <= 10 THEN 'Low (1-10%)'
    WHEN discount_pct <= 25 THEN 'Medium (11-25%)'
    WHEN discount_pct <= 50 THEN 'High (26-50%)'
    ELSE 'Very High (50%+)'
  END as discount_bucket,
  COUNT(*) as transactions,
  ROUND(AVG(quantity), 2) as avg_units_bought,
  ROUND(AVG(purchase_amount), 2) as avg_spend
FROM blackfriday
GROUP BY discount_bucket
ORDER BY avg_spend DESC;

-- Q-3 Which customer segments spend the most? 

SELECT
  customer_segment,
  gender,
  age_group,
  city,
  COUNT(DISTINCT customer_id) as unique_customers,
  ROUND(AVG(purchase_amount), 2) as avg_spend,
  ROUND(SUM(purchase_amount), 2) as total_revenue
FROM blackfriday
GROUP BY customer_segment, gender, age_group, city
ORDER BY avg_spend DESC
LIMIT 15;

-- Q-4 What time of day drives the most purchases?

select
purchase_hour,
is_weekend,
is_black_friday,
 count(*) as transaction,
 sum(purchase_amount) as total_revenue
 from blackfriday
 Group by purchase_hour, is_weekend, is_black_friday
 order by purchase_hour;
 
 -- Q-5 How does purchase behavior vary across cities?
 
 select
 product_category,
 discount_pct,
 quantity,
 payment_method,
 count(*) as sample_size,
 avg(Purchase_amount) as avg_spend
from blackfriday
group by 
 product_category, discount_pct, quantity, payment_method
 order by avg_spend; 
 
 
 