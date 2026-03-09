DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
select * from netflix;

select count(*) as total_count
from netflix;

SELECT DISTINCT type
from netflix;



-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows
SELECT type,
COUNT(*) as total_contenttype
FROM netflix
GROUP BY TYPE;




--2. Find the most common rating for movies and TV shows
SELECT
   type,
   rating
FROM

(SELECT type,
       rating,
	   COUNT(*),
	   RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY type,rating) AS t1
WHERE ranking=1;
---ORDER BY 1, 3 DESC;



--3. List all movies released in a specific year (e.g., 2020)
SELECT *
FROM netflix
WHERE 
TYPE ='Movie'
AND
release_year = 2020
;



--4. Find the top 5 countries with the most content on Netflix
SELECT
UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
COUNT(show_id) as tottal_content
FROM netflix
GROUP BY country
ORDER BY 2 DESC
LIMIT 5;




--Identify the longest movie
SELECT * FROM netflix
WHERE 
type = 'Movie'
AND duration = (SELECT MAX(duration) FROM netflix);





--6. Find content added in the last 5 years
SELECT * FROM netflix
WHERE
TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';



--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * FROM netflix
WHERE director like '%Rajiv Chilaka%';




--8. List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
AND
SPLIT_PART(duration,' ',1):: NUMERIC > 5;
 




--9. Count the number of content items in each genre
SELECT
UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
COUNT(show_id)
FROM netflix
GROUP BY 1;




--10.Find each year and the average numbers of content release in India on netflix.
--return top 5 year with highest avg content release!
SELECT 
EXTRACT (YEAR FROM TO_DATE(date_added,'Month dd,YYYY')) AS year,
COUNT(*)AS number_of_contents,
ROUND(COUNT (*)::NUMERIC/(SELECT COUNT(*)FROM netflix WHERE country = 'India'),2)::NUMERIC * 100 AS AVERAGE
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5;




--11. List all movies that are documentaries
SELECT *
FROM netflix
WHERE type = 'Movie'
AND 
listed_in LIKE '%Documentaries%';




--12. Find all content without a director
SELECT * FROM netflix
WHERE 
director is null;



--13 Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * FROM netflix
WHERE 
casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) -15;




--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
COUNT(*) AS appeared_in
FROM netflix
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;



--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.
WITH new_table
AS
(SELECT *,
  CASE
  WHEN 
  description ILIKE '%KILL%'
  OR
  description ILIKE '%violence%' THEN 'bad_content'
  ELSE 'good_content'
  END catogery
FROM netflix)

SELECT catogery,
COUNT(*)
FROM new_table
GROUP BY 1
ORDER BY 2 DESC;
 
  
     