--Below are scripts in T-SQL demonstrating elementary use of clauses, procedures, etc.


CREATE TABLE Bookshelf (
	BookshelfID int primary key,
	Bookshelf int,
	ShelfNumber varchar(30)
);

CREATE TABLE Book (
	BookID int identity primary key,
		Title	varchar(100),
		ISBN varchar(100),
		PublishDate varchar(100),
		PublisherID int,
);

INSERT INTO Book (Title, ISBN, PublishDate, PublisherID)
VALUES ('Murachs SQL Server 2012 for Developers','9781880774691','17/12/2015','1'),
('Modern Database Management, 12th ed.','9780273779285','17/1/2016','2'),
('Networks: An Introduction','9780199206650','17/2/2016','3'),
('Information Now','9780226085681','17/3/2016','4'),
('Animal','9781623582101','17/4/2016','5')
GO

-- DELETE WHERE EXISTS FROM Book
--	WHERE BookID=10;
INSERT INTO Bookshelf (BookshelfID, Bookshelf, Shelfnumber)
VALUES
	('1','1','1')
	, ('2','2','2')
	, ('3','3','3')
	, ('4','4','Office')
	, ('5','5', 'Family Room')
GO

CREATE TABLE Author (
	AuthorID int,
		Forename char (30),
		SurName	char(30),
		LOCName char(30),
);


INSERT INTO Author (AuthorID, Forename, SurName, LOCName)
VALUES			    ('1','Bryan', 'Syverson', 'Bryan Syverson'),
				('2','Joel', 'Murach', 'Joel Murach')


CREATE TABLE Publisher (
	PublisherID int identity primary key,
		PublisherName varchar(100),
		PublisherAddress varchar(100)
);

INSERT INTO Publisher (PublisherName,PublisherAddress)
VALUES ('Mike Murach & Associates','100 Center Road, NY, NY 90210'),
('Pearson','20 Jump Street, Pittsburgh, PA 29281'),
('Oxford University Press','Eton College, Oxford University, Oxford, England'),
('The University of Chicago Press','Chicago, Il 10928'),
('HarperBusiness','Berkely, CA 91028')
GO

CREATE TABLE BookBookshelf (
	BookBookshelfID int identity PRIMARY KEY,
		BookshelfID int foreign key references Bookshelf(BookshelfID),
		BookID int foreign key references Book(BookID)
);
-- DROP IF EXISTS TABLE BookBookshelf

CREATE TABLE BookSubject (
	SubjectID int identity,
		SubjectText char(50),
		CONSTRAINT PK_BookSubject PRIMARY KEY (SubjectID)
);

CREATE TABLE BookBookSubject (
	BookBookSubjectID int identity primary key
	, BookID int FOREIGN KEY REFERENCES Book(BookID) not null
	, SubjectID int not null
	, CONSTRAINT fk_bbs_bs FOREIGN KEY (SubjectID) REFERENCES BookSubject(SubjectID)
)

ALTER TABLE Author
	ALTER COLUMN AuthorID int NOT NULL;
ALTER TABLE Author
	ALTER COLUMN Forename char (30) NOT NULL;
ALTER TABLE Author
	ALTER COLUMN SurName char(30) NOT NULL;
ALTER TABLE Author
	ALTER COLUMN LOCName char(30) NOT NULL;
ALTER TABLE Author
	ADD CONSTRAINT pk_Author PRIMARY KEY (AuthorID); 


CREATE TABLE BookAuthor (
	BookAuthorID int identity primary key
	, BookID int FOREIGN KEY REFERENCES Book(BookID)
	, AuthorID int FOREIGN KEY REFERENCES Author(AuthorID)
)


ALTER TABLE BookAuthor ADD
	CONSTRAINT uk_ba UNIQUE (BookID, AuthorID)


SELECT
	ForeName
	, Surname
	, LOCName
FROM Author

SELECT
	RTRIM(SurName) + ', ' + RTRIM(Forename) AS FullName
FROM Author

SELECT * FROM Bookshelf
SELECT ShelfNumber FROM Bookshelf

SELECT
	[* | column1, ..., columnN]
FROM
	Author


--Join
SELECT 
	Book.Title
	, Book.ISBN
	, Book.PublisherID
	, Publisher.PublisherName
FROM Book
JOIN Publisher ON Publisher.PublisherID = Book.PublisherID

--Update
--I don't have BookBookshelf table :(
SELECT * FROM Book
JOIN BookBookshelf on BookBookshelf.BookID = Book.BookID
JOIN Bookshelf on Bookshelf.BookshelfID = BookBookshelf.BookshelfID

UPDATE BookBookshelf SET BookshelfID = 2 WHERE BookBookshelfID = 3


SELECT * FROM Book

UPDATE Book SET PublishDate = '1/1/2012' WHERE BookID = 1
UPDATE Book SET PublishDate = '1/1/2013' WHERE BookID = 2
UPDATE Book SET PublishDate = '1/1/2013' WHERE BookID = 3
UPDATE Book SET PublishDate = '1/1/2010' WHERE BookID = 4
UPDATE Book SET PublishDate = '1/1/2015' WHERE BookID = 5
UPDATE Book SET PublishDate = '1/1/2013' WHERE BookID = 6

--Delete rows from database
SELECT * FROM Bookshelf
DELETE Bookshelf WHERE ShelfNumber = '3'
INSERT INTO Bookshelf (Bookshelf, ShelfNumber)
VALUES ('3','Dining Room')

-- JOIN types
SELECT
	Bookshelf.ShelfNumber
From Bookshelf

SELECT
	Bookshelf.ShelfNumber
	, BookBookshelf.*
	, Book.Title
FROM BookBookshelf
RIGHT JOIN Bookshelf on BookBookshelf.BookshelfID = Bookshelf.BookshelfID
RIGHT JOIN Book on Book.BookID = BookBookshelf.BookID

-- Views
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'ListBookshelfContents')
BEGIN
	DROP VIEW ListBookshelfContents
END
GO -- "go" says do everything that you've got queued, and then start a new batch
CREATE VIEW ListBookshelfContents AS
SELECT
	Bookshelf.ShelfNumber
	,BookBookshelf.*
	,Book.Title
FROM BookBookshelf
JOIN Bookshelf on BookBookshelf.BookshelfID = Bookshelf.BookshelfID
JOIN Book on Book.BookID = BookBookshelf.BookID

-- Functions
CREATE FUNCTION GetPublishYear (
	@bookid int
) RETURNS int
BEGIN
	DECLARE @PubYear int
	SELECT @PubYear = YEAR(Book.PublishDate) FROM Book WHERE BookID = @bookid
	RETURN @PubYear 
END

SELECT Title, dbo.GetPublishYear(BookID) AS PubYear FROM Book

SELECT * FROM Book
UPDATE Book SET PublishDate = '1/1/2012' WHERE BookID = 1
UPDATE Book SET PublishDate = '1/1/2013' WHERE BookID = 2
UPDATE Book SET PublishDate = '1/1/2010' WHERE BookID = 3
UPDATE Book SET PublishDate = '1/1/2015' WHERE BookID = 4
UPDATE Book SET PublishDate = '1/1/2011' WHERE BookID = 5

EXEC SetPublishDate 6, '1/1/2020'

UPDATE Book SET PublishDate = '1/1/2013' WHERE BookID = 6
GO

CREATE PROCEDURE SetPublishDate (
	@BookID int
	, @PublishDate datetime
) AS
BEGIN
	UPDATE Book SET PublishDate = @PublishDate WHERE BookID = @BookID
END




-- Security
-- Creating a guestuser database user
CREATE USER guestuser FOR LOGIN guestuser


-- Code Academy Crap
CREATE TABLE celebs (
   id INTEGER, 
   name TEXT, 
   age INTEGER
);

INSERT INTO celebs (id, name, age) 
	VALUES (1, 'Justin Bieber', 22),
	(2, 'Beyonce Knowles', 33),
	(3, 'Jeremy Lin', 26),
	(4, 'Taylor Swift', 26);

ALTER TABLE celebs 
ADD twitter_handle TEXT;

UPDATE celebs 
SET twitter_handle = '@taylorswift13' 
WHERE id = 4;

DELETE FROM celebs 
WHERE twitter_handle IS NULL;

DROP TABLE celebs;

CREATE TABLE celebs (
   id INTEGER PRIMARY KEY, 
   name TEXT,
   date_of_birth TEXT NOT NULL,
   date_of_death TEXT DEFAULT 'Not Applicable'
);

CREATE TABLE awards (
   id INTEGER PRIMARY KEY,
   recipient TEXT NOT NULL,
   award_name TEXT DEFAULT 'Grammy'
);


SELECT
	Bookshelf.ShelfNumber
	,BookBookshelf.*
	,Book.Title
FROM BookBookshelf
JOIN Bookshelf on BookBookshelf.BookshelfID = Bookshelf.BookshelfID
JOIN Book on Book.BookID = BookBookshelf.BookID
