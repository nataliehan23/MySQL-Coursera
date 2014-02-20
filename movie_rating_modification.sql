
-- SQL Movie-Rating Modification Exercises

-- 1.Add the reviewer Roger Ebert to your database, with an rID of 209.

INSERT INTO reviewer values (209, "Roger Ebert")

-- 2.Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.

INSERT INTO rating
SELECT rating.rid, movie.mid, 5, NUll
FROM reviewer
JOIN movie, rating
ON reviewer.rid = rating.rid
WHERE reviewer.name = "James Cameron"

-- 3. For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)

UPDATE movie
SET year = year+25
WHERE mid IN(
	SELECT m.mid
	FROM movie m
	JOIN rating ra
	ON m.mid = ra.mid
	GROUP BY ra.mid
	HAVING avg(ra.stars)>=4)

-- 4. Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.

DELETE FROM rating
WHERE mid IN(
	SELECT m.mid
	FROM rating ra
	JOIN movie m
	ON ra.mid = m.mid
	WHERE m.year > 2000 OR m.year < 1970)
AND stars<4
