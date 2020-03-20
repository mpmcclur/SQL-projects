CREATE TABLE Studio (
	StudioID int primary key not null,
	StudioName char(50) not null
);

CREATE TABLE Film (
	FilmID int primary key not null,
	Title char(50) not null,
	StudioID int FOREIGN KEY REFERENCES Studio(StudioID) not null
);

CREATE TABLE Actor (
	ActorID int primary key not null,
	FirstName char(30) not null,
	LastName char(30) not null,
	DOB datetime
);


CREATE TABLE FilmCast (
	FilmCastID int primary key not null,
	FilmID int FOREIGN KEY REFERENCES Film(FilmID) not null,
	ActorID int FOREIGN KEY REFERENCES Actor(ActorID) not null
);

SELECT
[Lab10].[dbo].[Film].[Title]
, [Lab10].[dbo].[Actor].[FirstName] + ' ' + [Lab10].[dbo].[Actor].[LastName] as ActorName
FROM [Lab10].[dbo].[FilmCast]
INNER JOIN [Lab10].[dbo].[Film] ON [Lab10].[dbo].[Film].[FilmID] = [Lab10].[dbo].[FilmCast].[FilmID]
INNER JOIN [Lab10].[dbo].[Actor] ON [Lab10].[dbo].[Actor].[ActorID] = [Lab10].[dbo].[FilmCast].[ActorID]