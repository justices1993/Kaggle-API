--1 find top 10 highest revenue generating products
select top 10 product_id
,sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc


--2find top 5 hightest selling products in each region
With cte as (
select region
,product_id
,sum(sale_price) as region_sale
from df_orders
group by product_id,region)
select * from(
select * 
,row_number() over(partition by region order by region_sale desc) as rn
from cte) a
where rn<= 5


--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
With cte as(
select year(order_date) order_year
,month(order_date) order_month
,sum(sale_price) as sales
from df_orders
group by year(order_date)
,month(order_date)
)
select 
order_month 
,sum(case when order_year = 2022 then sales else 0 end) as sales_2022
,sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month