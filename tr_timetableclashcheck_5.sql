-- =============================================
-- Author:		Nathan Murphy
-- Description:	tr_timetableclashcheck_5.sql
-- Test time table clashes trigger.
-- =============================================

INSERT INTO StudentCourseOffering VALUES (1, 1, 3, '2022-01-05', NULL, NULL, 0);
INSERT INTO StudentCourseOffering VALUES (1, 1, 2, '2022-01-05', NULL, NULL, 0);
INSERT INTO StudentCourseOffering VALUES (1, 1, 7, '2020-07-05', 100, 'HD', 1);
INSERT INTO StudentCourseOffering VALUES (1, 1, 8, '2020-01-05', 98, 'HD', 1);
INSERT INTO StudentCourseOffering VALUES (1, 1, 9, '2021-01-05', 81, 'D', 1);
INSERT INTO StudentCourseOffering VALUES (1, 1, 10, '2021-01-05', 96, 'HD', 1);
INSERT INTO StudentCourseOffering VALUES (2, 1, 2, '2022-01-05', NULL, NULL, 0);
INSERT INTO StudentCourseOffering VALUES (2, 1, 3, '2022-01-05', NULL, NULL, 0);
INSERT INTO StudentCourseOffering VALUES (3, 1, 7, '2021-01-05', 90, 'HD', 1);
INSERT INTO StudentCourseOffering VALUES (3, 1, 11, '2020-01-05', 87, 'HD', 1);
INSERT INTO StudentCourseOffering VALUES (3, 1, 12, '2021-07-05', 69, 'C', 1);
INSERT INTO StudentCourseOffering VALUES (5, 1, 5, '2021-07-05', 60, 'P', 1);
INSERT INTO StudentCourseOffering VALUES (6, 1, 3, '2020-01-05', 48, 'F', 1);