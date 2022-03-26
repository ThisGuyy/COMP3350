--	==============================================================
--	Author: Jesse Lecathelinais
--	Description: createDB.sql
--	Creates the database for UniversityX
--	==============================================================

--Drops all tables so they can be created again
DROP TABLE IF EXISTS ProgramEnrolment
DROP TABLE IF EXISTS StudentEnrolment
DROP TABLE IF EXISTS StudentTimetableSlot
DROP TABLE IF EXISTS TimetableSlot
DROP TABLE IF EXISTS ReasonType
DROP TABLE IF EXISTS PhysicalOffering
DROP TABLE IF EXISTS StudentCourseOffering
DROP TABLE IF EXISTS CourseOffering
DROP TABLE IF EXISTS Period
DROP TABLE IF EXISTS Facility
DROP TABLE IF EXISTS FacilityType
DROP TABLE IF EXISTS PhysicalCampus
DROP TABLE IF EXISTS Campus
DROP TABLE IF EXISTS AssignmentMajor
DROP TABLE IF EXISTS ProgramMajorMinor
DROP TABLE IF EXISTS ProgramStaff
DROP TABLE IF EXISTS OrganisationStaff
DROP TABLE IF EXISTS AcademicStaff
DROP TABLE IF EXISTS Person
DROP TABLE IF EXISTS ProgramCourse
DROP TABLE IF EXISTS Program
DROP TABLE IF EXISTS AssumedKnowledge
DROP TABLE IF EXISTS Course
DROP TABLE IF EXISTS MajorMinor
DROP TABLE IF EXISTS AssignmentType
DROP TABLE IF EXISTS SubOrganisationUnit
DROP TABLE IF EXISTS OrganisationUnit
go

	---		Organisation Unit Data		---

CREATE TABLE OrganisationUnit(
	unitCode	VARCHAR(8)		PRIMARY KEY,	--Code to identify the organisation unit
	unitName	VARCHAR(50)		NOT NULL,		--Name of the organisation unit
	description	VARCHAR(200)	NOT NULL,		--Description of the organisation unit
	contactNo	VARCHAR(10)		NOT NULL,		--The contact number of the organisation unit
	UNIQUE(unitName),
);

INSERT INTO OrganisationUnit VALUES ('OU000001', 'Academic Division', 'A division for academics', '11111111');
INSERT INTO OrganisationUnit VALUES ('OU000002', 'Research Division', 'A division for research', '10101010');
INSERT INTO OrganisationUnit VALUES ('OU000003', 'College of Science and Engineering', 'Learn about the sciences and engineering in this college', '10293847');
INSERT INTO OrganisationUnit VALUES ('OU000004', 'College of Business and Law', 'Learn about the business and law in this college', '10010010');
INSERT INTO OrganisationUnit VALUES ('OU000005', 'School of Engineering', 'Learn about engineering in this school', '1029384756');
INSERT INTO OrganisationUnit VALUES ('OU000006', 'School of Business', 'Learn about business in this school', '1001001010');
INSERT INTO OrganisationUnit VALUES ('OU000007', 'School of Science', 'Learn about science in this school', '1029384712');
INSERT INTO OrganisationUnit VALUES ('OU000008', 'School of Mathematics', 'Learn about math', '66655511');
go

	---		Sub-Organisation Unit Data		---

CREATE TABLE SubOrganisationUnit(
	oUnit		VARCHAR(8)	NOT NULL,		--The main organisation unit
	subOUnit	VARCHAR(8)	NOT NULL,		--The sub organisation unit of oUnit
	PRIMARY KEY(oUnit, subOUnit),
	CHECK(oUnit != subOUnit),			--Make sure that an organisation unit can't be its own sub orgnisation unit
	FOREIGN KEY(oUnit) REFERENCES OrganisationUnit(unitCode)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(subOUnit) REFERENCES OrganisationUnit(unitCode)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO SubOrganisationUnit VALUES ('OU000003', 'OU000005');
INSERT INTO SubOrganisationUnit VALUES ('OU000004', 'OU000006');
INSERT INTO SubOrganisationUnit VALUES ('OU000003', 'OU000007');
go

	---		Type of assignment Data		---

CREATE TABLE AssignmentType(
	typeID	INT			PRIMARY KEY,	--Unique identifier
	name	VARCHAR(50)	NOT NULL,		--The name of the type (Major/Minor)
	UNIQUE(name)
);

INSERT INTO AssignmentType VALUES (1, 'Directed');
INSERT INTO AssignmentType VALUES (2, 'Compulsory');
INSERT INTO AssignmentType VALUES (3, 'Other');
go

	---		Major/Minor Data		---

CREATE TABLE MajorMinor(
	mCode			VARCHAR(8)		PRIMARY KEY,	--Unique code for the major/minor
	name			VARCHAR(50)		NOT NULL,		--Name for the major/minor
	description		VARCHAR(200)	NOT NULL,		--Description for this major/minor
	totalCredits	INT				NOT NULL,		--Total credits required to complete this major/minor
	conditions		VARCHAR(200)	NOT NULL,		--The conditions that need to be met to complete this major/minor
	isMajor			BIT				NOT NULL,		--Determines whether it's a major or a minor (1 if Major, 0 if Minor)
	UNIQUE(name)
);

INSERT INTO MajorMinor VALUES ('M1', 'Pure Mathematics', 'Mathematics that is pure', 120, 'Be really good at maths', 1);
INSERT INTO MajorMinor VALUES ('m2', 'Impure Mathematics', 'Mathematics that is impure', 60, 'Be alright at maths', 0);
INSERT INTO MajorMinor VALUES ('M3', 'Applied Mathematics', 'Mathematics that is to be applied', 120, 'Apply maths somewhere', 1);
INSERT INTO MajorMinor VALUES ('M4', 'Data Science', 'The science behind the data', 160, 'Know what SQL is', 1);
go

	---		Course Data		---

-----------------------------------------------------------------------------------------------
-----------		TRY USING TRIGGERS TO ENFORCE THAT EVERY COURSE IS USED LATER ON --------------
-----------------------------------------------------------------------------------------------

CREATE TABLE Course(
	courseID		VARCHAR(9)		PRIMARY KEY,	--The identifier for the course
	name			VARCHAR(50)		NOT NULL,		--The name of the course
	numberCredits	INT				NOT NULL,		--The number of credits assigned for the course 
	description		VARCHAR(200)	NOT NULL,		--description of the course
	UNIQUE(name)
);

INSERT INTO Course VALUES ('COMP3350', 'Advanced Database', 10, 'Continuation of COMP1140 with more stuff');
INSERT INTO Course VALUES ('COMP1140', 'Database and Information Management', 10, 'Learn SQL and databases');
INSERT INTO Course VALUES ('MATH1510', 'Discrete Mathematics', 10, 'Mathematics that is discrete');
INSERT INTO Course VALUES ('COMP3851A', 'CS and IT WIL Part A', 10, 'Off to work integrated learning!');
INSERT INTO Course VALUES ('COMP3851B', 'CS and IT WIL Part B', 10, 'Off to work integrated learning again!');
INSERT INTO Course VALUES ('SENG1110', 'Object-Oriented Programming', 10, 'Learn Java');
INSERT INTO Course VALUES ('SENG1120', 'Data Structures', 10, 'Learn C++');
INSERT INTO Course VALUES ('MATH3820', 'Numerical Methods', 10, 'Learn Interpolation and other methods');
INSERT INTO Course VALUES ('MATH3120', 'Algebra', 10, 'Learn algebra');
INSERT INTO Course VALUES ('MATH2310', 'Calculus of Science and Engineering', 10, 'Learn the calculus of the sciences');
INSERT INTO Course VALUES ('MATH1210', 'Mathematical Discovery 1', 10, 'Discover math');
INSERT INTO Course VALUES ('MATH1220', 'Mathematical Discovery 2', 10, 'Discover math again');
go

	---		Assumed Knowledge for Courses Data		---

CREATE TABLE AssumedKnowledge(
	course			VARCHAR(9)	NOT NULL,	--The main course
	assumedCourse	VARCHAR(9)	NOT NULL,	--The assumed knowledge of the main course
	isPrerequisite	BIT			NOT NULL,	--Flag that determines if assumedCourse has to be taken in order for the main course to be taken
	PRIMARY KEY(course, assumedCourse),
	CHECK(course != assumedCourse),			--Make sure that an organisation unit can't be its own sub orgnisation unit
	FOREIGN KEY(course) REFERENCES Course(courseID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(assumedCourse) REFERENCES Course(courseID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO AssumedKnowledge VALUES ('COMP3350', 'COMP1140', 1);
INSERT INTO AssumedKnowledge VALUES ('COMP3350', 'SENG1110', 1);
INSERT INTO AssumedKnowledge VALUES ('COMP3851B', 'COMP3851A', 0);
INSERT INTO AssumedKnowledge VALUES ('MATH3820', 'MATH2310', 0);
INSERT INTO AssumedKnowledge VALUES ('MATH2310', 'MATH1220', 1);
INSERT INTO AssumedKnowledge VALUES ('MATH1220', 'MATH1210', 1);
INSERT INTO AssumedKnowledge VALUES ('SENG1120', 'SENG1110', 0);
go

	---		Program Data		---

CREATE TABLE Program(
	progCode		INT			PRIMARY KEY,	--Code for the program
	name			VARCHAR(50)	NOT NULL,		--Name of the program
	oUnit			VARCHAR(8)	NOT NULL,		--The organisation unit that this program belongs to
	totalCredits	INT			NOT NULL,		--Total credits required to complete this program
	level			VARCHAR(20)	NOT NULL,		--Level of the program (ie Bachelor)
	certAchieved	VARCHAR(10)	NOT NULL,		--Certification achieved once the program is completed (ie BSc)
	UNIQUE(name),
	FOREIGN KEY(oUnit) REFERENCES OrganisationUnit(unitCode)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO Program VALUES (10237, 'Bachelor of Mathematics', 'OU000008', 240, 'Bachelor', 'BMath');
INSERT INTO Program VALUES (40103, 'Bachelor of Computer Science', 'OU000003', 240, 'Bachelor', 'BCompSc');
INSERT INTO Program VALUES (11497, 'Bachelor of Information Technology', 'OU000007', 240, 'Bachelor', 'BIT');
INSERT INTO Program VALUES (40177, 'Master of Information Technology', 'OU000007', 120, 'Masters', 'BIT');
INSERT INTO Program VALUES (60238, 'PhD (Mathematics)', 'OU000008', 120, 'PhD', 'PhD');
go

	---		Program Course Data		---

CREATE TABLE ProgramCourse(
	program		INT,					--Code of the program
	course		VARCHAR(9),				--Course that is featured in the program
	startDate	DATE		NOT NULL,	--StartDate 
	endDate		DATE,
	isCore		BIT			NOT NULL,
	PRIMARY KEY(program, course, startDate),
	CHECK(endDate > startDate),
	FOREIGN KEY(program) REFERENCES Program(progCode)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(course) REFERENCES Course(courseID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO ProgramCourse VALUES (10237, 'MATH1210', '2022-02-01', NULL, 1);
INSERT INTO ProgramCourse VALUES (10237, 'MATH1220', '2022-02-01', NULL, 1);
INSERT INTO ProgramCourse VALUES (10237, 'MATH2310', '2022-02-01', NULL, 0);
INSERT INTO ProgramCourse VALUES (10237, 'MATH1510', '2022-02-01', NULL, 0);
INSERT INTO ProgramCourse VALUES (10237, 'MATH3120', '2022-02-01', NULL, 1);
INSERT INTO ProgramCourse VALUES (10237, 'MATH3820', '2022-02-01', NULL, 1);
INSERT INTO ProgramCourse VALUES (60238, 'MATH3820', '2021-02-01', '2021-12-01', 1);
INSERT INTO ProgramCourse VALUES (60238, 'MATH3120', '2021-02-01', '2021-12-01', 1);
INSERT INTO ProgramCourse VALUES (40103, 'COMP3350', '2022-02-01', NULL, 0);
INSERT INTO ProgramCourse VALUES (40103, 'COMP1140', '2022-02-01', NULL, 1);
INSERT INTO ProgramCourse VALUES (40103, 'SENG1110', '2022-02-01', NULL, 1);
INSERT INTO ProgramCourse VALUES (40103, 'SENG1120', '2022-02-01', NULL, 1);
INSERT INTO ProgramCourse VALUES (40103, 'COMP3851A', '2022-02-01', NULL, 1);
INSERT INTO ProgramCourse VALUES (40103, 'COMP3851B', '2022-02-01', NULL, 1);
INSERT INTO ProgramCourse VALUES (11497, 'COMP3851A', '2022-02-01', NULL, 1);
INSERT INTO ProgramCourse VALUES (11497, 'COMP3851B', '2022-02-01', NULL, 1);
go

	---		Person Data		---

CREATE TABLE Person(
	personID		INT				PRIMARY KEY,	--Unique identifier for person
	name			VARCHAR(100)	NOT NULL,		--The person's name
	isStaff			BIT				NOT NULL,		--Flag to determine if the person is a staff member
	isStudent		BIT				NOT NULL,		--Flag to determine if the person is a student
	streetNum		VARCHAR(5)		NOT NULL,		--Street number of the address
	street			VARCHAR(50)		NOT NULL,		--Street of the address
	city			VARCHAR(50)		NOT NULL,		--City of the address
	postcode		VARCHAR(5)		NOT NULL,		--Postcode of the address
	contactNo		VARCHAR(10)		NOT NULL,		--Personal contact number of the person
	staffContact	VARCHAR(10),					--Staff contact number of the person (If the person is a staff member)
	CHECK(isStaff = 1 OR isStudent = 1),								--Ensures that at least one of the flags is true
	CHECK((isStaff = 0 AND staffContact IS NULL)			--Ensures that a non staff member doesn't have a staff contact number
		OR (isStaff = 1 AND staffContact IS NOT NULL)),		--Ensures that a staff member has a staff contact number
	UNIQUE(personID, isStaff),
	UNIQUE(personID, isStudent)
);

INSERT INTO Person VALUES (1, 'Jesse Lecathelinais', 0, 1, '25', 'Sesame St.', 'Newcastle', '2300', '2724228740', NULL);
INSERT INTO Person VALUES (2, 'Nathan Murphy', 0, 1, '123', 'Fake St.', 'Billton', '1234', '9988776655', NULL);
INSERT INTO Person VALUES (3, 'Mitch Black', 0, 1, '37', 'Nelson St.', 'Sydney', '8236', '3764283719', NULL);
INSERT INTO Person VALUES (4, 'Rukshan Athauda', 1, 0, '2', 'Apple St.', 'Newcastle', '2300', '1234568712', '12345687');
INSERT INTO Person VALUES (5, 'Billy Joe', 1, 1, '5', 'Five St.', 'Jesmond', '2299', '0987654321', '09876543');
INSERT INTO Person VALUES (6, 'Joey Bill', 1, 1, '5', 'Six St.', 'Wallsend', '2287', '0487645321', '21984365');
go

	---		Academic Staff Data		---

CREATE TABLE AcademicStaff(
	staff	INT	PRIMARY KEY,			--ID of the staff member
	isStaff	BIT	CHECK(isStaff = 1),		--Flag to make sure that the staff member is a staff member
	FOREIGN KEY(staff, isStaff) REFERENCES Person(personID, isStaff)
		ON UPDATE Cascade ON DELETE NO ACTION
);

INSERT INTO AcademicStaff VALUES (4, 1);
INSERT INTO AcademicStaff VALUES (6, 1);
go

	---		Organisation Unit/Staff Data		---

CREATE TABLE OrganisationStaff(
	oUnit		VARCHAR(8),						--Organisation unit that the staff is working for
	staff		INT,							--Staff member ID
	isStaff		BIT			CHECK(isStaff = 1),	--Flag to make sure that the person referenced is a staff member
	startDate	DATE		NOT NULL,			--Start date for the staff member at the organisation unit
	endDate		DATE,							--End date for the staff member at the organisation unit
	role		VARCHAR(50)	NOT NULL,			--The role of the staff member at the organisation unit
	PRIMARY KEY(oUnit, staff, startDate),
	CHECK(endDate > startDate),
	FOREIGN KEY(oUnit) REFERENCES OrganisationUnit(unitCode)
		ON UPDATE Cascade ON DELETE NO ACTION,
	FOREIGN KEY(staff, isStaff) REFERENCES Person(personID, isStaff)
		ON UPDATE Cascade ON DELETE NO ACTION
);

INSERT INTO OrganisationStaff VALUES ('OU000001', 4, 1, '2022-02-01', NULL, 'Lecturer');
INSERT INTO OrganisationStaff VALUES ('OU000003', 4, 1, '2021-02-01', '2021-12-31', 'Lecturer');
INSERT INTO OrganisationStaff VALUES ('OU000002', 5, 1, '2018-02-01', '2019-02-01', 'Lecturer');
INSERT INTO OrganisationStaff VALUES ('OU000002', 5, 1, '2019-02-01', '2020-02-01', 'PVC');
INSERT INTO OrganisationStaff VALUES ('OU000007', 5, 1, '2020-02-01', NULL, 'Tutor');
INSERT INTO OrganisationStaff VALUES ('OU000007', 6, 1, '2020-02-01', '2022-02-01', 'Lecturer');
INSERT INTO OrganisationStaff VALUES ('OU000001', 6, 1, '2022-02-01', NULL, 'Lecturer');
go

	---		Program Staff Data		---

CREATE TABLE ProgramStaff(
	program		INT,				--Code of the program
	convenor	INT,				--Course that is featured in the program
	startDate	DATE	NOT NULL,	--StartDate 
	endDate		DATE,
	PRIMARY KEY(program, convenor, startDate),
	CHECK(endDate > startDate),
	FOREIGN KEY(program) REFERENCES Program(progCode)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(convenor) REFERENCES AcademicStaff(staff)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO ProgramStaff VALUES (10237, 4, '2022-02-01', NULL);
INSERT INTO ProgramStaff VALUES (10237, 6, '2021-02-01', '2022-02-01');
INSERT INTO ProgramStaff VALUES (11497, 6, '2021-02-01', '2022-02-01');
INSERT INTO ProgramStaff VALUES (60238, 6, '2021-02-01', NULL);
INSERT INTO ProgramStaff VALUES (40177, 6, '2021-02-01', NULL);
INSERT INTO ProgramStaff VALUES (40103, 4, '2021-02-01', NULL);
go

	---		Program Major Minor Data		---

CREATE TABLE ProgramMajorMinor(
	program		INT,				--Code of the program
	majorMinor	VARCHAR(8),				--Code of the major that associates with the program
	PRIMARY KEY(program, majorMinor),
	FOREIGN KEY(program) REFERENCES Program(progCode)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(majorMinor) REFERENCES MajorMinor(mCode)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO ProgramMajorMinor VALUES (10237, 'M1');
INSERT INTO ProgramMajorMinor VALUES (10237, 'm2');
INSERT INTO ProgramMajorMinor VALUES (10237, 'M3');
INSERT INTO ProgramMajorMinor VALUES (40103, 'M4');
INSERT INTO ProgramMajorMinor VALUES (11497, 'M4');
go

	---		Assignment Major Data		---

CREATE TABLE AssignmentMajor(
	assignID	INT			PRIMARY KEY,	--Code of the program
	majorMinor	VARCHAR(8)	NOT NULL,		--Code of the major that associates with the program
	course		VARCHAR(9)	NOT NULL,
	type		INT			NOT NULL,
	startDate	DATE		NOT NULL,
	endDate		DATE,
	FOREIGN KEY(majorMinor) REFERENCES MajorMinor(mCode)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(course) REFERENCES Course(courseID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(type) REFERENCES AssignmentType(typeID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO AssignmentMajor VALUES (1, 'M1', 'MATH2310', 3, '1999-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (2, 'M1', 'MATH3820', 1, '1999-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (3, 'M1', 'MATH3120', 1, '1999-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (4, 'm2', 'MATH3820', 1, '2003-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (5, 'm2', 'MATH1510', 2, '2003-01-01', '2005-02-02');
INSERT INTO AssignmentMajor VALUES (6, 'm2', 'MATH1210', 2, '2001-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (7, 'm2', 'MATH1220', 2, '2003-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (8, 'm2', 'MATH3820', 1, '2005-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (9, 'M3', 'MATH3820', 1, '2003-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (10, 'M3', 'MATH3120', 1, '2008-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (11, 'M4', 'COMP3350', 2, '1989-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (12, 'M4', 'MATH1220', 2, '1979-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (13, 'M4', 'COMP3851A', 2, '2018-01-01', NULL);
INSERT INTO AssignmentMajor VALUES (14, 'M4', 'COMP3851B', 2, '2018-01-01', NULL);
go

	---		Campus Data		---

CREATE TABLE Campus(
	campID		INT			PRIMARY KEY,	--ID for the campus
	name		VARCHAR(50)	NOT NULL,		--Name of the campusID
);

INSERT INTO Campus VALUES (1, 'UniversityX, Callaghan Campus');
INSERT INTO Campus VALUES (2, 'UniversityX, Newcastle City Campus');
INSERT INTO Campus VALUES (3, 'UniversityX, Ourimbah Campus');
INSERT INTO Campus VALUES (4, 'UniversityX, Online Campus');
INSERT INTO Campus VALUES (5, 'UniversityX, Covid Campus');
INSERT INTO Campus VALUES (6, 'UniversityX, American Campus');
go

	---		Physical Campus Data		---

CREATE TABLE PhysicalCampus(
	campID		INT			PRIMARY KEY,	--ID for the campus
	city		VARCHAR(50)	NOT NULL,		--City that the campus is located in
	country		VARCHAR(50)	NOT NULL,		--Country that the campus is located in
	FOREIGN KEY(campID) REFERENCES Campus(campID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO PhysicalCampus VALUES (1, 'Callaghan', 'Australia');
INSERT INTO PhysicalCampus VALUES (2, 'Newcastle', 'Australia');
INSERT INTO PhysicalCampus VALUES (3, 'Ourimbah', 'Australia');
INSERT INTO PhysicalCampus VALUES (6, 'Los Angeles', 'USA');
go

	---		Type of Facility Data		---

CREATE TABLE FacilityType(
	typeID	INT			PRIMARY KEY,	--Unique identifier
	name	VARCHAR(50)	NOT NULL,		--The name of the type (Facility)
	UNIQUE(name)
);

INSERT INTO FacilityType VALUES (1, 'Room');
INSERT INTO FacilityType VALUES (2, 'Classroom');
INSERT INTO FacilityType VALUES (3, 'Computer Lab');
go

	---		Facility Data		---

CREATE TABLE Facility(
	facID			INT			PRIMARY KEY,	--ID for the facility
	campus			INT			NOT NULL,		--Campus that the facility resides in
	roomNumber		INT			NOT NULL,		--room number of the facility
	buildingName	VARCHAR(50)	NOT NULL,		--name of the building the facility is in
	capacity		INT			NOT NULL,		--capacity for the facility
	type			INT			NOT NULL,		--type of facility
	UNIQUE(campus, roomNumber, buildingName),
	FOREIGN KEY(campus) REFERENCES PhysicalCampus(campID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(type) REFERENCES FacilityType(typeID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO Facility VALUES (1, 1, 001, 'Social Sciences', 50, 2);
INSERT INTO Facility VALUES (2, 1, 002, 'General Purpose', 30, 2);
INSERT INTO Facility VALUES (3, 1, 209, 'Engineering Science', 70, 3);
INSERT INTO Facility VALUES (4, 1, 205, 'Mathematics', 50, 2);
INSERT INTO Facility VALUES (5, 1, 306, 'CT Building', 30, 3);
INSERT INTO Facility VALUES (6, 1, 013, 'Physics', 20, 3);
INSERT INTO Facility VALUES (7, 1, 201, 'General Purpose', 100, 2);
INSERT INTO Facility VALUES (8, 1, 107, 'Mathematics', 100, 2);
INSERT INTO Facility VALUES (9, 2, 201, 'CT Building', 100, 1);
INSERT INTO Facility VALUES (10, 3, 201, 'CT Building', 70, 1);
INSERT INTO Facility VALUES (11, 6, 407, 'USA Building', 407, 3);
INSERT INTO Facility VALUES (12, 6, 704, 'USA Building', 70, 3);
go

	---		Period Data		---

CREATE TABLE Period(
	periodID	INT			PRIMARY KEY,	--ID for the facility
	name		VARCHAR(10)	NOT NULL,		--Name of period
	startDate	DATE		NOT NULL,		--start date of period
	endDate		DATE,						--end date of period
	year		VARCHAR(5)	NOT NULL,		--year of the semester
	CHECK(name = 'Semester' OR name = 'Trimester')
);

INSERT INTO Period VALUES (1, 'Semester', '2020-01-01', '2020-06-30', '2020');
INSERT INTO Period VALUES (2, 'Semester', '2020-07-01', '2020-12-31', '2020');
INSERT INTO Period VALUES (3, 'Semester', '2021-07-01', '2021-12-31', '2021');
INSERT INTO Period VALUES (4, 'Semester', '2021-07-01', '2021-12-31', '2021');
INSERT INTO Period VALUES (5, 'Semester', '2022-07-01', '2022-12-31', '2022');
INSERT INTO Period VALUES (6, 'Trimester', '2020-01-01', '2020-04-30', '2020');
INSERT INTO Period VALUES (7, 'Trimester', '2020-05-01', '2020-08-31', '2020');
INSERT INTO Period VALUES (8, 'Trimester', '2020-09-01', '2020-12-31', '2020');
INSERT INTO Period VALUES (9, 'Trimester', '2021-01-01', '2021-04-30', '2020');
INSERT INTO Period VALUES (10, 'Trimester', '2021-05-01', '2021-08-31', '2020');
INSERT INTO Period VALUES (11, 'Trimester', '2021-09-01', '2021-12-31', '2020');
INSERT INTO Period VALUES (12, 'Trimester', '2022-01-01', '2022-04-30', '2020');
go

	---		Course Offering Data		---

CREATE TABLE CourseOffering(
	offeringID	INT			PRIMARY KEY,	--ID for the course offering
	course		VARCHAR(9)	NOT NULL,		--Course that is being offered
	coordinator	INT			NOT NULL,		--Coordinator of the course offering
	isStaff		BIT	CHECK(isStaff = 1),		--Flag that indicates that the coordinator is a staff member
	campus		INT			NOT NULL,		--Campus that the course offering is being held
	period		INT			NOT NULL,		--Period that the course offering is being held
	FOREIGN KEY(course) REFERENCES Course(courseID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(coordinator, isStaff) REFERENCES Person(personID, isStaff)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(campus) REFERENCES Campus(campID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(period) REFERENCES Period(periodID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO CourseOffering VALUES (1, 'COMP1140', 4, 1, 1, 1);
INSERT INTO CourseOffering VALUES (2, 'COMP3350', 4, 2, 1, 2);
INSERT INTO CourseOffering VALUES (3, 'COMP3851A', 4, 1, 1, 3);
INSERT INTO CourseOffering VALUES (4, 'COMP3851B', 6, 1, 1, 4);
INSERT INTO CourseOffering VALUES (5, 'MATH1210', 4, 6, 1, 5);
INSERT INTO CourseOffering VALUES (6, 'MATH1220', 5, 1, 1, 6);
INSERT INTO CourseOffering VALUES (7, 'MATH1510', 6, 5, 1, 7);
INSERT INTO CourseOffering VALUES (8, 'MATH2310', 6, 4, 1, 8);
INSERT INTO CourseOffering VALUES (9, 'MATH3120', 4, 1, 1, 9);
INSERT INTO CourseOffering VALUES (10, 'MATH3820', 5, 1, 1, 10);
INSERT INTO CourseOffering VALUES (11, 'SENG1110', 5, 3, 1, 11);
INSERT INTO CourseOffering VALUES (12, 'SENG1120', 5, 2, 1, 12);
go

	---		Student/Course Offering Data		---

CREATE TABLE StudentCourseOffering(
	student			INT			NOT NULL,		--ID of the student
	isStudent		BIT	CHECK(isStudent = 1),	--Flag that determines that this person is a student
	offering		INT			NOT NULL,		--Course that is being offered
	dateRegistered	DATE		NOT NULL,		--Coordinator of the course offering
	finalMark		INT,						--Flag that indicates that the coordinator is a staff member
	finalGrade		VARCHAR(2),					--Campus that the course offering is being held
	isCompleted		BIT			NOT NULL,		--Period that the course offering is being held
	PRIMARY KEY(student, offering),
	FOREIGN KEY(student, isStudent) REFERENCES Person(personID, isStudent)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(offering) REFERENCES CourseOffering(offeringID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

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
INSERT INTO StudentCourseOffering VALUES (5, 1, 1, '2021-07-05', 60, 'P', 1);
INSERT INTO StudentCourseOffering VALUES (6, 1, 3, '2020-01-05', 48, 'F', 1);
INSERT INTO StudentCourseOffering VALUES (6, 1, 4, '2021-07-05', 60, 'P', 1);
go

	---		Physical Offering Data		---

CREATE TABLE PhysicalOffering(
	offeringID	INT	PRIMARY KEY,			--ID of the course offering
	FOREIGN KEY(offeringID) REFERENCES CourseOffering(offeringID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO PhysicalOffering VALUES (1);
INSERT INTO PhysicalOffering VALUES (2);
INSERT INTO PhysicalOffering VALUES (3);
INSERT INTO PhysicalOffering VALUES (4);
INSERT INTO PhysicalOffering VALUES (8);
INSERT INTO PhysicalOffering VALUES (10);
go

	---		Type of Reason Data		---

CREATE TABLE ReasonType(
	typeID	INT			PRIMARY KEY,	--Unique identifier
	name	VARCHAR(50)	NOT NULL,		--The name of the type (Reason)
	UNIQUE(name)
);

INSERT INTO ReasonType VALUES (1, 'Lecture');
INSERT INTO ReasonType VALUES (2, 'Lab');
INSERT INTO ReasonType VALUES (3, 'Workshop');
go

	---		Timetable Slot Data		---

CREATE TABLE TimetableSlot(
	slotID		INT		PRIMARY KEY,	--ID of the timetable slot
	facility	INT		NOT NULL,		--Facility that this timetable slot is taken in
	offering	INT		NOT NULL,		--The offering that this slot is apart of
	staff		INT		NOT NULL,		--Staff member teaching in this slot
	isStaff		BIT	CHECK(isStaff = 1),	--Guarentees person is staff
	date		DATE	NOT NULL,		--Date of timetable slot
	startTime	TIME	NOT NULL,		--Start time of the timetable slot
	endTime		TIME	NOT NULL,		--End time of the timetable slot
	reason		INT		NOT NULL,		--The reason for this timetable slot
	FOREIGN KEY(facility) REFERENCES Facility(facID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(offering) REFERENCES PhysicalOffering(offeringID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(reason) REFERENCES ReasonType(typeID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
--	FOREIGN KEY(staff) REFERENCES Person(personID)
--		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO TimetableSlot VALUES (1, 2, 2, 4, 1, '2022-02-22', '15:00:00', '17:00:00', 1);
INSERT INTO TimetableSlot VALUES (2, 3, 2, 4, 1, '2022-02-22', '17:00:00', '19:00:00', 3);
INSERT INTO TimetableSlot VALUES (3, 7, 3, 4, 1, '2022-02-25', '09:00:00', '11:00:00', 1);
INSERT INTO TimetableSlot VALUES (4, 8, 3, 5, 1, '2022-02-25', '13:00:00', '15:00:00', 3);
INSERT INTO TimetableSlot VALUES (5, 11, 1, 5, 1, '2022-02-25', '10:00:00', '12:00:00', 2);

INSERT INTO TimetableSlot VALUES (7, 12, 1, 5, 1, '2022-02-23', '8:00:00', '10:00:00', 1);

INSERT INTO TimetableSlot VALUES (9, 1, 4, 6, 1, '2022-02-21', '13:00:00', '15:00:00', 1);
INSERT INTO TimetableSlot VALUES (10, 5, 4, 6, 1, '2022-02-24', '11:00:00', '12:00:00', 3);

INSERT INTO TimetableSlot VALUES (12, 1, 4, 6, 1, '2022-02-22', '15:00:00', '17:00:00', 3);

INSERT INTO TimetableSlot VALUES (14, 7, 8, 4, 1, '2022-02-24', '11:00:00', '14:00:00', 2);

INSERT INTO TimetableSlot VALUES (16, 10, 10, 6, 1, '2022-02-23', '15:00:00', '17:00:00', 1);

INSERT INTO TimetableSlot VALUES (18, 6, 10, 4, 1, '2022-02-22', '11:00:00', '13:00:00', 3);
INSERT INTO TimetableSlot VALUES (19, 1, 10, 6, 1, '2022-02-23', '12:00:00', '14:00:00', 2);
INSERT INTO TimetableSlot VALUES (20, 10, 10, 5, 1, '2022-02-23', '12:00:00', '14:00:00', 2);
go




SELECT * FROM TimetableSlot


DEALLOCATE timetableSlotCursor
DECLARE timetableSlotCursor CURSOR			--	Cursor for timetableclashcheck trigger
FOR
SELECT	slotID, staff, date, startTime, endTime
FROM	TimetableSlot
FOR READ ONLY
go

DECLARE	@slot	INT
DECLARE	@staff	INT
DECLARE @date	DATE
DECLARE @startTime	TIME
DECLARE @endTime	TIME

DECLARE	@count	INT
SET		@count = 0

OPEN timetableSlotCursor
FETCH NEXT FROM timetableSlotCursor INTO @slot, @slot, @date, @startTime, @endTime

WHILE @@FETCH_STATUS = 0
BEGIN

	SELECT ts.*, per.name
	FROM	TimetableSlot ts,				--The timetable slot data that is to be inserted
			PhysicalOffering po,
			CourseOffering c,
			StudentCourseOffering sc,
			Period pe,
			Person per
	WHERE	ts.offering = po.offeringID		--	Check offering's all connected
		AND	po.offeringID = c.offeringID
		AND	sc.offering = c.offeringID
		AND c.period = pe.periodID
		AND ts.date = @date
		AND ts.slotID != @slot
		AND ts.staff = per.personID
		AND ts.staff = @staff
		AND (			-- Timetable clash check section
				(ts.startTime >= @startTime AND ts.startTime < @endTime)
			OR	(ts.endTime > @startTime AND ts.endTime <= @endTime)
			)

	FETCH NEXT FROM timetableSlotCursor INTO @slot, @staff, @date, @startTime, @endTime
END

CLOSE timetableSlotCursor


	---		Student Course Offering x Timetabele slot data		---

CREATE TABLE StudentTimetableSlot(
	student		INT		NOT NULL,		--ID of the student
	offering	INT		NOT NULL,		--The offering that this slot is apart of
	slot		INT		NOT NULL,	--indicates this student is a student
	PRIMARY KEY(student, slot, offering),
	FOREIGN KEY(student, offering) REFERENCES StudentCourseOffering(student, offering)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(slot) REFERENCES TimetableSlot(slotID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO StudentTimetableSlot VALUES (1, 2, 1);
INSERT INTO StudentTimetableSlot VALUES (2, 2, 1);


go


SELECT * FROM TimetableSlot
SELECT * FROM StudentTimetableSlot

	---		Student Enrolment Data		---

---	MIGHT NOT NEED PERIOD WE'LL SEEEE	---
---	COME BACK LATER TO PROPERLY FILL IN	---

CREATE TABLE StudentEnrolment(
	enrolID				INT				PRIMARY KEY,	--ID of the student enrolment
	student				INT				NOT NULL,		--Student that is enrolling for program(s)
	isStudent			BIT	CHECK(isStudent = 1),		--Flag that makes sure that this person is a student
	period				INT				NOT NULL,		--The period this student is offering in
	dateEnrolled		DATE			NOT NULL,		--The date the student is enrolling
	dateCompletetion	DATE,							--The date the student completed their enrolment
	status				VARCHAR(100)	NOT NULL,		--Status of the student enrolment
	FOREIGN KEY(student, isStudent) REFERENCES Person(personID, isStudent)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(period) REFERENCES Period(periodID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO StudentEnrolment VALUES (1, 1, 1, 2, '2019-01-15', NULL, 'Enrolled');
INSERT INTO StudentEnrolment VALUES (2, 2, 1, 3, '2018-07-15', NULL, 'Enrolled');
INSERT INTO StudentEnrolment VALUES (3, 3, 1, 5, '2011-01-15', '2021-12-31', 'Completed');
go

	---		Program Enrolment Data		---

---	COME BACK LATER TO PROPERLY FILL IN	---

CREATE TABLE ProgramEnrolment(
	enrolID	INT	NOT NULL,	--ID of the student enrolment
	program	INT	NOT NULL,
	PRIMARY KEY(enrolID, program),
	FOREIGN KEY(enrolID) REFERENCES StudentEnrolment(enrolID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(program) REFERENCES Program(progCode)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO ProgramEnrolment VALUES (1, 10237);
INSERT INTO ProgramEnrolment VALUES (1, 40103);
INSERT INTO ProgramEnrolment VALUES (2, 11497);
INSERT INTO ProgramEnrolment VALUES (3, 10237);
go