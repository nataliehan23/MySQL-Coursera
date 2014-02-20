-- SQL Movie-Rating Query Exercises (extras)
-- Question 1
-- For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 

SELECT h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
FROM highschooler h1
JOIN highschooler h2, highschooler h3,( 
	SELECT l1.id1 as A, l1.id2 as B, l2.id2 as C
	FROM Likes l1
	JOIN likes l2
	ON  l1.id2 = l2.id1
	AND l1.id1 != l2.id2
	) T
ON h1.id = T.A
AND h2.id = T.B
AND h3.id = T.C


-- Question 2
-- Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 

SELECT h.name, h.grade
FROM highschooler h
WHERE h.id NOT IN (
	SELECT h1.ID
	FROM highschooler h1
	JOIN friend f, highschooler h2
	ON h1.ID = f.ID1
	AND h2.ID = f.ID2
	AND h1.grade = h2.grade)


-- Question 3
-- What is the average number of friends per student? (Your result should be just one number.) 


SELECT T1.N1/T2.N2 
FROM(
	SELECT COUNT(DISTINCT h.ID)*1.0 AS N2
	FROM Highschooler h) T2
JOIN(
	SELECT sum(TT.TF)*1.0 AS N1
	FROM(
		SELECT count(f.id2) AS TF
	    FROM friend f
	    GROUP BY f.id1) AS TT
	) T1

-- Question 4
-- Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.
-- This maybe not the best solution, but it's pretty straight forward. 

SELECT count(*)
FROM(
	Select TT.FF1 
	FROM(
		SELECT f2.ID2 as FF2, f1.ID2 as FF1
		FROM friend f1
		JOIN friend f2,(
			SELECT h.id CID
			FROM highschooler h
			WHERE h.name = "Cassandra") T
		ON f1.ID1 = T.CID
		AND f1.ID2 = f2.ID1
		AND f2.ID2 != T.CID) TT
	Union
	SELECT TT.FF2 
	FROM(
		SELECT f2.ID2 as FF2, f1.ID2 as FF1
		FROM friend f1
		JOIN friend f2,(
			SELECT h.id CID
			FROM highschooler h
			WHERE h.name = "Cassandra") T
		ON f1.ID1 = T.CID
		AND f1.ID2 = f2.ID1
		AND f2.ID2 != T.CID) TT
	)


-- Question 5
-- Find the name and grade of the student(s) with the greatest number of friends. 

SELECT h.name, H.grade
FROM highschooler h
JOIN(
	SELECT f1.id1 as FID
	FROM friend f1
	GROUP BY f1.id1
	HAVING count(f1.id2) =(
		SELECT count(f.id2) 
		FROM friend f
    	GROUP BY f.id1
   		ORDER BY count(f.id2) DESC
   	LIMIT 1)
	) T2
ON T2.FID = h.id




Modification:



2. 
Question 2

If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 
delete from likes
where exists (
select * from (
select l1.id1 as mis1, l1.id2 as mis2
from likes l1
join friend f
on f.id1 = l1.id1
and f.id2 = l1.id2
left outer join likes l2
on l1.id1 = l2.id2
and l2.id1 = l1.id2
where l2.id2 is NULL
) r
where r.mis1 = likes.id1 and r.mis2 = likes.id2
)