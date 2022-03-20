-- UniversityX Database Script

--Drops all tables so they can be created again
DROP TABLE ProgramEnrolment
DROP TABLE StudentEnrolment
DROP TABLE TimetableSlot
DROP TABLE ReasonType
DROP TABLE PhysicalOffering
DROP TABLE StudentCourseOffering
DROP TABLE CourseOffering
DROP TABLE Period
DROP TABLE Facility
DROP TABLE FacilityType
DROP TABLE PhysicalCampus
DROP TABLE Campus
DROP TABLE AssignmentMajor
DROP TABLE ProgramMajorMinor
DROP TABLE ProgramStaff
DROP TABLE OrganisationStaff
DROP TABLE AcademicStaff
DROP TABLE Person
DROP TABLE ProgramCourse
DROP TABLE Program
DROP TABLE AssumedKnowledge
DROP TABLE Course
DROP TABLE MajorMinor
DROP TABLE AssignmentType
DROP TABLE SubOrganisationUnit
DROP TABLE OrganisationUnit
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
	PRIMARY KEY(subOUnit),
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
  -- Business Rule must enforce assumed knowledged pre req has been completed before enrolling in the course.

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

--Trigger to enforce that two roles can't be held by the same staff members at the same time in an OU
--Start date of insert has to be after the end date.

INSERT INTO OrganisationStaff VALUES ('OU000001', 4, 1, '2022-02-01', NULL, 'Lecturer');
INSERT INTO OrganisationStaff VALUES ('OU000001', 4, 1, '2020-02-01', '2022-01-31', 'Tutor');
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
	PRIMARY KEY(student, offering, dateRegistered),
	FOREIGN KEY(student, isStudent) REFERENCES Person(personID, isStudent)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(offering) REFERENCES CourseOffering(offeringID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Check on insert, Can't apply for more then > 4 course period.
-- Enforce Section 4 Business rule here on insert.
-- Check all course offerings passed in by joining offering with the course ideas.

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
	date		DATE	NOT NULL,		--Date of timetable slot
	startTime	TIME	NOT NULL,		--Start time of the timetable slot
	endTime		TIME	NOT NULL,		--End time of the timetable slot
	reason		INT		NOT NULL,		--The reason for this timetable slot
	FOREIGN KEY(facility) REFERENCES Facility(facID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(offering) REFERENCES PhysicalOffering(offeringID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY(reason) REFERENCES ReasonType(typeID)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

INSERT INTO TimetableSlot VALUES (1, 2, 2, '2022-02-22', '15:00:00', '17:00:00', 1);
INSERT INTO TimetableSlot VALUES (2, 3, 2, '2022-02-22', '17:00:00', '19:00:00', 3);
INSERT INTO TimetableSlot VALUES (3, 7, 3, '2022-02-25', '09:00:00', '11:00:00', 1);
INSERT INTO TimetableSlot VALUES (4, 8, 3, '2022-02-25', '13:00:00', '15:00:00', 3);
INSERT INTO TimetableSlot VALUES (5, 11, 1, '2022-02-25', '10:00:00', '12:00:00', 2);
INSERT INTO TimetableSlot VALUES (6, 11, 1, '2022-02-25', '10:00:00', '12:00:00', 2);
INSERT INTO TimetableSlot VALUES (7, 12, 1, '2022-02-23', '8:00:00', '10:00:00', 1);
INSERT INTO TimetableSlot VALUES (8, 11, 1, '2022-02-25', '8:00:00', '10:00:00', 3);
INSERT INTO TimetableSlot VALUES (9, 1, 4, '2022-02-21', '13:00:00', '15:00:00', 1);
INSERT INTO TimetableSlot VALUES (10, 5, 4, '2022-02-24', '11:00:00', '12:00:00', 3);
INSERT INTO TimetableSlot VALUES (11, 1, 4, '2022-02-24', '11:00:00', '12:00:00', 3);
INSERT INTO TimetableSlot VALUES (12, 1, 4, '2022-02-22', '15:00:00', '17:00:00', 3);
INSERT INTO TimetableSlot VALUES (13, 2, 8, '2022-02-25', '10:00:00', '12:00:00', 1);
INSERT INTO TimetableSlot VALUES (14, 7, 8, '2022-02-24', '11:00:00', '14:00:00', 2);
INSERT INTO TimetableSlot VALUES (15, 9, 8, '2022-02-22', '14:00:00', '16:00:00', 2);
INSERT INTO TimetableSlot VALUES (16, 10, 10, '2022-02-23', '15:00:00', '17:00:00', 1);
INSERT INTO TimetableSlot VALUES (17, 4, 10, '2022-02-25', '08:00:00', '10:00:00', 1);
INSERT INTO TimetableSlot VALUES (18, 6, 10, '2022-02-22', '11:00:00', '13:00:00', 3);
INSERT INTO TimetableSlot VALUES (19, 1, 10, '2022-02-23', '12:00:00', '14:00:00', 2);
go

	---		Student Enrolment Data		---


---	MIGHT NOT NEED PERIOD WE'LL SEEEE	---
---	COME BACK LATER TO PROPERLY FILL IN	---

-- Pull Status out into its own entity called StatusType (typeID, name) Example Completed, Enrolled, Dropped, Leave of Absence


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

SELECT * FROM Program
SELECT * FROM StudentEnrolment


SELECT c.course, p.name, sc.*, pe.*
FROM CourseOffering c, StudentCourseOffering sc, Person p, Period pe
WHERE sc.offering = c.offeringID
AND p.personID = sc.student
AND pe.periodID = c.period


SELECT * FROM Person where isStudent = 1
SELECT * FROM Period
SELECT * FROM StudentCourseOffering

SELECT p.name, c.course
FROM StudentCourseOffering sc, Person p, CourseOffering c
WHERE p.personID = sc.student AND c.offeringID = sc.offering

SELECT *
FROM Campus c LEFT OUTER JOIN PhysicalCampus p ON c.campID = p.campID


/*		---TESTING QUERIES---



SELECT o.unitCode, o.unitName
FROM OrganisationUnit o, SubOrganisationUnit s
WHERE o.unitCode = s.oUnit

UPDATE OrganisationUnit
SET contactNo = '1029384756'
WHERE unitCode = 'OU789'
*/














/*		---COMP1140 ASSIGNMENT 3---


-- BankDetails Table
CREATE TABLE BankDetails(
	bankCode	CHAR(8)		PRIMARY KEY,
	bankName	VARCHAR(50)	NOT NULL
);

INSERT INTO BankDetails VALUES ('B0000001', 'OldCastle Temporary');
INSERT INTO BankDetails VALUES ('B0000002', 'The Bank of Australia');
INSERT INTO BankDetails VALUES ('B0000003', 'GoodBank');

-- ShiftType Table
CREATE TABLE ShiftType(
	staffID		CHAR(8)		PRIMARY KEY,
	ShiftType	VARCHAR(20)	NOT NULL
);

INSERT INTO ShiftType VALUES ('S0000001', 'Instore');
INSERT INTO ShiftType VALUES ('S0000002', 'Instore');
INSERT INTO ShiftType VALUES ('S0000003', 'Instore');
INSERT INTO ShiftType VALUES ('S0000004', 'Driver');
INSERT INTO ShiftType VALUES ('S0000005', 'Driver');
INSERT INTO ShiftType VALUES ('S0000006', 'Driver');

-- WorkingHours Table
CREATE TABLE WorkingHours(
	startTime	TIME	NOT NULL,
	endTime		TIME	NOT NULL,
	hoursWorked	INT		NOT NULL,
	PRIMARY KEY(startTime, endTime)
);

INSERT INTO WorkingHours VALUES ('09:00:00', '19:00:00', 10);
INSERT INTO WorkingHours VALUES ('10:00:00', '20:00:00', 10);
INSERT INTO WorkingHours VALUES ('11:00:00', '20:00:00', 9);

-- TotalPaidInstore Table
CREATE TABLE TotalPaidInstore(
	grossPayment	DECIMAL(10,2)	NOT NULL,
	taxWithheld		DECIMAL(10,2)	NOT NULL,
	totalHoursPaid	INT				NOT NULL,
	rate			DECIMAL(10,2)	NOT NULL,
	totalAmountPaid	DECIMAL(10,2)	NOT NULL,
	PRIMARY KEY(grossPayment, taxWithheld, totalHoursPaid, rate)
);

INSERT INTO TotalPaidInstore VALUES (40.00, 5.00, 6, 15.00, 120.00);
INSERT INTO TotalPaidInstore VALUES (40.00, 5.00, 6, 18.00, 150.00);
INSERT INTO TotalPaidInstore VALUES (40.00, 5.00, 4, 15.00, 60.00);

-- TotalPaidDriver Table
CREATE TABLE TotalPaidDriver(
	grossPayment		DECIMAL(10,2)	NOT NULL,
	taxWithheld			DECIMAL(10,2)	NOT NULL,
	totalDeliveriesPaid	INT				NOT NULL,
	ratePerDelivery		DECIMAL(10,2)	NOT NULL,
	totalAmountPaid		DECIMAL(10,2)	NOT NULL,
	PRIMARY KEY(grossPayment, taxWithheld, totalDeliveriesPaid, ratePerDelivery),
);

INSERT INTO TotalPaidDriver VALUES (50.00, 6.00, 5, 15.00, 100.00);
INSERT INTO TotalPaidDriver VALUES (50.00, 6.00, 4, 14.00, 90.00);
INSERT INTO TotalPaidDriver VALUES (50.00, 6.00, 4, 15.00, 95.00);

-- CallTime Table
CREATE TABLE CallTime(
	callAnswerTime		TIME	NOT NULL,
	callTerminatedTime	TIME	NOT NULL,
	callDurationTime	INT		NOT NULL,
	PRIMARY KEY(callAnswerTime, callTerminatedTime)
);

INSERT INTO CallTime VALUES ('11:30:00', '11:33:00', 3);
INSERT INTO CallTime VALUES ('12:30:00', '12:33:00', 3);
INSERT INTO CallTime VALUES ('13:30:00', '13:33:00', 3);

-- Instore Table
CREATE TABLE Instore(
	staffID			CHAR(8)			PRIMARY KEY,
	fName			VARCHAR(30)		NOT NULL,
	lName			VARCHAR(30)		NOT NULL,
	postalAddress	VARCHAR(200)	NOT NULL,
	contactNumber	VARCHAR(10)		NOT NULL,
	taxFileNum		CHAR(9)			NOT NULL,
	bankCode		CHAR(8)			NOT NULL,
	accountNum		CHAR(8)			NOT NULL,
	paymentRate		DECIMAL(10,2)	NOT NULL,
	status_			VARCHAR(50)		DEFAULT 'No status',
	description_	VARCHAR(200),
	FOREIGN KEY(bankCode) REFERENCES BankDetails(bankCode)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO Instore VALUES ('S0000001', 'Bill', 'Barlow', '3604 Duncan Avenue', '0412345678', '123456789', 'B0000002', 'A0000001', 20.30, DEFAULT, NULL);
INSERT INTO Instore VALUES ('S0000002', 'Leanne', 'Barlow', '3604 Duncan Avenue', '0443215678', '432168789', 'B0000002', 'A0000001', 20.30, DEFAULT, NULL);
INSERT INTO Instore VALUES ('S0000003', 'John', 'Johnson', '2375 Rose Street', '0412983476', '543278945', 'B0000001', 'A0000002', 20.30, DEFAULT, NULL);

-- InstorePayment Table
CREATE TABLE InstorePayment(
	paymentRecordID		CHAR(8)			PRIMARY KEY,
	totalHoursPaid		INT				NOT NULL,
	rate				DECIMAL(10,2)	NOT NULL,
	staffID				CHAR(8)			NOT NULL,
	grossPayment		DECIMAL(10,2)	NOT NULL,
	taxWithheld			DECIMAL(10,2)	NOT NULL,
	bankCode			CHAR(8)			NOT NULL,
	accountNum			CHAR(8)			NOT NULL,
	paymentDate			DATE			NOT NULL,
	paymentPeriodStart	DATE			NOT NULL,
	paymentPeriodEnd	DATE			NOT NULL,
	FOREIGN KEY(staffID) REFERENCES Instore(staffID)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(bankCode) REFERENCES BankDetails(bankCode)
		ON UPDATE NO ACTION ON DELETE NO ACTION,		-- ON UPDATE NO ACTION to prevent cycles
	FOREIGN KEY(grossPayment, taxWithheld, totalHoursPaid, rate) REFERENCES TotalPaidInstore(grossPayment, taxWithheld, totalHoursPaid, rate)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO InstorePayment VALUES ('PR000001', 6, 15.00, 'S0000001', 40.00, 5.00, 'B0000002', 'A0000001', '2019-02-27', '2019-01-01', '2019-12-31');
INSERT INTO InstorePayment VALUES ('PR000002', 6, 18.00, 'S0000002', 40.00, 5.00, 'B0000002', 'A0000001', '2019-05-27', '2019-01-01', '2019-12-31');
INSERT INTO InstorePayment VALUES ('PR000003', 4, 15.00, 'S0000003', 40.00, 5.00, 'B0000001', 'A0000002', '2019-10-27', '2019-01-01', '2019-12-31');

-- InstoreShift Table
CREATE TABLE InstoreShift(
	shiftID		CHAR(8)	PRIMARY KEY,
	staffID		CHAR(8)	NOT NULL,
	startDate	DATE	NOT NULL,
	startTime	TIME	NOT NULL,
	endDate		DATE	NOT NULL,
	endTime		TIME	NOT NULL,
	paymentID	CHAR(8)	NOT NULL,
	FOREIGN KEY(staffID) REFERENCES Instore(staffID)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(paymentID) REFERENCES InstorePayment(paymentRecordID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,		-- ON UPDATE NO ACTION to prevent cycles
	FOREIGN KEY(staffID) REFERENCES ShiftType(staffID)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(startTime, endTime) REFERENCES WorkingHours(startTime, endTime)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO InstoreShift VALUES ('SH000001', 'S0000001', '2019-02-25', '09:00:00', '2019-02-25', '19:00:00', 'PR000001');
INSERT INTO InstoreShift VALUES ('SH000002', 'S0000002', '2019-05-25', '09:00:00', '2019-05-25', '19:00:00', 'PR000002');
INSERT INTO InstoreShift VALUES ('SH000003', 'S0000003', '2019-10-25', '09:00:00', '2019-10-25', '19:00:00', 'PR000003');

-- Driver Table
CREATE TABLE Driver(
	staffID					CHAR(8)			PRIMARY KEY,
	driversLicenseNumber	CHAR(8)			NOT NULL,
	fName					VARCHAR(30)		NOT NULL,
	lName					VARCHAR(30)		NOT NULL,
	postalAddress			VARCHAR(200)	NOT NULL,
	contactNumber			VARCHAR(10)		NOT NULL,
	taxFileNum				CHAR(9)			NOT NULL,
	bankCode				CHAR(8)			NOT NULL,
	accountNum				CHAR(8)			NOT NULL,
	paymentRate				DECIMAL(10,2)	NOT NULL,
	status_					VARCHAR(50)		DEFAULT 'No status',
	description_			VARCHAR(200),
	FOREIGN KEY(bankCode) REFERENCES BankDetails(bankCode)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO Driver VALUES ('S0000004', '44422277', 'Billy', 'Jackson', '4509 Gateway Road', '0498763256', '046705356', 'B0000003', 'A0000003', 23.00, DEFAULT, NULL);
INSERT INTO Driver VALUES ('S0000005', '23542343', 'Joseph', 'Broseph', '2313 Church Street', '0455555578', '098765456', 'B0000001', 'A0000004', 23.00, DEFAULT, NULL);
INSERT INTO Driver VALUES ('S0000006', '44422277', 'Ethan', 'Boyle', '2902 Mandan Road', '0466612345', '564738921', 'B0000003', 'A0000005', 23.00, DEFAULT, NULL);

-- DriverPayment Table
CREATE TABLE DriverPayment(
	paymentRecordID		CHAR(8)			PRIMARY KEY,
	totalDeliveriesPaid	INT				NOT NULL,
	ratePerDelivery		DECIMAL(10,2)	NOT NULL,
	staffID				CHAR(8)			NOT NULL,
	grossPayment		DECIMAL(10,2)	NOT NULL,
	taxWithheld			DECIMAL(10,2)	NOT NULL,
	bankCode			CHAR(8)			NOT NULL,
	accountNum			CHAR(8)			NOT NULL,
	paymentDate			DATE			NOT NULL,
	paymentPeriodStart	DATE			NOT NULL,
	paymentPeriodEnd	DATE			NOT NULL,
	FOREIGN KEY(staffID) REFERENCES Driver(staffID)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(bankCode) REFERENCES BankDetails(bankCode)
		ON UPDATE NO ACTION ON DELETE NO ACTION,		-- ON UPDATE NO ACTION to prevent cycles
	FOREIGN KEY(grossPayment, taxWithheld, totalDeliveriesPaid, ratePerDelivery) REFERENCES TotalPaidDriver(grossPayment, taxWithheld, totalDeliveriesPaid, ratePerDelivery)
		ON UPDATE CASCADE ON DELETE NO ACTION,
);

INSERT INTO DriverPayment VALUES ('PR000004', 5, 15.00, 'S0000004', 50.00, 6.00, 'B0000003', 'A0000003', '2019-02-27', '2019-01-01', '2019-12-31');
INSERT INTO DriverPayment VALUES ('PR000005', 4, 14.00, 'S0000005', 50.00, 6.00, 'B0000001', 'A0000004', '2019-05-27', '2019-01-01', '2019-12-31');
INSERT INTO DriverPayment VALUES ('PR000006', 4, 15.00, 'S0000006', 50.00, 6.00, 'B0000003', 'A0000005', '2019-10-27', '2019-01-01', '2019-12-31');

-- DeliveryShift Table
CREATE TABLE DeliveryShift(
	shiftID					CHAR(8)	PRIMARY KEY,
	driverDeliveryAmount	INT		NOT NULL,
	staffID					CHAR(8)	NOT NULL,
	startDate				DATE	NOT NULL,
	startTime				TIME	NOT NULL,
	endDate					DATE	NOT NULL,
	endTime					TIME	NOT NULL,
	paymentID				CHAR(8)	NOT NULL,
	FOREIGN KEY(staffID) REFERENCES Driver(staffID)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(paymentID) REFERENCES DriverPayment(paymentRecordID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,		-- ON UPDATE NO ACTION to prevent cycles
	FOREIGN KEY(staffID) REFERENCES ShiftType(staffID)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(startTime, endTime) REFERENCES WorkingHours(startTime, endTime)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO DeliveryShift VALUES ('SH000004', 6, 'S0000004', '2019-02-25', '10:00:00', '2019-02-25', '20:00:00', 'PR000004');
INSERT INTO DeliveryShift VALUES ('SH000005', 8, 'S0000005', '2019-05-25', '10:00:00', '2019-05-25', '20:00:00', 'PR000005');
INSERT INTO DeliveryShift VALUES ('SH000006', 2, 'S0000006', '2019-10-25', '11:00:00', '2019-10-25', '20:00:00', 'PR000006');

-- MenuItem Table
CREATE TABLE MenuItem(
	itemCode		CHAR(8)			PRIMARY KEY,
	name_			VARCHAR(30)		NOT NULL,
	size			VARCHAR(10)		NOT NULL,
	sellingPrice	DECIMAL(10,2)	NOT NULL
);

INSERT INTO MenuItem VALUES ('M0000001', 'Meatlovers', 'Large', 13.00);
INSERT INTO MenuItem VALUES ('M0000002', 'Pepperoni', 'Large', 11.00);
INSERT INTO MenuItem VALUES ('M0000003', 'Meatlovers', 'Medium', 10.00);

-- Ingredient Table
CREATE TABLE Ingredient(
	ingredientID		CHAR(8)			PRIMARY KEY,
	name_				VARCHAR(30)		NOT NULL,
	type_				VARCHAR(30)		NOT NULL,
	description_		VARCHAR(200),
	currentStockLevel	INT				NOT NULL,
	dateLastStocktake	DATE			NOT NULL,
	suggestedStockLevel	INT				NOT NULL,
	reorderLevel		INT				NOT NULL
);

INSERT INTO Ingredient VALUES ('I0000001', 'Cheese', 'Dairy', NULL, 2000, '2019-01-01', 1500, 700);
INSERT INTO Ingredient VALUES ('I0000002', 'Pepperoni', 'Meat', NULL, 300, '2019-01-01', 300, 200);
INSERT INTO Ingredient VALUES ('I0000003', 'Beef', 'Meat', NULL, 200, '2019-01-01', 200, 100);

-- Supplier Table
CREATE TABLE Supplier(
	supplierID		CHAR(8)			PRIMARY KEY,
	name_			VARCHAR(60)		NOT NULL,
	address_		VARCHAR(200)	NOT NULL,
	phone			VARCHAR(10)		NOT NULL,
	email			VARCHAR(60)		NOT NULL,
	contactPerson	VARCHAR(200)	DEFAULT 'No details'
);

INSERT INTO Supplier VALUES ('SU000001', 'Harry Haroldson', '681 Lodgeville Road', '0487326678', 'harryharoldson@gmail.com', DEFAULT);
INSERT INTO Supplier VALUES ('SU000002', 'Jaqueline Borat', '4885 Waldeck Street', '0481236678', 'jaquelineborat@gmail.com', DEFAULT);
INSERT INTO Supplier VALUES ('SU000003', 'Ian Padillton', '2968 Prospect Street', '0487365438', 'ianpadillton@gmail.com', DEFAULT);

-- IngredientOrder Table
CREATE TABLE IngredientOrder(
	ingredientOrderID	CHAR(8)			PRIMARY KEY,
	dateOfOrder			DATE			NOT NULL,
	dateReceived		DATE			NOT NULL,
	totalAmount			INT				NOT NULL,
	orderStatus			VARCHAR(50)		DEFAULT 'No status',
	description_		VARCHAR(200),
	supplierID			CHAR(8)			NOT NULL,
	FOREIGN KEY(supplierID) REFERENCES Supplier(supplierID)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO IngredientOrder VALUES ('IO000001', '2019-02-01', '2019-02-04', 500, DEFAULT, NULL, 'SU000001');
INSERT INTO IngredientOrder VALUES ('IO000002', '2019-02-01', '2019-02-04', 300, DEFAULT, NULL, 'SU000002');
INSERT INTO IngredientOrder VALUES ('IO000003', '2019-02-01', '2019-02-04', 300, DEFAULT, NULL, 'SU000003');

-- QMenuItemIngredient Table
CREATE TABLE QMenuItemIngredient(
	itemCode		CHAR(8)	NOT NULL,		-- Item which contains ingredients
	ingredientID	CHAR(8)	NOT NULL,
	quantity		INT		NOT NULL,		-- Quantity of ingredient on item
	PRIMARY KEY(itemCode, ingredientID, quantity),
	FOREIGN KEY(itemCode) REFERENCES MenuItem(itemCode)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(ingredientID) REFERENCES Ingredient(ingredientID)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO QMenuItemIngredient VALUES ('M0000001', 'I0000001', 30);
INSERT INTO QMenuItemIngredient VALUES ('M0000002', 'I0000002', 10);
INSERT INTO QMenuItemIngredient VALUES ('M0000003', 'I0000003', 30);

-- QIngredientOrderIngredient Table
CREATE TABLE QIngredientOrderIngredient(
	ingredientOrderID	CHAR(8)			NOT NULL,		-- Order for ingredients
	ingredientID		CHAR(8)			NOT NULL,		
	quantity			INT				NOT NULL,		-- Quantity of ingredient in order
	price				DECIMAL(10,2)	NOT NULL,		-- Corresponding price (incorporates quantity)
	PRIMARY KEY(ingredientOrderID, ingredientID, quantity),
	FOREIGN KEY(ingredientOrderID) REFERENCES IngredientOrder(ingredientOrderID)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(ingredientID) REFERENCES Ingredient(ingredientID)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO QIngredientOrderIngredient VALUES ('IO000001', 'I0000001', 1000, 100.00);
INSERT INTO QIngredientOrderIngredient VALUES ('IO000002', 'I0000002', 100, 100.00);
INSERT INTO QIngredientOrderIngredient VALUES ('IO000003', 'I0000003', 100, 100.00);

-- QSupplierIngredient Table
CREATE TABLE QSupplierIngredient(
	supplierID		CHAR(8)			NOT NULL,		-- Suppler of the ingredient/s
	ingredientID	CHAR(8)			NOT NULL,
	quantity		INT				NOT NULL,		-- Quantity of ingredient supplied by supplier
	price			DECIMAL(10,2)	NOT NULL,		-- Corresponding price (incorporates quantity)
	PRIMARY KEY(supplierID, ingredientID, quantity),
	FOREIGN KEY(supplierID) REFERENCES Supplier(supplierID)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(ingredientID) REFERENCES Ingredient(ingredientID)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO QSupplierIngredient VALUES ('SU000001', 'I0000001', 1000, 100.00);
INSERT INTO QSupplierIngredient VALUES ('SU000002', 'I0000002', 100, 100.00);
INSERT INTO QSupplierIngredient VALUES ('SU000003', 'I0000003', 100, 100.00);

-- Customer Table
CREATE TABLE Customer(
	customerID	CHAR(8)			PRIMARY KEY,
	fName		VARCHAR(30)		NOT NULL,
	lName		VARCHAR(30)		NOT NULL,	
	address		VARCHAR(200)	NOT NULL,
	phone		VARCHAR(10)		NOT NULL
);

INSERT INTO Customer VALUES ('C0000001', 'Kevin', 'Motnar', '477 Elk Street', '0481926354');
INSERT INTO Customer VALUES ('C0000002', 'Kevin', 'Smith', '3880 Bryan Avenue', '0484322354');
INSERT INTO Customer VALUES ('C0000003', 'Kerry', 'Carrot', '2336 Romrog Way', '0411126354');

-- Order Table
CREATE TABLE Order_(
	orderID			CHAR(8)			NOT NULL,
	type_			VARCHAR(10)		NOT NULL,		-- Type of order
	dateOfOrder		DATE			NOT NULL,
	totalAmount		DECIMAL(10,2)	NOT NULL,
	orderStatus		VARCHAR(50)		DEFAULT 'No status',
	description_	VARCHAR(200),
	staffID			CHAR(8)			NOT NULL,
	customerID		CHAR(8)			NOT NULL,
	PRIMARY KEY(orderID, type_),	-- Primary key chosen to enforce mandatory or
	CHECK(type_ IN ('Walk-in', 'Pickup', 'Delivery')),
	FOREIGN KEY(staffID) REFERENCES Instore(staffID)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(customerID) REFERENCES Customer(customerID)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO Order_ VALUES ('O0000001','Walk-in', '2019-08-23', 120.00, DEFAULT, NULL, 'S0000001', 'C0000001')
INSERT INTO Order_ VALUES ('O0000002','Walk-in', '2019-08-21', 60.00, DEFAULT, NULL, 'S0000002', 'C0000002')
INSERT INTO Order_ VALUES ('O0000003','Walk-in', '2019-08-24', 20.00, DEFAULT, NULL, 'S0000003', 'C0000003')
INSERT INTO Order_ VALUES ('O0000004','Pickup', '2019-07-23', 120.00, DEFAULT, NULL, 'S0000001', 'C0000001')
INSERT INTO Order_ VALUES ('O0000005','Pickup', '2019-07-23', 22.00, DEFAULT, NULL, 'S0000002', 'C0000002')
INSERT INTO Order_ VALUES ('O0000006','Pickup', '2019-07-23', 33.00, DEFAULT, NULL, 'S0000003', 'C0000003')
INSERT INTO Order_ VALUES ('O0000007','Delivery', '2019-02-25', 120.00, DEFAULT, NULL, 'S0000001', 'C0000001')
INSERT INTO Order_ VALUES ('O0000008','Delivery', '2019-05-25', 34.00, DEFAULT, NULL, 'S0000002', 'C0000002')
INSERT INTO Order_ VALUES ('O0000009','Delivery', '2019-10-25', 12.00, DEFAULT, NULL, 'S0000003', 'C0000003')

-- WalkIn Table
CREATE TABLE WalkIn(
	orderID			CHAR(8)		NOT NULL,
	type_			VARCHAR(10)	NOT NULL,		-- Type of order
	walkInTime		TIME		NOT NULL,
	PRIMARY KEY(orderID, type_),	-- Primary key chosen to enforce mandatory or
	CHECK(type_ IN ('Walk-in')),
	FOREIGN KEY(orderID, type_) REFERENCES Order_(orderID, type_)
		ON UPDATE CASCADE ON DELETE NO ACTION,
);

INSERT INTO WalkIn VALUES ('O0000001', 'Walk-in', '12:00:00');
INSERT INTO WalkIn VALUES ('O0000002', 'Walk-in', '12:00:00');
INSERT INTO WalkIn VALUES ('O0000003', 'Walk-in', '12:00:00');

-- Pickup Table
CREATE TABLE Pickup(
	orderID				CHAR(8)			NOT NULL,
	type_				VARCHAR(10)		NOT NULL,		-- Type of order
	callAnswerTime		TIME			NOT NULL,
	callTerminatedTime	TIME			NOT NULL,
	hoax				VARCHAR(10)		DEFAULT 'Unverified',	-- If the phone call was legitimate
	pickupTime			TIME			NOT NULL,
	PRIMARY KEY(orderID, type_),	-- Primary key chosen to enforce mandatory or
	CHECK(hoax IN ('Verified', 'Unverified')),
	CHECK(type_ IN ('pickup')),
	FOREIGN KEY(orderID, type_) REFERENCES Order_(orderID, type_)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(callAnswerTime, callTerminatedTime) REFERENCES CallTime(callAnswerTime, callTerminatedTime)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO Pickup VALUES ('O0000004', 'Pickup', '11:30:00', '11:33:00', DEFAULT, '12:00:00');
INSERT INTO Pickup VALUES ('O0000005', 'Pickup', '12:30:00', '12:33:00', DEFAULT, '13:00:00');
INSERT INTO Pickup VALUES ('O0000006', 'Pickup', '13:30:00', '13:33:00', DEFAULT, '14:00:00');

-- Delivery Table
CREATE TABLE Delivery(
	orderID				CHAR(8)			NOT NULL,
	type_				VARCHAR(10)		NOT NULL,		-- Type of order
	callAnswerTime		TIME			NOT NULL,
	callTerminatedTime	TIME			NOT NULL,
	hoax				VARCHAR(10)		DEFAULT 'Unverified',	-- If the phone call was legitimate
	deliveryAddress		VARCHAR(200)	NOT NULL,
	deliveryTime		TIME			NOT NULL,
	shiftID				CHAR(8)			NOT NULL,
	PRIMARY KEY(orderID, type_),	-- Primary key chosen to enforce mandatory or
	CHECK(hoax IN ('Verified', 'Unverified')),
	CHECK(type_ IN ('Delivery')),
	FOREIGN KEY(orderID, type_) REFERENCES Order_(orderID, type_)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(shiftID) REFERENCES DeliveryShift(shiftID)
		ON UPDATE NO ACTION ON DELETE NO ACTION,		-- ON UPDATE NO ACTION to prevent cycles
	FOREIGN KEY(callAnswerTime, callTerminatedTime) REFERENCES CallTime(callAnswerTime, callTerminatedTime)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO Delivery VALUES ('O0000007', 'Delivery', '11:30:00', '11:33:00', DEFAULT, '314 Lowland Drive', '12:00:00', 'SH000004');
INSERT INTO Delivery VALUES ('O0000008', 'Delivery', '12:30:00', '12:33:00', DEFAULT, '4018 Farland Avenue', '13:00:00', 'SH000005');
INSERT INTO Delivery VALUES ('O0000009', 'Delivery', '13:30:00', '13:33:00', DEFAULT, '187 Baker Avenue', '14:00:00', 'SH000006');

-- QOrderMenuItem Table
CREATE TABLE QOrderMenuItem(
	orderID		CHAR(8)		NOT NULL,		-- Order consisting of item/s
	type_		VARCHAR(10)	NOT NULL,		-- Type of order
	itemCode	CHAR(8)		NOT NULL,
	quantity	INT			NOT NULL,		-- Quantity of items in the order
	PRIMARY KEY(orderID, type_, itemCode, quantity),
	FOREIGN KEY(orderID, type_) REFERENCES Order_(orderID, type_)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY(itemCode) REFERENCES MenuItem(itemCode)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO QOrderMenuItem VALUES ('O0000001','Walk-in', 'M0000001', 3);
INSERT INTO QOrderMenuItem VALUES ('O0000002','Walk-in', 'M0000002', 3);
INSERT INTO QOrderMenuItem VALUES ('O0000003','Walk-in', 'M0000003', 5);
INSERT INTO QOrderMenuItem VALUES ('O0000004','Pickup', 'M0000001', 3);
INSERT INTO QOrderMenuItem VALUES ('O0000005','Pickup', 'M0000002', 3);
INSERT INTO QOrderMenuItem VALUES ('O0000006','Pickup', 'M0000003', 3);
INSERT INTO QOrderMenuItem VALUES ('O0000007','Delivery', 'M0000001', 2);
INSERT INTO QOrderMenuItem VALUES ('O0000008','Delivery', 'M0000002', 3);
INSERT INTO QOrderMenuItem VALUES ('O0000009','Delivery', 'M0000003', 3);

-- Cash Table
CREATE TABLE Cash(
	paymentID		CHAR(8)		PRIMARY KEY,
	paymentMethod	CHAR(4)		NOT NULL,
	orderID			CHAR(8)		NOT NULL,		-- Order paid for
	type_			VARCHAR(10)	NOT NULL,		-- Type of order
	CHECK(paymentMethod IN ('Cash')),
	FOREIGN KEY(orderID, type_) REFERENCES Order_(orderID, type_)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO Cash VALUES ('P0000001', 'Cash', 'O0000001', 'Walk-in');
INSERT INTO Cash VALUES ('P0000002', 'Cash', 'O0000003', 'Walk-in');
INSERT INTO Cash VALUES ('P0000003', 'Cash', 'O0000005', 'Pickup');
INSERT INTO Cash VALUES ('P0000004', 'Cash', 'O0000007', 'Delivery');
INSERT INTO Cash VALUES ('P0000005', 'Cash', 'O0000009', 'Delivery');

-- Card Table
CREATE TABLE Card_(
	paymentID			CHAR(8)		PRIMARY KEY,
	paymentApprovalID	CHAR(8)		NOT NULL,
	paymentMethod		CHAR(4)		NOT NULL,
	orderID				CHAR(8)		NOT NULL,		-- Order paid for
	type_				VARCHAR(10)	NOT NULL,		-- Type of order
	CHECK(paymentMethod IN ('Card')),
	FOREIGN KEY(orderID, type_) REFERENCES Order_(orderID, type_)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

INSERT INTO Card_ VALUES ('P0000006', 'PA000001', 'Card', 'O0000002', 'Walk-in');
INSERT INTO Card_ VALUES ('P0000007', 'PA000002', 'Card', 'O0000004', 'Pickup');
INSERT INTO Card_ VALUES ('P0000008', 'PA000003', 'Card', 'O0000006', 'Pickup');
INSERT INTO Card_ VALUES ('P0000009', 'PA000004', 'Card', 'O0000008', 'Delivery');

go

--SQL STATMENTS

-- Question 1
-- For an in-office staff with id number xxx, print his/her 1stname, lname, and hourly payment rate.
SELECT	fName, lName, paymentRate
FROM	Instore
WHERE	staffID = 'S0000001';

-- Question 2
-- List all the shift details of a delivery staff with first name xxx and last name ttt between date yyy and zzz.
SELECT	s.*
FROM	DeliveryShift s, Driver d
WHERE	s.staffID = d.staffID
	AND d.fName = 'Ethan'
	AND d.lName = 'Boyle'
	AND s.startDate BETWEEN '2019-04-01' AND '2019-12-31'
	AND s.endDate BETWEEN '2019-04-01' AND '2019-12-31';

-- Question 3
-- List all the order details of the orders that are made by a walk-in customer with first name xxx and last name ttt between date yyy and zzz.
SELECT	w.*
FROM	WalkIn w, Customer c
WHERE	w.customerID = c.customerID
	AND c.fName = 'Kevin'
	AND c.lName = 'Smith'
	AND w.dateOfOrder BETWEEN '2019-04-01' AND '2019-12-31';

-- Question 4
-- Print the salary paid to a delivery staff with first name xxx and last name ttt in current month. Note the current month is the current month that is decided by the system.

SELECT	SUM(p.totalDeliveriesPaid * p.ratePerDelivery) AS Salary
FROM	DriverPayment p, Driver d
WHERE	p.staffID = d.staffID
	AND d.fName = 'Ethan'
	AND d.lName = 'Boyle'
	AND MONTH(p.paymentDate) = MONTH(GETDATE());

-- Question 5
-- List the name of the menu item that is mostly ordered in current year.

SELECT	m.name_
FROM	MenuItem m, QOrderMenuItem o
WHERE	m.itemCode = o.itemCode
	AND SUM(o.quantity) = MAX(
			SELECT SUM(quantity)
			FROM QOrderMenuItem
			WHERE orderID IN (
				SELECT orderID
				FROM Order_
				WHERE YEAR(dateOfOrder) = YEAR(GETDATE())
			)
			GROUP BY itemCode
		);

-- Question 6
-- List the name(s) of the ingredient(s) that was/were supplied by the supplier with supplier ID xxx on date yyy.

SELECT	i.name_
FROM	Supplier s, Ingredient i, IngredientOrder o, QIngredientOrderIngredient q
WHERE	q.ingredientID = i.ingredientID
	AND q.ingredientOrderID = o.ingredientOrderID
	AND s.supplierID = o.supplierID
	AND s.supplierID = 'SU000001'
	AND o.dateReceived = '2019-02-04';

*/