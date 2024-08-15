use sakila;
with clientes as ( -- Seleccionamos los clientes que no tienen peliculas pendientes de devolucion 
                   -- con with creamos una tabla temporal o varias como en este caso, la primera es clientes y la segunda es MesAnio, separadas por una ","
    select
        c.customer_id, 
        c.last_name,
        c.first_name,
        count(r.rental_id) as CANTTOTAL  -- funcion de agregacion para contar la cantidad de peliculas rentadas 
    from 
        customer c
        join rental r on r.customer_id = c.customer_id  -- Unimos las tablas customer y rental 
    where 
        not exists ( -- Verificamos que no existan peliculas pendientes de devolucion 
            select 1
            from rental ren 
            where ren.customer_id = c.customer_id   
            and ren.return_date is null  
        )
    group by
        c.customer_id,
        c.last_name,
        c.first_name
),
MesAnio as (
    select
        c.customer_id, 
        month(r.rental_date) as mes,
        year(r.rental_date) as anio,
        count(*) as cant
    from
        customer c
        join rental r on r.customer_id = c.customer_id 
    where
        (month(r.rental_date), year(r.rental_date)) = (
            select month(rental_date), year(rental_date)
            from rental r2
            where r2.customer_id = c.customer_id
            group by month(rental_date), year(rental_date)
            order by count(*) desc
            limit 1
        )
    group by
        c.customer_id,
        month(r.rental_date),
        year(r.rental_date)
)
select
    c.last_name as Apellido,
    c.first_name as Nombre,
    coalesce(a.total, 0) as CANTTOTAL,
    coalesce(b.mes, 0) as MESMAYOR,
    coalesce(b.anio, 0) as ANIOMAYOR,
    coalesce(b.cant, 0) as CANTIDAD
from
    (
        select *
        from customer cus
        where not exists (
            select 1
            from rental ren
            where ren.customer_id = cus.customer_id
            and ren.return_date is null
        )
    )c 
    left join (
        select customer_id, count(*) as total
        from rental
        group by customer_id
    ) a on c.customer_id = a.customer_id
    left join MesAnio b on c.customer_id = b.customer_id
order by
    c.last_name,
    c.first_name;
