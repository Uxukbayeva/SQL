CREATE DATABASE Customers_transactions; 
UPDATE customers SET Gender = NULL WHERE Gender = '';
UPDATE customers SET Age = NULL WHERE Age = '';
ALTER TABLE customers MODIFY AGE INT NULL;

SELECT*FROM customers;

CREATE TABLE Transactions
(date_new DATE,
 Id_check INT,
 ID_client INT,
 Count_products DECIMAL (10,3),
 Sum_payment DECIMAL (10,2));
 
 LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TRANSACTIONS_final.csv"
 INTO TABLE Transactions
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n'
 IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv';

# 1
# список клиентов с непрерывной историей за год, то есть каждый месяц на регулярной основе без пропусков за указанный годовой период (01.06.2015 по 01.06.2016.), 

SELECT t.ID_client
FROM transactions AS t
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY t.ID_client 
HAVING COUNT(DISTINCT MONTH(t.date_new)) = 12;

# средний чек за период с 01.06.2015 по 01.06.2016 

SELECT t.ID_client, AVG(t.Sum_payment)
FROM transactions AS t
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY t.ID_client;

# средняя сумма покупок за месяц, 

SELECT t.ID_client, AVG(t.Sum_payment*t.Count_products)
FROM transactions AS t
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY t.ID_client; 

# количество всех операций по клиенту за период

SELECT t.ID_client, COUNT(t.Id_check)
FROM transactions AS t
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY t.ID_client; 

# 2 
# информацию в разрезе месяцев:
# средняя сумма чека в месяц;

SELECT MONTH(t.date_new) AS month , AVG(t.Sum_payment)
FROM transactions AS t
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY month
ORDER BY month;
 
# среднее количество операций в месяц информацию в разрезе месяцев;

WITH monthly_transactions AS (
    SELECT YEAR(date_new) AS year, MONTH(date_new) AS month, COUNT(*) AS transaction_count
    FROM transactions 
    WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
    GROUP BY YEAR(date_new), MONTH(date_new)) 

SELECT year, month, FLOOR(AVG(transaction_count)) AS avg_per_month
FROM monthly_transactions
GROUP BY year, month;

# среднее количество клиентов, которые совершали операции;

WITH monthly_transactions AS (
    SELECT YEAR(date_new) AS year, MONTH(date_new) AS month, COUNT(DISTINCT(ID_client)) AS client_count
    FROM transactions 
    WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
    GROUP BY YEAR(date_new), MONTH(date_new)) 
    
SELECT year, month, FLOOR(AVG(client_count)) AS avg_clients_per_month
FROM monthly_transactions
GROUP BY year, month;

# долю от общего количества операций за год;

WITH total_trans_s AS (
    SELECT COUNT(*) AS count_trans_s
    FROM transactions 
    WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
)
SELECT 
    MONTH(date_new) AS month, 
    ROUND(COUNT(*) * 100.0 / (SELECT count_trans_s FROM total_trans_s), 2) AS t_count_percent
FROM transactions 
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY MONTH(date_new);

# в месяц от общей суммы операций;

WITH tr_sum_amount AS (
    SELECT SUM(Count_products * Sum_payment) AS total_amount
    FROM transactions 
    WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01')

SELECT 
    MONTH(date_new) AS month, 
    ROUND(SUM(Count_products * Sum_payment) * 100.0 / (SELECT total_amount FROM tr_sum_amount), 2) AS sum_payment_percent
FROM transactions 
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY MONTH(date_new);

# вывести % соотношение M/F/NA в каждом месяце с их долей затрат;

SELECT MONTH(t.date_new) AS month, c.gender, COUNT(*) AS t_count,
ROUND(SUM(t.Sum_payment) * 100.0 / (SELECT SUM(Sum_payment) FROM transactions WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'), 2) AS share_percent
FROM transactions AS t
JOIN customers c ON t.ID_client = c.ID_client
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY MONTH(t.date_new), c.gender
ORDER BY month, c.gender;

# возрастные группы клиентов с шагом 10 лет и отдельно клиентов, у которых нет данной информации, 
# с параметрами сумма и количество операций за весь период, и поквартально - средние показатели и %.

SELECT 
    CASE 
        WHEN c.age IS NULL THEN 'No data'
        WHEN c.age BETWEEN 0 AND 9 THEN '0-9'
        WHEN c.age BETWEEN 10 AND 19 THEN '10-19'
        WHEN c.age BETWEEN 20 AND 29 THEN '20-29'
        WHEN c.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN c.age BETWEEN 40 AND 49 THEN '40-49'
        WHEN c.age BETWEEN 50 AND 59 THEN '50-59'
        WHEN c.age BETWEEN 60 AND 69 THEN '60-69'
        WHEN c.age BETWEEN 70 AND 79 THEN '70-79'
        ELSE '80+ лет'
    END AS age_group,
    COUNT(*) AS client_count,
    SUM(t.Sum_payment) AS total_payment,
    COUNT(t.ID_client) AS total_transactions
FROM customers AS c
LEFT JOIN transactions AS t ON c.ID_client = t.ID_client
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY age_group
ORDER BY age_group;



WITH total AS (
    SELECT SUM(Sum_payment) AS total_amount,
    COUNT(*) AS total_tr_ns
    FROM transactions
    WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01')

SELECT 
    YEAR(date_new) AS year,
    QUARTER(date_new) AS quarter,
    AVG(Sum_payment) AS avg_sum,
    ROUND(COUNT(*)/3, 2) AS avg_trans_s,
    ROUND(SUM(Sum_payment) * 100.0 / (SELECT total_amount FROM total), 2) AS sum_percent,
    ROUND(COUNT(*)* 100/(SELECT total_tr_ns FROM total), 2) AS trants_percent
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY year, quarter
ORDER BY year, quarter;