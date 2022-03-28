--	==============================================================
--	Author: Jesse Lecathelinais
--	Description: create_tr_timetableclashcheck.sql
--	Enforces no student or staff member has any timetable clashes
--	==============================================================

DROP TRIGGER IF EXISTS timetableClashCheckStaff
DROP TRIGGER IF EXISTS timetableClashCheckStudent
go



CREATE TRIGGER timetableClashCheckStudent		--	Trigger name
ON StudentTimetableSlot						--	Table name
FOR INSERT, UPDATE						--	Actions when trigger is executed
AS
BEGIN
	--	Check if the Business Rule is violated
	--	If violated, print an error message
	--	Cancel (rollback) the transaction

	DECLARE studentCursor CURSOR			--	Cursor for timetableclashcheck trigger for students
	FOR
	SELECT	slotID, student, date, startTime, endTime
	FROM	TimetableSlot ts, StudentTimetableSlot sts
	WHERE	ts.slotID = sts.slot
	FOR READ ONLY

	DECLARE @slot		INT
	DECLARE @student	INT
	DECLARE @date		DATE
	DECLARE @startTime	TIME
	DECLARE @endTime	TIME
	
	DECLARE @finalCount	INT
	SET		@finalCount = 0
	DECLARE	@currCount	INT
	SET		@currCount = 0

	OPEN studentCursor
	FETCH NEXT FROM studentCursor INTO @slot, @student, @date, @startTime, @endTime

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		--	Find any overlapping time slots
		SELECT @currCount = COUNT(*)
		FROM	Inserted i,				--The timetable slot data that is to be inserted
				TimetableSlot ts,
				PhysicalOffering po,
				CourseOffering c,
				StudentCourseOffering sc,
				Period pe
		WHERE	i.slot = ts.slotID
			AND i.slot != @slot
			AND i.offering = ts.offering
			AND ts.offering = po.offeringID		--	Check offering's all connected
			AND	po.offeringID = c.offeringID
			AND	sc.offering = c.offeringID
			AND i.student = sc.student
			AND i.student = @student
			AND c.period = pe.periodID
			AND ts.date = @date
			AND (			-- Timetable clash check section
					(ts.startTime >= @startTime AND ts.startTime < @endTime)
				OR	(ts.endTime > @startTime AND ts.endTime <= @endTime)
				)

		--Update final counter
		IF @currCount > @finalCount	
		BEGIN
			SET @finalCount = @currCount
		END

		FETCH NEXT FROM studentCursor INTO @slot, @student, @date, @startTime, @endTime
	END

	DEALLOCATE studentCursor

	IF @finalCount > 0
	BEGIN
		RAISERROR('Time table clash encountered for a student. The command is terminated', 11, 1)
		ROLLBACK TRANSACTION
	END

END
go

CREATE TRIGGER timetableClashCheckStaff	--	Trigger to prevent staff timetable clashes
ON TimetableSlot						--	Table name
FOR INSERT, UPDATE						--	Actions when trigger is executed
AS
BEGIN
	--	Check if the Business Rule is violated
	--	If violated, print an error message
	--	Cancel (rollback) the transaction

	DECLARE staffCursor CURSOR			--	Cursor for timetableclashcheck trigger
	FOR
	SELECT	slotID, staff, date, startTime, endTime
	FROM	TimetableSlot
	FOR READ ONLY

	DECLARE	@slot		INT
	DECLARE	@staff		INT
	DECLARE @date		DATE
	DECLARE @startTime	TIME
	DECLARE @endTime	TIME

	DECLARE @finalCount	INT
	SET		@finalCount = 0
	DECLARE	@currCount	INT
	SET		@currCount = 0

	OPEN staffCursor
	FETCH NEXT FROM staffCursor INTO @slot, @staff, @date, @startTime, @endTime

	WHILE @@FETCH_STATUS = 0
	BEGIN

		--	Find any overlapping time slots
		SELECT @currCount = COUNT(*)
		FROM	Inserted i,				--The timetable slot data that is to be inserted
				PhysicalOffering po,
				CourseOffering c,
				StudentCourseOffering sc,
				Period pe
		WHERE	i.offering = po.offeringID		--	Check offering's all connected
			AND	po.offeringID = c.offeringID
			AND	sc.offering = c.offeringID
			AND c.period = pe.periodID
			AND i.staff = @staff
			AND i.slotID != @slot
			AND i.date = @date
			AND (			-- Timetable clash check section
					(i.startTime >= @startTime AND i.startTime < @endTime)
				OR	(i.endTime > @startTime AND i.endTime <= @endTime)
				)
		
		IF @currCount > @finalCount
		BEGIN
			SET @finalCount = @currCount
		END

		FETCH NEXT FROM staffCursor INTO  @slot, @staff, @date, @startTime, @endTime
	END

	DEALLOCATE staffCursor

	IF @finalCount > 0
	BEGIN
		RAISERROR('Time table clash encountered of a staff member. The command is terminated', 11, 1)
		ROLLBACK TRANSACTION
	END

END
go