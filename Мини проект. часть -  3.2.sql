CREATE DATABASE mini_project;

CREATE TABLE T_TAB1
(	
	ID INT UNIQUE,
	GOODS_TYPE VARCHAR (20),
	QUANTITY  INT,
	AMOUNT INT,
    SELLER_NAME VARCHAR (20)
);

    CREATE TABLE T_TAB2
(	
	ID INT UNIQUE,
	NAME  VARCHAR (20),
	SALARY   INT,
	AGE  INT    
);

INSERT INTO T_TAB1 (ID, GOODS_TYPE, QUANTITY, AMOUNT, SELLER_NAME) VALUES 

	(1, 'MOBILE PHONE', 2, 400000, 'MIKE'),
	(2, 'KEYBOARD', 1, 10000, 'MIKE'),
	(3, 'MOBILE PHONE', 1, 50000, 'JANE'),
	(4, 'MONITOR', 1, 110000, 'JOE'),
	(5, 'MONITOR', 2, 80000, 'JOE'),
	(6, 'MOBILE PHONE', 1, 130000, 'JANE'),
	(7, 'MOBILE PHONE', 1, 60000, 'ANNA'),
	(8, 'PRINTER', 1, 90000, 'ANNA'),
	(9, 'KEYBOARD', 2, 10000, 'ANNA'),
	(10, 'PRINTER', 1, 80000, 'MIKE');
    
INSERT INTO T_TAB2 (ID, NAME, SALARY, AGE) VALUES 

	(1, 'ANNA', 110000, 27),
	(2, 'JANE', 80000, 25),
	(3, 'MIKE', 120000, 25),
	(4, 'JOE', 70000, 24),
	(5, 'RITA', 120000, 29);
    
# ПОДСКАЗКА T_TAB1.SELLER_NAME = T_TAB2.NAME 
  
# 1.
# Напишите запрос, который вернёт список уникальных категорий товаров (GOODS_TYPE). Какое количество уникальных категорий товаров вернёт запрос. 

SELECT COUNT(DISTINCT GOODS_TYPE) 
	 FROM 
	(SELECT DISTINCT GOODS_TYPE AS GOODS_TYPE 
	 FROM T_TAB1) AS COUNT;
 
# 2. Напишите запрос, который вернет суммарное количество и суммарную стоимость проданных мобильных телефонов. 
# Какое суммарное количество и суммарную стоимость вернул запрос?

SELECT  SUM(T1.QUANTITY) AS SUM_QUANTITY, SUM(T2.AMOUNT) AS SUM_AMOUNT
FROM T_TAB1 T1
JOIN T_TAB1 T2
ON T1.ID=T2.ID
WHERE T1.GOODS_TYPE = 'MOBILE PHONE';

# 3 Напишите запрос, который вернёт список сотрудников с заработной платой > 100000. Какое кол-во сотрудников вернул запрос? 

SELECT DISTINCT t2.NAME 
FROM T_TAB1 t1
RIGHT JOIN T_TAB2 t2
ON t1.SELLER_NAME = t2.NAME
WHERE t2.SALARY > 100000;

SELECT COUNT(name) FROM
(SELECT DISTINCT t2.NAME as name
FROM T_TAB1 t1
RIGHT JOIN T_TAB2 t2
ON t1.SELLER_NAME = t2.NAME
WHERE t2.SALARY > 100000) as count_name;

#4 Напишите запрос, который вернёт минимальный и максимальный возраст сотрудников, а также минимальную и максимальную заработную плату.

SELECT MIN(SALARY) as min_max_salary, MIN(AGE) as min_max_age
FROM T_TAB2 T2
UNION
SELECT MAX(SALARY) as min_max_salary, MAX(AGE) as min_max_age
FROM T_TAB2 T2;

#5 Напишите запрос, который вернёт среднее количество проданных клавиатур и принтеров. 

SELECT SUM(AVG_QUANTITY) FROM 
	(SELECT AVG(QUANTITY) AS AVG_QUANTITY 
     FROM T_TAB1
	 WHERE GOODS_TYPE IN('KEYBOARD' ,'PRINTER')) AS SUM_AVG_QUANTITY;
     
# 6 Напишите запрос, который вернёт имя сотрудника и суммарную стоимость проданных им товаров.

SELECT t2.NAME, SUM(t1.AMOUNT) 
FROM T_TAB1 t1
RIGHT JOIN T_TAB2 t2
ON t1.SELLER_NAME = t2.NAME
GROUP BY t2.NAME;

# 7 Напишите запрос, который вернёт имя сотрудника, тип товара, кол-во товара, стоимость товара, заработную плату и возраст сотрудника MIKE.

SELECT  t2.NAME, t1.GOODS_TYPE, t1.QUANTITY, t1.AMOUNT, t2.SALARY, t2.AGE
FROM T_TAB2 t2
LEFT JOIN T_TAB1 t1
ON t1.SELLER_NAME = t2.NAME
WHERE t2.NAME = 'MIKE';

# 8 Напишите запрос, который вернёт имя и возраст сотрудника, который ничего не продал. Сколько таких сотрудников?

SELECT COUNT(*) FROM
	(SELECT t2.NAME, t2.AGE AS emp
	FROM T_TAB2 t2
	LEFT JOIN T_TAB1 t1
	ON t1.SELLER_NAME = t2.NAME
	WHERE t1.QUANTITY IS NULL OR t1.QUANTITY = 0) AS name_age;

# 9 Напишите запрос, который вернёт имя сотрудника и его заработную плату с возрастом меньше 26 лет? Какое количество строк вернул запрос?

SELECT COUNT(name_salary) FROM 
	(SELECT NAME, SALARY AS name_salary FROM T_TAB2
	 WHERE AGE < 26) AS count; 

SELECT NAME, SALARY AS name_salary 
FROM T_TAB2
WHERE AGE < 26;

# 10 Сколько строк вернёт следующий запрос: 

# Вернет 0 строк, надо поставить RIGHT JOIN или LEFT JOIN и поменять местами таблицы, тогда запрос будет работать.

SELECT *
FROM T_TAB1 t
JOIN T_TAB2 t2 
ON t2.NAME = t.SELLER_NAME
WHERE t2.NAME = 'RITA';

SELECT *
FROM T_TAB1 t
RIGHT JOIN T_TAB2 t2 
ON t2.NAME = t.SELLER_NAME
WHERE t2.NAME = 'RITA';

SELECT *
FROM T_TAB2 t2
LEFT JOIN T_TAB1 t 
ON t2.NAME = t.SELLER_NAME
WHERE t2.NAME = 'RITA';



   
   