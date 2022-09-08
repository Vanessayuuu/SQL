SELECT DISTINCT name
FROM people
WHERE name != "Kevin Bacon" AND people.id IN (
SELECT person_id FROM stars WHERE stars.movie_id IN (
    SELECT movies.id FROM movies JOIN stars ON stars.movie_id = movies.id
                                 JOIN people ON people.id = stars.person_id
    WHERE people.id = (SELECT id FROM people WHERE name = "Kevin Bacon" AND birth = "1958")
));
