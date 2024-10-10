create table dataset.products
(
	id				int generated always as identity primary key,
	name			varchar(100),
	price			float,
	release_date 	date
);
insert into dataset.products values(default,'iPhone 15', 800, to_date('22-08-2023','dd-mm-yyyy'));
insert into dataset.products values(default,'Macbook Pro', 2100, to_date('12-10-2022','dd-mm-yyyy'));
insert into dataset.products values(default,'Apple Watch 9', 550, to_date('04-09-2022','dd-mm-yyyy'));
insert into dataset.products values(default,'iPad', 400, to_date('25-08-2020','dd-mm-yyyy'));
insert into dataset.products values(default,'AirPods', 420, to_date('30-03-2024','dd-mm-yyyy'));


create table dataset.customers
(
    id         int generated always as identity primary key,
    name       varchar(100),
    email      varchar(30)
);
insert into dataset.customers values(default,'Meghan Harley', 'mharley@demo.com');
insert into dataset.customers values(default,'Rosa Chan', 'rchan@demo.com');
insert into dataset.customers values(default,'Logan Short', 'lshort@demo.com');
insert into dataset.customers values(default,'Zaria Duke', 'zduke@demo.com');


create table dataset.employees
(
    id         int generated always as identity primary key,
    name       varchar(100)
);
insert into dataset.employees values(default,'Nina Kumari');
insert into dataset.employees values(default,'Abrar Khan');
insert into dataset.employees values(default,'Irene Costa');



create table dataset.sales_order
(
	order_id		int generated always as identity primary key,
	order_date		date,
	quantity		int,
	prod_id			int references dataset.products(id),
	status			varchar(20),
	customer_id		int references dataset.customers(id),
	emp_id			int,
	constraint fk_so_emp foreign key (emp_id) references dataset.employees(id)
);
insert into dataset.sales_order values(default,to_date('01-01-2024','dd-mm-yyyy'),2,1,'Completed',1,1);
insert into dataset.sales_order values(default,to_date('01-01-2024','dd-mm-yyyy'),3,1,'Pending',2,2);
insert into dataset.sales_order values(default,to_date('02-01-2024','dd-mm-yyyy'),3,2,'Completed',3,2);
insert into dataset.sales_order values(default,to_date('03-01-2024','dd-mm-yyyy'),3,3,'Completed',3,2);
insert into dataset.sales_order values(default,to_date('04-01-2024','dd-mm-yyyy'),1,1,'Completed',3,2);
insert into dataset.sales_order values(default,to_date('04-01-2024','dd-mm-yyyy'),1,3,'Completed',2,1);
insert into dataset.sales_order values(default,to_date('04-01-2024','dd-mm-yyyy'),1,2,'On Hold',2,1);
insert into dataset.sales_order values(default,to_date('05-01-2024','dd-mm-yyyy'),4,2,'Rejected',1,2);
insert into dataset.sales_order values(default,to_date('06-01-2024','dd-mm-yyyy'),5,5,'Completed',1,2);
insert into dataset.sales_order values(default,to_date('06-01-2024','dd-mm-yyyy'),1,1,'Cancelled',1,1);


SELECT * FROM dataset.products;
SELECT * FROM dataset.customers;
SELECT * FROM dataset.employees;
SELECT * FROM dataset.sales_order;

/* set of 20 questions */
--Q1. Identify the total no of products sold
SELECT sum(quantity) as total_sold_product FROM dataset.sales_order
WHERE status='Completed';
--or
SELECT sum(quantity) as total_sold_product FROM dataset.sales_order;

--Q2.Other than Completed, display the available delivery status's
SELECT status
FROM dataset.sales_order
WHERE status NOT LIKE '%ompleted';
--or
SELECT status
FROM dataset.sales_order
WHERE status NOT IN ('completed','Completed');
--or
SELECT status
FROM dataset.sales_order
WHERE status <> 'Completed';-- != we can use
--or
SELECT DISTINCT status       -- distinct use for unique valuesto printed
FROM dataset.sales_order
WHERE status NOT LIKE '%ompleted';
--or
SELECT status
FROM dataset.sales_order
WHERE lower(status) <> 'completed' ;--not equal to completed kar dega phir sabhi status ki value ko lower kar dega
                                    -- aur phir jo completed ke equal nhi hai usko print kar dega
--or
SELECT status
FROM dataset.sales_order
WHERE upper(status) <> 'COMPLETED' ;

--Q3 Display the order id, order_date and product_name for all the completed orders
-- to this quesstionn we have to do inner join query
SELECT order_id , order_date , name
FROM dataset.sales_order so
INNER JOIN dataset.products p ON  so.prod_id = p.id
WHERE lower(so.status) = 'completed';
--inner join joins the two table on basis of common coland we are calling it by nick_name_table.col

--Q4 Sort the above query to show the earliest orders at the top. Also display the
--customer who purchased these orders.
SELECT order_id ,order_date,p.name as product_name,c.name as customer_name
FROM dataset.sales_order so
INNER JOIN dataset.products p ON so.prod_id = p.id
INNER JOIN dataset.customers c ON c.id = so.customer_id
ORDER BY so.order_date asc;--asc->ascending ke liye  , by default ascending hi rehta hai
                            -- desc ->descending ke liye

--Q5. Display the total no of orders corresponding to each delivery status
/*SELECT DISTINCT status, count(quantity)
FROM dataset.sales_order
  this not this way use group by
 */
SELECT status,count(*)
FROM dataset.sales_order
GROUP BY status;
--group by jo bhi same chizen hai uska ek group bana deta hai same cheezon ko ek hi baar show karta hai
--5  aggregate fn are there-avg,sum,count,min,max

/*6. For orders purchasing more than 1 item, how many are still not completed?*/
--i have to give more focus on this question
SELECT status,count(*) as not_completed
FROM dataset.sales_order
WHERE quantity > 1 AND lower(status) <> 'completed'
GROUP BY status

SELECT count(*) as not_completed
FROM dataset.sales_order
WHERE quantity > 1 AND lower(status) <> 'completed';
--GROUP BY status

/* q7-Find the total no of orders corresponding to each delivery status by ignoring
the case in delivery status. Status with highest no of orders should be at the top
 */
select status,sum(quantity) as no_of_order
from dataset.sales_order

group by status

order by no_of_order desc;

--0r
--trick
 select status,''updated_status
from dataset.sales_order;

-----------------------------------------------------
select status
,case when status='completed'
            then 'Completed'
        else status
    end as updated_status
from dataset.sales_order;


--or
--suquery->query inside query
select updated_status, count(*)
from(select status
,case when status='completed'
            then 'Completed'
        else status
    end as updated_status
from dataset.sales_order
)
group by updated_status;


--or we can do that
select lower(status)




/*8. Write a query to identify the total products purchased by each customer */
select customer_id,sum(quantity)
from dataset.sales_order
group by customer_id;

select c.name as customer_name, sum(s.quantity)
from dataset.customers c
inner join dataset.sales_order s on c.id  = s.customer_id
group by c.name;


/*Q9 9. Display the total sales and average sales done for each day.*/
SELECT s.order_date,sum(p.price),avg(p.price)
FROM dataset.products p
inner join dataset.sales_order s on p.id=s.prod_id

group by s.order_date
order by s.order_date;


/*Q10 Display the customer name, employee name and total sale amount of all
orders which are either on hold or pending*/
select c.name as customer_name,e.name as employee_name,sum(s.quantity * p.price),s.status
from dataset.sales_order s
inner join dataset.customers c on s.customer_id = c.id
inner join dataset.products p on s.prod_id = p.id
inner join dataset.employees e on s.emp_id  = e.id
where status in ('Pending','On Hold')
group by s.status,c.name,e.name;

/*11Fetch all the orders which were neither completed/pending or were handled by
the employee Abrar. Display employee name and all details or order.*/
SELECT  e.name, so.*
FROM dataset.employees e
inner join dataset.sales_order so on e.id = so.emp_id
WHERE lower(so.status) not in ('completed' , 'pending') or e.name like  'Abrar%'
;

/*12Fetch the orders which cost more than 2000 but did not include the macbook
pro. Print the total sale amount as well.*/
SELECT s.prod_id ,(s.quantity * p.price)as cost_o_product
FROM dataset.sales_order s
inner join dataset.products p on s.prod_id=p.id
where (s.quantity * p.price) >2000
and lower(p.name) not like '%macbook%';

/* 13 13. Identify the customers who have not purchased any product yet.  */
--1)solving it by without using left inner join
select distinct id,name
from dataset.customers  ;

--wrong hogaya from mai do table nhi lessakte lege toh join use karna padegs
/*select n.id
from  (select distinct id,name
from dataset.customers ) n
where  n.id  not in s.customer_id;
*/
-- not in works with single col only
--in where clause we cannot use two structures like below in where cluse's second part
select id,name
from dataset.customers
where id  not in (select customer_id from dataset.sales_order)


--or--
--now solving third one byleft outer join or right outer join
select c.id , c.name
from dataset.customers c
left join dataset.sales_order s on c.id=s.customer_id
where c.id not in s.customer_id;



-----------------------------------------------------------------------------------------
/* Q14Write a query to identify the total products purchased by each customer.
Return all customers irrespective of wether they have made a purchase or not.
Sort the result with highest no of orders at the top. */
select  id,coalesce(sum(so.quantity),0) as q--coalesce se null value ke jagah hum kuch bhi print kra sakte hain
from dataset.sales_order so
right join dataset.customers c on so.customer_id=c.id
group by id
order by q desc;

/*15Corresponding to each employee, display the total sales they made of all the
completed orders. Display total sales as 0 if an employee made no sales yet.*/
select e.id , coalesce(sum(so.quantity * p.price),0),e.name
from dataset.sales_order so
    inner join dataset.products p
    on so.prod_id=p.id

right join dataset.employees e on e.id = so.emp_id            --and lower(so.status)='completed'

           and lower(so.status)='completed'
group by e.id,e.name;
--jab hum join ke baad where lause lagare toh join ki priority kam ho jaari anu wehre clause ki priority zaada hai isliye hum hwere clauseke condition ko join ke saath mila ke likhenge


/* q16 Re-write the above query so as to display the total sales made by each
employee corresponding to each customer. If an employee has not served a
customer yet then display "-" under the customer.  */
select e.id ,e.name,c.id,coalesce(c.name,'under the customer') , coalesce(sum(so.quantity * p.price),0) as sales
from dataset.sales_order so
inner join dataset.customers c on so.customer_id = c.id
inner join dataset.products p on  so.prod_id = p.id
right join dataset.employees e on so.emp_id = e.id
group by e.id, e.name, c.id,c.name
order by 1,3;--1,3 does see in result


/* Q17 Re-write above query so as to display only those records where the total sales is above 1000*/
 select e.id ,e.name,c.id,coalesce(c.name,'under the customer') , coalesce(sum(so.quantity * p.price),0) as sales
from dataset.sales_order so
inner join dataset.customers c on so.customer_id = c.id
inner join dataset.products p on  so.prod_id = p.id
right join dataset.employees e on so.emp_id = e.id
group by e.id, e.name, c.id,c.name
having coalesce(sum(so.quantity * p.price),0)>1000
order by 1,3;--1,3 does see in result


/*Q18Identify employees who have served more than 2 customer. */
select emp_id,count (distinct customer_id) as customers
from dataset.sales_order
group by emp_id
having sum(customer_id) >2;

/*19dentify the customers who have purchased more than 5 products*/
select customer_id, sum(quantity)as no_of_products
from dataset.sales_order
group by customer_id
having sum(quantity)>5


/*20 Identify customers whose average purchase cost exceeds the average sale of
all the orders.  */


select so.customer_id,avg(p.price * so.quantity)
from dataset.sales_order so
inner join dataset.products p on so.prod_id = p.id
group by so.customer_id
having avg(p.price * so.quantity) > (select avg(so.quantity * p.price)
                                          from dataset.sales_order so
                                                   inner join dataset.products p on so.prod_id = p.id)



