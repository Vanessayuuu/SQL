SELECT DISTINCT title
FROM movies WHERE movies.id IN (
    SELECT movies.id FROM movies JOIN stars ON stars.movie_id = movies.id
                                 JOIN people ON stars.person_id = people.id
    WHERE people.name LIKE "Johnny Depp"
    INTERSECT
    SELECT movies.id FROM movies JOIN stars ON stars.movie_id = movies.id
                                 JOIN people ON stars.person_id = people.id
    WHERE people.name LIKE "Helena Bonham Carter"
);