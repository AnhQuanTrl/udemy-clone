UPDATE tbl_TEACH SET share=50.00, permission=b'11111111' WHERE instructor_id=2;
UPDATE tbl_TEACH SET share=50.00, permission=b'11111111' WHERE instructor_id=5;

UPDATE tbl_ENROLL set is_archived=TRUE WHERE course_id=9;
DELETE FROM tbl_COURSE WHERE id=9;

INSERT INTO tbl_MESSAGE(from_id, to_id, content) VALUES (9, 10, 'abc');

INSERT INTO tbl_ANSWER(question_id, user_id, content) VALUES (1, 7, 'ABC');