-- SQL Movie-Rating Query Exercises (extras)

-- 1. Find the names of all reviewers who rated Gone with the Wind. 

SELECT DISTINCT re.name
FROM reviewer re
JOIN movie m, rating ra
ON re.rID = ra.rID 
AND m.mID = ra.mID
WHERE m.title="Gone with the Wind"

-- 2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 

SELECT re.name, m.title, ra.stars
FROM movie m
JOIN rating ra, reviewer re
ON ra.rID=re.rID 
AND ra.mID = m.mID 
AND re.name = m.director

-- 3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 

SELECT * 
FROM
	(SELECT DISTINCT reviewer.name 
	 FROM reviewer
	 UNION ALL
	 SELECT DISTINCT movie.title 
	 FROM movie) a
ORDER BY 1 ASC

-- 4. Find the titles of all movies not reviewed by Chris Jackson. 

SELECT DISTINCT m.title
FROM movie m
WHERE m.mID NOT IN (
	SELECT ra.mid 
	FROM rating ra
	JOIN reviewer re
	ON re.rid = ra.rid 
	AND re.name="Chris Jackson")

-- another solution:

SELECT DISTINCT m.title
FROM movie m
LEFT OUTER JOIN
	(SELECT ra.mID as newID
	 FROM rating ra
	 JOIN reviewer re
	 ON ra.rid = re.rid 
	 AND re.name = "Chris Jackson") T
ON T.newID = m.mID
WHERE T.newID IS NULL

-- 5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.

SELECT DISTINCT re1.name, re2.name
FROM reviewer re1
JOIN reviewer re2, rating ra1, rating ra2
ON re1.rid = ra1.rid 
AND re2.rid = ra2.rid 
AND ra1.mid = ra2.mid
WHERE re1.name < re2.name

-- 6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.

SELECT re.name, m.title, T.s
FROM reviewer re
Join movie m, (
	SELECT ra.rID rn, ra.mID mn, ra.stars s
	FROM rating ra
	WHERE ra.stars IN 
		(SELECT min(stars) FROM rating)
	) T
ON T.rn = re.rid 
AND T.mn = m.mID

-- 7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 

SELECT m.title,  avg(ra.stars) avgR
FROM movie m
JOIN rating ra
ON m.mID = ra.mID
Group BY ra.mID
ORDER BY avgR DESC, m.title ASC

-- 8. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 

SELECT re.name 
FROM reviewer re
join
	(SELECT ra.rid id, count(*) num
	 FROM rating ra
	 GROUP BY ra.rid
	 Having num>2) T
ON re.rid = T.id

-- another solution

SELECT re.name FROM
reviewer re
JOIN
	(SELECT ra.rid id, count(*) num
	FROM rating ra
	GROUP BY ra.rid) T
ON re.rid = T.id
WHERE T.num>2

--another solution

SELECT re.name FROM
reviewer re
where re.rid in 
	(SELECT ra.rid id
	 FROM rating ra
	 GROUP BY ra.rid
	 Having count(*) >2)


-- 9.Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
 
SELECT m.title, m.director 
FROM movie m
WHERE m.director IN
	(SELECT m.director
	 FROM movie m
	 GROUP BY m.director
	 HAVING count(*) >1)
ORDER BY m.director, m.title


-- 10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 

SELECT m.title, avg(rating.stars)
FROM movie m
JOIN rating
ON rating.mid = m.mid
GROUP BY rating.mid
HAVING avg(rating.stars) IS (
   SELECT avg(rating.stars) avgR
   FROM rating
   GROUP BY mid
   ORDER BY avgR
   DESC LIMIT 1)

-- 11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)

SELECT m.title, avg(rating.stars)
FROM movie m
JOIN rating
ON rating.mid = m.mid
GROUP BY rating.mid
HAVING avg(rating.stars) IS (
   SELECT avg(rating.stars) avgR
   FROM rating
   GROUP BY mid
   ORDER BY avgR  ASC LIMIT 1)

-- 12:For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 

SELECT m.director, m.title, max(ra.stars)
FROM movie m
JOIN rating ra
ON m.mid = ra.mid
GROUP BY m.director
HAVING m.director is NOT NULL

