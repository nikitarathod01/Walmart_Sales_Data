# REAL BUSINESS PROBLEMS 
# 1. Find different payment method and number of transactions, and number of quantity sold.
select 
      payment_method,
      COUNT(*) as no_of_payments,
	  SUM(quantity) as no_of_qty_sold
from walmart_clean_data
group by payment_method;

# 2. Identify the highest-rated category in each branch, displaying the branch, the category and the 
#    average rating.
select 
      branch,
	  category,
	  AVG(rating) as avg_rating,
	  RANK() OVER(PARTITION BY branch order by AVG(rating) desc) as rank
from walmart_clean_data
group by 1, 2;

# 3. Identify the busiest day for each branch based on the number of transactions.
SELECT *
FROM (
    SELECT
           branch,
	       TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') AS day_name,
	       COUNT(*) as no_transactions,
	       RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
    from walmart_clean_data
    group by 1, 2 
) AS ranked_data
WHERE 
    rank = 1;

# 4. Calculate the total number of quantity of items sold per payment method. List payment method and total
     # quantity.
     select 
      payment_method,
      COUNT(*) as no_of_payments,
	  SUM(quantity) as no_of_qty_sold
from walmart_clean_data
group by payment_method;

# 5. Determine the average minimum and maximum rating of products for each city. List the city average 
#    rating and minimum rating and maximum rating.
   select 
      city,
	  category,
	  MIN(rating) as min_rating,
	  MAX(rating) as max_rating,
	  ROUND(AVG(rating)) as avg_rating
from walmart_clean_data 
group by 1,2;

# 6. Calculate the total profit for each category byy considering total profit as (unit_price * quantity * 
#     profit_margin). List category and total profit, ordered from highest to lowest profit.
    select 
      category,
	  SUM(total) as total_revenue,
	  SUM(total * profit_margin) as profit 
from walmart_clean_data 
group by 1;
	 
# 7. Determine the most common payment method for each branch. Display branch and the preferred_payment_method.
    WITH cte
AS
(select
      branch,
	  payment_method,
	  COUNT(*) as total_transactions,
	  RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC)
from walmart_clean_data
group by 1, 2
 )
 SELECT *
 FROM cte
 WHERE RANK = 1;

# 8. Categorize sales into 3 groups MORNING, AFTERNOON and EVENING, Find out which of the shift and number
#    and invoices.
    select 
      branch,
	CASE 
	   WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning'
	   WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
	   ELSE 'Evening'
	   End day_time,
	    COUNT(*)
from walmart_clean_data
GROUP BY 1, 2
ORDER BY 1, 3;

# 9. Identify 5 branch with highest decrese ratio in revenue compare to last year *(current year 2023 and last
#     last year 2022).
    WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM 
        walmart_clean_data
    WHERE 
        EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022
    GROUP BY 
        branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM 
        walmart_clean_data
    WHERE 
        EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
    GROUP BY 
        branch
)
SELECT 
    ls.branch,
    ls.revenue AS last_year_revenue,
    cs.revenue AS cr_year_revenue
FROM 
    revenue_2022 AS ls
JOIN 
    revenue_2023 AS cs ON ls.branch = cs.branch
WHERE 
    ls.revenue > cs.revenue
ORDER BY ls.revenue DESC
LIMIT 5;

# 10. 

