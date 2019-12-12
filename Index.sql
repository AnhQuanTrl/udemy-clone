EXPLAIN SELECT tu.*
FROM tbl_USER AS tu, tbl_TEACH AS tt, tbl_COURSE AS tc
WHERE
	tc.main_title = "The Web Developer Bootcamp"
	AND tt.course_id = tc.id
	AND tu.id = tt.instructor_id;
CREATE INDEX mt ON tbl_COURSE(main_title);
EXPLAIN SELECT tu.*
FROM tbl_USER AS tu, tbl_TEACH AS tt, tbl_COURSE AS tc
WHERE
	tc.main_title = "The Web Developer Bootcamp"
	AND tt.course_id = tc.id
	AND tu.id = tt.instructor_id;
    
EXPLAIN SELECT tq.*
FROM tbl_QUESTION AS tq, tbl_USER AS tu, tbl_COURSE AS tc
WHERE 
	tq.student_id = tu.id 
	AND tu.first_name = "Lam" 
	AND tu.last_name = "DH" 
	AND tq.course_id = tc.id 
	AND tc.main_title = "The Web Developer Bootcamp";
CREATE INDEX uname ON tbl_USER(last_name, first_name);
