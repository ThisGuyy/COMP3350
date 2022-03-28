-- =============================================
-- Author:		Nathan Murphy
-- Description:	usp_RegisterForCourses.sql
-- Creation SQL for stored procedure to be called by a front end system to register
-- Procedure Flow:
-- *Check if Valid Student Number, If invalid present error and exit.
-- *Create Cursor and begin iteration over CourseOfferingList
-- *Every iteration :
-- *Check if courseid exists in courses, If not RaiseError & continue.
-- *Check if student is already
-- =============================================
DROP PROCEDURE IF EXISTS usp_RegisterForCourses
DROP TYPE IF EXISTS CourseOfferingList
go

CREATE TYPE CourseOfferingList AS TABLE -- Table type for the list of offerings.
(
	courseID INT -- Course ID passed into the procedure.
)
go

--Sample Data
-- @studentNumber ID 2 = Nathan Murphy

CREATE PROCEDURE usp_RegisterForCourses
	@studentNumber INT, 
	@CourseOfferingList AS CourseOfferingList READONLY

AS
BEGIN
	DECLARE @CurrOfferingID VARCHAR(10)
	
	--Checking weather the Student is valid within the Pearson Table.
	-- Check if the count is less then 1 as 0 will be the result ending in error.
	IF (SELECT COUNT(personID) FROM Person WHERE personID = @studentNumber) < 1
		BEGIN
			RAISERROR('Invalid Student Number. Cannot proceed with enrollment.',11,1)
			RETURN -- Exit out of the procedure to provident incorrect data being passed forward.
		END
	ELSE IF (SELECT COUNT(personID) FROM Person WHERE personID = @studentNumber AND isStudent = 1) < 1
		BEGIN
			RAISERROR('Staff member not a student. Cannot proceed with enrollment.',11,1)
			RETURN -- Exit out of the procedure to provident incorrect data being passed forward.
		END
	ELSE
		BEGIN -- Begin iteration over the table of course offerings passed into the procedure.
			DECLARE insert_Cursor CURSOR FOR

			SELECT * -- Populate the cursor with all elements within Course Offering List.
			FROM @CourseOfferingList

			OPEN insert_Cursor -- open cursor.

			FETCH NEXT FROM insert_Cursor INTO @CurrOfferingID -- Get the first record from the table.

			WHILE @@FETCH_STATUS = 0 --Intiate the cursor status.
			
			BEGIN
				BEGIN TRY

					--Used to record the total amount of prerequisite courses for the selected offering
					DECLARE @temp INT

					SELECT @temp = COUNT(*)
					FROM AssumedKnowledge a, CourseOffering co
					WHERE	a.course = co.course
						AND co.offeringID = @CurrOfferingID


					-- Check if the current course offering is a valid course.
					IF (
						SELECT COUNT(offeringID)
						FROM CourseOffering 
						WHERE @CurrOfferingID = offeringID
					) < 1 
						RAISERROR('Invalid Course ID, This Course does not exist as a offered course.',11,1)
					
					-- Check if student already completed the course
					ELSE IF (
						SELECT COUNT(offering) 
						FROM StudentCourseOffering 
						WHERE	offering = @CurrOfferingID 
							AND student = @studentNumber 
							AND isCompleted = 1
					) > 0
						RAISERROR('Student has already completed this course.',16,1)

					-- Check if student is already enrolled in a course.
					ELSE IF (
						SELECT COUNT(offering) 
						FROM StudentCourseOffering 
						WHERE	offering = @CurrOfferingID 
							AND student = @studentNumber
					) > 0
						RAISERROR('Student is already enrolled in this course.',16,1)
					
					
				
					--Check if all prerequisite courses have been completed
					ELSE IF (
						SELECT COUNT(*)
						FROM StudentCourseOffering sc, CourseOffering co
						WHERE	sc.offering = co.offeringID
							AND sc.student = @studentNumber
							AND sc.isCompleted = 1
							AND co.course IN (
								SELECT a.assumedCourse
								FROM AssumedKnowledge a, CourseOffering co
								WHERE	a.course = co.course
									AND co.offeringID = @CurrOfferingID
							)
						) < @temp
						RAISERROR('Student has not completed all prerequisite courses for this course.',16,1)

					ELSE
					-- Insert enrolment record for student in an offering, allocated to today's date.
						INSERT INTO StudentCourseOffering(student, isStudent, offering, dateRegistered, finalMark, finalGrade, isCompleted) 
						VALUES (@studentNumber, 1, @CurrOfferingID, (SELECT GETDATE()), NULL, NULL, 0)
				END TRY
				-- Catch Statement to output any Error messages that happen
				BEGIN CATCH
					--Catch any Errors using the following 
					DECLARE @Message NVARCHAR(250);  
					DECLARE @Severity INT;  
					DECLARE @State INT;  
  
					SELECT   
						@Message = ERROR_MESSAGE(),  
						@Severity = ERROR_SEVERITY(),  
						@State = ERROR_STATE();
					
					RAISERROR(@Message, @Severity, @State);
				END CATCH
			-- Fetch next record.
			FETCH NEXT FROM insert_Cursor INTO @CurrOfferingID
			END
		END
END
go