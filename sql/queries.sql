-- 1. Analyze the distribution of content types (Movies vs TV Shows)
SELECT type, COUNT(*) AS total_count
FROM netflix
GROUP BY type
ORDER BY type;


-- 2. Rank the top countries based on total content contribution
SELECT *
FROM (
    SELECT 
        country,
        COUNT(*) AS total_content,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS country_rank
    FROM netflix
    WHERE country IS NOT NULL
    GROUP BY country
) t
WHERE country_rank <= 5;


-- 3. Display the titles of movies produced in a selected year (e.g., 2018)
SELECT title AS movie_name
FROM netflix 
WHERE type = 'Movie' AND release_year = 2018;


-- 4. Identify the year with highest content additions and compare with average
WITH yearly_content AS (
    SELECT 
        YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS year,
        COUNT(*) AS total_content
    FROM netflix
    WHERE date_added IS NOT NULL
    GROUP BY year
),
avg_content AS (
    SELECT AVG(total_content) AS avg_yearly_content
    FROM yearly_content
)
SELECT 
    yc.year,
    yc.total_content,
    ac.avg_yearly_content
FROM yearly_content yc
CROSS JOIN avg_content ac
ORDER BY yc.total_content DESC
LIMIT 1;


-- 5. Identify the movie with the longest duration
SELECT title, duration
FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;


# 📈 Time-Based Trends & Growth Analysis

-- 6. Content added in last 7 years
SELECT COUNT(*) AS content_added_over_7_years
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 7 YEAR;


-- 7. TV shows with more than 3 seasons
SELECT title AS tv_show_name,
       CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) AS seasons
FROM netflix
WHERE type = 'TV Show'
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) >= 3
ORDER BY seasons DESC;


-- 8. Year with most TV-MA rated TV shows
SELECT release_year, COUNT(*) AS tv_ma_rated_shows
FROM netflix
WHERE type = 'TV Show' AND rating = 'TV-MA'
GROUP BY release_year
ORDER BY tv_ma_rated_shows DESC;


# 🎬 Content & Genre Insights

-- 9. Genre-wise content distribution
SELECT genre, COUNT(*) AS total_content
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre
    FROM netflix
    JOIN (
        SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
        UNION SELECT 6 UNION SELECT 7 UNION SELECT 8
    ) n
    ON n.n <= 1 + LENGTH(listed_in) - LENGTH(REPLACE(listed_in, ',', ''))
) t
WHERE genre IS NOT NULL AND genre != ''
GROUP BY genre
ORDER BY total_content DESC;


-- 10. Content by specific director
SELECT title, director
FROM netflix
WHERE director = 'Toshiya Shinohara';


# 🌍 Country & Actor Analysis

-- 11. Country contribution over years (France example)
SELECT 
    YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS year,
    COUNT(*) AS year_count
FROM netflix
WHERE country = 'France'
GROUP BY year
ORDER BY year;


-- 12. Top actors in Indian productions
SELECT cast, COUNT(*) AS appearances
FROM netflix
WHERE country = 'India'
AND cast IS NOT NULL
GROUP BY cast
ORDER BY appearances DESC
LIMIT 10;


-- 13. Movies in last 15 years with Tom Hanks
SELECT *
FROM netflix
WHERE cast LIKE '%Tom Hanks%'
AND release_year >= YEAR(CURDATE()) - 15;


# 🎥 Content Exploration & Data Quality

-- 14. Documentary movies
SELECT title AS documentary_movies
FROM netflix
WHERE type = 'Movie'
AND listed_in LIKE '%Documentaries%';


-- 15. Content with missing director
SELECT *
FROM netflix
WHERE director IS NULL;


-- 16. Movie with highest number of cast members
SELECT title,
       (LENGTH(cast) - LENGTH(REPLACE(cast, ',', '')) + 1) AS no_of_cast_members
FROM netflix
ORDER BY no_of_cast_members DESC
LIMIT 10;


# 🧠 Advanced Analysis & Classification

-- 17. Content classification based on keywords
SELECT title,
       CASE 
           WHEN description LIKE '%death%' OR description LIKE '%kill%' THEN 'Sensitive'
           ELSE 'Non-Sensitive'
       END AS content_category
FROM netflix;


-- 18. Top 20 directors and contribution
WITH director_count AS (
    SELECT 
        director,
        COUNT(*) AS total_titles
    FROM netflix
    WHERE director IS NOT NULL
    GROUP BY director
),
total_content AS (
    SELECT COUNT(*) AS total_all
    FROM netflix
)
SELECT 
    dc.director,
    dc.total_titles,
    ROUND(dc.total_titles * 100.0 / tc.total_all, 2) AS contribution_percentage
FROM director_count dc
CROSS JOIN total_content tc
ORDER BY dc.total_titles DESC
LIMIT 20;
