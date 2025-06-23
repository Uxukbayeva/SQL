#1. Выведите сколько пользователей добавили книгу 'Coraline', сколько пользователей прослушало больше 10%. 

SELECT count (ac.user_id)  
FROM audio_cards ac
JOIN audiobooks ab
ON ac.audiobook_uuid = ab.uuid
WHERE ab.title = 'Coraline';

SELECT count (ac.user_id)
FROM audio_cards ac
JOIN audiobooks ab
ON ac.audiobook_uuid = ab.uuid
WHERE title = 'Coraline' AND ac.progress > (ab.duration * 10 / 100); 

# 2. По каждой операционной системе и названию книги выведите количество пользователей, 
сумму прослушивания в часах, не учитывая тестовые прослушивания. IOS B IPHONE соединить

SELECT 
    CASE 
        WHEN ls.os_name IN ('iOS', 'iPhoneOS') THEN 'iOS'
        ELSE ls.os_name
        END AS os_name_group, ab.title, COUNT(ls.user_id) AS total,
		SUM(EXTRACT(HOUR FROM (ls.finished_at - ls.started_at))) AS listening_hours 
    FROM listenings ls
	JOIN audiobooks ab
	ON ls.audiobook_uuid = ab.uuid
WHERE ls.is_test = 0
GROUP BY os_name_group, ab.title
ORDER BY os_name_group;

# 3. Найдите книгу, которую слушает больше всего людей. 

SELECT  COUNT(ls.user_id),  ab.title, 
SUM(EXTRACT(HOUR FROM (ls.finished_at - ls.started_at))) AS listening_hours  
FROM listenings ls
JOIN audiobooks ab
ON ls.audiobook_uuid = ab.uuid
GROUP BY  ab.title
ORDER BY COUNT (user_id) DESC
LIMIT 1;


# 4 Найдите книгу, которую чаще всего дослушивают до конца.

SELECT COUNT(ls.user_id), ab.title
FROM listenings ls
JOIN audiobooks ab
ON ls.audiobook_uuid = ab.uuid
WHERE ls.position_to = ab. duration
GROUP BY  ab.title
ORDER BY COUNT (user_id) DESC
LIMIT 1;








