-- =============================================
-- Author:		Nathan Murphy & Jesse Lecathelinais
-- Description:	tr_timetableclashcheck_5
-- Trigger to Enforce the following Business Rule
-- "There should not be a timetable clash for a student or staff member.
-- =============================================
DROP Trigger tr_timetableclashcheck_5
GO
CREATE TRIGGER tr_timetableclashcheck_5
   ON  StudentCourseOffering
   AFTER INSERT
AS 
BEGIN
--	SET NOCOUNT ON; 

	-- # Attempt 1
	-- Get all offerings from the student ID in studentcourseoffering then check if the timeslot 
	-- assiocated with the offering clashes with any of the other course offerings.
	-- Declare @VarOfferID as INT
	-- Set @VarOfferID =  (Select offering from StudentCourseOffering where student = (select student from inserted ))

	Select offering from StudentCourseOffering where student = (select student from inserted )
	
	-- Get list of Course offering ID's Get the timetableslot information for them.

	-- Compare timeslot info for any clashes
	---------------------------------------------------------------------------------------------------------------------
	-- # Attempt 2
	-- Inserted offerings data from TimetableSlot
	DECLARE @CurDate DATE
	DECLARE @CurStartTime Time(7) 
	DECLARE @CurEndTime Time(7) 

	-- Variables for looping over all exisiting course offerings data.
	DECLARE @CompDate DATE 
	DECLARE @CompStartTime Time(7)
	DECLARE @CompEndTime Time(7)

	DECLARE @TempTable TABLE(comDate DATE, comStartTime TIME(7), comEndTime TIME(7))

	-- Get Current Date Information
	SELECT *



END
GO
