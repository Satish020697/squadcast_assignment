
CREATE TABLE movies (id int(4) NOT NULL PRIMARY KEY, 
title varchar(255) NOT NULL, 
year int(4) NOT NULL, 
country varchar(255) NOT NULL, 
genre varchar(255) NOT NULL, 
director varchar(255) NOT NULL, 
minutes int(4) NOT NULL, 
poster varchar(255) NOT NULL);


CREATE TABLE ratings (rater_id int(7) NOT NULL, 
movie_id int(4) NOT NULL,
rating int(2) NOT NULL, 
time int(10) NOT NULL 
ADD CONSTRAINT FK_ratings 
FOREIGN KEY(movie_id) REFERENCES movies(id));


-- IMPORTING DATA FILES TO POSTGRES TABLE FROM LOCAL FILE SYSTEM

COPY movies(first_name, last_name, dob, email)
FROM 'E:\movies_csv\movies.csv'
DELIMITER '|'
CSV HEADER;

COPY ratings(first_name, last_name, dob, email)
FROM 'E:\movies_csv\ratings.csv'
DELIMITER '|'
CSV HEADER;


-----------------------------------------------------------------------------------------------------------------------

a. Top 5 Movie Titles: Sort and print the top 5 movie titles based on the following criteria:
● Duration
● Year of Release
● Average rating (consider movies with minimum 5 ratings)
● Number of ratings given

SELECT title, year, AVG(rating) AS avg_rating, COUNT(rating) AS total_rating
FROM movies, ratings
WHERE movies.id = ratings.movie_id AND rating >= 5
ORDER BY avg_rating DESC LIMIT 5;


-----------------------------------------------------------------------------------------------------------------------

b. Number of Unique Raters: Determine and print the count of unique rater IDs.

SELECT COUNT(DISTINCT rater_id) FROM ratings

-----------------------------------------------------------------------------------------------------------------------

c. Top 5 Rater IDs: Sort and print the top 5 rater IDs based on:
● Most movies rated
● Highest Average rating given (consider raters with min 5 ratings)

SELECT rater_id, COUNT(DISTINCT movie_id) AS movies_rated, AVG(rating) AS avg_rating  FROM ratings 
WHERE rating >= 5
GROUP BY rater_id
ORDER BY movies_rated DESC
LIMIT 5;

--> FOR EACH RATER_ID DISTINCT MOVIES RATED WITH AVERAGE RATING GIVEN SORTED BY MOST NUMBER OF MOVIES RATED BY RATER_ID IN DESCENDING ORDER.
-----------------------------------------------------------------------------------------------------------------------

d. Top Rated Movie:
- Find and print the top-rated movies by:
● Director 'Michael Bay',
● 'Comedy',
● In the year 2013
● In India (consider movies with a minimum of 5 ratings).

SELECT title, AVG(rating) AS rated, COUNT(DISTINCT movie_id) AS movies_rated, director, genre, year, country
FROM movies, ratings
WHERE movies.id = ratings.movie_id AND director = 'Michael Bay' AND year = 2013 AND rating >= 5
GROUP BY title, director, genre, year, country
HAVING country = 'India' AND genre = 'Comedy'
ORDER BY movies_rated, rated DESC;

ASSUMPTION => CONSIDERING THE FACT THAT COUNTRY AND GENRE COLUMN HAS MULTIPLE VALUES STORED
SO THAT MOVIE COULD BE VIEWED IN INDIA AS WELL AS IN OTHER COUNTRY AS WELL.
TAKEN ALSO THE TOTAL COUNT OF THE RATING FOR STREAMLINING THE ORDER OF LISTING.

-----------------------------------------------------------------------------------------------------------------------

e. Favorite Movie Genre of Rater ID 1040: Determine and print the favorite movie genre
for the rater with ID 1040 (defined as the genre of the movie the rater has rated most often).

SELECT rater_id, genre, COUNT(DISTINCT genre) AS total_rating FROM ratings, movies
WHERE ratings.movie_id = movies.id AND rater_id = 1040 
ORDER BY rated_genre DESC
LIMIT 1;

-----------------------------------------------------------------------------------------------------------------------

f. Highest Average Rating for a Movie Genre by Rater ID 1040: Find and print the
highest average rating for a movie genre given by the rater with ID 1040 (consider genres with a
minimum of 5 ratings).

SELECT rater_id, genre, AVG(rating) AS avg_rating FROM ratings, movies
WHERE ratings.movie_id = movies.id AND rater_id = 1040 AND rating >= 5
GROUP BY genre
ORDER BY avg_rating DESC
LIMIT 1;

-----------------------------------------------------------------------------------------------------------------------

g. Year with Second-Highest Number of Action Movies: Identify and print the year with
the second-highest number of action movies from the USA that received an average rating of 6.5 or higher and had a runtime of less than 120 minutes.

SELECT year, COUNT(title) AS total_movies, AVG(rating) AS avg_rating FROM movies, ratings
WHERE ratings.movie_id = movies.id AND avg_rating >= 6.5 AND minutes < 120
HAVING genre = 'Action' 
LIMIT 1,1;


-----------------------------------------------------------------------------------------------------------------------

h. Count of Movies with High Ratings: Count and print the number of movies that have
received at least five reviews with a rating of 7 or higher.

SELECT COUNT(title) FROM ratings, movies
WHERE ratings.movie_id = movies.id AND (SELECT COUNT(rating) AS total_rating FROM ratings GROUP BY title) >= 5 AND rating >= 7;

-----------------------------------------------------------------------------------------------------------------------