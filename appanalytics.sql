/**
The data sourced from KAGGLE comprises information on diverse applications. 
This project has been undertaken to acquire a basic understanding of SQL, collaborate with a stakeholder, and analyze data to meet their requirements. 
In this particular project, my focus will be on examining the provided app data to identify potential opportunities for creating new apps that could find success in the market.
**/
-- Just did this to combine all the description csvs into one
CREATE TABLE appleStore_description_combined AS
SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

*******EXPLORATORY DATA ANALYSIS*********

-- check the number of unique apps in both tables of AppleStore data
SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined


-- check for any missing values in key fields
-- Counts the number of rows in appleStore table where track_name is null,user_rating is null,or prime_genre is null
SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS null or user_rating IS null OR prime_genre IS null

-- Counts the number of rows in appleStore_combined table where app_desc is null
SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc IS null

-- Find out the number of apps per genre
 
SELECT prime_genre, COUNT(*) AS NumApps 
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

--Get an overview of the apps' ratingsAppleStore
SELECT min(user_rating) AS MinRating,
	   max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
FROM AppleStore



*******DATA ANALYSIS*********

--Determine whether paid apps have higher ratings than free apps
	/*This SQL query categorizes apps in the "AppleStore" table as either 'Paid' or 'Free' based on their prices.
	  It then calculates the average user rating for each category.*/
SELECT CASE
			
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
       END AS App_type, -- Creates new column called App_type
       avg(user_rating) AS Avg_Rating -- Calculates average user rating for apps in "AppleStore" table. Then put in result column "Avg_Rating"
FROM AppleStore
GROUP BY App_Type --Groups the results based on the "App_type" column, the query will calculate the average user rating separately for apps categorized as 'Paid' and 'Free.



--Check if apps with more supported languages have higher ratings AppleStore
SELECT CASE
			WHEN lang_num < 10 THEN '<10 languages'
            WheN lang_num BETWEEN 10 and 30 THEN '10-30 languages'
            ELSE '>30 languages'
          END AS language_bucket,
          avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_Rating DESC




--Check genres with low ratingsAppleStore
SELECT prime_genre,
	avg(user_rating) As Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_RATING ASC
LIMIT 10 




--Check if there is a correlation between the length of the apple description and user ratingAppleStore

SELECT CASE
		WHEN length(b.app_desc) < 500 THEN 'Short'
        WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Long'
	END AS description_length_bucket,
    avg(a.user_rating) AS average_rating
    
FROM
	AppleStore AS A 
JOIN
	appleStore_description_combined AS b  
ON
	a.id = b.id

GROUP BY description_length_bucket
ORDER BY average_rating DESC


-- Check the top-rated apps for each design.

SELECT
	prime_genre,
    track_name,
    user_rating
FROM (
  		SELECT
  	prime_genre,
    track_name,
    user_rating,
    RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
  	FROM
  	appleStore
  ) AS a 
  WHERE
  a.rank = 1
 
 /*
 Findings:
 1. Paid apps have better ratings: if they think their app is good enough consider charging for it
 2. Apps supporting between 10 and 30 langauges have better ratings: Focusing on the right languages for the app rather than the quantity can make their app stand out
 3. Finance and book apps have low ratings: User needs aren't being fully met: Potential for high user ratings with a higher quality app 
 4. Apps with longer description have better ratings: A good description can set a clear expectaion and increase satisfaction of users.demo
 5. A new app should aim for an average rating above 3.5
 6. Games and Entertainment have high competition: Entering this market would be more difficult as it is slightly oversaturated, but a quality game could lead to high amount of users.




            
