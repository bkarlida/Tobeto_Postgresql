-- 26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın 
select product_id, product_name, company_name, phone, units_in_stock from products
inner join suppliers on products.product_id=suppliers.supplier_id where units_in_stock = 0;

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select ship_address, first_name || ' ' || last_name as name from employees e
inner join orders o on o.employee_id=e.employee_id
where order_date >= '1998-03-01' and order_date < '1998-04-01';

--28. 1997 yılı şubat ayında kaç siparişim var?
select count(*) from orders
where order_date >= '1997-02-01' and order_date < '1997-03-01';

--29. London şehrinden 1998 yılında kaç siparişim var?
select count(ship_city), ship_city from orders
where ship_city = 'London' and order_date >= '1998-01-01' and order_date <= '1998-12-31'
group by ship_city;

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select contact_name, phone from customers c
inner join orders o on o.customer_id=c.customer_id
where order_date >= '1998-01-01' and order_date <= '1998-12-31';

--31. Taşıma ücreti 40 üzeri olan siparişlerim
select * from orders
where freight > 40;

-- 32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select ship_city, first_name || ' ' || last_name AS name from employees as e
inner join orders  on e.employee_id=orders.employee_id
where freight > 40;

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select upper(first_name || ''|| last_name) AS name, ship_city, order_date  from employees as e
inner join orders  on e.employee_id=orders.employee_id
where freight > 40 and EXTRACT(YEAR FROM order_date) = 1998;

-- 34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select contact_name, REGEXP_REPLACE(phone, '[^0-9]', '', 'g')as phone from customers
inner join orders on orders.customer_id=customers.customer_id
where extract(year from order_date) = 1997;

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select order_date, contact_name, first_name || ' ' || last_name as name from orders
inner join customers on customers.customer_id=orders.customer_id
inner join employees on employees.employee_id=orders.employee_id;

--36. Geciken siparişlerim?
select * from orders
where required_date < shipped_date;

--37. Geciken siparişlerimin tarihi, müşterisinin adı

select order_date ,contact_name from orders
inner join customers on customers.customer_id=orders.customer_id
where required_date < shipped_date;

-- 38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select order_id, product_name, category_name, quantity from order_details od
inner join products p on od.product_id = p.product_id
inner join categories c on p.category_id = c.category_id
where order_id = 10248;

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select od.order_id, p.product_name, s.company_name as suppliers_name from order_details od
inner join products p on od.product_id = p.product_id
inner join suppliers s on p.supplier_id = s.supplier_id
where order_id = 10248;

-- 40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select o.order_id, o.order_date, o.employee_id, p.product_name, od.quantity from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
where EXTRACT(YEAR FROM order_date)=1997 AND o.employee_id = 3;

-- 41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS ad_soyad, SUM(od.quantity * p.unit_price) AS siparis_tutari FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY e.employee_id, ad_soyad, o.order_id
ORDER BY siparis_tutari DESC
LIMIT 1;

-- 42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS ad_soyad, SUM(od.quantity) AS toplam_satis
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY e.employee_id, ad_soyad
ORDER BY toplam_satis DESC
LIMIT 1;

-- 43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select product_name, unit_price, category_name from products p
inner join categories c on c.category_id=p.category_id
group by category_name, product_name, unit_price
order by unit_price desc
limit 1;

-- 44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name || ' ' || e.last_name AS ad_soyad, o.order_date, o.order_id FROM orders o
JOIN employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date;

-- 45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_id, o.order_date,  AVG(od.unit_price * od.quantity) AS ortalama_fiyat FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;

-- 46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, SUM(od.quantity) AS toplam_satis_miktari FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE EXTRACT(MONTH FROM o.order_date) = 1
GROUP BY p.product_name, c.category_name;

-- 47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT od.order_id, SUM(od.quantity) AS status
FROM order_details od
GROUP BY od.order_id
HAVING SUM(od.quantity) > (
    SELECT AVG(quantity)
    FROM order_details
)
ORDER BY status DESC;

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select product_name , category_name, company_name from order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY p.product_name, c.category_name, s.company_name
ORDER BY SUM(od.quantity) DESC
LIMIT 1;

--49. Kaç ülkeden müşterim var
select COUNT(DISTINCT country) as ülke
FROM customers;

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select SUM(od.quantity * od.unit_price) AS "toplam ürün"
FROM order_details od
inner join orders o on o.order_id=od.order_id
where EXTRACT(MONTH FROM o.order_date) = 1
AND o.employee_id = 3
AND o.order_date >= DATE '1998-01-01' AND o.order_date <= DATE '2023-11-10';


--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select order_id, product_name, category_name, quantity from order_details od
inner join products p on p.product_id=od.product_id
inner join categories c on c.category_id=p.category_id
where order_id = 10248;

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
 select product_name, company_name from order_details od
 inner join products p on p.product_id=od.product_id
 JOIN suppliers s ON p.supplier_id = s.supplier_id
 where order_id = 10248;

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT p.product_name, od.quantity FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE e.employee_id = 3
AND EXTRACT(YEAR FROM o.order_date) = 1997;

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS ad_soyad, SUM(od.quantity * p.unit_price) AS siparis_tutari
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY e.employee_id, ad_soyad, o.order_id
ORDER BY siparis_tutari DESC
LIMIT 1;

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

SELECT e.employee_id, e.first_name || ' ' || e.last_name AS name, SUM(od.quantity) AS toplam_satis
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY e.employee_id, name
ORDER BY toplam_satis DESC
LIMIT 1;

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name from products p
inner join categories c on c.category_id=p.category_id
order by unit_price desc
limit 1;

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select od.order_id, o.order_date, first_name || ' ' || last_name as name from order_details od
inner join orders o on o.order_id=od.order_id
inner join employees e on e.employee_id=o.employee_id
order by order_date asc;

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select od.order_id, o.order_date, avg(unit_price) from order_details od
inner join orders o on o.order_id=od.order_id
group by od.order_id, order_date
order by o.order_date desc
limit 5;

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select order_date, product_name, category_name, sum(od.quantity) from order_details od
inner join orders o on o.order_id=od.order_id
inner join products p on p.product_id=od.product_id
inner join categories c on c.category_id=p.category_id
WHERE EXTRACT(MONTH FROM o.order_date) = 01
GROUP BY p.product_name, c.category_name, o.order_date;

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

SELECT od.order_id, SUM(od.quantity) AS toplam_satis FROM order_details od
GROUP BY od.order_id
HAVING SUM(od.quantity) > ( SELECT AVG(quantity) FROM order_details)
ORDER BY toplam_satis DESC;

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

SELECT p.product_name, c.category_name, s.company_name
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY p.product_name, c.category_name, s.company_name
ORDER BY SUM(od.quantity) DESC
LIMIT 1;

--62. Kaç ülkeden müşterim var
select count(distinct(c.city)) from customers c;

--63. Hangi ülkeden kaç müşterimiz var
SELECT country, COUNT(DISTINCT customer_id) AS müsteri_sayisi
FROM customers
GROUP BY country;

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT SUM(od.quantity * od.unit_price) AS "toplam satiş miktarı"
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
WHERE EXTRACT(MONTH FROM o.order_date) = 1
AND o.employee_id = 3
AND o.order_date >= DATE '1998-01-01' AND o.order_date <= DATE '2023-11-10';

-- 65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
SELECT SUM(od.quantity * p.unit_price) AS total FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE od.product_id = 10 AND o.order_date >= CURRENT_DATE - INTERVAL '3 months';

-- 66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
SELECT e.employee_id, e.first_name || ' ' || e.last_name as name, COUNT(o.order_id) AS "Toplam Sipariş Adedi" FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name;

-- 67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
SELECT o.order_id, c.contact_name,c.country  FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name, contact_name, address, city, country from customers c
where country = 'Brazil';

-- 69. Brezilya’da olmayan müşteriler
select company_name, contact_name, address, city, country from customers c
where country != 'Brazil';

-- 70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select company_name, contact_name, address, city, country from customers c
where country = 'Spain' or country = 'France' or country = 'Germany'; -- yada ' in ' ile de yapabiliriz

--71. Faks numarasını bilmediğim müşteriler
select company_name, contact_name, address, city, country, fax from customers c
where fax is  null;

-- 72. Londra’da ya da Paris’de bulunan müşterilerim
select company_name, contact_name, address, city, country, fax from customers c
where city in ('London', 'Paris');

-- 73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select company_name, contact_name, contact_title, address, city, country from customers c
where city = 'Mexico D.F' and contact_title = 'Owner';

-- 74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name, unit_price from products
where product_name  like 'C%';

-- 75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name , last_name, birth_date from employees
where first_name like 'A%';

-- 76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT company_name
FROM customers
WHERE company_name LIKE '%Restaurant%' OR company_name LIKE '%Restaurante%';

-- 77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name, unit_price from products
where unit_price between 50 and 100;

-- 78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select order_id, order_date from orders
where order_date between date '1996-07-01' and date '1996-12-31';

-- 79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select company_name, contact_name, address, city, country from customers c
where country = 'Spain' or country = 'France' or country = 'Germany'; -- yada ' in ' ile de yapabiliriz

--80. Faks numarasını bilmediğim müşteriler
select company_name, contact_name, address, city, country, fax from customers c
where fax is  null;

--81. Müşterilerimi ülkeye göre sıralıyorum:
SELECT *
FROM customers
ORDER BY country;

-- 82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price from products
order by unit_price desc;

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price, units_in_stock from products
order by unit_price desc, units_in_stock asc;

-- 84. 1 Numaralı kategoride kaç ürün vardır..?
SELECT COUNT(*) AS "Ürün Sayısı" FROM products
WHERE category_id = 1;

-- 85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct country) as diff_country from customers;
