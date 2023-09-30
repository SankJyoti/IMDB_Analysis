use imdb;
/* IMDb Movies Analysis using SQL

Bolly Movies, an Indian film production company, has a successful track record of producing numerous blockbuster films. While primarily catering to the Indian audience, they have decided to venture into the global market with their upcoming project scheduled for release in 2022.

Objective:
Recognizing the value of data-driven decision-making, Bolly Movies has enlisted your expertise as a data analyst and SQL specialist. The objective of this case study is to analyse the movie dataset using SQL queries and extract valuable insights to guide Bolly Movies in planning their new project. The analysis will cover various aspects such as table exploration, movie release trends, production statistics, genre popularity, ratings analysis, crew members, and more.

Segment 1: Database - Tables, Columns, Relationships
-What are the different tables in the database and how are they connected to each other in the database?
Answer:
In this IMDB Database,we have a relational database with multiple tables. Here's a description of each table and how they are connected to each other based on the column names:

1. movie table:
   - Columns: id, title, year, date_published, duration, country, worlwide_gross_income, languages, production_company
   - This table likely stores information about movies, including their titles, release years, production details, and more.

2. genre table:
   - Columns: movie_id, genre
   - This table likely stores information about movie genres and associates them with specific movies using the 'movie_id' column.

3. director_mapping table:
   - Columns: movie_id, name_id
   - This table may be used to map directors to movies. The 'movie_id' links to a specific movie, and 'name_id' likely links to a director's name in another table.

4. role_mappin` table:
   - Columns: movie_id, name_id, category
   - This table could be used to map roles or characters to movies. The 'movie_id' links to a specific movie, 'name_id' links to a person's name, and 'category' may specify the role or category of the person in the movie.

5. names table:
   - Columns: id, name, height, date_of_birth, known_for_movies
   - This table likely stores information about people involved in the movie industry, including their names, birthdates, heights, and known works.

6. ratings table:
   - Columns: movie_id, avg_rating, total_votes, median_rating
   - This table may store information about movie ratings, including average ratings, total votes, and median ratings for each movie.

Based on the column names, the tables are connected as follows:

- The 'movie' table serves as the central table, containing information about movies. Other tables, such as 'genre', 'director_mapping', 'role_mapping', and 'ratings', are linked to specific movies using the 'movie_id' column.

- The 'genre' table is connected to the 'movie' table through the 'movie_id' column, associating genres with movies.

- The 'director_mapping' table is also connected to the 'movie' table through the 'movie_id' column, indicating which directors were involved in each movie.

- The 'role_mapping' table connects to both the 'movie' table and the 'names' table through the 'movie_id' and 'name_id' columns, linking specific roles or characters in movies to individuals.

- The 'ratings' table is associated with the 'movie' table via the 'movie_id' column, providing rating-related data for each movie.

- The 'names' table is linked to other tables like 'director_mapping' and 'role_mapping' using the 'name_id' column, allowing you to retrieve additional information about people involved in movies.

These connections enable you to query and retrieve information about movies, genres, directors, roles, ratings, and individuals involved in the film industry while maintaining data integrity and relationships between the tables.*/

-- -Find the total number of rows in each table of the schema.
SELECT COUNT(*) AS row_count FROM movie;
SELECT COUNT(*) AS row_count FROM genre;
SELECT COUNT(*) AS row_count FROM director_mapping;
SELECT COUNT(*) AS row_count FROM role_mapping;
SELECT COUNT(*) AS row_count FROM names;
SELECT COUNT(*) AS row_count FROM ratings;

-- -Identify which columns in the movie table have null values.
SELECT * FROM movie;
SELECT * FROM movie WHERE id IS NULL;
SELECT * FROM movie WHERE title IS NULL;
SELECT * FROM movie WHERE year IS NULL;
SELECT * FROM movie WHERE date_published IS NULL;
SELECT * FROM movie WHERE duration IS NULL;
SELECT * FROM movie WHERE country IS NULL;
SELECT * FROM movie WHERE worlwide_gross_income IS NULL;
SELECT * FROM movie WHERE languages IS NULL;
SELECT * FROM movie WHERE production_company IS NULL;
/*By running above SQL queries to examine the "movie" table for null values,we have got 4 columns which are having null values:
1. 'country'
2. 'languages'
3. 'worlwide_gross_income'
4. 'production_company'*/ 

/*Segment 2: Movie Release Trends
-Determine the total number of movies released each year and analyse the month-wise trend.*/
SELECT year,date_published, COUNT(*) AS total_movies
FROM movie
GROUP BY year,date_published
ORDER BY total_movies desc;

-- Calculate the number of movies produced in the USA or India in the year 2019.
SELECT * FROM movie;
SELECT country, COUNT(*) AS total_movies
FROM movie
WHERE (country = 'USA' OR country = 'India')  -- Filter for USA or India
    AND year = 2019
group by country;  -- Filter for the year 2019

/*Segment 3: Production Statistics and Genre Analysis
-Retrieve the unique list of genres present in the dataset.*/
SELECT DISTINCT genre
FROM genre;

-- Identify the genre with the highest number of movies produced overall.
SELECT genre, COUNT(*) AS total_movies
FROM genre
GROUP BY genre
ORDER BY total_movies DESC
LIMIT 1;

-- Determine the count of movies that belong to only one genre.
select * from genre;
SELECT distinct genre,count(movie_id) as total_movies
from genre
group by genre
order by total_movies;

-- Calculate the average duration of movies in each genre.
SELECT g.genre , AVG(m.duration) AS average_duration
FROM genre g
JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY average_duration DESC;

-- Find the rank of the 'thriller' genre among all genres in terms of the number of movies produced.

SELECT g.genre , COUNT(*) AS total_movies,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
FROM genre g
GROUP BY g.genre;
-- From the above query we have got the rank of genre 'Thriller' is 3rd 
SELECT g.genre , COUNT(*) AS total_movies,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
FROM genre g
GROUP BY g.genre
HAVING g.genre = 'thriller';

-- Segment 4: Ratings Analysis and Crew Members
select * from ratings;
-- Retrieve the minimum and maximum values in each column of the ratings table (except movie_id).
SELECT
    (SELECT MIN(avg_rating) FROM ratings) AS min_avg_rating,
    (SELECT MAX(avg_rating) FROM ratings) AS max_avg_rating,
    (SELECT MIN(total_votes) FROM ratings) AS min_total_votes,
    (SELECT MAX(total_votes) FROM ratings) AS max_total_votes,
    (SELECT MIN(median_rating) FROM ratings) AS min_median_rating,
    (SELECT MAX(median_rating) FROM ratings) AS max_median_rating;

-- Identify the top 10 movies based on average rating.

SELECT m.id AS movie_id , m.title AS movie_title , AVG(r.avg_rating) AS average_rating
FROM movie m
JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id, m.title
ORDER BY average_rating DESC
LIMIT 10;

-- Summarise the ratings table based on movie counts by median ratings.

SELECT median_rating , COUNT(*) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;

-- Identify the production house that has produced the most number of hit movies (average rating > 8).

SELECT m.production_company AS production_house , COUNT(*) AS hit_movie_count
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY m.production_company
ORDER BY hit_movie_count DESC
LIMIT 1;

-- Determine the number of movies released in each genre during March 2017 in the USA with more than 1,000 votes.

SELECT g.genre , COUNT(*) AS movie_count
FROM genre g
JOIN movie m ON g.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
WHERE m.country = 'USA'
    AND EXTRACT(YEAR FROM m.date_published) = 2017
    AND EXTRACT(MONTH FROM m.date_published) = 3
    AND r.total_votes > 1000
GROUP BY g.genre
order by movie_count desc;

-- Retrieve movies of each genre starting with the word 'The' and having an average rating > 8.

SELECT g.genre,m.title AS movie_title,r.avg_rating
FROM genre g
JOIN movie m ON g.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
WHERE m.title LIKE 'The%'  -- Movies starting with 'The'
    AND r.avg_rating > 8;

/*Segment 5: Crew Analysis
-Identify the columns in the names table that have null values.*/
SELECT * from names;
SELECT * FROM names where id is null;
SELECT * FROM names where name is null;
SELECT * FROM names where height is null;
SELECT * FROM names where date_of_birth is null;
SELECT * FROM names where known_for_movies is null;
/*From above queries we have got 3 columns in names table having null values are
1.height
2.date_of_birth
3.known_for movies*/

-- Determine the top three directors in the top three genres with movies having an average rating > 8.
WITH TopGenres AS (
    SELECT g.genre,COUNT(*) AS movie_count
    FROM genre g
    JOIN movie m ON g.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY movie_count DESC
    LIMIT 3
)

SELECT tg.genre,d.name AS director_name,COUNT(*) AS movie_count
FROM TopGenres tg
JOIN genre g ON tg.genre = g.genre
JOIN movie m ON g.movie_id = m.id
JOIN director_mapping dm ON m.id = dm.movie_id
JOIN names d ON dm.name_id = d.id
GROUP BY tg.genre,d.name
ORDER BY tg.genre,movie_count DESC
LIMIT 3;


-- Find the top two actors whose movies have a median rating >= 8.

SELECT n.name AS actor_name,
    COUNT(*) AS movie_count
FROM names n
JOIN role_mapping rm ON n.id = rm.name_id
JOIN ratings r ON rm.movie_id = r.movie_id
WHERE rm.category = 'actor' AND r.median_rating >= 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;

-- Identify the top three production houses based on the number of votes received by their movies.

SELECT
    m.production_company AS production_house,
    SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.production_company IS NOT NULL
GROUP BY m.production_company
ORDER BY total_votes DESC
LIMIT 3;

-- Rank actors based on their average ratings in Indian movies released in India.

SELECT n.name AS actor_name,
    AVG(r.avg_rating) AS average_rating
FROM names n
JOIN role_mapping rm ON n.id = rm.name_id
JOIN movie m ON rm.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
WHERE
    rm.category = 'actor'
    AND m.country = 'India'
GROUP BY n.name
ORDER BY average_rating desc;

-- Identify the top five actresses in Hindi movies released in India based on their average ratings.

SELECT n.name AS actress_name,
    AVG(r.avg_rating) AS average_rating
FROM names n
JOIN role_mapping rm ON n.id = rm.name_id
JOIN movie m ON rm.movie_id = m.id
JOIN ratings r ON m.id = r.movie_id
WHERE
    rm.category = 'actress'
    AND m.country = 'India'
    AND m.languages LIKE '%Hindi%'
GROUP BY n.name
ORDER BY average_rating DESC
LIMIT 5;

-- Segment 6: Broader Understanding of Data
-- Classify thriller movies based on average ratings into different categories.

SELECT
    title AS movie_title,
    CASE
        WHEN avg_rating >= 9.0 THEN 'Excellent'
        WHEN avg_rating >= 8.0 AND avg_rating < 9.0 THEN 'Very Good'
        WHEN avg_rating >= 7.0 AND avg_rating < 8.0 THEN 'Good'
        WHEN avg_rating >= 6.0 AND avg_rating < 7.0 THEN 'Average'
        ELSE 'Below Average'
    END AS rating_category
FROM movie
JOIN ratings ON movie.id = ratings.movie_id
WHERE
    movie.id IN (
        SELECT DISTINCT movie_id
        FROM genre
        WHERE genre = 'Thriller'
    );

-- analyse the genre-wise running total and moving average of the average movie duration.

WITH GenreAverageDurations AS (
    SELECT
        g.genre,
        m.duration AS movie_duration,
        AVG(m.duration) OVER (PARTITION BY g.genre ORDER BY m.date_published) AS genre_avg_duration,
        ROW_NUMBER() OVER (PARTITION BY g.genre ORDER BY m.date_published) AS row_num
    FROM
        genre g
    JOIN
        movie m ON g.movie_id = m.id
    WHERE
        m.duration IS NOT NULL
)

SELECT
    genre,
    movie_duration,
    SUM(movie_duration) OVER (PARTITION BY genre ORDER BY row_num) AS running_total_duration,
    CASE
        WHEN row_num <= 3 THEN
            genre_avg_duration
        ELSE
            (movie_duration +
            LAG(movie_duration, 1) OVER (PARTITION BY genre ORDER BY row_num) +
            LAG(movie_duration, 2) OVER (PARTITION BY genre ORDER BY row_num)) / 3.0
    END AS moving_average_duration
FROM
    GenreAverageDurations
ORDER BY
    genre, row_num;

-- Identify the five highest-grossing movies of each year that belong to the top three genres.

WITH TopGenres AS (
    SELECT g.genre,COUNT(*) AS movie_count
    FROM genre g
    JOIN movie m ON g.movie_id = m.id
    GROUP BY g.genre
    ORDER BY movie_count DESC
    LIMIT 3
),
RankedMovies AS (
    SELECT m.title AS movie_title,m.year AS movie_year,m.worlwide_gross_income AS highest_gross_income,g.genre,
        ROW_NUMBER() OVER (PARTITION BY m.year, g.genre ORDER BY m.worlwide_gross_income DESC) AS ranking
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    JOIN TopGenres tg ON g.genre = tg.genre
)
SELECT movie_title,movie_year,highest_gross_income,genre
FROM RankedMovies
WHERE ranking <= 5
ORDER BY highest_gross_income desc
limit 5;

-- Determine the top two production houses that have produced the highest number of hits among multilingual movies.

WITH MultilingualHits AS (
    SELECT m.production_company AS production_house,COUNT(*) AS hit_movie_count
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.languages <> 'English'  -- Filter for multilingual movies
        AND r.avg_rating > 8       -- Define hits based on average rating
    GROUP BY m.production_company
    ORDER BY hit_movie_count DESC
    LIMIT 2  -- Limit to the top two production houses
)
SELECT production_house,hit_movie_count
FROM MultilingualHits;

-- dentify the top three actresses based on the number of Super Hit movies (average rating > 8) in the drama genre.

WITH SuperHitActresses AS (
    SELECT n.name AS actress_name,COUNT(*) AS super_hit_count
    FROM names n
    JOIN role_mapping rm ON n.id = rm.name_id
    JOIN movie m ON rm.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    JOIN genre g ON m.id = g.movie_id
    WHERE rm.category = 'actress' AND r.avg_rating > 8 AND g.genre = 'Drama'
    GROUP BY n.name
    ORDER BY super_hit_count DESC
    LIMIT 3
)
SELECT actress_name,super_hit_count
FROM
    SuperHitActresses;

-- Retrieve details for the top nine directors based on the number of movies, including average inter-movie duration, ratings, and more.

WITH TopDirectors AS (
    SELECT dm.name_id AS director_id,
        COUNT(DISTINCT dm.movie_id) AS movie_count,
        AVG(r.avg_rating) AS avg_rating
    FROM director_mapping dm
    JOIN movie m ON dm.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    GROUP BY dm.name_id
    ORDER BY movie_count DESC
    LIMIT 9
)

SELECT d.name AS director_name,td.movie_count,
    CASE
        WHEN td.avg_rating IS NOT NULL AND td.movie_count > 1 THEN
            (
                SELECT AVG(DATEDIFF(m2.date_published,m1.date_published))
                FROM movie m1
                JOIN movie m2 ON m1.id < m2.id
                WHERE EXISTS (
                        SELECT 1
                        FROM director_mapping dm1
                            JOIN director_mapping dm2 ON dm1.name_id = dm2.name_id
                        WHERE dm1.movie_id = m1.id
                            AND dm2.movie_id = m2.id
                            AND dm1.name_id = td.director_id
                    )
                    AND DATEDIFF(m2.date_published, m1.date_published) > 0
            )
        ELSE
            NULL
    END AS avg_inter_movie_duration,
    td.avg_rating
FROM TopDirectors td
JOIN names d ON td.director_id = d.id;

/*Segment 7: Recommendations
-Based on the analysis, provide recommendations for the types of content Bolly movies should focus on producing.

From IMDB Database, we can consider the analysis of the dataset and key insights. Here are some recommendations based on the data:

1.Genre Focus:
   Drama: Given that drama is one of the most popular genres with a significant number of movies and a diverse audience, Bolly movies should continue producing high-quality dramas.
   Thriller: Thriller movies also perform well, ranking third in terms of the number of movies produced. Exploring engaging thriller stories could be a fruitful direction.

2. Quality over Quantity:
   - While Bolly movies produce a large number of films, it's essential to focus on quality. The average rating for movies can be improved by investing in compelling scripts, talented actors, and skilled directors.

3. Multilingual Movies:
   - Considering that multilingual movies have a substantial presence in the dataset, Bolly movies can explore creating content in multiple languages to cater to a broader audience.

4. Duration Matters:
   - Analyzing the average duration of movies in each genre can provide insights into audience preferences. Bolly movies should aim for an optimal movie duration that aligns with the genre and viewer expectations.

5. High-Grossing Content:
  Understanding which genres and production houses generate high worldwide gross income can guide Bolly movies in making profitable content. Focusing on these genres and collaborating with successful production houses can be beneficial.

6. Focus on Hits:
    The dataset identifies "Super Hit" movies based on average ratings greater than 8. Bolly movies should prioritize creating content that falls into this category to maximize audience engagement and revenue.

7. Explore New Genres:
   While popular genres like drama and thriller are essential, Bolly movies can also experiment with less-explored genres to cater to niche audiences and diversify their content portfolio.

8. Director Talent:
   Identifying and collaborating with top directors who have a proven track record of producing successful movies can significantly impact the quality and success of Bolly movies.

9. Data-Driven Decision-Making:
   -Continue analyzing viewer preferences, ratings, and trends in the film industry to adapt and evolve content strategies based on changing audience demands.


10. Audience Engagement:
    Interacting with the audience, collecting feedback, and staying connected through social media and other platforms can help Bolly movies understand viewer preferences and adjust their content accordingly.
*/