show databases;
use customer;
Select * from customers limit 20;

-- what is the total revenue generayed by male vs female customers

select gender,SUM(purchase_amount) as revenue 
from customers
group by gender;

-- which customers used a discount but still they spent more than the average purchase amount?

select customer_id,purchase_amount
from customers
where discount_applied ='Yes' and purchase_amount >=(select AVG(purchase_amount) from customers);

-- which are the top 5 products with the highest average revenue rating?

select item_purchased,round(AVG(review_rating),2)as Average_Product_Rating
from customers
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- Compare the average purchase amounts between standard and express shipping

select shipping_type,avg(purchase_amount)
from customers
where shipping_type in ('Standard','Express')
group by shipping_type;


-- Do subscribe customers spend more? Compare average spend and total revenue between subscribers and non subscribers.

select subscription_status,count(customer_id) as total_customers,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2)as total_revenue
from customers
group by subscription_status
order  by total_revenue,avg_spend desc;

-- which 5 products have the highest percentage of purchases with discount applied?

select item_purchased,
round(sum(case when discount_applied = 'Yes' then 1 else 0 end) /count(*)*100,2) as discount_rate
from customers
group by item_purchased
order by discount_rate desc 
limit 5;

-- Segment customers into new ,returning , and loyal based on their total no. of previous purchases ,and show count of each segment

with customer_type as (
select customer_id,previous_purchases,
case when previous_purchases = 1 then 'New'
when previous_purchases between 2 and 10 then 'Returning'
else 'Loyal'
end as customer_segment
from customers)
select customer_segment,count(*) as no_of_customers
from customer_type
group by customer_segment;

--  what are the top 3 most purchased products with each category?

with item_counts as (
select category,item_purchased,
count(customer_id) as total_orders,
ROW_NUMBER() over (partition by category order by count(customer_id) desc) as item_rank
from customers
group by category,item_purchased)

select item_rank,category,item_purchased,total_orders
from item_counts
where item_rank<=3;


-- Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

select subscription_status,
count(customer_id) as repeat_buyers
from customers
where previous_purchases > 5
group by subscription_status;


-- What is the revenue contribution of each age group?

select age_group,
sum(purchase_amount) as total_revenue
from customers
group by age_group
order by total_revenue desc;








