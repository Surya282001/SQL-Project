use imdb;

/*1.Find the total number of rows in each table of the schema */

Select 'director_mapping' As TableName,  count(*) as TotalRows
From Director_mapping
Union All
Select 'Genre',count(*)
From Genre
Union All
Select 'Movie',count(*)
From Movie
Union All
Select 'Names',count(*)
From Names
Union All
Select 'Ratings',count(*)
From Ratings
Union All
Select 'Role_Mapping',Count(*)
From Role_Mapping;

/*2.Which columns in the movie table have null values? */

Select 'Country' As ID, count(*) as count From movie
where Country is Null
Union All
select 'Date_published', Count(*) from Movie
where Date_published is null
Union All
Select 'Duration',count(*) From Movie
Where Duration is null
Union All
Select 'ID',count(*) From Movie
Where ID is Null
Union All
Select 'Languages',Count(*) From Movie
Where Languages is null
Union All
Select 'Production_Company',count(*) From Movie
Where Production_Company is Null
Union All
Select 'Title',count(*) From Movie
Where Title is Null
Union ALL 
Select 'Worlwide_Gross_Income',count(*) From Movie
Where Worlwide_Gross_Income is null
Union All
Select 'Year',count(*) from Movie
Where year is Null;

/*3.Find the total number of movies released each year. How does the trend look month-wise?*/

Select  Year(Date_published)as year,count(*) as Total_Movies
From Movie
Group by Year(Date_published)
Order by Year(Date_published);

Select  Month(Date_published)as Month,count(*) as Total_Movies
From Movie
Group by Month(Date_published)
Order by Month(Date_published);

/*4.How many movies were produced in the USA or India in the year 2019?*/

Select Year,Country,Count(*)as Total_Movies
From Movie
Where country in('India','USA') And Year='2019'
group by country
Order by country;

/*5.Find the unique list of genres present in the dataset and how many movies belong to only one genre.*/

Select distinct Genre
From genre;
Use imdb;


SELECT COUNT(movie_id) AS Single_genre_movies
FROM (Select movie_id
from genre
GROUP BY movie_id
HAVING COUNT(genre) = 1) As Single_genre_movies;


/*6.Which genre had the highest number of movies produced overall?*/

Select Genre,count(movie_id) as NUMBEROFMOVIES
FROM GENRE
group by Genre
order by NUMBEROFMOVIES desc LIMIT 1 ;

/*7.What is the average duration of movies in each genre?*/

Select g.genre,Avg(duration) as Avg_duration
From Movie m
Join genre g on m.id=g.movie_id
group by g.genre
order by Avg_duration desc;
        
        
/*8.Identify actors or actresses who have worked in more than three movies with an average rating below 5?*/
use imdb;

SELECT n.name, COUNT(r1.movie_id) AS Low_rated_movies
FROM names n
join role_mapping r1 on r1.name_id=n.id
join ratings r2 on r2.movie_id=r1.movie_id
where r2.Avg_rating<5
group by r1.name_id
Having count(r1.movie_id)>3
order by Low_Rated_Movies Desc;

/*9.Find the minimum and maximum values in each column of the ratings table except the movie_id column.*/

Select
	min(avg_rating) As Min_Rating,
    max(avg_rating) As Max_Rating,
    min(Total_Votes) As Min_Votes,
    Max(Total_Votes) As Max_Votes,
    min(Median_Rating) As Min_median_rating,
	max(Median_Rating) As Max_median_rating
From Ratings;
    
/*10.Which are the top 10 movies based on average rating?*/

Select m.title,Avg(avg_rating) as Avg_Rating
        from Ratings r
		 left Join movie m
        on m.id=r.movie_id
        group by m.title
        order by Avg_Rating desc limit 10;

/*11.	Summarise the ratings table based on the movie counts by median ratings.*/

Select median_rating, count(movie_id) As moviecounts
from Ratings
Group by  median_rating
Order by  median_rating ASC;


/*12.	How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?*/

SELECT g.genre,COUNT(m.id) AS movie_count
FROM movie m
 left join genre g
	ON m.id = g.movie_id
 left  join ratings r
    ON m.id = r.movie_id
WHERE m.country = 'USA'
    AND m.Date_published BETWEEN '2017-03-01' AND '2017-03-31'
    And r.total_votes > 1000
GROUP BY g.genre
Order by movie_count desc;


/*13.	Find movies of each genre that start with the word ‘The ’ and which have an average rating > 8.*/


SELECT g.genre, m.title, r.avg_rating AS avg_rating
FROM genre g
JOIN movie m on m.id=g.movie_id
JOIN Ratings r on r.movie_id=m.id 
WHERE 
    m.title LIKE 'The %' and 
    r.avg_rating > 8
   order by g.genre;



/*14.Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?*/
	
SELECT count(*)  AS TOTALMOVIES
FROM ratings r
JOIN movie m ON r.movie_id = m.id
WHERE m.Date_Published BETWEEN '2018-04-01' AND '2019-04-01'
and r.median_rating=8
order by totalmovies;

use imdb;

/*15.Do German movies get more votes than Italian movies?*/

SELECT m.country,SUM(r.total_votes) AS total_votes
FROM movie m
Left JOIN 
    Ratings r ON m.id = r.movie_id
WHERE m.country IN ('Germany', 'Italy')
GROUP BY m.country
ORDER BY total_votes DESC;

/*16.	Which columns in the names table have null values?*/
Select 'id' as id,count(*) As null_id
from names
where id is null
union all
Select 'name',count(*) As null_id
from names
where name is null
union all
Select 'Height',count(*) As null_id
from names
where height is null
union all
Select 'Date_of_birth',count(*) As null_id
from names
where Date_of_birth is null
union all
Select 'Known_for_movies',count(*) As null_id
from names
where Known_for_movies is null;

/*17.	Who are the top two actors whose movies have a median rating >= 8?*/
Select n.name,count(*) as totalmovies
from names n
join role_mapping ro on ro.name_id=n.id
join ratings ra on ra.movie_id=ro.movie_id
where ro.category='actor' and ra.median_rating>=8
Group by n.name
order by totalmovies DESC limit 2;

/*18.	Which are the top three production houses based on the number of votes received by their movies?*/

SELECT m.production_company, 
SUM(total_votes) AS totalvotes
FROM movie m
JOIN ratings r on r.movie_id=m.id
GROUP BY m.production_company
ORDER BY totalvotes DESC limit 3;


/*19.How many directors worked on more than three movies?*/

Select n.name,count(n.id) As total_movies
from names n
join director_mapping d on d.name_id=n.id
group by n.name
having count(d.movie_id)>3
order by total_movies DESC ;

/*20.	Find the average height of actors and actresses separately.*/

select r.category,avg(n.height)as avgheight
from role_mapping r
join names n on r.name_id=n.id
group by  r.category
order by avgheight DESC;

/*21.	Identify the 10 oldest movies in the dataset along with its title, country, and director.*/

Select m.title,m.country,n.name As director_name,date_published
from movie m
join director_mapping d on d.movie_id=m.id
join names n on n.id=d.name_id
order by m.date_published ASC, m.country limit 10;

/*22.	List the top 5 movies with the highest total votes and their genres.*/

Select m.title,g.genre,r.total_votes
from movie m
join genre g on g.movie_id=m.id
join ratings r on r.movie_id=g.movie_id
order by genre, total_votes DESC limit 5;

/*23.	Find the movie with the longest duration, along with its genre and production company*/

Select m.title,m.duration,g.genre,m.production_company
from movie m
join genre g on g.movie_id=m.id
order by  duration desc limit 1;

/*24.	Determine the total votes received for each movie released in 2018.*/

Select m.title,sum(r.total_votes) As total_votes
from movie m
join ratings r on r.movie_id=m.id
where m.year=2018
group by m.title
order by total_votes DESC;
 

/*25.	Find the most common language in which movies were produced.*/

SELECT languages, COUNT(*) AS Total_movies
FROM movie
GROUP BY languages
ORDER BY Total_movies DESC
LIMIT 1;
