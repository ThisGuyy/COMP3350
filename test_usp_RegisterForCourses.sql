-- =============================================
-- Author:		Nathan Murphy
-- Description:	test_usp_RegisterForCourses.sql
-- Script for testing the stored prcoedure (usp_RegisterForCourses)
-- =============================================
SET NOCOUNT ON;
DECLARE @StudentID INT
DECLARE @OfferingsTable CourseOfferingList;

SET @StudentID = 2--  Valid Student Nathan Murphy

--DELETE FROM StudentCourseOffering

INSERT INTO @OfferingsTable VALUES(1) -- COMP1140
INSERT INTO @OfferingsTable VALUES(1) -- COMP1140
INSERT INTO @OfferingsTable VALUES(20) -- Not a valid Course
INSERT INTO @OfferingsTable VALUES(2) -- SENG1110
INSERT INTO @OfferingsTable VALUES(3) -- COMP3851A

SET NOCOUNT OFF;

PRINT('First Exec')
EXEC usp_RegisterForCourses @StudentID, @OfferingsTable --

SET @StudentID = 200 -- Invalid Student

PRINT(' ')
PRINT('Second Exec')
EXEC usp_RegisterForCourses @StudentID, @OfferingsTable

