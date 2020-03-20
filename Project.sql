-- Data imported successfully as new schema called "Sheet1$". This was achieved by creating new database, "Project", and then inserting data from Excel file.
-- Duplicate Sheet1$ as new table called "Feedback"
CREATE TABLE [dbo].[Feedback](
	[RequestID] [nvarchar] NULL,
	[Category] [nvarchar](255) NULL,
	[CreatedTime] [datetime] NULL,
	[RequestStatus] [nvarchar](255) NULL,
	[CompletedTime] [datetime] NULL,
	[SubCategory] [nvarchar](255) NULL,
	[ElapsedTime] [datetime] NULL,
	[BUEntity] [nvarchar](255) NULL
) ON [PRIMARY]
GO

-- Insert all the values/rows
SELECT t. *
  INTO dbo.Feedback
  FROM dbo.Sheet1$ t

-- Replace hyphens in BUEntity with NAs
UPDATE Feedback
SET [BUEntity] = REPLACE([BUEntity],'-','NA')
WHERE [BUEntity] like '%-%'

--Create procedure in case a variable's dashes need to be replaced with NA. In this case it's the time variable.
CREATE PROCEDURE dbo.ElapsedTimeReplace AS
BEGIN
UPDATE [Project].[dbo].[Feedback]
SET [Project].[dbo].[Feedback].[ElapsedTime] = REPLACE([Project].[dbo].[Feedback].[ElapsedTime],'-','NA')
WHERE [BUEntity] like '%-%'
END
GO
EXEC ElapsedTimeReplace

-- Questions
-- 1. What is the most popular Sub Category the inbox receives in a given week?
CREATE VIEW SubCategorybyWeek AS
SELECT TOP (5)
  [SubCategory]
FROM
  [Project].[dbo].[Feedback]
GROUP BY
  [SubCategory]
ORDER BY
  COUNT([SubCategory]) DESC
-- Test out view
SELECT * FROM [SubCategorybyWeek]; 
-- Product Questions is most popular, aside from Not Assigned


-- 2. On average, how long does it take for each email to be addressed – that is, how long does it take for an action to be taken, and what can be inferred by this?
SELECT cast(avg(cast([ElapsedTime] as float))as datetime) AvgTime
FROM [Project].[dbo].[Feedback]
-- this is what the average of the cast looks like, but I can't interpret it without converting back to datetime:
SELECT cast([ElapsedTime] as float)
FROM [Project].[dbo].[Feedback]
-- Update ElapsedTime column by converting values from datetime to time
CREATE VIEW ElapsedTimeView as
  SELECT CONVERT(char(5), [ElapsedTime], 108) AS ElapsedTimeFix
  FROM [Project].[dbo].[Feedback]
 SELECT * FROM [ElapsedTimeView]; 
-- Create new table with converted ElapsedTime
SELECT CAST([ElapsedTime] AS time) AS ElapsedTimeFix INTO [Project].[dbo].[ElapsedTime] FROM [Project].[dbo].[Feedback] AS ElapsedTime
--DROP TABLE [Project].[dbo].[ElapsedTime]
--Now replace the old ElapsedTime column in feedback with the converted time in the ElapsedTime table
UPDATE [Project].[dbo].[Feedback] SET [Project].[dbo].[Feedback].[ElapsedTime]=[Project].[dbo].[ElapsedTime].[ElapsedTimeFix]
FROM [Project].[dbo].[Feedback]
JOIN [Project].[dbo].[ElapsedTime] on ([Project].[dbo].[Feedback].[ElapsedTime]=[Project].[dbo].[ElapsedTime].[ElapsedTimeFix])


-- 3. What types of relationships exist in the data? For example, is there a relationship between BU-Entity and Sub Category? What about BU-Entity and Elapsed Time?
-- What are the most popular BU Entities?
SELECT TOP (5)
  [BUEntity]
FROM
  [Project].[dbo].[Feedback]
GROUP BY
  [BUEntity]
ORDER BY
  COUNT([BUEntity]) DESC
-- OBU (optics business unit) is the most popular
-- How many tasks were completed in this time period?
SELECT COUNT([ElapsedTime])
FROM [Project].[dbo].[Feedback]
-- 1090 tickets were completed








-- Crap code
CREATE PROCEDURE dbo.YearTimeConvert(@variable datetime) AS
BEGIN
DECLARE
	@newtime TIME
SELECT @newtime = CAST(@variable as TIME) FROM [Project].[dbo].[Feedback] WHERE @variable = [Project].[dbo].[Feedback].[ElapsedTime]
END
BEGIN

EXEC YearTimeConvert [ElapsedTime]
--DROP FUNCTION  dbo.YearTimeConvert