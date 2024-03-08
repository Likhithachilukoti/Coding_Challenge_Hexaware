create database Virtual_Art_Gallery;
use Virtual_Art_Gallery

-- Create the Artists table
CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));

-- Create the Categories table
CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);

-- Create the Artworks table
CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

-- Create the Exhibitions table
CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);

-- Create a table to associate artworks with exhibitions
CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

 -- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

-- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');

-- Insert sample data into the Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picassos powerful anti-war mural.', 'guernica.jpg');

-- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2); select * from Artists select * from Artworks select * from Categories select * from ExhibitionArtworks select * from Exhibitions ------1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks.---- select a.name,count(aw.ArtworkID) as [Artwork count] from Artists a left join Artworks aw on a.ArtistID=aw.ArtistID group by a.name,aw.ArtworkID order by count(aw.ArtworkID) desc ---2. List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order them by the year in ascending order.----- select aw.title,aw.year,a.Nationality from Artworks aw join  Artists a on a.ArtistID=aw.ArtistID where a.Nationality in ('Spanish','Dutch') order by aw.Year
----- 3. Find the names of all artists who have artworks in the 'Painting' category, and the number of artworks they have in this category.----select a.Name, COUNT(aw.ArtworkID) AS [Painting Count]
FROM Artists a
join 
Artworks aw
on a.ArtistID = aw.ArtistID
join
Categories c
on aw.CategoryID = c.CategoryID
WHERE c.Name = 'Painting'
GROUP BY a.Name

------4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories.-------
select a.Name as [artist name],aw.Title, c.Name as Categories
from Artworks aw
join 
ExhibitionArtworks eaw
on aw.ArtworkID = eaw.ArtworkID
join 
Exhibitions e
on eaw.ExhibitionID = e.ExhibitionID
join 
Artists a on aw.ArtistID =a.ArtistID
join 
Categories c on aw.CategoryID = c.CategoryID
where e.Title = 'Modern Art Masterpieces'
-----5. Find the artists who have more than two artworks in the gallery---select a.name from Artists ajoin Artworks awon a.ArtistID=aw.ArtistIDgroup by a.namehaving count(aw.ArtistID)>2

--6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions
select aw.Title from Artworks aw
join ExhibitionArtworks ea1 ON aw.ArtworkID = ea1.ArtworkID
join Exhibitions e1 ON ea1.ExhibitionID = e1.ExhibitionID
join ExhibitionArtworks ea2 ON aw.ArtworkID = ea2.ArtworkID
join Exhibitions e2 ON ea2.ExhibitionID = e2.ExhibitionID
where e1.Title = 'Modern Art Masterpieces' AND e2.Title = 'Renaissance Art';

--------7. Find the total number of artworks in each category-----
select c.Name, COUNT(aw.ArtworkID) as ArtworkCount
from Categories c
left join Artworks aw
on c.CategoryID = aw.CategoryID
GROUP BY c.Name

--------8. List artists who have more than 3 artworks in the gallery.------select a.name from Artists ajoin Artworks awon a.ArtistID=aw.ArtistIDgroup by a.namehaving count(aw.ArtistID)>3------9. Find the artworks created by artists from a specific nationality (e.g., Spanish)-----select aw.Title,a.Name as [artist name]
from Artworks aw
join
Artists a
on aw.ArtistID = a.ArtistID
where a.Nationality = 'Spanish';

-----10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.------
select e.Title from Exhibitions e
join ExhibitionArtworks ea1 ON e.ExhibitionID = ea1.ExhibitionID
join Artworks a1 ON ea1.ArtworkID = a1.ArtworkID
join Artists ar1 ON a1.ArtistID = ar1.ArtistID
join ExhibitionArtworks ea2 ON e.ExhibitionID = ea2.ExhibitionID
join Artworks a2 ON ea2.ArtworkID = a2.ArtworkID
join Artists ar2 ON a2.ArtistID = ar2.ArtistID
where ar1.Name = 'Vincent van Gogh' AND ar2.Name = 'Leonardo da Vinci';

-----11. Find all the artworks that have not been included in any exhibition.----------
select aw.Title from Artworks aw
left join 
ExhibitionArtworks eaw
on aw.ArtworkID = eaw.ArtworkID
WHERE eaw.ArtworkID IS NULL

-----12. List artists who have created artworks in all available categories.--------select a.Name from Artists a
join
Artworks aw 
on a.ArtistID = aw.ArtistID
group by a.ArtistID,a.Name
having count(distinct aw.CategoryID) = (select count(Distinct CategoryID) from Categories)

-----13. List the total number of artworks in each category.-------
select c.Name, COUNT(aw.ArtworkID) as ArtworkCount
from Categories c
left join Artworks aw
on c.CategoryID = aw.CategoryID
group by c.Name

-----14. Find the artists who have more than 2 artworks in the gallery----------
select a.name from Artists a
join 
Artworks aw
on a.ArtistID=aw.ArtistID
group by a.ArtistID,a.Name
having count(a.ArtistID)>2

------15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.-----
select c.Name, avg(aw.Year) as AverageYear
from Categories c
join
Artworks aw
on c.CategoryID = aw.CategoryID
group by c.Name
having count(aw.ArtworkID) > 1

------16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.--------
select aw.Title from Artworks aw
join
ExhibitionArtworks eaw
on aw.ArtworkID = eaw.ArtworkID
join
Exhibitions e
on eaw.ExhibitionID = e.ExhibitionID
where e.Title = 'Modern Art Masterpieces'
------17. Find the categories where the average year of artworks is greater than the average year of all artworks.------select c.Name from Categories c
join
Artworks aw
on c.CategoryID = aw.CategoryID
group by c.CategoryID,c.Name
having avg(aw.Year) > (select avg(Year) from Artworks)
------18. List the artworks that were not exhibited in any exhibition.------select aw.Title from Artworks aw
left join
ExhibitionArtworks eaw
on aw.ArtworkID = eaw.ArtworkID
where eaw.ArtworkID IS NULL;
------19. Show artists who have artworks in the same category as "Mona Lisa."--------
select a.name from Artists a
join
Artworks aw
on a.ArtistID=aw.ArtistID
where aw.Title='Mona Lisa' and a.Name <> 'Leonardo da Vinci'

------20. List the names of artists and the number of artworks they have in the gallery.-------
select a.Name, count(aw.ArtworkID) as [number of artworks]
from Artists a
join
Artworks aw
on a.ArtistID = aw.ArtistID
group by a.Name
