-- SQL QUERIES
-- LIMIT
SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;

-- ORDER BY

-- Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

-- Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

-- Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

-- 1. Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

-- 2. Now write a query that again displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

-- WHERE

-- 1.Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

-- 2.Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

-- WHERE NON NUMERIC

-- 1. Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

-- DERIVED COLUMNS

SELECT id, account_id, standard_amt_usd / standard_qty AS derived_column
FROM orders
LIMIT 10;

-- Write a query that finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd. (Try to do this without using the total column.) Display the id and account_id fields also. NOTE - you will receive an error with the correct solution to this question. This occurs because at least one of the values in the data creates a division by zero in your formula. You will learn later in the course how to fully handle this issue. For now, you can just limit your calculations to the first 10 orders, as we did in question #1, and you'll avoid that set of data that causes the problem.
SELECT id, account_id, 
        poster_amt_usd /(standard_amt_usd + gloss_amt_usd + poster_amt_usd) * 100 AS derived_poster_percentage
FROM orders
LIMIT 10;

-- LIKE

-- 1. All the companies whose names start with 'C'.
SELECT * FROM accounts WHERE name LIKE 'C%'

-- All companies whose names contain the string 'one' somewhere in the name.
SELECT * FROM accounts WHERE name LIKE '%one%'

-- All companies whose names end with 's'.
SELECT * FROM accounts WHERE name LIKE '%s'

-- IN

-- Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts WHERE name IN ('Walmart','Target','Nordstrom')

-- Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
SELECT *
FROM web_events WHERE channel IN ('organic','adwords')

-- NOT

-- Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id 
FROM accounts 
WHERE name NOT IN('Walmart','Target','Nordstrom')

-- Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.
SELECT * FROM web_events WHERE channel NOT IN('organic','adwords')

-- 1. All the companies whose names start with 'C'.
SELECT name FROM accounts WHERE name NOT LIKE 'C%'

-- All companies whose names contain the string 'one' somewhere in the name.
SELECT name FROM accounts WHERE name NOT LIKE '%one%'

-- All companies whose names end with 's'.
SELECT name FROM accounts WHERE name NOT LIKE '%s'

-- AND and BETWEEN

-- Write a query that returns all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

-- Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

-- BETWEEN de 24 ve 29 dahildir.
SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

SELECT * 
FROM web_events
WHERE channel IN('organic','adwords') AND occurred_at BETWEEN ('2016-1-1') AND ('2017-1-1');

-- OR

-- 1. Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.

SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000

-- 2. Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.

SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000)

-- 3. Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.

SELECT *
FROM accounts
WHERE (name LIKE 'C%' or name LIKE 'W%') AND ((primary_poc LIKE '%ana%' or primary_poc LIKE '%Ana%') AND primary_poc NOT LIKE '%eana%') 

-- JOIN

-- 1. Try pulling all the data from the accounts table, and all the data from the orders table.

SELECT accounts.*, orders.*
FROM accounts
JOIN orders ON accounts.id = orders.account_id;

-- 2. Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
FROM orders
JOIN accounts ON orders.account_id = accounts.id;

-- 1.Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

SELECT t2.primary_poc, t1.occurred_at, t1.channel, t2.name
FROM web_events t1
JOIN accounts t2 ON t1.account_id = t2.id
WHERE t2.name = 'Walmart'

-- 2. Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT t2.name region_name, t1.name sales_reps_name, t3.name account_name
FROM sales_reps t1
JOIN region t2 ON t1.region_id = t2.id
JOIN accounts t3 ON t1.id = t3.sales_rep_id
ORDER BY account_name

-- 3. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.

SELECT t1.name region_name, t3.name account_name, (t4.total_amt_usd / (t4.total + 0.01)) unit_price
FROM region t1
JOIN sales_reps t2 ON t2.region_id = t1.id
JOIN accounts t3 ON t3.sales_rep_id = t2.id
JOIN orders t4 ON t4.account_id = t3.id

-- 1. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.-48

SELECT r.name region_name, s.name sales_reps_name, a.name account_name
FROM sales_reps s
JOIN region r ON r.id = s.region_id AND r.name = 'Midwest'
JOIN accounts a ON a.sales_rep_id = s.id
ORDER BY a.name

-- 2. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name. -5

SELECT r.name region_name, s.name sales_reps_name, a.name account_name
FROM sales_reps s
JOIN region r ON r.id = s.region_id AND r.name = 'Midwest' AND s.name LIKE 'S%'
JOIN accounts a ON a.sales_rep_id = s.id
ORDER BY a.name

-- 3. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name. -13

SELECT r.name region_name, s.name sales_reps_name, a.name account_name
FROM sales_reps s
JOIN region r ON r.id = s.region_id AND r.name = 'Midwest' AND s.name LIKE '% K%'
JOIN accounts a ON a.sales_rep_id = s.id
ORDER BY a.name

-- 4.Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01). -4509

SELECT r.name region_name, a.name account_name, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM region r
JOIN sales_reps s ON s.region_id = r.id
JOIN accounts a ON a.sales_rep_id = s.id
JOIN orders o ON o.account_id = a.id AND o.standard_qty > 100

-- 5. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01). -835

SELECT r.name region_name, a.name account_name, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM region r
JOIN sales_reps s ON s.region_id = r.id
JOIN accounts a ON a.sales_rep_id = s.id
JOIN orders o ON o.account_id = a.id AND o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price

-- 6. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01). -835

SELECT r.name region_name, a.name account_name, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM region r
JOIN sales_reps s ON s.region_id = r.id
JOIN accounts a ON a.sales_rep_id = s.id
JOIN orders o ON o.account_id = a.id AND o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC

-- 7. What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values. -6

SELECT DISTINCT a.name account_name, channel
FROM accounts a
JOIN web_events w ON a.id = w.account_id AND a.id = 1001

-- ⭐ 8. Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd. -99400

SELECT o.occurred_at, a.name account_name, o.total order_total, o.total_amt_usd
FROM orders o
JOIN accounts a ON a.id = o.account_id AND o.occurred_at BETWEEN ('2015-1-1') AND ('2016-1-1');

-- COUNT

-- ⭐rowlari sayar

SELECT COUNT(*)
FROM accounts

-- primary_puc NULL olan satirlari gosterme

SELECT * 
FROM accounts
WHERE primary_poc IS NULL

-- SUM
-- 1 Find the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty) poster_total
FROM orders

-- 2
SELECT SUM(standard_qty) standard_total
FROM orders

-- 3 Find the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(total_amt_usd) usd_total
FROM orders

-- 4 Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.
SELECT standard_amt_usd + gloss_amt_usd total
FROM orders

-- ❓(soru garip )5 Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.
SELECT SUM(standard_amt_usd) / SUM(standard_qty) ratio
FROM orders

-- MIN MAX

-- 1. When was the earliest order ever placed? You only need to return the date.

SELECT MIN(occurred_at) min_order_date
FROM orders

-- 2. Try performing the same query as in question 1 without using an aggregation function.

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

-- 3. When did the most recent (latest) web_event occur?

SELECT MAX(occurred_at)
FROM web_events

-- 4. Try to perform the result of the previous query without using an aggregation function.

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

-- 5. Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

SELECT AVG(standard_qty) standard_qty_avg, AVG(gloss_qty) gloss_qty_avg, AVG(poster_qty) poster_qty_avg, AVG(standard_amt_usd) standard_amt_usd_avg, AVG(gloss_amt_usd) gloss_amt_usd_avg, AVG(poster_amt_usd) poster_amt_usd_avg
FROM orders

-- 6. Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?
-- ❓

-- GROUP BY

-- 1. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.

SELECT a.name account_name, occurred_at date_of_order
FROM orders o
JOIN accounts a ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1

-- 2. Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.

SELECT a.name account_name, SUM(total_amt_usd)
FROM orders o
JOIN accounts a ON a.id = o.account_id
GROUP BY a.name

-- satis olmayan sirket

SELECT *
FROM accounts a
LEFT JOIN orders o ON o.account_id = a.id
WHERE o.total_amt_usd IS NULL

-- 3. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT occurred_at date, channel, a.name account_name
FROM web_events w
JOIN accounts a ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1

-- 4.Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
SELECT w.channel, COUNT(*) number_of_times
FROM web_events w
GROUP BY w.channel

-- 5. Who was the primary contact associated with the earliest web_event?

SELECT a.primary_poc contact
FROM web_events w
JOIN accounts a ON a.id = w.account_id
ORDER BY occurred_at
LIMIT 1

-- 6 What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.

SELECT a.name account_name, MIN(total_amt_usd) total_usd
FROM accounts a
JOIN orders o ON o.account_id = a.id
GROUP BY a.name
ORDER BY total_usd

--7. Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.

SELECT r.name region, COUNT(s.id) number_of_sales_reps
FROM sales_reps s
JOIN region r ON r.id = s.region_id
GROUP BY r.name
ORDER BY number_of_sales_reps

-- GROUP BY 2

-- 1. For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.

SELECT a.name company_name, AVG(standard_qty) s_avg, AVG(gloss_qty) g_avg, AVG(poster_qty) p_avg
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name

-- 2. For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.

SELECT a.name company_name, AVG(standard_amt_usd) s_amt_avg, AVG(gloss_amt_usd) g_amt_avg, AVG(poster_amt_usd) p_amt_avg
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name

-- 3. Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.

SELECT s.name sales_rep_name, w.channel channel, COUNT(*) num_occurred
FROM web_events w
JOIN accounts a ON a.id = w.account_id
JOIN sales_reps s ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num_occurred DESC

-- 4. Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first. -24

SELECT r.name region, w.channel channel, COUNT(*) num_occurred
FROM web_events w
JOIN accounts a ON a.id = w.account_id
JOIN sales_reps s ON s.id = a.sales_rep_id
JOIN region r ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_occurred DESC

-- DISTINCT
-- 1. Use DISTINCT to test if there are any accounts associated with more than one region.

SELECT DISTINCT a.id account_id, a.name account_name, r.name region
FROM accounts a
JOIN sales_reps s ON s.id = a.sales_rep_id
JOIN region r ON r.id = s.region_id

SELECT a.id account_id, a.name account_name
FROM accounts a
-- There is no difference in row count so there aro no accounts with more than a region

-- 2 Have any sales reps worked on more than one account?
-- Yes, all of them have more than one account at least 3

-- There are distinct 50 sales_reps
SELECT DISTINCT s.id, s.name
FROM sales_reps s

-- How many accounts associated for each sales_rep ordered DESC by total account number
SELECT s.id, s.name, COUNT(a.id) num_account
FROM sales_reps s
JOIN accounts a ON a.sales_rep_id = s.id
GROUP BY s.id, s.name
ORDER BY num_account DESC

-- HAVING

-- 1. How many of the sales reps have more than 5 accounts that they manage? - 34

SELECT s.id s_id, s.name s_name, COUNT(a.id) num_accounts
FROM sales_reps s
JOIN accounts a ON a.sales_rep_id = s.id
GROUP BY s.id, s.name
HAVING COUNT(a.id) > 5
ORDER BY num_accounts

-- 2. How many accounts have more than 20 orders? -120

SELECT a.id, a.name, COUNT(o.id) num_order
FROM accounts a
JOIN orders o ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING COUNT(o.id) > 20
ORDER BY num_order DESC

-- 3. Which account has the most orders? - Leucadia 71

SELECT a.id, a.name account_name, COUNT(o.id) num_order
FROM accounts a
JOIN orders o ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY num_order DESC
LIMIT 1

-- 4. Which accounts spent more than 30,000 usd total across all orders? -204

SELECT a.id, a.name account_name, SUM(total_amt_usd) total_spent
FROM accounts a
JOIN orders o ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING SUM(total_amt_usd) > 30000
ORDER BY total_spent DESC

-- 5. Which accounts spent less than 1,000 usd total across all orders? -3

SELECT a.id, a.name account_name, SUM(total_amt_usd) total_spent
FROM accounts a
JOIN orders o ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING SUM(total_amt_usd) < 1000
ORDER BY total_spent

-- 6. Which account has spent the most with us? - EOG

SELECT a.id, a.name account_name, SUM(total_amt_usd) total_spent
FROM accounts a
JOIN orders o ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1

-- 7. Which account has spent the least with us? -nike 390

SELECT a.id, a.name account_name, SUM(total_amt_usd) total_spent
FROM accounts a
JOIN orders o ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1

-- 8. Which accounts used facebook as a channel to contact customers more than 6 times? -46

-- benim cozum
SELECT a.id, a.name account_name, COUNT(w.id) facebook_count
FROM accounts a
JOIN web_events w ON w.account_id = a.id
WHERE w.channel LIKE 'facebook'
GROUP BY a.id, a.name
HAVING COUNT(w.id) > 6
ORDER BY facebook_count DESC

-- ikinci cozum
SELECT a.id, a.name account_name, w.channel, COUNT(w.id) facebook_count
FROM accounts a
JOIN web_events w ON w.account_id = a.id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(w.id) > 6 AND w.channel = 'facebook'
ORDER BY facebook_count DESC

--9 Which account used facebook most as a channel? - Gilead S 16

SELECT a.id, a.name account_name, COUNT(w.id) facebook_count
FROM accounts a
JOIN web_events w ON w.account_id = a.id
WHERE w.channel LIKE 'facebook'
GROUP BY a.id, a.name
HAVING COUNT(w.id) > 6
ORDER BY facebook_count DESC
LIMIT 1

-- 10. Which channel was most frequently used by most accounts?

-- benim cozum
SELECT a.id, a.name account_name, w.channel channel, COUNT(w.id) count
FROM accounts a
JOIN web_events w ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY a.id, count DESC

-- udacity cozum
SELECT a.id, a.name account_name, w.channel channel, COUNT(w.id) count
FROM accounts a
JOIN web_events w ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY count DESC


SELECT
FROM
JOIN ON
GROUP BY
HAVING
ORDER BY

-- DATE

-- 1. Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?

-- First looking the distrubution of the months of esach year. There is one month for 2017 and 2013

SELECT DISTINCT DATE_PART('year', o.occurred_at) year1, DATE_PART('month', o.occurred_at) month1
FROM orders o
GROUP BY 1, 2
ORDER BY 1 DESC

-- 2017 and 2013 should be extracted for all queries. because there is one monthe for each.

SELECT DATE_PART('year', o.occurred_at) year1, SUM(total_amt_usd)
FROM orders o
GROUP BY 1
ORDER BY 2 DESC

-- 2. Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset? -12 3...98 - 12 275 ... 98

SELECT DATE_PART('month', o.occurred_at) o_month, SUM(total_amt_usd)
FROM orders o
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- 3. Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset? 2016 - 3757. 2013 and 2017 recommended to exclude

SELECT DATE_PART('year', o.occurred_at) o_month, COUNT(o.id)
FROM orders o
GROUP BY 1
ORDER BY 2 DESC

-- 4. Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset? -12 783

SELECT DATE_PART('month', o.occurred_at) o_month, COUNT(o.id) total_orders
FROM orders o
WHERE o.occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC

-- 5. In which month of which year did Walmart spend the most on gloss paper in terms of dollars? - 2016-05-01 9257

SELECT a.name account_name, DATE_TRUNC('month', o.occurred_at) o_month, SUM(o.gloss_amt_usd) total
FROM orders o
JOIN accounts a ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1

-- CASE

-- 1. Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.

-- benim yazdigim
SELECT o.account_id, a.name account_name, SUM(total_amt_usd) total_usd, 
        CASE WHEN SUM(total_amt_usd) > 3000 THEN 'LARGE' ELSE 'SMALL' END level_order
FROM orders o
JOIN accounts a ON a.id = o.account_id
GROUP BY 1, 2
ORDER BY 1

-- benim duzelttigim sadece order bazinda sormus account bazinda sormamis
SELECT o.account_id, a.name account_name, o.total_amt_usd,
        CASE WHEN o.total_amt_usd > 3000 THEN 'LARGE' ELSE 'SMALL' END level_order
FROM orders o
JOIN accounts a ON a.id = o.account_id
ORDER BY 1

-- 2. Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT CASE WHEN o.total >= 2000 THEN 'At Least 2000' WHEN o.total BETWEEN 1000 AND 1999 THEN 'Between 1000 and 2000' ELSE 'Less than 1000' END category, COUNT(*)
FROM orders o
GROUP BY 1

-- 3. We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

SELECT a.name account_name, SUM(o.total_amt_usd) lifetime_value, 
CASE WHEN SUM(o.total_amt_usd) > 200000 THEN '1' WHEN SUM(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN '2' ELSE '3' END level_
FROM orders o
JOIN accounts a ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC


-- 4. We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.

SELECT a.name account_name, SUM(o.total_amt_usd) lifetime_value, 
CASE WHEN SUM(o.total_amt_usd) > 200000 THEN '1' WHEN SUM(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN '2' ELSE '3' END level_
FROM orders o
JOIN accounts a ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01'
GROUP BY 1
ORDER BY 2 DESC

-- 5. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.

SELECT s.id, s.name sales_rep_name, COUNT(o.id), CASE WHEN COUNT(o.id) > 200 THEN 'top' ELSE 'not' END
FROM orders o
JOIN accounts a ON a.id = o.account_id
JOIN sales_reps s ON s.id = a.sales_rep_id
GROUP BY 1, 2
ORDER BY 3 DESC

-- 6. The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!

SELECT s.id, s.name sales_rep_name, COUNT(o.id), SUM(o.total_amt_usd) total_usd, CASE WHEN COUNT(o.id) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top' WHEN COUNT(o.id) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'  ELSE 'not' END
FROM orders o
JOIN accounts a ON a.id = o.account_id
JOIN sales_reps s ON s.id = a.sales_rep_id
GROUP BY 1, 2
ORDER BY 4 DESC

-- SUBQUERY
-- 1. On which day-channel pair did the most events occur. (Mark all that are true)

SELECT *
FROM
(SELECT DATE_TRUNC('day', w.occurred_at), channel, COUNT(w.id) num_events, ROW_NUMBER() OVER (PARTITION BY channel ORDER BY COUNT(w.id) DESC) row_num
FROM web_events w
GROUP BY 1, 2
) sub
WHERE row_num = 1

-- EKSTRA: Hangi gunlerde encok hangi kanal kullanildi
SELECT *
FROM
(SELECT DATE_TRUNC('day', w.occurred_at) day1, channel, COUNT(w.id) num_events, ROW_NUMBER() OVER (PARTITION BY DATE_TRUNC('day', w.occurred_at) ORDER BY COUNT(w.id) DESC) row_num
FROM web_events w
GROUP BY 1, 2
) sub
WHERE row_num = 1

-- 3. average number of events for each channel

SELECT channel, AVG(num_events)
FROM
(SELECT DATE_TRUNC('day', w.occurred_at) day1, channel, COUNT(w.id) num_events
FROM web_events w
GROUP BY 1, 2
) sub
GROUP BY 1
ORDER BY 2 DESC

-- SUBQUERY conditional statement

-- 1. month level information of first order - December 2013
-- LIMIT yerine MIN() de kullanilabilirmis
SELECT DATE_TRUNC('month', o.occurred_at) 
FROM orders o
ORDER BY occurred_at
LIMIT 1

-- 2. the avg and the sum of the month above

SELECT AVG(o.standard_qty) s_qty, AVG(o.gloss_qty) g_qty, AVG(o.poster_qty) p_qty, SUM(o.total_amt_usd) sum_usd 
FROM orders o
WHERE DATE_TRUNC('month',o.occurred_at) = (
        SELECT DATE_TRUNC('month', o.occurred_at) 
        FROM orders o
        ORDER BY occurred_at
        LIMIT 1
        )

-- 1. ⭐ Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

SELECT *
FROM
        (SELECT s.id s_id, s.name s_name, r.id r_id, r.name r_name, SUM(o.total_amt_usd), 
                ROW_NUMBER() OVER (PARTITION BY r.id ORDER BY SUM(o.total_amt_usd) DESC) row_num
        FROM sales_reps s
        JOIN region r ON r.id = s.region_id
        JOIN accounts a ON a.sales_rep_id = s.id
        JOIN orders o ON o.account_id = a.id
        GROUP BY 1,2,3,4) sub
WHERE row_num = 1
ORDER BY 5 DESC

-- ⭐ 2. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

WITH cte AS (
        SELECT r.id r_id, r.name r_name, o.total_amt_usd
        FROM region r
        JOIN sales_reps s ON s.region_id = r.id
        JOIN accounts a ON a.sales_rep_id = s.id
        JOIN orders o ON o.account_id = a.id
), cte2 AS (
        SELECT r_id, r_name, SUM(total_amt_usd) sum_usd
        FROM cte
        GROUP BY 1,2
        ORDER BY 3 DESC
        LIMIT 1
), cte3 AS (
        SELECT r_id FROM cte2
)
SELECT COUNT(*)
FROM cte
WHERE r_id IN (SELECT * FROM CTE3)

-- ⭐ 3. How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

WITH cte AS (
        SELECT *
        FROM orders o
        JOIN accounts a ON o.account_id = a.id
), cte2 AS (
        SELECT account_id, SUM(standard_qty) p_sum, SUM(total) total_count
        FROM cte
        GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 1
), cte3 AS (
        SELECT account_id, name, SUM(total) total_count
        FROM cte
        GROUP BY 1,2
), cte4 AS (
        SELECT *
        FROM cte3
        WHERE total_count > (SELECT total_count FROM cte2)
)
SELECT * FROM cte4

-- ⭐ 4. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

WITH cte AS (
        SELECT a.id account_id, a.name account_name, SUM(o.total_amt_usd) sum_usd
        FROM accounts a
        JOIN orders o ON o.account_id = a.id
        GROUP BY 1,2
        ORDER BY 3 DESC
        LIMIT 1
), cte2 AS (
        SELECT *
        FROM cte
        JOIN web_events w ON cte.account_id = w.account_id
), cte3 AS (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY channel) row_num
        FROM cte2
), cte4 AS (
        SELECT account_name, channel, MAX(row_num) AS max_row_num
        FROM cte3
        GROUP BY 1,2
        
)
SELECT * FROM cte4
ORDER BY 3 DESC

-- ⭐ 5.What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

WITH cte AS (
        SELECT a.id account_id ,a.name account_name, SUM(total_amt_usd) sum_usd
        FROM accounts a
        JOIN orders o ON a.id = o.account_id
        GROUP BY 1,2
        ORDER BY 3 DESC
        LIMIT 10
), cte2 AS (
        SELECT AVG(sum_usd)
        FROM cte
)
SELECT * FROM cte2

-- ⭐ 6. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders. -- 15165007.77

WITH cte AS (
        SELECT a.id, a.name, AVG(total_amt_usd) avg_usd
        FROM accounts a
        JOIN orders o ON a.id = o.account_id
        GROUP BY 1,2
), cte2 AS (
        SELECT a.id, a.name, AVG(total_amt_usd) avg_usd
        FROM accounts a
        JOIN orders o ON a.id = o.account_id
        GROUP BY 1,2
), cte3 AS (
        SELECT AVG(total_amt_usd) avg_usd_all
        FROM orders
), cte4 AS (
        SELECT *
        FROM cte2
        WHERE avg_usd > (SELECT * FROM cte3)
), cte5 AS (
        SELECT AVG(avg_usd) avg_all
        FROM cte
        WHERE (id,name) IN (SELECT id,name FROM cte4)
)
SELECT * FROM cte5

-- SQL cleaning 

-- 1.In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using.

WITH cte AS (
	SELECT website, RIGHT(website,3) address_type
	FROM accounts a
)
SELECT address_type, COUNT(*)
FROM cte
GROUP BY 1

-- 2. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).

WITH cte AS(
        SELECT LEFT(UPPER(a.name),1) first_letter_company
        FROM accounts a
)
SELECT first_letter_company, COUNT(*)
FROM cte
GROUP BY 1
ORDER BY 1


-- 3. Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?

WITH cte AS(
        SELECT LEFT(a.name,1) first_letter_company
        FROM accounts a
), cte2 AS (
        SELECT CASE WHEN first_letter_company IN ('0','1','2','3','4','5','6','7','8','9') THEN 'num' ELSE 'letter' END is_numeric
        FROM cte
)
SELECT is_numeric, COUNT(*)
FROM cte2
GROUP BY 1

-- 4. Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?

WITH cte AS(
        SELECT LEFT(LOWER(a.name),1) first_letter_company
        FROM accounts a
), cte2 AS (
        SELECT CASE WHEN first_letter_company IN ('a','e','i','o','u') THEN 'vowel' ELSE 'not-vowel' END is_vowel
        FROM cte
)
SELECT is_vowel, COUNT(*)
FROM cte2
GROUP BY 1

-- POSITION

-- 1. Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.

SELECT  primary_poc,
        LEFT(primary_poc, STRPOS(primary_poc,' ') -1) first_name,
        RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) last_name
FROM accounts a

-- 2. Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.

SELECT  s.name,
        LEFT(s.name, STRPOS(s.name,' ') -1) first_name,
        RIGHT(s.name, LENGTH(s.name) - STRPOS(s.name,' ')) last_name
FROM sales_reps s

-- CONCAT

-- 1.Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.

WITH cte AS (
  SELECT  a.id a_id, a.primary_poc, RIGHT(a.website,LENGTH(a.website) - 4) a_website,
          LOWER(LEFT(a.primary_poc, STRPOS(a.primary_poc,' ') -1)) first_name,
          LOWER(RIGHT(a.primary_poc, LENGTH(a.primary_poc) - STRPOS(a.primary_poc,' '))) last_name
  FROM accounts a
), cte2 AS (
        SELECT a_id, a_website, CONCAT(first_name, '.',last_name)
        FROM cte
), cte3 AS (
        SELECT CONCAT(concat,'@',a_website)
        FROM cte2
)
SELECT * FROM cte3

-- 2. We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.

WITH cte AS (
  SELECT  a.id a_id, a.primary_poc, LOWER(REPLACE(a.name, ' ', '')) a_name,
          LOWER(LEFT(a.primary_poc, STRPOS(a.primary_poc,' ') -1)) first_name,
          LOWER(RIGHT(a.primary_poc, LENGTH(a.primary_poc) - STRPOS(a.primary_poc,' '))) last_name
  FROM accounts a
), cte2 AS (
        SELECT CONCAT(LEFT(first_name,1), RIGHT(first_name,1), LEFT(last_name,1), RIGHT(last_name,1), LENGTH(first_name), LENGTH(last_name), UPPER(a_name)) pass
        FROM cte
)
SELECT * FROM cte2

-- CAST

SELECT * 
FROM sf_crime_data
LIMIT 10

WITH t1 AS (
        SELECT LEFT(date,2) month1, SUBSTR(date,4,2) day1, SUBSTR(date,7,4) year1, date
        FROM sf_crime_data
        LIMIT 10
), t2 AS (
        SELECT CONCAT(year1,'-',month1,'-',day1)::DATE new_date
        FROM t1
)
SELECT * FROM t2

-- COALESCE

SELECT COALESCE(a.id,o.id) filled_id
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COALESCE(a.id,o.account_id) filled_id
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

-- Filling Nulls

SELECT *, COALESCE(a.id,o.account_id) filled_id, COALESCE(standard_qty,0) standard_qty,
        COALESCE(gloss_qty,0) gloss_qty,
        COALESCE(poster_qty,0) poster_qty,
        COALESCE(standard_amt_usd,0) standard_amt_usd,
        COALESCE(gloss_amt_usd,0) gloss_amt_usd,
        COALESCE(poster_amt_usd,0) poster_amt_usd,
        COALESCE(total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

-- counting

SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;

-- WINDOW FUNCTIONS

-- SUM() OVER ()

-- running total
SELECT standard_amt_usd, SUM(standard_amt_usd) OVER (ORDER BY occurred_at) running_total
FROM orders o

⭐-- running total partioned by year

SELECT standard_amt_usd, DATE_TRUNC('year',occurred_at) year1, SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year',occurred_at) ORDER BY occurred_at) running_total
FROM orders o

-- ROW_NUMBER()

-- DENSE RANK

-- ranking orders by total
SELECT id, account_id, total, DENSE_RANK() OVER (ORDER BY total DESC) total_rank
FROM orders

⭐-- ranking orders by total for each account using partition

SELECT id, account_id, total, DENSE_RANK() OVER (PARTITION BY account_id ORDER BY total DESC) total_rank
FROM orders

-- some windows functions together
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders

-- ⭐ WINDOW alias
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER main_window AS dense_rank,
       SUM(standard_qty) OVER main_window AS sum_std_qty,
       COUNT(standard_qty) OVER main_window AS count_std_qty,
       AVG(standard_qty) OVER main_window AS avg_std_qty,
       MIN(standard_qty) OVER main_window AS min_std_qty,
       MAX(standard_qty) OVER main_window AS max_std_qty
FROM orders
WINDOW main_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at))

-- LAG LEAD

-- bir onceki siparis ile mevcut siparisin toplam usd farki

SELECT id, occurred_at, total_amt_usd, LEAD(total_amt_usd) OVER(ORDER BY occurred_at) lead1, LEAD(total_amt_usd) OVER(ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM orders

-- NTILE
-- ⭐Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.

SELECT account_id, occurred_at, standard_qty, NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty)
FROM orders
ORDER BY 1 DESC

-- ⭐Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of gloss_qty paper purchased, and one of two levels in a gloss_half column.

SELECT account_id, occurred_at, gloss_qty, NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) gloss_half
FROM orders
ORDER BY 1 DESC

-- Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.

SELECT account_id, occurred_at, total_amt_usd, NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) gloss_half
FROM orders
ORDER BY 1 DESC

-- FULL OUTER JOIN

SELECT *
FROM accounts a 
FULL OUTER JOIN sales_reps s ON a.sales_rep_id = s.id
WHERE a.sales_rep_id IS NULL OR s.id IS NULL

-- JOIN icerisinde AND ile ekstra filtreleme

-- primary_poc name in alfabetik olarak sales_reps name den once geldigi durumlar
SELECT a.name a_name, a.primary_poc, s.name
FROM accounts a
LEFT JOIN sales_reps s ON s.id = a.sales_rep_id AND a.primary_poc < s.name

-- ⭐SELF JOIN
-- 28 gun icinde birbiri ardindan gelen ayni hesaba ait siparisler
SELECT o1.id AS o1_id,
       o1.account_id AS o1_account_id,
       o1.occurred_at AS o1_occurred_at,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at
  FROM orders o1
 LEFT JOIN orders o2
   ON o1.account_id = o2.account_id
  AND o2.occurred_at > o1.occurred_at
  AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at

--
-- ayni hesaba ait 1 gun icinde birbiri ardindan gelen web eventler
SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w1.channel AS w1_channel,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at,
       w2.channel AS w2_channel
FROM web_events w1
LEFT JOIN web_events w2 ON w1.account_id = w2.account_id
  AND w1.occurred_at > w2.occurred_at
  AND w1.occurred_at <= w2.occurred_at + INTERVAL '1 day'
ORDER BY w1.account_id, w2.occurred_at

-- UNION 

-- Alt alta ayni tablolari eklemek icin kullanilir.

-- accounts un kopyasini altina eklemek
SELECT *
FROM accounts a
UNION ALL
SELECT *
FROM accounts a


-- Walmart ve Disney i hesaplarini alt alta eklemek
-- SELECT * FROM accounts WHERE name = 'Walmart' OR name= 'Disney' ile aynidir.
SELECT *
FROM accounts a
WHERE a.name = 'Walmart'
UNION
SELECT *
FROM accounts a
WHERE a.name = 'Disney'

-- alt alta ekledigimiz iki adet account tablosunda, hangi hesaptan kac adet var bunu hesaplama. 2 cikmasi gerekiyor ve cikti
WITH t1 AS (
        SELECT *
        FROM accounts a
        UNION ALL
        SELECT *
        FROM accounts a
)
SELECT name, COUNT(*)
FROM t1
GROUP BY 1

-- PROJE

-- 1. actor's first and last name combined as full_name, film title, film description and length of the movie. How many rows are there in the table?

SELECT a.first_name, a.last_name, f.title
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id

-- 2. Write a query that creates a list of actors and movies where the movie length was more than 60 minutes. How many rows are there in this query result?

SELECT a.first_name, a.last_name, f.title
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.length > 60

-- 3.Write a query that captures the actor id, full name of the actor, and counts the number of movies each actor has made. (HINT: Think about whether you should group by actor id or the full name of the actor.) Identify the actor who has made the maximum number movies.

SELECT  a.actor_id, CONCAT(a.first_name, ' ', a.last_name) full_name, COUNT(f.film_id)
FROM actor a  
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1

-- 4.Categorizing movies based on their length, 4 category
SELECT CONCAT(a.first_name, ' ', a.last_name) full_name, f.title, f.length, 
        CASE WHEN f.length <= 60 THEN '1 hour or less'
                WHEN f.length BETWEEN 61 AND 120 THEN 'between 1-2 hours'
                WHEN f.length BETWEEN 121 AND 180 THEN 'between 2-3 hours' 
                WHEN f.length > 180 THEN 'More than 3 hours' END AS filmlen_groups
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id

-- 5. looking at just three of them
SELECT f.title, f.length, 
        CASE WHEN f.length <= 60 THEN '1 hour or less'
                WHEN f.length BETWEEN 61 AND 120 THEN 'between 1-2 hours'
                WHEN f.length BETWEEN 121 AND 180 THEN 'between 2-3 hours' 
                WHEN f.length > 180 THEN 'More than 3 hours' END AS filmlen_groups
FROM film f
WHERE f.title = 'Academy Dinosaur' OR f.title = 'Color Philadelphia' OR f.title = 'Oklahoma Jumanji'
ORDER BY 1


-- Hangi gruptan kac tane film var
WITH t1 AS (
        SELECT  f.title, f.length, 
                CASE WHEN f.length <= 60 THEN '1 hour or less'
                        WHEN f.length > 60 AND f.length <= 120 THEN 'between 1-2 hours'
                        WHEN f.length BETWEEN 121 AND 180 THEN 'between 2-3 hours' 
                        WHEN f.length > 180 THEN 'More than 3 hours' END AS filmlen_groups
        FROM film f
), t2 AS (
        SELECT DISTINCT title, filmlen_groups
        FROM t1
), t3 AS (
        SELECT DISTINCT filmlen_groups, COUNT(*) OVER (PARTITION BY filmlen_groups)
        FROM t2
)
SELECT * FROM t3
ORDER BY 1

-- ikinci yol

WITH t1 AS (
        SELECT  f.title, f.length, 
                CASE WHEN f.length <= 60 THEN '1 hour or less'
                        WHEN f.length > 60 AND f.length <= 120 THEN 'between 1-2 hours'
                        WHEN f.length BETWEEN 121 AND 180 THEN 'between 2-3 hours' 
                        WHEN f.length > 180 THEN 'More than 3 hours' END AS filmlen_groups
        FROM film f
), t2 AS (
        SELECT  DISTINCT filmlen_groups,
  	        COUNT(*) OVER (PARTITION BY filmlen_groups)
        FROM t1
)
SELECT * FROM t2
ORDER BY 1

-- Project Quiz

-- We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.

-- Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.

--- 1.cozum
SELECT f.film_id, f.title, c.name, COUNT(r.rental_id) rental_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
LEFT JOIN inventory i ON i.film_id = f.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE c.name IN ('Animation','Children','Classics','Comedy','Family')
GROUP BY 1,2,3
ORDER BY 3,2

-- 2.cozum

WITH t1 AS(
        SELECT f.film_id, f.title, c.name
        FROM film f
        JOIN film_category fc ON f.film_id = fc.film_id
        JOIN category c ON fc.category_id = c.category_id
        WHERE c.name IN ('Animation','Children','Classics','Comedy','Family','Music')
        ORDER BY 3,2
), t2 AS (
        SELECT f.film_id, f.title, COUNT(r.rental_id) rental_count
        FROM film f
        LEFT JOIN inventory i ON f.film_id = i.film_id
        LEFT JOIN rental r ON r.inventory_id = i.inventory_id
        GROUP BY 1,2
        ORDER BY 2
)
SELECT t1.film_id, t1.title, t1.name, t2.rental_count
FROM t1
JOIN t2 ON t1.film_id = t2.film_id
ORDER BY 3,2

-- Question 2
-- Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.

WITH t1 AS(
        SELECT f.film_id, f.title, c.name, f.rental_duration
        FROM film f
        JOIN film_category fc ON f.film_id = fc.film_id
        JOIN category c ON fc.category_id = c.category_id
        WHERE c.name IN ('Animation','Children','Classics','Comedy','Family','Music')
        ORDER BY 3,2
), t2 AS (
        SELECT f.film_id, NTILE(4) OVER (PARTITION BY c.name ORDER BY f.rental_duration) standard_quartile
        FROM film f
        JOIN film_category fc ON f.film_id = fc.film_id
        JOIN category c ON fc.category_id = c.category_id
        ORDER BY 1
)
SELECT t1.film_id, t1.title, t1.name, t1.rental_duration, t2.standard_quartile
FROM t1
JOIN t2 ON t1.film_id = t2.film_id
ORDER BY 5,4

-- Question 3
-- Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. The resulting table should have three columns:

-- Category
-- Rental length category
-- Count

WITH t1 AS(
        SELECT f.film_id, f.title, c.name, f.rental_duration
        FROM film f
        JOIN film_category fc ON f.film_id = fc.film_id
        JOIN category c ON fc.category_id = c.category_id
        WHERE c.name IN ('Animation','Children','Classics','Comedy','Family','Music')
        ORDER BY 3,2
), t2 AS (
        SELECT f.film_id, NTILE(4) OVER (ORDER BY f.rental_duration) standard_quartile
        FROM film f
        JOIN film_category fc ON f.film_id = fc.film_id
        JOIN category c ON fc.category_id = c.category_id
        ORDER BY 1
)
SELECT t1.name, t2.standard_quartile, COUNT(*)
FROM t1
JOIN t2 ON t1.film_id = t2.film_id
GROUP BY 1,2
ORDER BY 1,2

-- Question 1:
-- We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.

SELECT DATE_PART('month',rental_date) rental_month, DATE_PART('year',rental_date) rental_year, sto.store_id, COUNT(r.rental_id) count_rentals
FROM store sto
JOIN staff sta ON sto.store_id = sta.store_id
JOIN payment p ON p.staff_id = sta.staff_id
JOIN rental r ON r.rental_id = p.rental_id
GROUP BY 1,2,3
ORDER BY 4 DESC

--⭐ Question 2 (GOsterilen sonucla birebir ayni)
-- We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?

WITH t1 AS (
        SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) full_name, SUM(p.amount) sum_amount
        FROM customer c
        JOIN rental r ON c.customer_id = r.customer_id
        JOIN payment p ON p.rental_id = r.rental_id
        WHERE p.payment_date BETWEEN '2007-1-1' AND '2008-1-1'
        GROUP BY 1,2
        ORDER BY 3 DESC
        LIMIT 10 
), t2 AS (
        SELECT t1.customer_id, t1.full_name, DATE_TRUNC('month',p.payment_date) month1, COUNT(p.payment_id) payment_count, SUM(p.amount) monthly_payment
        FROM t1
        JOIN payment p ON t1.customer_id = p.customer_id
        GROUP BY 1,2,3
        ORDER BY 2,3
) 
SELECT * FROM t2


-- ⭐Question 3 (DENENDI birebir aynisi)
-- Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.

WITH t1 AS (
        SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) full_name, SUM(p.amount) sum_amount
        FROM customer c
        JOIN rental r ON c.customer_id = r.customer_id
        JOIN payment p ON p.rental_id = r.rental_id
        WHERE p.payment_date BETWEEN '2007-1-1' AND '2008-1-1'
        GROUP BY 1,2
        ORDER BY 3 DESC
        LIMIT 10 
), t2 AS (
        SELECT t1.customer_id, t1.full_name, DATE_TRUNC('month',p.payment_date) month1, SUM(p.amount) monthly_payment
        FROM t1
        JOIN payment p ON t1.customer_id = p.customer_id
        GROUP BY 1,2,3
        ORDER BY 2,3
), t3 AS (
        SELECT *, LAG(t2.monthly_payment) OVER (PARTITION BY t2.customer_id ORDER BY month1) previous_monthly_payment
        FROM t2
), t4 AS (
        SELECT *, monthly_payment - previous_monthly_payment AS difference
        FROM t3
        WHERE previous_monthly_payment IS NOT NULL
)
SELECT * FROM t4
ORDER BY 6 DESC


