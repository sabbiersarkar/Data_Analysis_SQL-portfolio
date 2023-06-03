#In this SQL, I'm querying a database containing Nexflix data to answer questions about the data.

#1. How many movie titles are there in the database? (movies only, not tv shows)

SELECT
    COUNT(*) AS num_movies
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
WHERE
   type = 'Movie';

#2. When was the most recent batch of tv shows and/or movies added to the database?

-- Most recent movie

SELECT
    MAX(DATE(date_added)) AS most_recent_movie
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
WHERE
    type = 'Movie';

-- Most recent tv show

SELECT
    MAX(DATE(date_added)) AS most_recent_show
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
WHERE
    type = 'TV Show';

-- Double check

SELECT
    type,
    date_added
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
WHERE 
    date_added IS NOT NULL
ORDER BY
    date_added DESC
LIMIT 10;

#3. List all the movies and tv shows in alphabetical order.

SELECT
    title
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
ORDER BY
    title ASC;

#4. Who was the Director for the movie Bright Star?

SELECT
    director
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info" AS titles
LEFT JOIN
    "CharlotteChaze/BreakIntoTech"."netflix_people" AS people
ON
    titles.show_id = people.show_id
WHERE 
    titles.title LIKE '%Bright Star%';

#5. What is the oldest movie in the database and what year was it made?

SELECT
    title,
    release_year
FROM
    "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
WHERE 
    type = 'Movie'
AND 
    release_year <= 
        (SELECT MIN(release_year) 
        FROM "CharlotteChaze/BreakIntoTech"."netflix_titles_info"
        WHERE type = 'Movie');