-- SQL Movie-Rating Query Exercises (core set)

-- 1. Find the titles of all movies directed by Steven Spielberg. 

SELECT title 
FROM movie 
WHERE director = "Steven Spielberg" 

-- 2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

SELECT DISTINCT year 
FROM movie
JOIN rating
ON rating.mID = movie.mID
WHERE stars>3
ORDER BY year ASC;


-- 3. Find the titles of all movies that have no ratings. 

SELECT m.title 
FROM movie m
LEFT OUTER JOIN rating r
ON m.mID = r.mID
WHERE r.mID is NULL


-- 4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

SELECT re.name 
FROM Reviewer re 
JOIN Rating ra
ON re.rID = ra.rID
WHERE ra.ratingDate IS NULL

-- 5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 

SELECT re.name, m.title, ra.stars, ra.ratingdate
FROM movie m join reviewer re, rating ra
ON m.mID=Ra.mID AND re.rID=Ra.rID
ORDER BY re.name, m.title, ra.stars

-- 6.For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.  

SELECT re.name, m.title
FROM Reviewer re
JOIN movie m, rating ra
ON m.mID=ra.mID
AND re.rID = ra.rID
GROUP BY ra.rID, ra.mID
HAVING count(stars) = 2
ORDER BY ra.stars DESC
LIMIT 1;

-- 7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 

SELECT m.title, MAX(ra.stars)
FROM rating ra
JOIN movie m
ON m.mID = ra.mID
GROUP BY ra.mID
HAVING COUNT(ra.rid)>1
ORDER BY m.title ASC;

-- 8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title

SELECT title, (max(stars) - min(stars)) as spread
FROM movie join rating
ON movie.mid = rating.mid
GROUP BY rating.mid
ORDER BY spread DESC, title ASC;

-- 9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)


SELECT  avg(T1.r) - avg(T2.r)
FROM
	( SELECT m.title, AVG(ra.stars) as r
	  FROM movie m
	  JOIN rating ra
	  ON m.mID=ra.mID
	  GROUP BY ra.mID
	  HAVING m.year < 1980
	) T1,
	( SELECT m.title, AVG(ra.stars) as r
	  FROM movie m
	  JOIN rating ra
	  ON m.mID=ra.mID
	  GROUP BY ra.mID
	  HAVING m.year > 1980
	) T2