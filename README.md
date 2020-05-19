# Database Project

---

## [Entity Relationship Diagram](https://github.com/ZhijunLiu96/Database-Project/tree/master/Entity%20Relationship%20Diagram)

#### Scenario
Assume the following simplified database schema of a consumer lifestyle segmentation database. This will be based off the much larger database produced by Experian called Mosaic [link](https://bit.ly/2Dppm2c). Such a database is extremely useful for a business looking to accurately target the locations of their likely customers. Our simplified database will store the populations by lifestyle segmentation group at the CBSA (Core-Based Statistical Area) and City levels.

```
 cities (*city_name*, *year*, *seg_id*, state_id, cbsa_name, city_seg_pop)
 states (*state_id*, state_name, state_capital)
 cbsas (*cbsa_name*, *year*, cbsa_pop)
 segments (*seg_id*, seg_name, seg_desc)
```

#### ER-Diagram
Draw the ER diagram for the schema using different notation

<img src="https://github.com/ZhijunLiu96/Database-Project/blob/master/Entity%20Relationship%20Diagram/ERD1.png">

<img src="https://github.com/ZhijunLiu96/Database-Project/blob/master/Entity%20Relationship%20Diagram/ERD2.png">

#### SQL queries

1. Provide the SQL statement that returns all unique city names with 2015 city-segment populations greater than 10,000 belonging to segment A.
```sql
SELECT city_name
  FROM cities c
  JOIN segments se ON c.seg_id = se.seg_id
 WHERE c.city_seg_pop > 10000
   AND c.year = 2015
   AND c.seg_id = 'A';
```

2. Provide the SQL statement that returns the state names, city names, and city populations for only the state capital cities. Consider all 50 states.
```sql
SELECT state_name, city_name, SUM(city_seg_pop) city_pop
  FROM cities c 
  JOIN states s ON c.state_id = s.state_id
 WHERE c.city_name = s.state_capital
   AND c.year = 2015 -- Or another year to avoid double counting
GROUP BY state_name, city_name;
```

3. Explore more queries: [link](https://github.com/ZhijunLiu96/Database-Project/blob/master/Entity%20Relationship%20Diagram/APAN5310S19OC_HW4_zl2772.sql)

---

## MongoDB

## Cassandra

## Map Reduce Architecture

