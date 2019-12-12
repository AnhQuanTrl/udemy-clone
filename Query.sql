USE DBS_Assignment;

-- 																QUERIES FROM (AT LEAST) 2 TABLES
-- Liet ke nhung COURSE thuoc TOPIC co topic = "HTML" va topic = "CSS" 													$$$ (1)
EXPLAIN SELECT *
FROM tbl_COURSE AS tc
WHERE 
	EXISTS(
		SELECT * FROM tbl_COURSE_TOPIC AS tct WHERE tct.course_id=tc.id AND tct.topic = 'HTML'
	) 
	AND 
	EXISTS(
		SELECT * FROM tbl_COURSE_TOPIC AS tct WHERE tct.course_id=tc.id AND tct.topic = 'CSS'
	);

-- Liet ke toan bo CATEGORY, SUBCATEGORY tuong ung 																		$$$ (2)
SELECT tc.name AS "Category's Name", ts.name AS "Subcategory's Name"
FROM tbl_CATEGORY AS tc, tbl_SUBCATEGORY AS ts
WHERE tc.id = ts.category_id;

-- Liet ke toan bo COURSE nam trong SUBCATEGORY co name = 'Web Development' va co TOPIC la 'CSS' 						$$$ (3)
EXPLAIN SELECT tc.id, tc.main_title
FROM tbl_SUBCATEGORY AS ts, tbl_COURSE AS tc, tbl_COURSE_TOPIC AS tct
WHERE 
	ts.name = 'Web Development'
	AND tc.sub_category_id = ts.ID 
	AND tct.topic = 'CSS' 
	AND tct.course_id = tc.id;

-- Liet ke toan bo COURSE ma STUDENT co id = 6 da ENROLL vao (MY COURSE)												$$$ (4)
SELECT tc.*, tu.id AS "owner_id", tu.first_name AS "owner_first_name", tu.last_name AS "owner_last_name"
FROM tbl_COURSE AS tc, tbl_ENROLL AS te, tbl_USER AS tu
WHERE 
	te.user_id = 6
	AND tc.id = te.course_id
	AND tu.id = tc.owner_id;

-- Liet ke toan bo COURSE da duoc them vao SHOPPING_CART cua USER co id = 6												$$$ (5)
SELECT tc.*
FROM tbl_COURSE AS tc, tbl_SHOPPING_CART AS tsc, tbl_SHOPPING_CART_COURSE AS tscc, tbl_USER AS tu
WHERE 
	tu.id = 6
	AND tsc.user_id = tu.id
	AND tscc.shopping_cart_id = tsc.id
	AND tc.id = tscc.course_id;

-- Liet ke nhung thong tin can thiet cua nhung REVIEW co rating = 5 trong COURSE co id = 1								$$$ (6)
SELECT te.comment, tu.first_name, tu.last_name
FROM tbl_ENROLL AS te, tbl_USER AS tu
WHERE 
	te.course_id = 1
	AND te.rating = 5
	AND tu.id = te.user_id;
	
-- Liet ke nhung INSTRUCTOR ma TEACH COURSE co main_title = "The Web Developer Bootcamp"								$$$ (7)
SELECT tu.*
FROM tbl_USER AS tu, tbl_TEACH AS tt, tbl_COURSE AS tc
WHERE
	tc.main_title = "The Web Developer Bootcamp"
	AND tt.course_id = tc.id
	AND tu.id = tt.instructor_id;

-- Liet ke nhung STUDENT da ENROLL vao COURSE 
-- co main_title = "Complete Python Bootcamp: Go from zero to hero in Python 3" 										$$$ (8)
SELECT tu.*
FROM tbl_USER AS tu, tbl_ENROLL AS te, tbl_COURSE AS tc
WHERE 
	te.user_id = tu.id 
	AND te.course_id = tc.id 
	AND tc.main_title = "Complete Python Bootcamp: Go from zero to hero in Python 3";

-- Liet ke nhung QUESTION duoc hoi boi USER co first_name = "Lam", last_name = "DH" 
-- va duoc hoi trong COURSE co main_title = "The Web Developer Bootcamp" 												$$$ (9)
CREATE INDEX uname ON tbl_USER(last_name, first_name);
EXPLAIN SELECT tq.*
FROM tbl_QUESTION AS tq, tbl_USER AS tu, tbl_COURSE AS tc
WHERE 
	tq.student_id = tu.id 
	AND tu.first_name = "Lam" 
	AND tu.last_name = "DH" 
	AND tq.course_id = tc.id 
	AND tc.main_title = "The Web Developer Bootcamp";

-- Liet ke nhung ANNOUNCEMENT co trong toan bo khoa hoc duoc ENROLL boi USER co id = 7
-- va name cua INSTRUCTOR da thong bao 																					$$$ (10) 
SELECT A.id, A.content, A.created_date, A.course_id, U.first_name, U.last_name
FROM tbl_ANNOUNCEMENT A, tbl_ENROLL E, tbl_USER U
WHERE 
	E.user_id = 7
	AND A.course_id = E.course_id 
	AND U.id = A.instructor_id;

-- 																	QUERIES FROM (AT LEAST) 3 TABLES
-- Liet ke nhung TOPIC duoc day boi cac INSTRUCTOR co first_name = "Vuong" va last_name = "Cuong"						$$$ (1)
SELECT *
FROM tbl_COURSE_TOPIC
WHERE course_id IN (
	SELECT tt.id
	FROM tbl_USER AS tu, tbl_TEACH AS tt
	WHERE 
		tu.first_name = "Cuong" 
		AND tu.last_name = "Vuong" 
		AND tt.instructor_id = tu.id
);

-- Liet ke nhung USER da dang ky COURSE cua INSTRUCTOR co id = 1 va thoi gian dang ky (enroll_date) 					$$$ (2)
SELECT u.id, u.first_name, u.last_name, c.id, e.enroll_date 
FROM tbl_ENROLL AS e
JOIN tbl_USER AS u ON e.user_id = u.id 
JOIN tbl_COURSE AS c ON e.course_id = c.id 
WHERE c.owner_id = 1
GROUP BY first_name 
ORDER BY enroll_date;

-- Hien thi outline cua COURSE co id = 1 (outline la toan bo SECTION va ITEM) 											$$$ (3)
SELECT I.course_id, I.item_id, C.section_id
FROM tbl_ITEM AS I
LEFT JOIN tbl_COMPOSE AS C
ON I.item_id = C.item_id AND I.course_id = C.course_id_item
WHERE I.course_id = 1
UNION 
SELECT S.course_id, C.item_id, S.section_id
FROM tbl_COMPOSE AS C
RIGHT JOIN tbl_SECTION AS S
ON C.course_id_section = S.course_id AND C.section_id = S.section_id
WHERE S.course_id = 1;

-- Liet ke so luong ITEM da duoc FINISH trong tung COURSE duoc ENROLL boi USER co id = 6								$$$ (4)
SELECT I.item_id, COUNT(*)
FROM tbl_FINISH F , tbl_ITEM I, tbl_ENROLL E
WHERE E.user_id = 6 AND E.user_id=F.user_id AND I.course_id = E.course_id AND F.item_id = I.item_id AND F.course_id = I.course_id
GROUP BY I.course_id;

-- Hien thi muc QUESTION-ANSWER cua LECTURE co id = 2 trong COURSE co id = 10 											$$$ (5)
SELECT q.id AS question_id, U1.email as question_email, q.content, q.created_date AS question_created_date, a.id AS answer_id, U2.email AS answer_email, a.content, a.created_date AS answer_created_date
FROM tbl_LECTURE AS l, tbl_CONTEXT AS c, tbl_USER AS U1, tbl_QUESTION AS q
LEFT JOIN tbl_ANSWER AS a
ON q.id=a.question_id
LEFT JOIN tbl_USER AS U2
ON U2.id=a.user_id
WHERE l.item_id=2 AND l.course_id=1 AND c.item_id=l.item_id AND q.id=c.question_id AND U1.id=q.student_id 
ORDER BY q.id, q.created_date;

-- 																	NESTED QUERIES
# Liet ke nhung MESSAGE gui tu USER co email = "tri.dang@gmail.com" toi USER co email = "lam.daihiep@gmail.com"			$$$ (1)
SELECT id, content 
FROM tbl_MESSAGE 
WHERE 
	from_id in (SELECT id FROM tbl_USER WHERE email = 'tri.dang@gmail.com') 
	AND 
	to_id in (SELECT id FROM tbl_USER WHERE email = 'lam.daihiep@gmail.com');

# Liet ke toan bo Lecture thuoc COURSE co main_title = "The Web Developer Bootcamp"										$$$ (2)
SELECT ti.* 
FROM tbl_LECTURE AS tl, tbl_ITEM AS ti
WHERE 
	tl.item_id = ti.item_id
	AND tl.item_id IN (
		SELECT item_id FROM tbl_ITEM WHERE course_id IN (
			SELECT id FROM tbl_COURSE WHERE main_title = "The Web Developer Bootcamp"
			)
		);

-- Liet ke nhung COURSE thuoc mot trong 2 SUBCATEGORY co name = "Web Developer" va "Programming Language"				$$$ (3)
SELECT * FROM tbl_COURSE WHERE sub_category_id IN (
	SELECT id FROM tbl_SUBCATEGORY WHERE name  = "Web Development" OR name = "Programming Language"
);

-- Liet ke nhung COURSE thuoc CATEGORY co name = "Development"															$$$ (4)
SELECT * FROM tbl_COURSE WHERE sub_category_id IN (
	SELECT id FROM tbl_SUBCATEGORY WHERE category_id IN (
		SELECT id FROM tbl_CATEGORY WHERE name = "Development"
	)
);

-- Liet ke nhung ANNOUNCEMENT duoc thong bao boi INSTRUCTOR co email = "vuongcuong@gmail.com" 
-- trong COURSE co main_title = "The Web Developer Bootcamp"															$$$ (5)
SELECT * FROM tbl_ANNOUNCEMENT 
WHERE
	instructor_id IN (SELECT id FROM tbl_USER WHERE email = "vuongcuong@gmail.com")
	AND 
	course_id IN (SELECT id FROM tbl_COURSE WHERE main_title = "The Web Developer Bootcamp");

-- 																	AGGREATE QUERY

-- Liet ke 10 COURSE co rating cao nhat sap xep theo rating 															$$$ (1)
SELECT c.id, AVG(rating) as average_rating
FROM tbl_COURSE c, tbl_ENROLL e
WHERE c.id = e.course_id
GROUP BY c.id
ORDER BY average_rating
LIMIT 10;

-- Liet ke 10 TOPIC thinh hanh nhat trong 1 SUBCATEGORY "Web Development" sap xep theo do thinh hanh					$$$ (2)
SELECT t.topic, COUNT(*) AS popularity
FROM tbl_COURSE_TOPIC t, tbl_ENROLL e
WHERE 
	t.course_id = e.course_id 
	AND t.course_id IN (
		SELECT c.id FROM tbl_COURSE c, tbl_SUBCATEGORY s WHERE c.sub_category_id = s.id AND s.name="Web Development"
	)
GROUP BY t.topic
ORDER BY popularity
LIMIT 10;


-- Lay so luong STUDENT da ENROLL vao cac COURSE thuoc cac CATEGORY tuong ung 											$$$ (3)
SELECT cate.name, COUNT(DISTINCT e.user_id)
FROM tbl_COURSE c, tbl_SUBCATEGORY s, tbl_ENROLL e, tbl_CATEGORY cate
WHERE 
	s.category_id=cate.id 
	AND c.sub_category_id=s.id 
	AND e.course_id=c.id
GROUP BY cate.name;

-- Tinh tong thoi gian DURATION cua tung COURSE nam trong SUBCATEGORY co name = "Finance"								$$$ (4)												$$$ (4)
SELECT tc.id, tc.main_title, SUM(tv.duration)
FROM tbl_VIDEO AS tv, tbl_COURSE AS tc, tbl_SUBCATEGORY AS ts
WHERE 
	ts.name = "Finance"
	AND tc.sub_category_id = ts.id
	AND tv.course_id = tc.id
GROUP BY tc.id;

-- Tinh tong price cua cac SHOPPING_CART_COURSE co trong tung SHOPPING_CART cua USER co id = 7							$$$ (5)
SELECT tsc.id, SUM(tc.price)
FROM tbl_COURSE AS tc, tbl_SHOPPING_CART_COURSE AS tscc, tbl_SHOPPING_CART AS tsc
WHERE 
	tsc.user_id = 7
	AND tscc.shopping_cart_id = tsc.id
	AND tc.id = tscc.course_id
GROUP BY tsc.id;
