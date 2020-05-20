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

<img src="https://github.com/ZhijunLiu96/Database-Project/blob/master/Entity%20Relationship%20Diagram/ERD1.png" hight = "45%" width = "45%">

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

## Cassandra
#### Scenario
In this assignment you will create a database for a virtual library. The books from the library can be be “checked out” by Users for a fixed period of time. For this assignment let us assume that books cannot be renewed. A User may check out any number of books at a time. Since the books are eBooks, any number of Users can check out a book at the same time.

- The library contains a collection of eBooks. Basic information about each book needs to be stored

>> - Title, primary author, secondary authors (if any), date of first publication, number of pages, publisher, translator (if any)
>> - For non-fiction books, a list of the key topics covered by the book needs to be stored. For works of fiction (including poems, plays, novels, collection of stories), the topic is just ‘fiction’.
- For each book, we also need to store information about when it was checked out by which User.
- For each User we need to store certain information
>> - User id, name, phone, address, university affiliation (if any)

#### Design
- My database is designed by Cassandra, which is an open source distributed database management system and provides high availability with no single point of failure.
- The keyspace I created is library, which includes three tables (column families). One is book_info, one is people, and the other is check_out.
- For the first table book_info, there are columns including book_id, title, primary_author, secondary_author, date_of_1st_publish, number_of_page, publisher, translator, and book_topic. And I set book_id as a primary key, because book_id is unique for each book. Also, in order to use LIKE operation later, the values in book_topic include both book_id and their topics for the convenience of creating indexed column.
- For the second table people, its columns are user_id, name, phone, address, and university_affiliation, and its primary key is user_id which is unique.
- In order to get the check out information, I also created a table check_out, which includes id, book_id, user_id, book_name, check_out_date, check_out_topic, user_name and university_affiliation. The primary key is id, which is unique for each check out, and the values in check_out_topic include both id and their topics for the convenience of creating indexed column to use the LIKE operation.

#### Create database
```
create keyspace library with replication = {'class':'SimpleStrategy','replication_factor':3};

use library;

create table library.book_info (book_id int primary key, title text, primary_author text, secondary_author text, date_of_1st_publish date, number_of_page int, publisher text, translator text, book_topic text);

create table library.people (user_id int primary key, name text, phone text, address text, university_affiliation text);

create table library.check_out (id int primary key, book_id int, user_id int, book_name text, check_out_date date, check_out_topic text, user_name text, university_affiliation text);
```
#### Queries
1.	Which books have been checked out since such and such date.
```
select book_name from check_out where check_out_date>='2018-09-01' allow filtering;
```
2.	Which users have checked out such and such book.
```
select user_name from check_out where book_name='Introduction to machine learning' allow filtering;
```

3.	How many books does the library have on such and such topic.
```
CREATE CUSTOM INDEX ON library.book_info (book_topic) USING 'org.apache.cassandra.index.sasi.SASIIndex' WITH OPTIONS = {
'analyzed' : 'true',
'analyzer_class' : 'org.apache.cassandra.index.sasi.analyzer.NonTokenizingAnalyzer',
'case_sensitive' : 'false', 
'mode' : 'CONTAINS'
};

select count(*) from book_info where book_topic LIKE '%Fiction%' allow filtering;
```
4.	Which users from Columbia University have checked out books on Machine Learning between this date and that date.
```
CREATE CUSTOM INDEX ON library.check_out (check_out_topic) USING 'org.apache.cassandra.index.sasi.SASIIndex' WITH OPTIONS = {
'analyzed' : 'true',
'analyzer_class' : 'org.apache.cassandra.index.sasi.analyzer.NonTokenizingAnalyzer',
'case_sensitive' : 'false', 
'mode' : 'CONTAINS'
};

select user_name from check_out where university_affiliation='Columbia University' and check_out_topic LIKE '%Machine Learning%' and check_out_date>'2017-01-01' and check_out_date<'2019-03-01' allow filtering;
```
---

## MongoDB
#### Scenario

In this assignment you will create a database for a virtual library. The books from the library can be be “checked out” by Users for a fixed period of time. For this assignment let us assume that books cannot be renewed. A User may check out any number of books at a time. Since the books are eBooks, any number of Users can check out a book at the same time.

- The library contains a collection of eBooks. Basic information about each book needs to be stored

>> - Title, primary author, secondary authors (if any), date of first publication, number of pages, publisher, translator (if any)
>> - For non-fiction books, a list of the key topics covered by the book needs to be stored. For works of fiction (including poems, plays, novels, collection of stories), the topic is just ‘fiction’.
- For each book, we also need to store information about when it was checked out by which User.
- For each User we need to store certain information
>> - User id, name, phone, address, university affiliation (if any)

#### Design

- The database I created is library, which includes three collections. One is book_info, one is people, and the other is check_out.
- For the first collection book_info, there are columns including book_id, title, primary_author, secondary_author, date_of_1st_publish, number_of_page, publisher, translator, and topic. And each row is a JSON object. Attribute book_id and attribute number_of_page are in the format of integer, date_of_1st_publish is in the format of date,  topic is in the format of list, and others are in the format of character.
- For the second collection people, its columns are user_id, name, phone, address, and university_affiliation, and each row is a document. The data type of user_id is integer, and other data types are in the format of character.
- In order to get the check out information, I also created a collection check_out, which includes book_id, user_id, book_name, check_out_date, topic, user_name and university_affiliation. Each row is a JSON object. book_id, user_id are integer, check_out_data is date type, and others are character types.

#### Create and populate database
```
use library

db.book_info.insert({book_id:1,title:"Introduction to machine learing",primary_author:"Alpaydin",secondary_author:"Ethem",date_of_1st_publish:ISODate("2014-03-01"),number_of_page:567,publisher:"The MIT Press",topic:["Machine Learning","Data Science"]})
db.book_info.insert({book_id:2, title: "Queen: the ultimate illustrated history of the crown kings of rock", primary_author:"Sutcliffe",secondary_author:"Phol", date_of_1st_publish:ISODate("2011-01-20"),number_of_page:367, publisher:"Voyageur Press", topic:["Music","Biogrophy"]})
db.book_info.insert({book_id:3,title:"Harry Potter und der Feuerkelch",primary_author:"Rowling,J.K",date_of_1st_publish:ISODate("2000-05-06"),number_of_page:776,publisher:"Carlsen",translator:"Klaus Fritz",topic:["Fiction"]})

db.people.insert({user_id:1, name:"Johnny",phone:"1891579896",address:"420 W 110th street, NYC",university_affiliation:"Columbia Universty"})
db.people.insert({user_id:2, name:"Jane",phone:"9172679391", address:"97W 42nd street, NYC", university_affiliation:"New York University"})
db.people.insert({user_id:3, name:"Jim",phone:"9173809395", address:"100W 82nd street, NYC",university_affiliation:"New York University"})
db.people.insert({user_id:4, name:"Kale",phone:"1234567890", address:"87W 145nd street, NYC",university_affiliation:"Columbia University"})
db.people.insert({user_id:5, name:"Sarah",phone:"6759823874",address:"56W 52nd street, NYC",university_affiliation:"New York University"})

db.check_out.insert({book_id:1,user_id:1, book_name:"Introduction to machine learning", check_out_date:ISODate("2018-07-01"),topic:["Machine Learning","Data Science"], user_name:"Johnny", university_affiliation:"Columbia University"})
db.check_out.insert({book_id:1,user_id:2, book_name:"Introduction to machine learning", check_out_date:ISODate("2018-12-01"),topic:["Machine Learning","Data Science"], user_name:"Jane", university_affiliation:"New York University"})
db.check_out.insert({book_id:2,user_id:3, book_name:"Queen: the ultimate illustrated history of the crown kings of rock", check_out_date:ISODate("2019-01-01"),user_name:"Jim",topic:["Music","Biogrophy"], university_affiliation:"New York University"})
db.check_out.insert({book_id:3,user_id:4, book_name:"Harry Potter und der Feuerkelch", check_out_date:ISODate("2018-07-01"), topic:["Fiction"], user_name:"Kale", university_affiliation:"Columbia University"})
db.check_out.insert({book_id:3,user_id:5, book_name:"Harry Potter und der Feuerkelch", check_out_date:ISODate("2018-11-01"), topic:["Fiction"], user_name:"Sarah", university_affiliation:"New York University"})
```

#### Queries

1. Which books have been checked out since such and such date.
```
db.check_out.find({check_out_date: {"$gte": ISODate("2018-04-20"),"$lt": ISODate("2018-10-21")}},{book_name:1})
```
2. Which users have checked out such and such book.
```
db.check_out.find({book_name:"Introduction to machine learning"},{user_name:1})
```
3. How many books does the library have on such and such topic.
```
db.book_info.find({$and:[{"topic":"Machine Learning"},{"topic":"Data Science"}]}).count()
```
4. Which users from Columbia University have checked out books on Machine Learning between this date and that date.
```
db.check_out.find({$and:[{university_affiliation:"Columbia University"},{"topic":"Machine Learning"},{check_out_date: {"$gte": ISODate("2018-04-20"),"$lt": ISODate("2018-10-21")}}]},{user_name:1})
```
---

## Map Reduce algorithm
We have a set of 5 documents containing HTML links to some other documents. Thus, you may have a document, Doc1, which contains the word ‘manufacturer’ which is a hyperlink, www.apple.com, to the landing page of Apple, Inc. (the company) landing page. In this case we regard Doc1 as the source, the word ‘manufacturer’ as the anchor in Doc1, and the landing page (which we will call Apple Landing Page) as the target. So, we can represent this information as <Apple Landing Page <Doc1:manufacturer>>. The general format for representing this information is <target <source:anchor>>. Of course, Doc1 may contain another hyperlink to Apple Landing page on the anchor ‘Apple’. In this case, we can represent the information about these two links in Doc1 as <Apple Landing Page <Doc1: manufacturer, Doc1: Apple>>. And if we had a second document Doc2 which contains a hyperlink to Apple Landing Page on the anchor ‘Apple’, we can represent this information as <Apple Landing Page <Doc1: manufacturer, Doc1: Apple, Doc2:Apple>>. Thus, the format for representing this information is: <target <list of source:anchor>>

Suppose you are given 5 documents which may contain hyperlinks to some targets. The MapReduce algorithm is used to compile a list of <target <list of source:anchor>>. Suppose you have 5 processing nodes (n1, n2, n3, n4, n5) on which to execute MapReduce for this task. The nodes n1, n2, n3 are used for Map and nodes n4, n5 are used for Reduce. Node n1 processes Doc1 and Doc2; node n2 processes Doc3 and Doc4, node n3 processes Doc5. You decide what should be assigned to nodes n4 and n5.
Show the following:

a.) Information stored on nodes n1, n2, n3 after Map has been executed
b.) Information stored on nodes n4, n5 after Reduce has been executed
c.) The final output

Also provide a diagram showing what information is sent to which node from which node.

<img src="https://github.com/ZhijunLiu96/Database-Project/blob/master/map%20reduce_architecture/map-reduce.png">
