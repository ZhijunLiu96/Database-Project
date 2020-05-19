-- APAN 5310: SQL & RELATIONAL DATABASES SPRING 2019 ONCAMPUS

   -------------------------------------------------------------------------
   --                                                                     --
   --                            HONOR CODE                               --
   --                                                                     --
   --  I affirm that I will not plagiarize, use unauthorized materials,   --
   --  or give or receive illegitimate help on assignments, papers, or    --
   --  examinations. I will also uphold equity and honesty in the         --
   --  evaluation of my work and the work of others. I do so to sustain   --
   --  a community built around this Code of Honor.                       --
   --                                                                     --
   -------------------------------------------------------------------------

/*
 *    You are responsible for submitting your own, original work. We are
 *    obligated to report incidents of academic dishonesty as per the
 *    Student Conduct and Community Standards.
 */


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-- HOMEWORK ASSIGNMENT 4 (DUE 2/25/2019, 6:00 pm EST)

/*
 *  NOTES:
 *
 *    - Type your SQL statements between the START and END tags for each
 *      question. Do not alter this template .sql file in any way other than
 *      adding your answers. Do not delete the START/END tags. The .sql file
 *      you submit will be validated before grading and will not be graded if
 *      it fails validation due to any alteration of the commented sections.
 *
 *    - Our course is using PostgreSQL which has been preinstalled for you in
 *      Codio. We grade your assignments in Codio and PostgreSQL. You risk
 *      losing points if you prepare your SQL queries for a different database
 *      system (MySQL, MS SQL Server, Oracle, etc).
 *
 *    - It is highly recommended that you insert additional, appropriate data
 *      to test the results of your queries. You do not need to include your
 *      sample data in your answers.
 *
 *    - Make sure you test each one of your answers in pgAdmin. If a query
 *      returns an error it will earn no points.
 *
 *    - In your CREATE TABLE statements you must provide data types AND
 *      primary/foreign keys (if applicable).
 *
 *    - You may expand your answers in as many lines as you find appropriate
 *      between the START/END tags.
 *
 */



-------------------------------------------------------------------------------



/*
 * QUESTION 1 (5 points: 1 point for each table plus 1 point for correct order
 *             of execution)
 * ----------------------------------------------------------------------------
 *
 * Assume the following simplified database schema of a consumer lifestyle
 * segmentation database. This will be based off the much larger database
 * produced by Experian called Mosaic (https://bit.ly/2Dppm2c). Such a database
 * is extremely useful for a business looking to accurately target the
 * locations of their likely customers. Our simplified database will store the
 * populations by lifestyle segmentation group at the CBSA (Core-Based
 * Statistical Area) and City levels.
 *
 * Provide the SQL statements that create the four (4) tables listed below with
 * data types of your design. Implement integrity constraints (primary/foreign
 * keys, NOT NULL) as needed.
 * Note: since underlining is not supported in this file format, primary keys
 * for each relation below are shown within '*'.
 *
 *
 *   cities (*city_name*, *year*, *seg_id*, state_id, cbsa_name, city_seg_pop)
 *   states (*state_id*, state_name, state_capital)
 *   cbsas (*cbsa_name*, *year*, cbsa_pop)
 *   segments (*seg_id*, seg_name, seg_desc)
 *
 *
 * Type the CREATE TABLE statements in the order they have to be executed so
 * that there is no error in PostgreSQL. Expand the space between the START/END
 * tags to fit all of your CREATE TABLE statements.
 *
 * IMPORTANT: Make sure you implement the schema with exactly the provided
 *            relation and attribute names. Do not rename relations or
 *            attributes, either by accident (typos) or on purpose.
 *
 *
 * Schema Description:
 * -------------------
 *
 * cities
 * ------
 *  city_name: official name of city
 *  year: year of population data
 *  seg_id: Mosaic segment ID as identified by a single letter (A to S)
 *  cbsa_name: official name of CBSA that encompasses given city
 *  state_id: two-letter postal state abbreviation of state in which the city
 *            is contained
 *  city_seg_pop: population of the given city, segment, and year
 *
 * states
 * ------
 *  state_id: two-letter postal state abbreviation (e.g. ‘AK’ for Alaska)
 *  state_name: official name of the state (e.g. ‘Alaska’)
 *  state_capital: capital city of the state (e.g. ‘Juneau’)
 *
 * cbsas
 * -----
 *  cbsa_name: official name of CBSA (e.g. 'Dallas-Fort Worth-Arlington,
 *             TX Metro')
 *  year: year of population data
 *  cbsa_pop: population of entire CBSA for the given year
 *
 * segments
 * --------
 *  seg_id: Mosaic segment ID identified by a single letter (A to S)
 *  seg_name: official name of the segment according to Experian
 *  seg_desc: detailed description of the given segment’s characteristics
 *
 */

-- START ANSWER 1 --
CREATE
 TABLE segments (
	   seg_id		char(1)
	 , seg_name		varchar(100) NOT NULL
	 , seg_desc		text
	 , PRIMARY KEY (seg_id)
);

CREATE
 TABLE states (
	   state_id			char(2)
	 , state_name		varchar(20) NOT NULL
	 , state_capital	varchar(50) NOT NULL
	 , PRIMARY KEY (state_id)
);

CREATE
 TABLE cbsas (
	   cbsa_name	varchar(50)
	 , year			integer
	 , cbsa_pop		integer NOT NULL
	 , PRIMARY KEY (cbsa_name, year)
);

CREATE
 TABLE cities (
	   city_name	varchar(50)
	 , year			integer
	 , seg_id		char(1)
	 , state_id		char(2)
	 , cbsa_name	varchar(50)
	 , city_seg_pop	integer NOT NULL
	 , PRIMARY KEY (city_name, year, seg_id)
	 , FOREIGN KEY (state_id) REFERENCES states (state_id)
	 , FOREIGN KEY (seg_id) REFERENCES segments (seg_id)
	 , FOREIGN KEY (cbsa_name, year) REFERENCES cbsas (cbsa_name, year)
);
-- END ANSWER 1 --

-------------------------------------------------------------------------------

/*
 * QUESTION 2 (2 points)
 * ---------------------
 *
 * Provide brief reasoning on your selection of each one of the data types
 * above as well as your implementation of integrity constraints. Include any
 * additional assumptions you made beyond the provided schema description. Type
 * your answers (plain text) within the START/END tags. Expand your answers in
 * as many lines as you need.
 *
 */

-- START ANSWER 2 --
states:
state_id [char(2)]: only need two characters as defined (AK, AL, …, WY)
state_name [varchar(20)]: sufficient for longest state name (North Carolina)
state_capital [varchar(50)]: sufficient for longest state capital (Jefferson City)

cbsas:
cbsa_name [varchar(50)]: sufficient for longest CBSA name of consequence
year [smallint]: sufficient for all years
cbsa_pop [integer]: sufficient for population of all US, so good for CBSA

segments:
seg_id [char(1)]: only need one character as defined (A, B, …, S)
seg_name [varchar(100)]: sufficient for longest segment name (Middle-class Melting Pot)
seg_desc [text]: needed in case lengthy notes desired

cities:
city_name [varchar(50)]: sufficient for longest city name of consequence
year [smallint]: sufficient for all years
state_id [char(2)]: only need two characters as defined (AK, AL, …, WY)
seg_id	[char(1)]: only need one character as defined (A, B, …, S)
cbsa_name [varchar(50)]: sufficient for longest CBSA name of consequence
city_seg_pop [integer]: sufficient for population of all US, so good for segment

-- END ANSWER 2 --

-------------------------------------------------------------------------------

/*
 * QUESTION 3 (3 points)
 * ----------------------
 *
 * Draw the ER diagram for the schema detailed in Question 1 using the same
 * notation as in Chapter 7 of your textbook. You may draw the ER diagram in
 * any software you prefer, Lucidchart is recommended. Hand drawn diagrams will
 * not be accepted. Upload the ER diagram as a separate file.
 *
 */

-- No START/END tags here. Your answer is a separate PDF submitted along with
-- this SQL file.


-------------------------------------------------------------------------------

/*
 * QUESTION 4 (2 points)
 * ---------------------
 *
 * Draw the ER diagram for the schema detailed in Question 1 using Engineering
 * notation. You may draw the ER diagram in any software you prefer, Lucidchart
 * is recommended. Hand drawn diagrams will not be accepted. Upload the ER
 * diagram as a separate file.
 *
 */

 -- No START/END tags here. Your answer is a separate PDF submitted along with
 -- this SQL file and the PDF file for the diagram in Question 3.


-------------------------------------------------------------------------------

/*
 * QUESTION 5 (2 points)
 * ---------------------
 *
 * Provide the SQL statement that returns all unique city names with 2015
 * city-segment populations greater than 10,000 belonging to segment A.
 *
 */

-- START ANSWER 5 --
SELECT city_name
  FROM cities c
  JOIN segments se ON c.seg_id = se.seg_id
 WHERE c.city_seg_pop > 10000
   AND c.year = 2015
   AND c.seg_id = 'A';


-- END ANSWER 5 --

-------------------------------------------------------------------------------

/*
 * QUESTION 6 (2 points)
 * ---------------------
 *
 * Provide the SQL statement that returns the state names, city names, and city
 * populations for only the state capital cities. Consider all 50 states.
 *
 */

-- START ANSWER 6 --

SELECT state_name
     , city_name
     , SUM(city_seg_pop) city_pop
  FROM cities c 
  JOIN states s ON c.state_id = s.state_id
 WHERE c.city_name = s.state_capital
   AND c.year = 2015 -- Or another year to avoid double counting
 GROUP
    BY state_name, city_name;


-- END ANSWER 6 --

-------------------------------------------------------------------------------

/*
 * QUESTION 7 (2 points)
 * ---------------------
 *
 * Provide the SQL statement that returns the number of segments in the city of
 * Dallas that have segment populations in the range [125000, 150000).
 *
 */

-- START ANSWER 7 --
SELECT COUNT(seg_id) segs
  FROM (SELECT city_name
             , seg_id
             , city_seg_pop
   	   FROM cities
         WHERE city_name = 'Dallas'
   	    AND city_seg_pop BETWEEN 125000 AND 149999 -- not 150000 due to )
   	    AND year = 2015) a;


-- END ANSWER 7 --

-------------------------------------------------------------------------------

/*
 * QUESTION 8 (2 points)
 * ---------------------
 *
 * Provide the SQL statement that returns, in descending order by CBSA
 * population, the CBSAs containing at least one city with a segment population
 * less than 2000 for the year 2015.
 *
 */

-- START ANSWER 8 --

  SELECT 
DISTINCT cbsa_name
       , cbsa_pop
    FROM (SELECT c.cbsa_name
               , city_seg_pop
               , cbsa_pop
      	     FROM cities c
      	     JOIN cbsas cb ON c.year = cb.year
                         AND c.cbsa_name = cb.cbsa_name
     	    WHERE c.year = 2015
            AND city_seg_pop < 2000) a
   ORDER
      BY cbsa_pop DESC;

-- END ANSWER 8 --

-------------------------------------------------------------------------------

/*
 * QUESTION 9 (2 points)
 * ---------------------
 *
 * Provide the SQL statement that returns the single CBSA with the highest
 * concentration of 2010 population in the B segment.
 *
 */

-- START ANSWER 9 --

SELECT cbsa_name
     , ROUND(seg_pop/cbsa_pop,5) b_pop
  FROM (SELECT c.cbsa_name
             , cbsa_pop::numeric
   	      	, SUM(city_seg_pop) seg_pop
          FROM cbsas cb
          JOIN cities c ON cb.year = c.year
                       AND cb.cbsa_name = c.cbsa_name
         WHERE seg_id = 'B'
           AND c.year = 2010
         GROUP
            BY c.cbsa_name, cbsa_pop) a
ORDER
   BY seg_pop/cbsa_pop DESC
LIMIT 1;


-- END ANSWER 9 --

-------------------------------------------------------------------------------

/*
 * QUESTION 10 (2 points)
 * ----------------------
 *
 * Provide the SQL statement that returns the cities with a 'Suburban Style'
 * segment population that experienced at least a 5% growth from 2010 to 2015.
 *
 */

-- START ANSWER 10 --

SELECT city_name
     , ROUND(pop_2015/pop_2010, 5) growth
  FROM (SELECT city_name
             , seg_name
             , SUM(CASE 
                     WHEN year = 2010 THEN city_seg_pop::numeric
                     ELSE 0
   		      END) pop_2010
   		, SUM(CASE 
                     WHEN year = 2015 THEN city_seg_pop::numeric
   			 ELSE 0
   		      END) pop_2015
          FROM cities c
          JOIN segments se ON c.seg_id = se.seg_id
         WHERE seg_name = 'Suburban Style'
         GROUP 
            BY city_name, seg_name) a
 WHERE pop_2015/pop_2010 >= 1.05;


-- END ANSWER 10 --

-------------------------------------------------------------------------------

/*
 * QUESTION 11 (2 points)
 * ----------------------
 *
 * Provide the SQL statement that creates a view showing cbsa_name, popA, popB,
 * and popC where pop* is the average of all segment * populations regardless
 * of year.
 *
 */

-- START ANSWER 11 --
CREATE
  VIEW cbsa_abc (cbsa_nm, popA, popB, popC) AS 
SELECT cbsa_name
     , ROUND(AVG(CASE
                   WHEN seg_id = 'A' THEN city_seg_pop
                   ELSE NULL
                 END),2)
     , ROUND(AVG(CASE
                   WHEN seg_id = 'B' THEN city_seg_pop
                   ELSE NULL
                 END),2)
     , ROUND(AVG(CASE
                   WHEN seg_id = 'C' THEN city_seg_pop
                   ELSE NULL
                 END),2)
  FROM cities
 GROUP
    BY cbsa_name;

SELECT * FROM cbsa_abc;

 
-- END ANSWER 11 --

-------------------------------------------------------------------------------
