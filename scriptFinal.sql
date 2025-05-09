
--LógicaConsultasSQL

--1. Crea el esquema de la BBDD.
--!HECHO!
SELECT * FROM "language" l ;


--2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
SELECT *
FROM film f 
WHERE "rating" = 'R'
ORDER BY f.film_id;


--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
SELECT actor_id, CONCAT(a.first_name, ' ', a.last_name) AS nombre_actor
FROM actor a
WHERE actor_id BETWEEN 30 AND 40;


--4. Obtén las películas cuyo idioma coincide con el idioma original.
--Primero voy a ver que peliculas tienen contenido no-nulo en la columna idioma original...
select *
from film f
where original_language_id is not null;
--vemos que no hay resultados de esto, por tanto ninguna pelicula va a coincidir su idioma con su idioma orignal pues no 
-- hay contenido 


--5. Ordena las películas por duración de forma ascendente.
SELECT title AS titulo, length AS duracion
FROM film f 
order BY length ;


--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
SELECT a.actor_id, CONCAT(a.first_name, ' ', a.last_name) asAS nombre_actor
FROM actor a 
where a.last_name = 'ALLEN';


--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film”
--y muestra la clasificación junto con el recuento.
SELECT COUNT(film_id ) AS total, rating 
FROM film f
GROUP BY f.rating;


--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
SELECT title asAS titulo, rating, length
FROM film f 
WHERE f.rating = 'PG-13' OR f.length > 180;


--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
select sum(f.replacement_cost )
from film f ;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
select max(length) as duracion_max, min(length) as duracion_min
from film f ;


--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select amount as costo
from payment p 
order by p.payment_date desc
limit 1 offset 2;


--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.
SELECT title as titulo, rating as clasificacion 
FROM film f
WHERE rating NOT IN ('NC-17', 'G');

/*13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film
y muestra la clasificación junto con el promedio de duración.*/
select ROUND(AVG(length),2) as promedio, rating as clasificacion
from film f 
group by clasificacion ;


--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select title as titulo, length as duracion
from film as f
where f.length > 180;


--15. ¿Cuánto dinero ha generado en total la empresa?
select sum(amount)
from payment;


--16. Muestra los 10 clientes con mayor valor de id.
select *
from customer c 
order by c.customer_id desc
limit 10;


--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
with tabla1 as (
select * 
from actor a
inner join film_actor fa 
on a.actor_id = fa.actor_id)
select CONCAT(tabla1.first_name, ' ', tabla1.last_name) as nombre_completo, title as titulo
from tabla1 
inner join film on tabla1.film_id = film.film_id
where title = 'EGG IGBY';


--18. Selecciona todos los nombres de las películas únicos.
select distinct title as titulo
from film f; 


--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

select title as titulo, c."name"  as categoria, length  as duracion
from category c 
inner join film_category fc 
on c.category_id = fc.category_id
inner join film f on f.film_id = fc.film_id
where "name" = 'Comedy' and length > 180;


--20. Encuentra las categorías de películas que tienen un promedio de 
--duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
with tabla2 as (
select *
from category c 
inner join film_category fc 
on c.category_id = fc.category_id
inner join film f on f.film_id = fc.film_id)

select name as categoria, ROUND(avg(length),2)  as promedio_duracion
from tabla2
group by categoria
having avg(length) > 110;


--21. ¿Cuál es la media de duración del alquiler de las películas?
select avg(rental_duration) as media_duracion
from film f;


--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
select concat(first_name, ' ', last_name) as nombre_completo
from actor;


--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select payment_date::date as fecha_alquiler, count(payment_id) as cantidad
from payment p 
group by payment_date::date
order by cantidad  desc;


--24. Encuentra las películas con una duración superior al promedio.
select title, length 
from film f 
where f.length > (
	select avg(length)
	from film );


--25. Averigua el número de alquileres registrados por mes.
select count (rental_id) as total_alquileres
from rental;


--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
select round(avg(amount), 3) as promedio, round(stddev(amount),3) as desviacion_estandar, round(variance(amount), 3) as varianza
from payment p ;


--27. ¿Qué películas se alquilan por encima del precio medio?
select title as titulo, rental_rate  as duracion
from film f 
where f.rental_rate > (
select avg(rental_rate) from film);



--28. Muestra el id de los actores que hayan participado en más de 40 películas.
select count(f.film_id) as total_peliculas, a.actor_id
from film_actor fa 
inner join film f on fa.film_id = f.film_id
inner join actor a on a.actor_id = fa.actor_id
group by a.actor_id 
having count(f.film_id) > 40
order by a.actor_id;


--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
select  count(f.film_id) as total, f.title 
from inventory i
inner join film f on f.film_id = i.film_id
group by f.title;


--30. Obtener los actores y el número de películas en las que ha actuado.
select count(fa.film_id) as total, concat(a.first_name, ' ', a.last_name) as nombre
from film_actor fa 
inner join film f on f.film_id = fa.film_id
inner join actor a on a.actor_id = fa.actor_id
group by nombre;


--31. Obtener todas las películas y mostrar los actores que han actuado en 
-- ellas, incluso si algunas películas no tienen actores asociados.
select title as titulo, concat(a.first_name, ' ', a.last_name) as nombre_actor
from film_actor fa 
inner join film f on f.film_id = fa.film_id
inner join actor a on a.actor_id = fa.actor_id
order by titulo;


--32. Obtener todos los actores y mostrar las películas en las que han
--actuado, incluso si algunos actores no han actuado en ninguna película.
select title as titulo, concat(a.first_name, ' ', a.last_name) as nombre_actor
from film_actor fa 
left join film f on f.film_id = fa.film_id
left join actor a on a.actor_id = fa.actor_id
order by titulo;


--33. Obtener todas las películas que tenemos y todos los registros de alquiler.
select title as titulo, rental_rate as registro_renta
from film;


--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.



with tabla_momentanea as (
select sum(amount) total, customer_id as id_cliente
from payment 
group by id_cliente)
select concat(first_name, ' ', last_name) as nombre, total  
from tabla_momentanea 
inner join customer c on c.customer_id = tabla_momentanea.id_cliente
order by total desc
limit 5;


--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select concat(first_name, ' ', last_name) as nombre_completo
from actor a
where a.first_name = 'Johnny';


--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
select first_name  as Nombre, last_name as Apellido
from actor a;


--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
select max(actor_id) as maximo, min(actor_id) as minimo
from actor a ;


--38. Cuenta cuántos actores hay en la tabla “actor”.
select count(actor_id) as recuento
from actor;


--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select first_name, last_name
from actor a
order by a.last_name;


--40. Selecciona las primeras 5 películas de la tabla “film”.
select title
from film f 
limit 5;


--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

--a) agrupacion de actores por nombre
select count(first_name) as recuento, first_name as nombre 
from actor
group by first_name 
order by nombre;

--b) nombre mas repetido
select first_name as nombre, count(first_name) as recuento 
from actor
group by first_name 
order by recuento desc
limit 1;



--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select concat(first_name, ' ', last_name) as nombre_completo, amount as alquiler
from payment p 
inner join customer c on c.customer_id = p.customer_id;


--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select concat(first_name, ' ', last_name) as nombre_completo, amount as alquiler
from payment p 
left join customer c on c.customer_id = p.customer_id;


--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valoresta consulta?
--¿Por qué? Deja después de la consulta la contestación.
select *
from film
cross join category;
--CONTESTACION --> No tiene ningun valor en especial, de hecho puede generar confusiones pues dice que cada una
-- de las peliculas tiene todos los generos

--45. Encuentra los actores que han participado en películas de la categoría 'Action'.
select distinct (concat(first_name, ' ', last_name)) as nombre, name as categoria
from actor a
inner join film_actor fa on fa.actor_id = a.actor_id
inner join film_category fc on fc.film_id = fa.film_id
inner join category c on c.category_id = fc.category_id
where name = 'Action'
order by nombre;


--46. Encuentra todos los actores que no han participado en películas.
select concat(first_name, ' ', last_name) as nombre 
from actor a
left join film_actor fa on fa.actor_id = a.actor_id
where fa.film_id is null;


--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
with conteo_total as (
select count(fa.film_id) as total, actor_id 
from film_actor fa
group by actor_id)
select concat(a.first_name, ' ', a.last_name) as nombre, total
from conteo_total 
inner join actor a on a.actor_id = conteo_total.actor_id
order by total desc;


--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el 
--número de películas en las que han participado.
create view actor_num_peliculas as
with conteo_total as (
select count(fa.film_id) as total, actor_id 
from film_actor fa
group by actor_id)
select concat(a.first_name, ' ', a.last_name) as nombre, total
from conteo_total 
inner join actor a on a.actor_id = conteo_total.actor_id
order by total desc;


--49. Calcula el número total de alquileres realizados por cada cliente.
select concat(c.first_name, ' ', c.last_name) as nombre, count(r.rental_id) as total
from customer c
inner join rental r on r.customer_id = c.customer_id
group by nombre
order by total desc;


--50. Calcula la duración total de las películas en la categoría 'Action'.
select title as titulo, f.length as duracion
from film f 
inner join film_category fc on fc.film_id = f.film_id
inner join  category c on c.category_id = fc.category_id
where name = 'Action'
order by duracion desc;


--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
CREATE TEMPORARY TABLE cliente_rentas_temporal as (
select concat(c.first_name, ' ', c.last_name) as nombre, count(r.rental_id) as total
from customer c
inner join rental r on r.customer_id = c.customer_id
group by nombre
order by total desc);


--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las 
-- películas que han sido alquiladas al menos 10 veces.
CREATE TEMPORARY TABLE peliculas_alquiladas as (
select title as titulo, count(rental_rate) as numero_alquileres
from film f
group by titulo 
having count(rental_rate) > 10
order by numero_alquileres  desc);


/*53. Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película.*/
select *
from customer c
inner join rental r on r.customer_id = c.customer_id 
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on i.film_id = f.film_id
where concat(c.first_name, ' ', c.last_name) = 'Tammy Sanders' ;


/*54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la 
categoría ‘Sci-Fi’. Ordena los resultados
alfabéticamente por apellido.*/
select  (a.first_name) as nombre,  (a.last_name) as apellido
from actor a
inner join film_actor fa on fa.actor_id = a.actor_id
inner join film f on f.film_id  = fa.film_id 
inner join film_category fc2  on fc2.film_id  = f.film_id
inner join category c on c.category_id = fc2.category_id
where c."name" = 'Sci-Fi'
order by apellido;


/*55. Encuentra el nombre y apellido de los actores que han actuado en
películas que se alquilaron después de que la película ‘Spartacus
Cheaper’ se alquilara por primera vez. Ordena los resultados
alfabéticamente por apellido.*/
select a.first_name as nombre, a.last_name as apellido
from rental r
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on f.film_id = i.film_id
inner join film_actor fa on fa.film_id = f.film_id
inner join actor a on a.actor_id = fa.actor_id
where r.rental_date > (
select rental_date::date as fecha
from rental r
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on f.film_id = i.film_id
where f.title = 'SPARTACUS CHEAPER'
order by fecha
limit 1);


--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

select distinct(first_name) as nombre, last_name as apellido
from actor a
inner join film_actor fa  on fa.actor_id =a.actor_id
left join film f on f.film_id = fa.film_id
inner join film_category fc on fc.film_id = f.film_id
inner join category c on c.category_id = fc.category_id
where c.name <> 'Music';


--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
select title as titulo
from film f
where f.rental_duration > 8;


--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
select title as titulo
from film f 
inner join film_category fc on fc.film_id = f.film_id
inner join category c on c.category_id = fc.category_id
where c.name = 'Animation';


--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título 
--‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
select title as titulo, length as duracion
from film f
where f.length = (
select length  
from film f
where title = 'DANCING FEVER')
order by titulo; 


--60. Encuentra los nombres de los clientes que han alquilado al menos 7
--películas distintas. Ordena los resultados alfabéticamente por apellido.
select count(r.rental_id) as total_alquileres, concat(c.first_name, ' ', c.last_name) as nombre_cliente
from rental r
inner join customer c on c.customer_id = r.customer_id
inner join payment p on p.rental_id = r.rental_id
group by nombre_cliente
having count(r.rental_id) >= 7
order by nombre_cliente ;


--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre 
-- de la categoría junto con el recuento de alquileres.
select COUNT(rental_id) as recuento, c."name" as categoria
from rental r
inner join inventory i on i.inventory_id  =r.inventory_id
inner join film f on f.film_id = i.film_id
inner join film_category fc on fc.film_id =f.film_id
inner join category c on c.category_id = fc.category_id
group by categoria 
order by recuento desc;


--62. Encuentra el número de películas por categoría estrenadas en 2006.
select COUNT(f.film_id) as total, c.name as categoria
from film f
inner join film_category fc on fc.film_id = f.film_id
inner join category c on c.category_id = fc.category_id
where release_year = 2006
group by categoria
order by total desc;


--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select *
from store st
full join staff s on s.staff_id  = st.manager_staff_id  ;


/*64. Encuentra la cantidad total de películas alquiladas por cada cliente y
muestra el ID del cliente, su nombre y apellido junto con la cantidad de
películas alquiladas.*/
select CONCAT(c.first_name,' ', c.last_name, ' - ', c.customer_id) as nombre_id, count(rental_id) as total
from customer c 
inner join rental r on r.customer_id = c.customer_id 
group by nombre_id 
order by total desc;