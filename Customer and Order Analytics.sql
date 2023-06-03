# In this SQL, I'm querying a database with customer and order data in multiple tables to answer questions that stakeholders may have.

#1. How many orders were placed in January?

SELECT
    COUNT(orderID) AS num_orders
FROM
    BIT_DB.JanSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID';

#2. How many of those orders were for an iPhone?

SELECT
    COUNT(orderID) AS num_iphone_orders
FROM
    BIT_DB.JanSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID' AND
    Product LIKE '%iPhone%';

#3. Select the customer account numbers for all the orders that were placed in February.

SELECT
    DISTINCT customers.acctnum,
    febsales.orderID
FROM
    BIT_DB.customers AS customers
INNER JOIN
    BIT_DB.FebSales AS febsales
ON
    customers.order_id = febsales.orderID
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID'
ORDER BY
    customers.acctnum;

#4. Which product was the cheapest one sold in January, and what was the price?

SELECT
    product,
    price
FROM
    BIT_DB.JanSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID'
GROUP BY
    product
ORDER BY
    price ASC
LIMIT 1;

/* Let's double check in case there is another product with the same price */

SELECT
    product,
    price
FROM
    BIT_DB.JanSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID' AND
    price <= 
        (SELECT MIN(price) 
        FROM BIT_DB.JanSales)
GROUP BY
    product;

#5. What is the total revenue for each product sold in January? 
    
SELECT
    product,
    ROUND((SUM(Quantity)*price),2) AS revenue
FROM
    BIT_DB.JanSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID'
GROUP BY
    product
ORDER BY
    revenue DESC;

#6. Which products were sold in February at 548 Lincoln St, Seattle, WA 98101, how many of each were sold, and what was the total revenue?

SELECT
    product,
    (num_sold * price) AS revenue
FROM
    (SELECT
        product,
        SUM(quantity) AS num_sold,
        price
    FROM
        BIT_DB.FebSales
    WHERE
        length(orderID) = 6 AND 
        orderID <> 'Order ID' AND
        location LIKE '%548 Lincoln St, Seattle, WA 98101%'
    GROUP BY
        product) AS product_info
ORDER BY
    revenue;

#7. How many customers ordered more than 2 products at a time in February, and what was the average amount spent for those customers?

SELECT
    COUNT(acctnum) AS num_customers,
    ROUND(AVG(quantity * price),2) AS avg_spent
FROM
    BIT_DB.FebSales AS febsales
LEFT JOIN
    BIT_DB.customers AS customers
ON
    customers.order_id = febsales.orderID
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID' AND
    quantity > 2;

/* Let's double check to verify that there 278 customers who purchased more than 2 of a product in one order */

SELECT 
    *
FROM
    FebSales
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID' AND
    quantity > 2;

/* There are only 263 orders in the FebSales table where the quantity is more than 2 */
/* This should not be the case. I was expecting there to be 278 orders, since there are 278 rows in the below query */

SELECT
    *
FROM
    BIT_DB.FebSales AS febsales
LEFT JOIN
    BIT_DB.customers AS customers
ON
    customers.order_id = febsales.orderID
WHERE
    length(orderID) = 6 AND 
    orderID <> 'Order ID' AND
    quantity > 2;

/* After exporting the output of the above table, and importing it into Excel for inspection, it appears that there are duplicate orderID's */
/* This means that multiple account numbers are linked to the same order ID, which should not be the case. */
/* For example, account number 41861194 and 86869999 are linked to order 155130 */

SELECT
    *
FROM
    BIT_DB.FebSales AS febsales
LEFT JOIN
    BIT_DB.customers AS customers
ON
    customers.order_id = febsales.orderID
WHERE
    quantity > 2 AND
    orderID = 155130;

/* As you can see, there are two account numbers linked to one order. There are multiple instances where this is the case. */
/* There was most likely a flaw in the data collection process for this dataset. */

#8. List all the products sold in Los Angeles in February, and include how many of each were sold.

SELECT
    product,
    SUM(quantity) AS total_sold
FROM
    BIT_DB.FebSales
WHERE
    length(orderID) = 6 AND
    orderID <> 'Order ID' AND
    location LIKE '%Los Angeles%'
GROUP BY
    product
ORDER BY
    total_sold DESC;

#9. Which locations in New York received at least 3 orders in January, and how many orders did they each receive?

SELECT
    location,
    COUNT(orderID) AS num_orders
FROM
    BIT_DB.JanSales
WHERE
    LENGTH(orderID) = 6 AND
    orderID <> 'Order ID' AND
    location LIKE '%NY%'
GROUP BY
    location
HAVING
    num_orders >= 3
ORDER BY
    num_orders DESC;

#10. How many of each type of headphone were sold in February?

SELECT
    product,
    SUM(quantity) AS num_sold
FROM
    BIT_DB.FebSales
WHERE
    product LIKE '%Headphone%'
GROUP BY
    product
ORDER BY
    num_sold DESC;

#11. What was the average amount spent per account in February? (Total Spent / Number of Accounts)

SELECT 
    ROUND(SUM(febsales.quantity*febsales.price)/COUNT(customers.acctnum),2) AS avg_spent
FROM 
    BIT_DB.FebSales febsales
LEFT JOIN 
    BIT_DB.customers customers
ON 
    febsales.orderid = customers.order_id
WHERE 
    length(orderID) = 6 AND 
    orderID <> 'Order ID';

#12. What was the average quantity of products purchased per account in February?

SELECT 
    SUM(febsales.quantity)/COUNT(customers.acctnum) AS avg_qty
FROM 
    BIT_DB.FebSales febsales
LEFT JOIN 
    BIT_DB.customers customers
ON 
    febsales.orderid = customers.order_id
WHERE 
    length(orderID) = 6 AND 
    orderID <> 'Order ID';

#13. Which product brought in the most revenue in January and how much revenue did it bring in total?

SELECT
    product,
    MAX(revenue) AS revenue
FROM 
    (SELECT
        product,
        ROUND(SUM(quantity)*Price,2) AS revenue
    FROM
        BIT_DB.JanSales
    GROUP BY
        product) AS A;

