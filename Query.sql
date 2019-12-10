USE DBS_Assignment;






-- 																QUERIES FROM (AT LEAST) 2 TABLES
-- Liet ke nhung Course thuoc Topic co topic = "Python" va topic = "C++" $$$
SELECT *
FROM tbl_COURSE C
WHERE EXISTS(SELECT * FROM tbl_COURSE_TOPIC T WHERE C.id=T.course_id AND T.topic='Python') AND EXISTS(SELECT * FROM tbl_COURSE_TOPIC T WHERE C.id=T.course_id AND T.topic='C++');


-- Liet ke toan bo category,subcategory tuong ung $$$
SELECT C.name, S.name
FROM tbl_CATEGORY C, tbl_SUBCATEGORY S
WHERE C.id=S.category_id;



-- Liet ke toan bo course nam trong subcategory 'Web Development' va co topic la 'C++' $$$
SELECT C.id, C.main_title
FROM tbl_SUBCATEGORY S, tbl_COURSE C, tbl_COURSE_TOPIC T
WHERE S.name='Web Development' AND C.sub_category_id=S.ID AND T.topic='C++' and T.course_id=C.id;

-- Liet ke nhung Student da Enroll vao Course co main_title = "Learn Ethical Hacking From Scratch"
SELECT tu.*
FROM tbl_USER AS tu, tbl_ENROLL AS te, tbl_COURSE AS tc
WHERE tu.student_flag = TRUE AND te.user_id = tu.id AND te.course_id = tc.id AND tc.main_title = "Learn Ethical Hacking From Scratch";

-- Liet ke nhung Question duoc hoi boi User co first_name = "Quan", last_name = "DB" va duoc hoi trong Course co main_title = "The Web Development Bootcamp"
SELECT tq.*
FROM tbl_QUESTION AS tq, tbl_USER AS tu, tbl_COURSE AS tc
WHERE tq.student_id = tu.id AND tq.course_id = tc.id;

-- Liet ke nhung announcement co trong toan bo khoa hoc enroll boi user co id la 2 va ten cua giang vien thong bao $$$
SELECT A.id, A.content, A.created_date, A.course_id, U.first_name, U.last_name
FROM tbl_ANNOUNCEMENT A, tbl_ENROLL E, tbl_USER U
WHERE E.user_id=2 AND A.course_id=E.course_id AND U.id=A.instructor_id;

-- Liet ke nhung Topic duoc day boi cac Instructor co first_name = "Thanh" va last_name = "Vo Khac"
SELECT *
FROM tbl_COURSE_TOPIC
WHERE course_id IN (
	SELECT tc.id 
	FROM tbl_COURSE AS tc, tbl_USER AS tu, tbl_TEACH AS tt
	WHERE tu.first_name = "Thanh" AND tu.last_name = "Vo Khac" AND tt.course_id = tc.id AND tt.instructor_id = tu.id
);
-- Liet ke nhung user da dang ky course cua instructor co id la 1 va thoi gian dang ky $$$
SELECT u.id, u.first_name, u.last_name, c.id, e.enroll_date 
FROM tbl_ENROLL e
JOIN tbl_USER u ON e.user_id = u.id 
JOIN tbl_COURSE c ON e.course_id = c.id 
WHERE c.owner_id=9
GROUP BY first_name 
ORDER BY enroll_date;

-- Hien thi outline cua khoa hoc co id la 1 (outline la toan bo section va item) $$$
SELECT I.course_id, I.item_id, C.section_id
FROM tbl_ITEM AS I
LEFT JOIN tbl_COMPOSE AS C
ON I.item_id=C.item_id AND I.course_id=C.course_id_item
WHERE I.course_id=1
UNION 
SELECT S.course_id, C.item_id, S.section_id
FROM tbl_COMPOSE AS C
RIGHT JOIN tbl_SECTION AS S
ON C.course_id_section=S.course_id AND C.section_id=S.section_id
WHERE S.course_id=1;
-- Liet ke so luong item da duoc finish trong tung course enroll boi user co id la 2 $$$
SELECT I.course_id, COUNT(*)
FROM tbl_FINISH F , tbl_ITEM I, tbl_ENROLL E
WHERE E.user_id=2 AND I.course_id=E.course_id AND F.item_id=I.item_id AND F.course_id=I.course_id
GROUP BY I.course_id;
-- Hien thi muc Q-A cua lecture co id 2 trong khoa hoc co id la 10 $$$
SELECT q.id AS question_id, U1.email as question_email, q.content, q.created_date AS question_created_date, a.id AS answer_id, U2.email AS answer_email, a.content, a.created_date AS answer_created_date
FROM tbl_LECTURE AS l, tbl_CONTEXT AS c, tbl_USER AS U1, tbl_QUESTION AS q
LEFT JOIN tbl_ANSWER AS a
ON q.id=a.question_id
LEFT JOIN tbl_USER AS U2
ON U2.id=a.user_id
WHERE l.item_id=2 AND l.course_id=1 AND c.item_id=l.item_id AND q.id=c.question_id AND U1.id=q.student_id 
ORDER BY q.id, q.created_date;
-- 																	NESTED QUERIES
# select content message from user 'cuong' to user 'quan'
SELECT id, content 
FROM tbl_MESSAGE 
WHERE 
from_id in (SELECT id FROM tbl_USER WHERE email = 'cuong@udemy.com') 
AND 
to_id in (SELECT id FROM tbl_USER WHERE email = 'quan@udemy.com');

# select lecture's name in course 'Learn Database System' 
SELECT name 
FROM tbl_LECTURE
WHERE item_id IN 
(SELECT item_id FROM tbl_COMPOSE WHERE course_id_item IN 
	(SELECT id AS course_id_item FROM tbl_COURSE WHERE main_title = 'Learn Database System')
);

-- Liet ke nhung Course thuoc mot trong 2 Subcategory co name = "Web Developer" va "Programming Languages"
SELECT * FROM tbl_COURSE WHERE sub_category_id IN (
	SELECT id FROM tbl_SUBCATEGORY WHERE name  = "Web Developer" OR name = "Programming Languages"
);

-- Liet ke nhung Course thuoc Category co name = "Development"
SELECT * FROM tbl_COURSE WHERE sub_category_id IN (
	SELECT id FROM tbl_SUBCATEGORY WHERE category_id IN (
		SELECT id FROM tbl_CATEGORY WHERE name = "Development"
	)
);

-- Liet ke nhung Announcement duoc thong bao boi Instructor co email = "vuongcuong@gmail.com" trong Course co main_title = "The Web Developer Bootcamp"
SELECT * FROM tbl_ANNOUNCEMENT 
WHERE
instructor_id IN (SELECT id FROM tbl_USER WHERE email = "vuongcuong@gmail.com")
AND 
course_id IN (SELECT id FROM tbl_COURSE WHERE main_title = "The Web Developer Bootcamp");

-- 																	AGGREATE QUERY

-- Liet ke 10 course co rating cao nhat sap xep theo rating 
SELECT c.id, AVG(rating) as average_rating
FROM tbl_COURSE c, tbl_ENROLL e
WHERE c.id = e.course_id
GROUP BY c.id
ORDER BY average_rating
LIMIT 10;

-- Liet ke 10 topic thinh hanh nhat trong 1 subcategory "Math" sap xep theo do thinh hanh
SELECT t.topic, COUNT(*) AS popularity
FROM tbl_COURSE_TOPIC t, tbl_ENROLL e
WHERE t.course_id = e.course_id AND t.course_id IN (SELECT c.id FROM tbl_COURSE c, tbl_SUBCATEGORY s WHERE c.sub_category_id = s.id AND c.name="Math")
GROUP BY t.topic
ORDER BY popularity
LIMIT 10;

-- find the total number of distinct course student in each category $$$
SELECT cate.name, COUNT(DISTINCT e.user_id)
FROM tbl_COURSE c, tbl_SUBCATEGORY s, tbl_ENROLL e, tbl_CATEGORY cate
WHERE s.category_id=cate.id AND c.sub_category_id=s.id AND e.course_id=c.id
GROUP BY cate.name;

-- Tim tong thoi gian duration cua toan bo course trong subcategory 'Web Development'
