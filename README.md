# Advance database concepts

This repo holds all the assignments developed towards the course B561 Advance
Database Concepts.

## Topics covered in this course

- Database models and systems:
	- especially relational, nested and object-relational, and semi-structured (
	  JSON document), key-value stores, and graph databases). This will contrast
	  SQL, noSQL, and new SQL database systems
- State-changing database operations:
	- database updates and triggers
- Query and database programming languages:
  (object-relational) SQL, key-valued, partitioned, and distributed
  programming (e.g. Spark), property-graph querying (e.g., neo4J)
- Aspects and components of query processing:
	- query transformation, translation, analysis, and optimization)
- Data structures and algorithms for efficient query processing
	- External sorting
	- Indexes: B+-trees and hashing
	- Algorithms for a spectrum of fundamental query operations
- Elements of transaction management:
	- concurrency and recovery

### Repo structure

- Each directory contains the sql query's developed towards the specific
  assignment
- Each assignment has problem statement, initial data , driver script and
  expected output.
- The folder `submission` will contain the final version developed towards the
  assignment.
- `test-query-postgres.sql` contains all development code.

> Assignment 1: Assignment 1 Relational Databases, Expressing Queries and Constraints in SQL and in Tuple Relational Calculus (TRC).

> Assignment 2: SQL Part 1 and SQL Part 2 (Pure SQL); Views; Relational Algebra (RA); and Joins and semi-joins.

> Assignment 3: Translating Pure SQL queries into RA expressions; and  Query optimization

> Assignment 4: Functions and expressions in SQL; Aggregate functions and partitioning; and Triggers.

> Assignment 5: Object-relational databases and queries; Nested relational and semi-structured databases.

> Assignment 6: External Merge Sorting, Indexing, B+ trees and Hashing

> Assignment 7: Algorithms for RA operations , Query processing and query plans , Object-relational database programming , Key-value stores. NoSQL in MapReduce style  Key-value stores; NoSQL in Spark style , Graph databases

> Assignment 8: Concurrency control, Transaction scheduling

### List of Postgres commands

- Basic commands[#basic-commands]
- User Management[#user-management]

> #### **_Basic commands_**

##### List all tables in database: `\l`

##### List all users: `\du`

##### Connect To database: `\c database_name`

##### Clear screen: `\! cls`

> #### **_User Management_**

##### create user: `create user user_name with password 'test123';`

##### alter user: `alter user user_name with SUPERUSER;`