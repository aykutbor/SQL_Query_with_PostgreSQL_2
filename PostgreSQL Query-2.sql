--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
SELECT products.product_id,products.product_name,suppliers.company_name,suppliers.phone,products.units_in_stock AS "out_of_stock" FROM products INNER JOIN suppliers
ON products.supplier_id = suppliers.supplier_id
WHERE units_in_stock = 0;


--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT orders.order_id,employees.last_name,employees.first_name,orders.ship_address,orders.order_date,employees.employee_id FROM orders INNER JOIN employees
ON orders.employee_id = employees.employee_id
WHERE orders.order_date BETWEEN '1998-03-01' AND '1998-03-31';


--28. 1997 yılı şubat ayında kaç siparişim var?
SELECT COUNT(order_id) AS"order_count" FROM orders WHERE order_date BETWEEN '1997-02-01' AND '1997-02-28';


--29. London şehrinden 1998 yılında kaç siparişim var?
SELECT order_id,order_date,ship_city FROM orders WHERE ship_city ='London' AND order_date BETWEEN '1998-01-01' AND '1998-12-31';


--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
SELECT c.customer_id,c.contact_name,c.phone,o.order_id,o.order_date FROM customers c INNER JOIN orders o 
ON c.customer_id = o.customer_id
WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31';


--31. Taşıma ücreti 40 üzeri olan siparişlerim
SELECT * FROM orders WHERE freight>40


--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
SELECT customer_id,ship_city,freight FROM orders WHERE freight>40


--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
SELECT o.employee_id,UPPER(e.last_name|| ' ' ||e.first_name) AS"surname_name", o.order_date,o.ship_city FROM orders O 
INNER JOIN employees e
ON o.employee_id = e.employee_id
WHERE order_date BETWEEN '1997-01-01' AND '1997-12-31';


--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
SELECT DISTINCT c.contact_name,regexp_replace(c.phone, '\D', '', 'g') AS formatted_phone FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
WHERE to_char(order_date,'YYYY') = '1997';


--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
SELECT o.order_date,c.contact_name,e.first_name AS"employee_name",e.last_name AS"employee_surname" FROM orders AS o 
INNER JOIN customers AS c ON o.customer_id = c.customer_id  
INNER JOIN employees AS e ON o.employee_id = e.employee_id


--36. Geciken siparişlerim?
SELECT COUNT(required_date) AS"delayed_order" FROM orders
WHERE shipped_date>required_date


--37. Geciken siparişlerimin tarihi, müşterisinin adı
SELECT o.order_date,o.required_date,o.shipped_date,c.contact_name FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
WHERE o.shipped_date>o.required_date


--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name,c.category_name,od.quantity FROM order_details AS od
INNER JOIN products AS p ON p.product_id = od.product_id
INNER JOIN categories AS c ON c.category_id = p.category_id
WHERE od.order_id = 10248


--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT od.order_id,p.product_name,s.company_name FROM order_details AS od
INNER JOIN products AS p ON p.product_id = od.product_id
INNER JOIN suppliers AS s ON s.supplier_id = p.category_id
WHERE od.order_id = 10248


--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT
  p.product_name,
  SUM(od.quantity) AS sold_quantity
FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE e.employee_id = 3
  AND o.order_date BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY p.product_name
ORDER BY sold_quantity DESC;


--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT DISTINCT e.employee_id,e.first_name,e.last_name,od.quantity AS total_sales FROM employees as e
INNER JOIN orders AS o ON e.employee_id = o.employee_id
INNER JOIN order_details AS od ON o.order_id = od.order_id
WHERE o.order_date BETWEEN '1997-01-01' AND '1997-12-31'
ORDER BY total_sales DESC LIMIT 1;


--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, (e.first_name ||' '|| e.last_name)AS"name_surname",o.order_id, SUM(od.quantity) AS most_sales
FROM employees AS e 
INNER JOIN orders AS o ON e.employee_id = o.employee_id
INNER JOIN order_details AS od ON o.order_id = od.order_id
WHERE EXTRACT(YEAR FROM o.order_date)=1997 
GROUP BY e.employee_id, e.first_name,e.last_name,o.order_id,od.quantity
ORDER BY most_sales DESC LIMIT 1;


--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name,c.category_name,MAX(od.unit_price) AS"expensive_product" FROM order_details AS od 
INNER JOIN products AS p ON od.product_id = p.product_id
INNER JOIN categories AS c ON p.category_id = c.category_id
GROUP BY p.product_name,od.unit_price,c.category_name
ORDER BY expensive_product DESC LIMIT 1;


--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT (e.first_name||' '||e.last_name) AS"name_surname",o.order_date,o.order_id FROM employees AS e
INNER JOIN orders AS o ON e.employee_id = o.employee_id
ORDER BY o.order_date ASC;


--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_id,AVG(od.unit_price) AS"average_price" FROM orders AS o 
INNER JOIN order_details AS od ON o.order_id = od.order_id
GROUP BY o.order_id
ORDER BY o.order_id DESC LIMIT 5;


--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name,c.category_name , SUM(od.quantity) AS total_sales FROM order_details as od
INNER JOIN products AS p ON p.product_id = od.product_id
INNER JOIN orders AS o ON o.order_id = od.order_id
INNER JOIN categories AS c ON c.category_id= p.category_id
WHERE to_char(o.order_date,'MM')= '03'
GROUP BY p.product_name,c.category_name;


--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT od.order_id,p.product_name,od.quantity FROM order_details AS od
INNER JOIN products AS p ON od.product_id = p.product_id
WHERE quantity > (SELECT AVG(quantity) FROM order_details)


--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name,c.category_name,s.contact_name,MAX(od.quantity) AS"most_product"  FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers s ON s.supplier_id = p.supplier_id
GROUP BY p.product_name,c.category_name,s.contact_name,od.quantity
ORDER BY most_product DESC LIMIT 1;


--49. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT country) AS number_of_countries FROM customers


--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT SUM(od.unit_price * quantity) FROM orders AS o
INNER JOIN order_details AS od ON od.order_id =o.order_id
WHERE employee_id = 3 AND (order_date >= '1998-01-01' AND order_date <= CURRENT_DATE);


--63. Hangi ülkeden kaç müşterimiz var
SELECT country,COUNT(*) AS"number_of_customers" FROM customers
GROUP BY country


--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
SELECT SUM(od.unit_price * od.quantity) AS"profit"  FROM order_details AS od 
INNER JOIN orders AS o ON od.order_id = o.order_id
WHERE od.product_id = 10 AND o.order_date >= '1998-09-01' AND o.order_date <= '1998-12-31'


--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
SELECT e.last_name||' '||e.first_name AS"surname_name",COUNT(*) AS"total_order" FROM orders AS o
INNER JOIN employees AS e ON o.employee_id = e.employee_id
GROUP BY e.employee_id


--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
SELECT c.contact_name,c.customer_id FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id ISNULL


--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
SELECT * FROM customers WHERE country = 'Brazil'


--69. Brezilya’da olmayan müşteriler
SELECT * FROM customers WHERE country != 'Brazil'


--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT * FROM customers WHERE country IN ('Brazil','Spain','France','Germany')


--71. Faks numarasını bilmediğim müşteriler
SELECT * FROM customers WHERE fax ISNULL


--72. Londra’da ya da Paris’de bulunan müşterilerim
SELECT * FROM customers WHERE city IN ('Londra','Paris')


--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
SELECT * FROM customers WHERE contact_title = 'Owner' AND city = 'México D.F.'


--74. C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT product_name,unit_price FROM products WHERE product_name LIKE 'C%'


--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT first_name||' '||last_name AS"name_surname",birth_date FROM employees WHERE first_name LIKE 'A%'


--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT company_name FROM customers WHERE contact_name LIKE '%RESTAURANT%'


--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT product_name,unit_price FROM products WHERE unit_price BETWEEN 50 AND 100 


--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT order_id,order_date FROM orders WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31'


--81. Müşterilerimi ülkeye göre sıralıyorum:
SELECT country,COUNT(*) AS"customer_country_ranking" FROM customers
GROUP BY country
ORDER BY customer_country_ranking ASC;


--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name,unit_price FROM products 
ORDER BY unit_price DESC;


--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name,unit_price,units_in_stock FROM products 
ORDER BY unit_price DESC, units_in_stock ASC;

-----		--------

--84. 1 Numaralı kategoride kaç ürün vardır..?
SELECT COUNT(*) AS"category_id_1" FROM categories WHERE category_id = 1


--85. Kaç farklı ülkeye ihracat yapıyorum..?
SELECT COUNT(DISTINCT(ship_country)) FROM orders 


--86. a.Bu ülkeler hangileri..?
SELECT DISTINCT ship_country FROM orders 


--87. En Pahalı 5 ürün
SELECT * FROM products
ORDER BY unit_price DESC LIMIT 5


--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
SELECT COUNT(*) AS"order_quantity" FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id 
WHERE o.customer_id = 'ALFKI'


--89. Ürünlerimin toplam maliyeti
SELECT SUM(quantity * unit_price) AS "total_cost" FROM order_details


--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
SELECT SUM(od.quantity * p.unit_price) AS "total_revenue"
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;


--91. Ortalama Ürün Fiyatım
SELECT AVG(p.unit_price) AS "total_price"
FROM order_details od
JOIN products p ON od.product_id = p.product_id;
-----
SELECT AVG(unit_price) AS "total_price"
FROM products;


--92. En Pahalı Ürünün Adı
SELECT p.product_name,MAX(od.unit_price) AS"expensive_product" FROM order_details AS od 
INNER JOIN products AS p ON od.product_id = p.product_id
GROUP BY p.product_name,od.unit_price
ORDER BY expensive_product DESC LIMIT 1;


--93. En az kazandıran sipariş
SELECT p.product_name,MAX(od.unit_price) AS"cheapest_product" FROM order_details AS od 
INNER JOIN products AS p ON od.product_id = p.product_id
GROUP BY p.product_name,od.unit_price
ORDER BY expensive_product ASC LIMIT 1;


--94. Müşterilerimin içinde en uzun isimli müşteri
SELECT contact_name FROM customers
ORDER BY LENGTH(contact_name) DESC
LIMIT 1;


--95. Çalışanlarımın Ad, Soyad ve Yaşları
SELECT first_name||' '||last_name AS"name_surname",birth_date FROM employees 


--96. Hangi üründen toplam kaç adet alınmış..?
SELECT p.product_name, SUM(od.quantity) AS "total_products_sold"
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name;


--97. Hangi siparişte toplam ne kadar kazanmışım..?
SELECT p.product_name, SUM(od.quantity * p.unit_price) AS "total_order_amount"
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name;


--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
SELECT c.category_name, COUNT(*) AS total_product FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
GROUP BY category_name;


--99. 1000 Adetten fazla satılan ürünler?
SELECT p.product_name FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(od.quantity) > 1000;


--100. Hangi Müşterilerim hiç sipariş vermemiş..?
SELECT c.contact_name,c.customer_id FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id  ISNULL






