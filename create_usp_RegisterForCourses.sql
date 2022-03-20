-- =============================================
-- Author:		Nathan Murphy
-- Description:	usp_RegisterForCourses.sql
-- Creation SQL for stored procedure to be called by a front end system to register
-- =============================================

CREATE TYPE CourseOfferingList AS TABLE -- Table type for the list of offerings.
(
	courseID INT -- Course ID passed into the procedure.
)
GO

CREATE PROCEDURE usp_RegisterForCourses
	@studentNumber INT,
	@CourseOfferingList AS CourseOfferingList READONLY

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @OfferingID VARCHAR(10)

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>

	DECLARE insert_Cursor CURSOR FOR

	SELECT *
	FROM @CourseOfferingList

	OPEN insert_Cursor

	FETCH NEXT FROM insert_Cursor INTO @OfferingID

	WHILE @@FETCH_STATUS = 0

	BEGIN

		INSERT INTO StudentCourseOffering(student, isStudent, offering, dateRegistered, finalMark, finalGrade, isCompleted) 
		VALUES (@studentNumber, 1, @OfferingID, (SELECT GETDATE()), NULL, NULL, 0)
		
	END
END
GO
