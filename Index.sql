alter table tbl_announcement add index (created_date);
select content from tbl_announcement where instructor_id in (select id from tbl_user where email = 'tri.dang@gmail.com') and created_date = '2019-12-12 10:07:47';
alter table tbl_course_topic add index (topic);