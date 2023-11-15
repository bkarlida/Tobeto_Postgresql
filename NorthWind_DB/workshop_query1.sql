-- 0. 
select * from products;
-- 0. 
select * from categories;
-- 0.
select * from suppliers;
--0.
select * from employees;
--0.
select * from orders;
--0.
select * from customers;
--0.
select * from order_details;
-- 1.
select product_name, quantity_per_unit from products;
-- 2.
select product_id, product_name, discontinued from products where discontinued=1;
-- 3.
select product_id, product_name, discontinued from products where discontinued=0;
-- 4.
select product_id, product_name, unit_price from products where unit_price < 20;
-- 5.
select product_id, product_name, unit_price from products where unit_price > 15 and unit_price < 25;
-- 6.
select product_id, product_name, units_on_order, units_in_stock from products where units_in_stock < units_on_order;
-- 7.
select product_name from products where product_name like 'A%';
-- 8.
select product_name from products where product_name like '%i';
-- 9.
select product_name, unit_price, (unit_price*118/100) FROM products;
-- 10.
select count(*) from products where unit_price > 30;
-- 11.
select unit_price, lower(product_name) from products order by unit_price desc;  
-- 12.
select first_name || ' ' || last_name as name FROM employees;
-- 13.
select count(*) from suppliers where region is null;
-- 14.
select count(*) from suppliers where region is not null;
-- 15.
select UPPER(product_name) || 'TR'  as upper_name_tr FROM products;
-- 16.
select 'TR' || product_name as tr_name FROM products WHERE unit_price<20;
-- 17.
select product_name, unit_price FROM products WHERE unit_price = (SELECT MAX(unit_price) FROM products);
-- 18.
select product_name, unit_price FROM products order by unit_price desc limit 10;
-- 19.
select product_name, unit_price from products where unit_price > (select avg(unit_price) from products);
-- 20.
select SUM(unit_price * units_in_stock) FROM products;
-- 21.
select SUM(units_in_stock) , SUM(discontinued) FROM products;
-- 22.
select product_name, category_name FROM products INNER JOIN categories ON products.category_id=categories.category_id;
-- 23.
select AVG(unit_price) FROM products GROUP BY category_id;
-- 24.
select product_name, unit_price, category_name FROM products INNER JOIN categories ON products.category_id=categories.category_id
WHERE unit_price = (SELECT MAX(unit_price) FROM products);
-- 25.
SELECT product_name, category_name, company_name FROM products 
JOIN categories ON products.category_id=categories.category_id
JOIN suppliers ON products.supplier_id=suppliers.supplier_id
WHERE units_on_order=(SELECT MAX(units_on_order) FROM products);

--hangi kategoride kaç tane ürün var
select category_id from products
inner join categories on products.category_id = categories.category_id;
