-- =============================================
-- Author:		Nathan Murphy
-- Description:	test_usp_RegisterForCourses.sql
-- Script for testing the stored prcoedure (usp_RegisterForCourses)
-- =============================================
DECLARE @OfferingsTable TABLE(OfferingID INT)
INSERT INTO @OfferingsTable VALUES(1) -- COMP1140
INSERT INTO @OfferingsTable VALUES(6) -- MATH1220
INSERT INTO @OfferingsTable VALUES(12) -- SENG1120
INSERT INTO @OfferingsTable VALUES(11) -- SENG1110
INSERT INTO @OfferingsTable VALUES(2) -- COMP3350
INSERT INTO @OfferingsTable VALUES(3) -- COMP3851A
INSERT INTO @OfferingsTable VALUES(4) -- COMP3851B

DECLARE @StudentID INT
SET @StudentID = 1 -- Student Jesse Leacathelinais

--Tests that will work.
EXEC usp_RegisterForCourses(@StudentID, @OfferingsTable)
EXEC usp_RegisterForCourses(@StudentID, @OfferingsTable)
EXEC usp_RegisterForCourses(@StudentID, @OfferingsTable)

DELETE FROM @OfferingsTable
INSERT INTO @OfferingsTable VALUES(1) -- COMP1140
INSERT INTO @OfferingsTable VALUES(6) -- MATH1220
INSERT INTO @OfferingsTable VALUES(12) -- SENG1120
INSERT INTO @OfferingsTable VALUES(11) -- SENG1110
INSERT INTO @OfferingsTable VALUES(2) -- COMP3350
INSERT INTO @OfferingsTable VALUES(3) -- COMP3851A
INSERT INTO @OfferingsTable VALUES(4) -- COMP3851B

--Tests that will break.
EXEC usp_RegisterForCourses(@StudentID, @OfferingsTable)
EXEC usp_RegisterForCourses(@StudentID, @OfferingsTable)
EXEC usp_RegisterForCourses(@StudentID, @OfferingsTable)