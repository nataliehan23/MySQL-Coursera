-- SQL Social-Network Query Exercises (core set)

-- 1 Find the names of all students who are friends with someone named Gabriel. 

SELECT name 
FROM highschooler h
JOIN friend f
ON f.ID1 = h.ID
WHERE f.ID2 in (
	SELECT ID 
	FROM highschooler 
	WHERE name = "Gabriel")

-- 2. For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 

SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Highschooler h1
JOIN Likes l
ON h1.ID = l.ID1
JOIN Highschooler h2
ON h2.ID = l.ID2
WHERE h1.grade >=h2.grade+2

-- 3. For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Highschooler h1
JOIN Likes l1, Highschooler h2, likes l2
ON h2.id = l1.id2 
   AND h1.id = l1.ID1 
   AND l1.ID1 = l2.id2 
   AND l2.id1 = l1.id2
WHERE h1.name < h2.name

-- 4. Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.

SELECT h1.name, h1.grade
FROM Highschooler h1
LEFT OUTER JOIN Likes l1
ON h1.ID = l1.ID1 OR h1.ID = l1.ID2
WHERE l1.ID1 IS NULL
ORDER BY h1.grade, h1.name;


-- 5. For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 

SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Highschooler h1
join likes l1, highschooler h2
ON h1.id = l1.ID1 AND h2.id = l1.ID2
WHERE l1.id2 not IN 
	(SELECT id1 FROM likes)

-- 6. Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 

SELECT h.name, h.grade 
FROM highschooler h 
WHERE h.id NOT IN
	(SELECT h1.id
	 FROM Highschooler h1
	 JOIN Friend f, Highschooler h2
	 ON f.ID1=h1.ID 
	 AND f.ID2 = h2.ID 
	 AND h1.grade != h2.grade)
ORDER BY h.grade ASC, h.name ASC;


-- 7. For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 

SELECT A.name, A.grade, B.name, B.grade, C.name, C.grade
FROM Highschooler A
JOIN Highschooler B, Highschooler C,
    (SELECT T.A AS ID1, T.B AS ID2, F2.id2 AS ID3
     FROM 
       (SELECT l.id1 as A, l.id2 as B
        FROM Likes l
        LEFT OUTER JOIN friend f
        ON l.id1 = f.id1 AND l.id2 = f.id2 WHERE f.id1 is null) T
     JOIN Friend F1, Friend F2
     ON T.A = F1.id1 
     AND T.B = F2.id1 
     AND F1.id2 = F2.id2) Fancy
ON Fancy.ID1 = A.ID AND Fancy.ID2 = B.ID AND Fancy.ID3 = C.ID

-- 8. Find the difference between the number of students in the school and the number of different first names. 

SELECT COUNT(ID)-COUNT(DISTINCT name) 
FROM highschooler 

-- 9. Find the name and grade of all students who are liked by more than one other student. 

SELECT DISTINCT h.name, h.grade
FROM Highschooler h
JOIN Likes l
ON l.ID2 = h.ID 
WHERE l.ID2 IN (
     SELECT ID2 FROM Likes
     GROUP BY ID2
     HAVING count(ID1)>1)



