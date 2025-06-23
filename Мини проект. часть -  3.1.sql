CREATE DATABASE user_adverts;

# ответ
CREATE TABLE users
(date date,
user_id VARCHAR (100),
view_advets INT
);

#1. Напишите запрос SQL, выводящий одним числом количество уникальных пользователей в этой таблице в период с 2023-11-07 по 2023-11-15.

# ответ
SELECT COUNT(DISTINCT user_id) AS COUNT FROM users
WHERE date BETWEEN '2023-11-07' AND '2023-11-15';

#2. Определите пользователя, который за весь период посмотрел наибольшее количество объявлений. доработать

# ответ
SELECT user_id, SUM(view_advets) AS max_view FROM users
GROUP BY user_id
ORDER BY SUM(view_advets)DESC 
LIMIT 1;

#3  Определите день с наибольшим средним количеством просмотренных рекламных объявлений на пользователя, 
# учитывайте только дни с более чем 500 уникальными пользователями.

SELECT DATE, AVG(view_advets) 
FROM users
GROUP BY DATE
ORDER BY AVG(view_advets) DESC
LIMIT 1;

SELECT  DATE  FROM users
GROUP BY DATE
HAVING COUNT(DISTINCT user_id) >500;

# ответ
SELECT DATE, AVG(view_advets) 
FROM users
WHERE DATE IN 
	(SELECT  DATE  FROM users
	GROUP BY DATE
	HAVING COUNT(DISTINCT user_id) >500)
	GROUP BY DATE
	ORDER BY AVG(view_advets) DESC
	LIMIT 1;

#4 Напишите запрос возвращающий LT (продолжительность присутствия пользователя на сайте) 
# по каждому пользователю. Отсортировать LT по убыванию.

SELECT COUNT(DISTINCT user_id) FROM users;
SELECT COUNT(user_id) FROM users;
SELECT DISTINCT date FROM users;

# ответ
SELECT  user_id, COUNT(view_advets) FROM users
WHERE date BETWEEN  '2023-11-01' AND '2023-11-30'
GROUP BY user_id
ORDER BY COUNT(view_advets) DESC;

#5 Для каждого пользователя подсчитайте среднее количество просмотренной рекламы за день, 
# а затем выясните, у кого самый высокий средний показатель среди тех, кто был активен как минимум в 5 разных дней. 

SELECT user_id, date, SUM(view_advets) 
FROM users 
GROUP BY user_id, date;

SELECT user_id, AVG(view_advets) FROM users 
GROUP BY user_id 
HAVING COUNT(DISTINCT date) >= 5;

# ответ
WITH max_avg_user AS(
SELECT user_id, AVG(view_advets) AS  avg_view_adv
FROM (SELECT user_id, date, SUM(view_advets)  AS  view_advets
FROM users 
GROUP BY user_id, date) AS m_avg
GROUP BY user_id 
HAVING COUNT(DISTINCT date) >= 5
)

SELECT user_id, avg_view_adv
FROM max_avg_user 
ORDER BY avg_view_adv DESC
LIMIT 1;