USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'COMP3350UniversityDB'
)
CREATE DATABASE COMP3350UniversityDB
GO
--Create Tables Below once confirmation of finality of Sections 1 & 2