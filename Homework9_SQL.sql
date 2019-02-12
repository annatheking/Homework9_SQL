use sakila;

# 1a. Display the first and last names of all actors from the table actor.
select first_name
	, last_name
from actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select concat(first_name, " ", last_name) as Actor from actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
# What is one query would you use to obtain this information?
select * from actor
where first_name = "JOE";

# 2b. Find all actors whose last name contain the letters GEN:
select * from actor
where last_name like "%GEN%";

# 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select * from actor
where last_name like "%LI%"
order by last_name, first_name;

# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id
	, country 
from country
where country in ("Afghanistan", "Bangladesh", "China");

# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
# so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, 
# as the difference between it and VARCHAR are significant).
alter table actor
add column description blob;

select * from actor;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor
drop column description;

select * from actor;

#4a. List the last names of actors, as well as how many actors have that last name.
select distinct last_name
	, count(*) as Counts
from actor
group by last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at 
# least two actors
select distinct last_name
	, count(*) as Counts
from actor
group by last_name
having Counts >= 2;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor
set first_name = "HARPO"
where first_name = "GROUCHO" and last_name = "WILLIAMS";

select * from actor
where first_name = "GROUCHO" and last_name = "WILLIAMS";

select * from actor
where first_name = "HARPO" and last_name = "WILLIAMS";

# 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
# In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor
set first_name = "GROUCHO"
where first_name = "HARPO" and last_name = "WILLIAMS";

# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select a.first_name
	, a.last_name
    , b.address
from staff a join address b on a.address_id = b.address_id;

# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select a.first_name
	, a.last_name
    , sum(b.amount) as Total
from staff a join payment b on a.staff_id = b.staff_id
group by a.staff_id;
    
select * from payment;

# 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from film_actor;
select * from film;

select distinct a.title 
	, count(b.actor_id) as Actor_Count
from film a join film_actor b on a.film_id = b.film_id
group by a.title;

# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
#select * from inventory;

select a.title
	, count(b.inventory_id) as Inventory_Count 
from film a join inventory b on a.film_id = b.film_id
where title = "Hunchback Impossible";

# 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
# List the customers alphabetically by last name:
#select * from customer;
#select * from payment;

select a.first_name
	, a.last_name
    , sum(b.amount) as Paid_total
from customer a join payment b on a.customer_id = b.customer_id
group by a.customer_id
order by a.last_name;
    
# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
# films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies 
# starting with the letters K and Q whose language is English.
select *
from film 
where (title like "K%" or title like "Q%") 
	and language_id in (select language_id from language where name = "English");

# 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select * from actor
where actor_id in (select actor_id from film where title = "Alone Trip");

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all 
# Canadian customers. Use joins to retrieve this information.
#select * from customer;
#select * from address;
#select * from country;
#select * from city;

select a.first_name
	, a.last_name
    , a.email
    , d.country
from customer a join address b on a.address_id = b.address_id
	join city c on b.city_id = c.city_id
    join country d on c.country_id = d.country_id and d.country = "Canada";

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
# Identify all movies categorized as family films.
#select * from film;
#select * from film_category;
#select * from category;

select a.title
	, c.name
from film a join film_category b on a.film_id = b.film_id
	join category c on b.category_id = c.category_id and c.name = "Family";

# 7e. Display the most frequently rented movies in descending order.
#select * from rental;
#select * from inventory;
#select * from film;

select a.title
	, count(c.rental_id) as Frequency
from film a join inventory b on a.film_id = b.film_id
	join rental c on b.inventory_id = c.inventory_id
group by a.title
order by Frequency desc;
    
# 7f. Write a query to display how much business, in dollars, each store brought in.
#select * from store;
#select * from customer;
#select * from payment;

select c.store_id
	, sum(b.amount) as Total_Business
from customer a join payment b on a.customer_id = b.customer_id
	join store c on a.store_id = c.store_id
group by c.store_id;

# 7g. Write a query to display for each store its store ID, city, and country.
select a.store_id
	, b.city
    , c.country
from store a join address d on a.address_id = d.address_id
	join city b on d.city_id = b.city_id
    join country c on b.country_id = c.country_id;

# 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: 
# category, film_category, inventory, payment, and rental.)
#select * from category;
#select * from film_category;
#select * from inventory;
#select * from payment;
#select * from rental;

select c.name
	#, a.title
	#, a.film_id
    #, d.inventory_id
    #, e.rental_id
    , sum(f.amount) as Genre_Revenue
from film a join film_category b on a.film_id = b.film_id
	join category c on b.category_id = c.category_id
    join inventory d on a.film_id = d.film_id
    join rental e on d.inventory_id = e.inventory_id
    join payment f on e.rental_id = f.rental_id
group by c.name
order by Genre_Revenue desc
limit 5;

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
# Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to 
# create a view.

create view top_5_genres_revenue as
select c.name
    , sum(f.amount) as Genre_Revenue
from film a join film_category b on a.film_id = b.film_id
	join category c on b.category_id = c.category_id
    join inventory d on a.film_id = d.film_id
    join rental e on d.inventory_id = e.inventory_id
    join payment f on e.rental_id = f.rental_id
group by c.name
order by Genre_Revenue desc
limit 5;

# 8b. How would you display the view that you created in 8a?

select * from top_5_genres_revenue;

# 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

drop view top_5_genres_revenue;