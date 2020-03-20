-- Create empty table with column names
create table [BorderData].[dbo].[Border_Crossing_Entry_Data] (
	Port_Name nvarchar(50),
	State nvarchar(50),
	Port_Code int,
	Border nvarchar(50),
	Date datetime2(7),
	Measure nvarchar(50),
	Value int,
	Location nvarchar(50)
)ON [PRIMARY]
GO

-- Import CSV file into empty table
BULK INSERT [BorderData].[dbo].[Border_Crossing_Entry_Data]
    FROM './input/Border_Crossing_Entry_Data.csv'
    WITH
    (
    FIRSTROW = 2, -- skip 1st row of column names
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n', -- determines next row of data in table
    TABLOCK
    )

-- Duplicate Border_Crossing_Entry_Data as new table called "DataCopy" and insert all the values/rows
select t. *
  into BorderData.dbo.DataCopy
  from BorderData.dbo.Border_Crossing_Entry_Data t

-- Select key columns and compute the sum
select Border,Date,Measure,sum(Value) as Sum from BorderData.dbo.DataCopy
group by Border, Date, Measure
order by Date desc

-- Script new select statement to grab columns and compute both the sum and a 2-month moving average
select Border,Date,Measure,sum(Value) as Sum , Avg(Sum(Value)) over
(partition by Measure order by Date rows between 1 preceding and current row) as Average from BorderData.dbo.DataCopy
group by Date, Border, Measure
order by Date desc;

-- Output the select statement above to a CSV file using the "sqlcmd" utility
sqlcmd -S . -d BorderData.dbo.DataCopy -E -s',' -W -Q "select Border,Date,Measure,sum(Value) as Sum , Avg(Sum(Value)) over (Partition by Measure order by Date rows between 1 preceding and current row) as Average from BorderData.dbo.DataCopy
group by Date, Border, Measure order by Date desc;" > C:\Users\Matt\Desktop\output.csv

