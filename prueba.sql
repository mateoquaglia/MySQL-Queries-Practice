 
SELECT 
    c.name AS "Nombre de la categoría",
    CONCAT(a.first_name, ' ', a.last_name) AS "Nombre y apellido del actor",
    COUNT(r.rental_id) AS "Cantidad de alquileres"
FROM 
    category c
CROSS JOIN  
    actor a
LEFT JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN 
    film f ON fa.film_id = f.film_id
LEFT JOIN 
    film_category fc ON f.film_id = fc.film_id AND c.category_id = fc.category_id
LEFT JOIN 
    inventory i ON f.film_id = i.film_id
LEFT JOIN 
    rental r ON i.inventory_id = r.inventory_id
GROUP BY 
    c.name, a.first_name, a.last_name 
ORDER BY 
    c.name, a.first_name, a.last_name 

