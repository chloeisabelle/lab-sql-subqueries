-- 	1. How many copies of the film Hunchback Impossible exist in the inventory system?

select title, COUNT(inventory_id)
from film f
inner join inventory i 
on f.film_id = i.film_id
where title = "Hunchback Impossible";

-- 2. List all films whose length is longer than the average of all the films. 

select flm.title, flm.length, ct.name
from film flm join film_category fc on flm.film_id=fc.film_id
             join category ct on ct.category_id=fc.category_id
where flm.length > (select avg(flm.length) 
                   from film flm join film_category fc on flm.film_id = fc.film_id
                   join category cat on cat.category_id=fc.category_id
                   where cat.name=ct.name);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

select last_name, first_name
from actor
where actor_id in
	(select actor_id from film_actor
	where film_id in 
		(select film_id from film
		where title = "Alone Trip"));


-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select title, category
from film_list
where category = 'Family';
		
-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

select country, last_name, first_name, email
from country c
left join customer cu
on c.country_id = cu.customer_id
where country = 'Canada';


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select
actor.first_name as first_name,
actor.last_name as last_name,
a.film_count,
a.actor_id
from actor
left join(
select
COUNT(film_id) as film_count,
actor_id
from film_actor
group by actor_id)as a on (actor.actor_id=a.actor_id)
order by film_count desc;

-- from above found that Gina Degeneres is the is the most profilic actor (actor id = 107). Now running a different query to see her movies joining film_actor & actor tables: 

select * from sakila.Film_actor A1
join sakila.film A2
on A1.film_id = A2.film_id
where A1.actor_id = '107';


-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select
customer.first_name,
customer.last_name,
a.total_spend
from customer
left join(
select
payment.customer_id,
SUM(payment.amount) as total_spend
from payment
left join customer on (payment.customer_id=customer.customer_id)
group by 1) AS a on(customer.customer_id=a.customer_id)
order by a.total_spend desc;


-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

select
customer_id, payment.amount,
SUM(payment.amount) as total_amount_spent
from payment
where payment.amount > select(amount) as avgPrice
group by payment.amount;






