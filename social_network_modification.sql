SQL Social-Network Modification Exercises


-- Question 1
-- It's time for the seniors to graduate. Remove all 12th graders from Highschooler.

DELETE FROM Highschooler
WHERE grade = 12
 
-- Question 2
-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 

DELETE FROM likes
WHERE EXISTS (
	SELECT * FROM (
		SELECT l1.id1 as mis1, l1.id2 as mis2
		FROM likes l1
		JOIN friend f
		ON f.id1 = l1.id1
		AND f.id2 = l1.id2
		LEFT OUTER JOIN likes l2
		ON l1.id1 = l2.id2
		AND l2.id1 = l1.id2
		WHERE l2.id2 IS NULL
		) r
	WHERE r.mis1 = likes.id1 
	AND r.mis2 = likes.id2
	)

-- Question 3
-- For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.)
-- I have not got time to work on this, if you have answer, please let me know.:-)