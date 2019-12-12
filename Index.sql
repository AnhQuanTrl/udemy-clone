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