-- Query #1: Count of Each Type
SELECT 
    type,
    COUNT(*) AS count
FROM netflix_titles
GROUP BY type;

-- Query #2: Most Frequent Rating per Type
-- Find the rating counts for each type
SELECT 
    type,
    rating,
    COUNT(*) AS rating_count
FROM netflix_titles
GROUP BY type, rating
ORDER BY type, rating_count DESC;

-- Query #3: All Titles Released in 2020
SELECT * 
FROM netflix_titles
WHERE release_year = 2020;

-- Query #4: Titles Directed by 'Rajiv Chilaka'
SELECT *
FROM netflix_titles
WHERE director LIKE '%Rajiv Chilaka%';

-- Query #5: TV Shows with a Duration Greater than 5 Minutes
SELECT *
FROM netflix_titles
WHERE type = 'TV Show'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- Query #6: Average Release Percentage of Titles in India by Year
SELECT 
    release_year,
    COUNT(*) AS total_release,
    ROUND(
        COUNT(*) / (SELECT COUNT(*) FROM netflix_titles WHERE country = 'India') * 100, 2
    ) AS avg_release
FROM netflix_titles
WHERE country = 'India'
GROUP BY release_year
ORDER BY avg_release DESC
LIMIT 5;

-- Query #7: Titles in the 'Documentaries' Genre
SELECT * 
FROM netflix_titles
WHERE listed_in LIKE '%Documentaries%';

-- Query #8: Titles with No Director
SELECT * 
FROM netflix_titles
WHERE director IS NULL;

-- Query #9: Titles Featuring 'Salman Khan' Released in the Last 10 Years
SELECT * 
FROM netflix_titles
WHERE cast LIKE '%Salman Khan%'
  AND release_year > YEAR(CURDATE()) - 10;

-- Query #10: Categorize Content Based on Description
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix_titles
) AS categorized_content
GROUP BY category;

-- Query #11: Average Duration of Movies
SELECT 
    AVG(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)) AS avg_duration
FROM netflix_titles
WHERE type = 'Movie';

-- Query #12: Count of Titles by Genre
SELECT 
    genre,
    COUNT(*) AS total_content
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre
    FROM 
        netflix_titles
    INNER JOIN 
        (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
         UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) numbers
    ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
) AS genres
GROUP BY genre
ORDER BY total_content DESC;

-- Query #13: Most Recent Title by Each Director
-- Step 1: Determine the most recent release year for each director
SELECT 
    director,
    MAX(release_year) AS most_recent_year
FROM netflix_titles
GROUP BY director;
-- Step 2: Join the result with the original table to get the corresponding titles
SELECT 
    nt.director,
    nt.title,
    nt.release_year
FROM netflix_titles nt
INNER JOIN (
    SELECT 
        director,
        MAX(release_year) AS most_recent_year
    FROM netflix_titles
    GROUP BY director
) recent ON nt.director = recent.director
   AND nt.release_year = recent.most_recent_year;

-- Query #14: Titles by Rating and Country
SELECT 
    country,
    rating,
    COUNT(*) AS count
FROM netflix_titles
GROUP BY country, rating
ORDER BY country, rating;

-- Query #15: Number of Titles Added per Year
SELECT 
    YEAR(STR_TO_DATE(date_added, '%B %d, %Y')) AS year_added,
    COUNT(*) AS num_titles
FROM netflix_titles
GROUP BY year_added
ORDER BY year_added DESC;

-- Query #16: Titles with Longest and Shortest Duration
-- Longest duration
SELECT 
    title,
    duration
FROM netflix_titles
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;

-- Shortest duration
SELECT 
    title,
    duration
FROM netflix_titles
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)
LIMIT 1;

-- Query #17: Top 5 Countries by Number of Unique Titles
SELECT 
    country,
    COUNT(DISTINCT title) AS unique_titles
FROM netflix_titles
GROUP BY country
ORDER BY unique_titles DESC
LIMIT 5;

-- Query #18: Count of TV Shows and Movies per Rating
SELECT 
    type,
    rating,
    COUNT(*) AS count
FROM netflix_titles
GROUP BY type, rating
ORDER BY type, rating;

-- Query #19: Top 3 Actors by Number of Appearances
SELECT 
    actor,
    COUNT(*) AS appearances
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', numbers.n), ',', -1)) AS actor
    FROM 
        netflix_titles
    INNER JOIN 
        (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
         UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) numbers
    ON CHAR_LENGTH(cast) - CHAR_LENGTH(REPLACE(cast, ',', '')) >= numbers.n - 1
) AS actors
GROUP BY actor
ORDER BY appearances DESC
LIMIT 3;

-- Query #20: Titles by Genre and Release Year
SELECT 
    genre,
    release_year,
    COUNT(*) AS count
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre,
        release_year
    FROM 
        netflix_titles
    INNER JOIN 
        (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
         UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) numbers
    ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
) AS genre_data
GROUP BY genre, release_year
ORDER BY genre, release_year;
