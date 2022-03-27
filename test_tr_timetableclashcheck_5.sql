--	==============================================================
--	Author: Jesse Lecathelinais
--	Description: test_tr_timetableclashcheck_5.sql
--	Data to test that no timetable clashes occur for staff or students
--	==============================================================

--Shouldn't work for TimetableSlot (Staff clash)
INSERT INTO TimetableSlot VALUES (15, 11, 1, 5, 1, '2022-02-25', '10:00:00', '12:00:00', 2);
INSERT INTO TimetableSlot VALUES (16, 11, 1, 4, 1, '2022-02-25', '8:00:00', '10:00:00', 3);
INSERT INTO TimetableSlot VALUES (17, 1, 4, 6, 1, '2022-02-24', '11:00:00', '12:00:00', 3);
INSERT INTO TimetableSlot VALUES (18, 2, 8, 4, 1, '2022-02-25', '10:00:00', '12:00:00', 1);
INSERT INTO TimetableSlot VALUES (19, 9, 8, 4, 1, '2022-02-22', '14:00:00', '16:00:00', 2);
INSERT INTO TimetableSlot VALUES (20, 4, 10, 4, 1, '2022-02-25', '08:00:00', '10:00:00', 1);

--Should work for TimetableSlot (Staff doesn't clash)
INSERT INTO TimetableSlot VALUES (21, 4, 10, 4, 1, '2022-02-24', '14:00:00', '16:00:00', 2);

--Shouldn't work for StudentTimetableSlot (Student clash)
INSERT INTO StudentTimetableSlot VALUES (1, 10, 14);

--Should work for StudentTimetableSlot (Student doesn't clash)
INSERT INTO StudentTimetableSlot VALUES (6, 4, 8);
INSERT INTO StudentTimetableSlot VALUES (6, 4, 9);