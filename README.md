# PostgreSQL

## Table of contents

- [PostgreSQL](#postgresql)
  - [Table of contents](#table-of-contents)
  - [**COMMANDS**](#commands)
    - [`psql` Commands](#psql-commands)
    - [PostgreSQL Commands](#postgresql-commands)
    - [Useful commands line](#useful-commands-line)
      - [Use `pg_dumpall` to backup all databases](#use-pg_dumpall-to-backup-all-databases)
      - [Use `pg_dump` to backup a database](#use-pg_dump-to-backup-a-database)
      - [Restore a database with `psql`](#restore-a-database-with-psql)
      - [Restore a database with `pg_restore`](#restore-a-database-with-pg_restore)
  - [**DATATYPE**](#datatype)
    - [Enumerated Types `ENUM`](#enumerated-types-enum)
    - [`SEQUENCE`](#sequence)
  - [**CONSTRAINT**](#constraint)
    - [Syntax](#syntax)
    - [`CHECK()`](#check)
    - [`NOT NULL`](#not-null)
    - [`UNIQUE`](#unique)
    - [`PRIMARY KEY()`](#primary-key)
    - [`FOREIGN KEY()`](#foreign-key)
    - [`DEFAULT`](#default)
    - [`EXCLUDE`](#exclude)
    - [`DEFERRABLE`](#deferrable)
    - [`INITIALLY DEFERRED`](#initially-deferred)
  - [**DATABASE**](#database)
  - [**DATA DEFINITION**](#data-definition)
    - [Modifying Tables](#modifying-tables)
    - [Modifying Columns](#modifying-columns)
    - [Relations](#relations)
  - [**DATA MANIPULATION**](#data-manipulation)
    - [Inserting Data](#inserting-data)
    - [Updating Data](#updating-data)
    - [Deleting Data](#deleting-data)
  - [**QUERIES**](#queries)
    - [`FROM` Clause](#from-clause)
    - [`JOIN` Tables](#join-tables)
      - [`INNER JOIN` \& `NATURAL INNER JOIN`](#inner-join--natural-inner-join)
      - [`LEFT JOIN`](#left-join)
      - [`RIGHT JOIN`](#right-join)
      - [`FULL JOIN`](#full-join)
      - [Conditional `JOIN`](#conditional-join)
    - [`TABLE` \& `COLUMN` Aliases](#table--column-aliases)
    - [`WHERE` Clause](#where-clause)
    - [`GROUP BY` \& `HAVING` Clause](#group-by--having-clause)
      - [`GROUP BY`](#group-by)
      - [`HAVING`](#having)
    - [`GROUPING SETS`, `CUBE`, and `ROLLUP`](#grouping-sets-cube-and-rollup)
    - [`ORDER BY`](#order-by)
    - [`LIMIT` \& `OFFSET`](#limit--offset)
  - [**SCHEMAS**](#schemas)
    - [Search Path](#search-path)
  - [**DATABASE ROLES**](#database-roles)
    - [Role Attributes](#role-attributes)
    - [`CREATE ROLE` | `CREATE USER`](#create-role--create-user)
    - [`SET ROLE`, `RESET ROLE`](#set-role-reset-role)
    - [`ALTER ROLE`](#alter-role)
    - [`DROP ROLE`, `REASSIGN`](#drop-role-reassign)
  - [**PRIVILEGES** `GRANT` \& `REVOKE`](#privileges-grant--revoke)
    - [Privileges Attributes and Abbreviations](#privileges-attributes-and-abbreviations)
    - [`GRANT`](#grant)
    - [`REVOKE`](#revoke)
    - [`ALTER DEFAULT PRIVILEGES`](#alter-default-privileges)
    - [Few Examples](#few-examples)

## **COMMANDS**

### `psql` Commands

`psql` is a command-line interface for interacting with PostgreSQL databases. It allows you to execute SQL commands and view the results, create and modify database objects, and manage database users and permissions.

| Commands             | Details                          | Example                    |
| -------------------- | -------------------------------- | -------------------------- |
| `-U <username>`      | Connecting as a specific use     | `psql -U postgres`         |
| `-d <database_name>` | Connecting to database           | `psql -d animals`          |
| `-h <host_name>`     | Connecting to a host             | `psql -h localhost`        |
| `-p <port_name>`     | Connecting to a port             | `psql -p 1222`             |
| `-f`                 | Execute commands from a file     | `psql animals -f file.sql` |
| `-t`,`--tuples-only` | Print rows only                  | `psql -U -t`               |
| `-x`,`--expanded`    | Turn on expanded table output    | `psql -U -d -x`            |
| `-c`,`--command`     | Run only single command and exit | `psql -c -U -d`            |

### PostgreSQL Commands

| Commands             | scope      | Details                         |
| -------------------- | ---------- | ------------------------------- |
| `\c <database_name>` | DATABASE   | Connect to new database         |
| `\conninfo`          | DATABASE   | Display information             |
| `\l`                 | DATABASE   | List all databases              |
| `\l+`                | DATABASE   | List all databases with details |
| `\d <table_name>`    | TABLE      | Describe table                  |
| `\d+ <table_name>`   | TABLE      | Describe table with details     |
| `\dt`                | TABLE      | List tables from current schema |
| `\dT`, `\dT+`        | TABLE      | Show all user-defined types     |
| `\dt *.*`            | TABLE      | List tables from all schemas    |
| `\dp`                | TABLE      | List table access privileges    |
| `\! clear`           | GLOBAL     | Clear screen                    |
| `\du`, `\du+`        | DATABASE   | Clear screen                    |
| `\dn`, `\dn+`        | DATABASE   | List of all schema              |
| `\dD+`               | DOMAIN     | List of domains                 |
| `\db+`               | TABLESPACE | List of tablespaces             |

### Useful commands line

#### Use `pg_dumpall` to backup all databases

```sql
pg_dumpall -U postgres > universe.sql
```

#### Use `pg_dump` to backup a database

```sql
-- syntax --
pg_dump -d <database_to_be_saved> -f planets.sql

pg_dump -d planets -f planets.sql

-- `-a` Dump only the data, not the schema
-- `-s` Dump only the schema, no data
-- `-c` Drop database before recreating
-- `-C` Create database before restoring
-- `-t` Dump the named table(s) only
```

#### Restore a database with `psql`

```sql
-- syntax --
psql -U <username> <database_to_be_restored> < <backup_database>

psql -U postgres planets < planets.sql
```

#### Restore a database with `pg_restore`

```sql
-- syntax --
psql -U <username> -d <database_to_be_restored> <backup_database> -c

psql -U postgres planets planets.sql -c

-- `-U` Specify a database user
-- `-c` Drop database before recreating
-- `-C` Create database before restoring
-- `-e` Exit if an error has encountered
-- `-F` Format (c: custom, d: directory, t: tar, p: plain text sql(default)
```

## **DATATYPE**

PostgreSQL offers a wide range of data types to choose from when designing your database tables. From basic types like `integers` and `characters` to more specialized types like `JSON` and `UUID`, PostgreSQL has a data type to suit almost any need.

```SQL
-- syntax --
ALTER TABLE <table_name> ADD COLUMN <column_name> DATA TYPE;

-- example --
ALTER TABLE users ADD COLUMN username VARCHAR(30);

-- change data type --
ALTER TABLE <table_name> ALTER COLUMN <column_name> SET DATA TYPE <new_data_type>;

ALTER TABLE users ADD COLUMN username VARCHAR(99);
```

| Name             | typw    | Description                                          | syntax                   |
| ---------------- | ------- | ---------------------------------------------------- | ------------------------ |
| `SERIAL`         | Numeric | Auto-incrementing integer.                           | `... SERIAL`             |
| `INTEGER`, `INT` | Numeric | Stores integer values.                               | `...age INT`             |
| `SMALLINT`,      | Numeric | Signed two-byte integer.                             | ``                       |
| `NUMERIC(p,s)`,  | Numeric | Stores numbers with a fixed `precision` and `scale`. | `...price NUMERIC(10,2)` |
| `DECIMAL(p,s)`,  | Numeric | ''                                                   | ``                       |
| `VARCHAR(n)`     | char    | Variable-length character string                     | `...VARCHAR(255)`        |
| `text`           | char    | Variable unlimited length                            | ``                       |
| `BOOLEAN` `BOOL` | bool    | Logical Boolean (true/false)                         | `... BOOL`               |
| `DATE`           | date    | Calendar date (year, month, day)                     | `... DATE`               |
| `TIMESTAMP`      | date    | Date and time (no time zone)                         | ``                       |
| `uuid`           | ''      | Universally unique identifier                        | ``                       |
| `json`           | ''      | Textual JSON data                                    | ``                       |

### Enumerated Types `ENUM`

### `SEQUENCE`

_Create `SEQUENCE`_
_Alter `SEQUENCE`_
_Drop `SEQUENCE`_

```sql
-- syntax --
CREATE TYPE <enum_name> AS ENUM (<enum_values>);

-- examples --
CREATE TYPE user_status AS ENUM ('Active', 'Inactive', 'Blocked');

-- Rename Enum
ALTER TYPE <old_enum_name> RENAME TO <new_enum_name>
ALTER TYPE user_status RENAME TO user_login_status

-- View All Enum values
SELECT * FROM pg_enum;
-- View All Enum values from specific type
SELECT * FROM pg_enum WHERE enumtypid = '<enum_name>'::regtype ;


-- Add Enum values
ALTER TYPE <enum_name> ADD VALUE '<value>'

ALTER TYPE <enum_name> ADD VALUE '<value>' AFTER '<stored_value>'


-- Rename enum values
ALTER TYPE <enum_name> RENAME VALUE  '<old_value>' TO '<new_value>'

ALTER TYPE user_status RENAME VALUE 'Inactive' to 'In-Active'

-- Drop Enum Type--
DROP TYPE <enum_name>;

DROP TYPE user_status;

-- Drop a Enum Value
DELETE FROM pg_enum WHERE enumtypid = '<enum_name>'::regtype AND enumlabel = '<enum_value_to_delete>'

DELETE FROM pg_enum WHERE enumtypid = 'user_status'::regtype AND enumlabel = 'In-Active'
```

## **CONSTRAINT**

### Syntax

```sql

-- Example with create table --
CREATE TABLE users (
   id   INT PRIMARY KEY,
   username VARCHAR(33) UNIQUE NOT NULL,
   profile  INT REFERENCES profiles(profile_id)
   age CHECK(age >= 18)
   status VARCHAR(55) DEFAULT 'Active'
);

-- With desire constraint name --

ALTER TABLE <table_name> add CONSTRAINT <constraint_name> CONSTRAINT;

ALTER TABLE  users add CONSTRAINT valid_age CHECK(age >= 18);
ALTER TABLE  articles add CONSTRAINT article_primary_key PRIMARY KEY(article_id, article_author);

-- Rename constraint name --

ALTER TABLE <table_name> RENAME CONSTRAINT <old_constraint_name> TO <new_constraint_name>;

ALTER TABLE articles RENAME CONSTRAINT author_title to compkey_author_title;

-- drop --
ALTER TABLE <table_name> DROP CONSTRAINT <CONSTRAINT_NAME>;

ALTER TABLE users DROP CONSTRAINT users_age_check;
```

### `CHECK()`

A combination of a NOT NULL and UNIQUE constraint, used to identify each row in a table.

```sql
-- syntax --
ALTER TABLE <table_name> ADD COLUMN <column_name> <DATA_TYPE> <CONSTRAINT> CHECK( <column_name> <condition>) ;

-- example --
ALTER TABLE users ADD COLUMN age INT NOT NULL CHECK( age >= 18 );

ALTER TABLE  users add CONSTRAINT valid_age CHECK(age >= 18)

...CHECK (status IN ('Active', 'Inactive'))
...CHECK (grade >= 0 AND grade <= 100),
...CHECK (date_of_birth < NOW()),

-- drop --
ALTER TABLE <table_name> DROP CONSTRAINT <CONSTRAINT_NAME>;

ALTER TABLE users DROP CONSTRAINT users_age_check;
```

### `NOT NULL`

Ensures that a column cannot contain a null value.

```sql
-- syntax --
ALTER TABLE <table_name> ADD COLUMN <column_name> <DATA_TYPE> NOT NULL;

-- examples --
ALTER TABLE users ADD COLUMN username VARCHAR(33) NOT NULL;

ALTER TABLE users ALTER COLUMN username SET NOT NULL;

-- drop --
ALTER TABLE <table_name> ALTER COLUMN <column_name> DROP NOT NULL ;

ALTER TABLE users ALTER COLUMN username DROP NOT NULL ;
```

### `UNIQUE`

Ensures that the values in a column or set of columns are unique across all rows in the table.

```sql
-- syntax --
ALTER TABLE <table_name> ADD COLUMN <column_name> <DATA_TYPE> UNIQUE ;

ALTER TABLE <table_name> ADD UNIQUE(<column_name>) ;

-- examples --
ALTER TABLE users ADD COLUMN username VARCHAR(33) UNIQUE ;

ALTER TABLE users ADD UNIQUE(username) ;

-- drop --
ALTER TABLE <table_name> DROP CONSTRAINT <CONSTRAINT_NAME>;

ALTER TABLE users DROP CONSTRAINT users_username_key;
```

Add the `UNIQUE` constraint to the column you just added.

### `PRIMARY KEY()`

A combination of a NOT NULL and UNIQUE constraint, used to identify each row in a table.

```sql
-- syntax --
ALTER TABLE <table_name> ADD PRIMARY KEY(<column_name>);

-- examples --
ALTER TABLE users ADD PRIMARY KEY(username) ;

-- drop --
ALTER TABLE <table_name> DROP CONSTRAINT <CONSTRAINT_NAME>;

ALTER TABLE users DROP CONSTRAINT users_pkey;
```

**Composite `PRIMARY KEY()`**

A composite primary key, also known as a compound primary key, is a primary key that consists of two or more columns. It is used to uniquely identify each row in a table when the primary key cannot be determined by a single column.

```sql
-- syntax --
ALTER TABLE <table_name> ADD PRIMARY KEY(<column_name>,<column_name>,...) ;

-- examples --
ALTER TABLE articles ADD PRIMARY KEY(title, author) ;

ALTER TABLE articles ADD CONSTRAINT compkey_title_author PRIMARY KEY(title, author)

-- drop --
ALTER TABLE <table_name> DROP CONSTRAINT <CONSTRAINT_NAME>;

ALTER TABLE users DROP CONSTRAINT users_pkey;
```

### `FOREIGN KEY()`

Ensures that the values in a column (or set of columns) match the values in a column (or set of columns) in another table.

```sql
-- syntax --
ALTER TABLE <table_name> ADD COLUMN <column_name> <CONSTRAINT> REFERENCES <table_name>(<column_name>)

ALTER TABLE <table_name> ADD FOREIGN KEY (<column_name>) REFERENCES <table_name>(<column_name>)

-- examples --
ALTER TABLE profiles ADD COLUMN user_id INT REFERENCES users(user_id)

ALTER TABLE profiles ADD FOREIGN KEY(stat_id) REFERENCES statistics(stat_id)

-- drop --
ALTER TABLE <table_name> DROP CONSTRAINT <CONSTRAINT_NAME>;

ALTER TABLE users DROP CONSTRAINT profile_uname_fkey;
```

### `DEFAULT`

is a constraint that specifies a default value for a column. If no value is specified for the column when a new row is inserted, the default value will be used.

```sql
-- syntax --
ALTER TABLE <table_name> ALTER COLUMN <column_name> SET DEFAULT <value> ;

-- examples --
ALTER TABLE users ALTER COLUMN name SET DEFAULT 'Anonymous' ;

-- drop --

ALTER TABLE profiles ALTER COLUMN name DROP DEFAULT;
```

### `EXCLUDE`

_not yet learn_

### `DEFERRABLE`

_not yet learn_

### `INITIALLY DEFERRED`

_not yet learn_

## **DATABASE**

```sql
-- List of all databases
\l

-- Connect to a database.
\c <database_name>

\c users

-- Show current database
SELECT current_database();

-- Create new database
CREATE DATABASE <database_name>;

CREATE DATABASE users ;

--- Rename a database
ALTER DATABASE <old_database_name> RENAME TO <new_database_name>;

ALTER DATABASE user RENAME TO users;

-- Drop database
DROP DATABASE <database_name>;
DROP DATABASE IF EXISTS <database_name>;

DROP DATABASE users ;
DROP DATABASE IF EXISTS users;

```

## **DATA DEFINITION**

### Modifying Tables

```sql
-- Display the tables.
\d
\d <table_name>

-- Create tables
CREATE TABLE <table_name>();
CREATE TABLE <table_name>(<column_name> DATATYPE CONSTRAINT, ...);

CREATE TABLE user(username VARCHAR(30) UNIQUE PRIMARY KEY,...);

-- Rename Table
ALTER TABLE <table_name> RENAME TO <new_table_name> ;

ALTER TABLE user RENAME TO users ;

-- Drop Table
DROP TABLE <table_name>;

DROP TABLE users;

-- Constraint
ALTER TABLE users ADD UNIQUE(username);
ALTER TABLE users ADD PRIMARY KEY(username) ;
ALTER TABLE users ADD CONSTRAINT valid_age CHECK(age >= 18) ;
ALTER TABLE profiles ADD FOREIGN KEY(stat_id) REFERENCES statistics(stat_id)

ALTER TABLE <table_name> DROP CONSTRAINT <CONSTRAINT_NAME>;
```

### Modifying Columns

```sql
--- Add columns
ALTER TABLE <table_name> ADD COLUMN <column_name> DATATYPE CONSTRAINT;

ALTER TABLE users ADD COLUMN username VARCHAR(30) UNIQUE NOT NULL;

-- Rename column
ALTER TABLE <table_name> RENAME COLUMN <old_column_name> TO <new_column_name>;

ALTER TABLE persons RENAME COLUMN name TO username;

-- Drop columns
ALTER TABLE <table_name> DROP COLUMN <column_name>;

ALTER TABLE profiles DROP COLUMN bio;

-- Change Data Type

ALTER TABLE <table_name> ALTER COLUMN <column_name> TYPE <NEW_DATA_TYPE>;
ALTER TABLE profiles ALTER COLUMN bio TYPE TEXT;

-- Constraint
ALTER TABLE profiles ALTER COLUMN gender SET NOT NULL;
ALTER TABLE profiles ALTER COLUMN bio SET DEFAULT '';

ALTER TABLE profiles ALTER COLUMN bio DROP DEFAULT;
```

### Relations

```sql
-- These tables have a "one-to-one" relationship. One row in the characters table will be related to exactly one row in more_info and vice versa. Enforce that by adding the UNIQUE constraint to your foreign key.

ALTER TABLE table_name ADD UNIQUE(column_name);

---

ALTER TABLE table_name ADD COLUMN column_name DATATYPE CONSTRAIN REFERENCES referenced_table_name(referenced_column_name);

ALTER TABLE additional_info ADD COLUMN character_id VARCHAR(30) UNIQUE REFERENCES characters(character_id);

```

```sql
-- This will be a "one-to-many" relationship because one character will have many sounds, but no sound will have more than one character. Here's the example again:

ALTER TABLE table_name ADD COLUMN column_name DATATYPE CONSTRAINT REFERENCES referenced_table_name(referenced_column_name);
```

```sql
-- "Many-to-many" relationships usually use a junction table to link two tables together, forming two "one-to-many" relationships.

```

## **DATA MANIPULATION**

### Inserting Data

```sql
-- syntax --
INSERT INTO <table_name>(<column_name>, <column_name>,...) VALUES(<value>, <value>,...);

-- examples --
INSERT INTO persons(id,username) VALUES(1,'Sizar');

-- Insert into Multiple row/data at the same time
INSERT into users(username, name, email, role, profile)
  values('luffy','Luffy Monkey D.','luffy@onepiece.com','User',3),
  ('demonslayer','Tanjirou Kamado','tanjirou@demonslayer.com','User',5);

-- Insert and return values
INSERT INTO users(username,name,email,role,profile)
  VALUES('jujutsu_sorcerer','Satoru Gojou','gojou@ujutsu.com','User',11)
  RETURNING username, name, email ;
```

### Updating Data

```sql
-- syntax --
UPDATE <table_name> SET <column_name> = <new_value> WHERE <CONDITIONS>;

-- examples --
UPDATE users SET name='Monkey D. Luffy' WHERE username='luffy';

-- The new column value can be any scalar expression
UPDATE products SET price = price * 1.10;

-- Update more than one column
UPDATE users SET name = '...', bio = '...', website = '...'  WHERE username= '...';

-- Update and return values
UPDATE users SET name='Monkey D. Luffy' WHERE username='luffy' RETURNING name as updated_name;
```

### Deleting Data

```sql
-- syntax --
DELETE FROM table_name WHERE CONDITIONS;

-- examples --
DELETE FROM persons WHERE username='Sizar';
```

## **QUERIES**

### `FROM` Clause

```sql
-- syntax --
SELECT * FROM <table_name>;
SELECT <column_name>,... FROM <table_name>
SELECT <column_name>, <column_name> + <column_name> FROM <table_name>

-- example --
SELECT * FROM users;
SELECT customer_name,  total_price - discount AS total FROM cart;
```

### `JOIN` Tables

```sql
-- syntax --
... <table_name_1> <JOIN TYPE> JOIN <table_name_1> ON <boolean_expression>
... <table_name_1> <JOIN TYPE> JOIN <table_name_1> USING(<join_column_name>)
```

```bash
table_1           table_2

  num | name        num | value
------+------     ------+------
  1   |   a         1   | xxx
  2   |   b         3   | yyy
  3   |   c         5   | zzz
```

#### `INNER JOIN` & `NATURAL INNER JOIN`

```sql
SELECT * FROM table_1 INNER JOIN table_2 ON table_1.num = table_2.num;

 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
   3 | c    |   3 | yyy

SELECT * FROM table_1 INNER JOIN table_2 USING (num);

 num | name | value
-----+------+-------
   1 | a    | xxx
   3 | c    | yyy

SELECT * FROM table_1 NATURAL INNER JOIN table_2;

 num | name | value
-----+------+-------
   1 | a    | xxx
   3 | c    | yyy
```

#### `LEFT JOIN`

```sql
SELECT * FROM table_1 LEFT JOIN table_2 ON table_1.num = table_2.num;

 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
   2 | b    |     |
   3 | c    |   3 | yyy

SELECT * FROM table_1 LEFT JOIN table_2 USING (num);

 num | name | value
-----+------+-------
   1 | a    | xxx
   2 | b    |
   3 | c    | yyy
```

#### `RIGHT JOIN`

```sql
SELECT * FROM table_1 RIGHT JOIN table_2 ON table_1.num = table_2.num;

 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
   3 | c    |   3 | yyy
     |      |   5 | zzz
```

#### `FULL JOIN`

```sql
SELECT * FROM table_1 FULL JOIN table_2 ON table_1.num = table_2.num;

 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
   2 | b    |     |
   3 | c    |   3 | yyy
     |      |   5 | zzz
```

#### Conditional `JOIN`

```sql
SELECT * FROM table_1 LEFT JOIN table_2 ON table_1.num = table_2.num AND table_2.value = 'xxx';

 num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
   2 | b    |     |
   3 | c    |     |

SELECT * FROM table_1 LEFT JOIN table_2 ON table_1.num = table_2.num WHERE table_2.value = 'xxx';

   num | name | num | value
-----+------+-----+-------
   1 | a    |   1 | xxx
```

### `TABLE` & `COLUMN` Aliases

```sql
-- syntax --
...FROM <table_name> AS <alias>
...FROM <table_name> <alias>

-- example --
SELECT * FROM users AS u INNER JOIN profiles AS p ON u.user_id = p.user_id;
SELECT * FROM users u INNER JOIN profiles p ON u.user_id = p.user_id;

SELECT * FROM people AS mother JOIN people AS child ON mother.id = child.mother_id;

SELECT u.name, u.username, p.gender FROM users AS u INNER JOIN profiles AS p ON u.user_id = p.user_id;
```

### `WHERE` Clause

```sql
-- syntax --
... WHERE <CONDITION>

-- examples --
SELECT * FROM users INNER JOIN profiles USING(user_id) WHERE username < 'd';
SELECT * FROM users INNER JOIN profiles USING(user_id) WHERE role IN ('Admin','Author');
SELECT * FROM users INNER JOIN profiles USING(user_id) WHERE role IN (SELECT role FROM users WHERE user_id = 1);
SELECT * FROM users INNER JOIN profiles USING(user_id) WHERE gender = 'Female' AND role = 'Admin';
```

### `GROUP BY` & `HAVING` Clause

#### `GROUP BY`

```sql
-- syntax --
SELECT ... FROM ... GROUP BY <grouping_column_reference> [,...];
SELECT ... FROM ... WHERE ... GROUP BY <grouping_column_reference> [,...];
SELECT ..., <aggregate_expressions> FROM ... WHERE ... GROUP BY <grouping_column_reference> [,...];

-- examples --
SELECT gender FROM users INNER JOIN profiles USING(user_id) GROUP BY gender;
SELECT gender, count(username) AS total_users_by_gender
  FROM users INNER JOIN profiles USING(user_id)
  GROUP BY gender;

```

#### `HAVING`

```sql
-- syntax --
SELECT ... FROM ... GROUP BY ... HAVING <boolean_expression | conditions>;

-- examples --
SELECT gender, count(username) AS total_users_by_gender FROM users INNER JOIN profiles USING(user_id) GROUP BY gender HAVING count(username) > 4;

SELECT product_id, p.name, (sum(s.units) * (p.price - p.cost)) AS profit
    FROM products p LEFT JOIN sales s USING (product_id)
    WHERE s.date > CURRENT_DATE - INTERVAL '4 weeks'
    GROUP BY product_id, p.name, p.price, p.cost
    HAVING sum(p.price * s.units) > 5000;
```

### `GROUPING SETS`, `CUBE`, and `ROLLUP`

```sql
-- Grouping Sets

SELECT role,count(username) FROM users GROUP BY GROUPING SETS ((role),());
SELECT brand, size, sum(sales) FROM items_sold GROUP BY GROUPING SETS ((brand), (size), ());
```

### `ORDER BY`

```sql
-- syntax --
SELECT <column_name> FROM <table_name> ORDER BY <sort_expression | column_name>;
-- [ASC | DESC] [NULLS { FIRST | LAST }]

SELECT * FROM users ORDER BY username
SELECT * FROM users ORDER BY username DESC;
```

### `LIMIT` & `OFFSET`

```sql
-- syntax --
SELECT <column_name> FROM <table_name> ORDER BY <column_name> LIMIT <number>;

-- example --
SELECT * FROM users ORDER BY user_id LIMIT 5;
SELECT * FROM users ORDER BY user_id LIMIT 5 OFFSET 2;
```

## **SCHEMAS**

```sql
-- Show all schema
\dn

-- Create Schema
CREATE SCHEMA <schema_name>
CREATE SCHEMA <schema_name> AUTHORIZATION <user_name>

CREATE SCHEMA private_schema;
CREATE SCHEMA private_schema AUTHORIZATION galactus;

-- To create or access objects in a schema
CREATE TABLE <schema_name>.<table_name>();

CREATE TABLE private_schema.users();

-- Drop schema
DROP SCHEMA <schema_name>;

DROP SCHEMA private_schema;

-- Drop schema including everything inside
DROP SCHEMA private_schema CASCADE;
```

### Search Path

```sql
-- show current search path
SHOW search_path;

-- set different search path
SET search_path TO <to_new_schema_name>, public;
SET search_path TO <to_new_schema_name>;
```

## **DATABASE ROLES**

### Role Attributes

| Parameter                            | Description                  |
| ------------------------------------ | ---------------------------- |
| `name`, `<role_name>`, `<user_name>` |                              |
| `SUPERUSER`, `NOSUPERUSER`           | Superuser status             |
| `CREATEDB`, `NOCREATEDB`             | Database creation            |
| `CREATEROLE`,`NOCREATEROLE`          | Role creation                |
| `INHERIT`,`NOINHERIT`                | Inheritance of privileges    |
| `LOGIN`,`NOLOGIN`                    | Login privilege              |
| `BYPASSRLS`,`NOBYPASSRLS`            | Bypassing row-level security |
| `CONNECTION LIMIT <connlimit>`       | Connection limit             |
| `ENCRYPTED PASSWORD 'password'`      |                              |
| `VALID UNTIL 'timestamp'`            |                              |
| `IN ROLE <role_name> [,...]`         |                              |
| `IN GROUP <role_name> [,...]`        |                              |
| `ROLE <role_name>`                   |                              |
| `ADMIN <role_name>`                  |                              |
| `USER <role_name>`                   |                              |
| `SYSID uid`                          |                              |

```sql
-- List of roles
SELECT rolname FROM pg_roles;

-- Listing the existing roles.
\du
```

### `CREATE ROLE` | `CREATE USER`

```sql
-- syntax --
CREATE ROLE <role_name> WITH <role_attribute>
CREATE USER <user_name> WITH <role_attribute>
CREATE ROLE <role_name> <role_attribute>;

-- examples --
CREATE USER galactus WITH SUPERUSER PASSWORD 'password'

CREATE ROLE db_admin WITH CREATEDB CREATEROLE;

-- Create a role with a password that is valid until the end of 2004. After one second has ticked in 2005, the password is no longer valid.
CREATE ROLE silver_surfer WITH LOGIN PASSWORD 'jw8s0F4' VALID UNTIL '2005-01-01';
```

### `SET ROLE`, `RESET ROLE`

```sql
-- Show active role
SELECT current_user;

-- Set/Switch to other role
SET ROLE <role_name|user_name>
SET ROLE aurora

-- Reset To default role
RESET ROLE;
```

### `ALTER ROLE`

```sql
-- syntax --
ALTER ROLE <role_name> WITH <new_role_attribute>

--example --
ALTER ROLE db_admin WITH NOCREATEROLE ;

ALTER USER aurora valid until 'Jan 9 3:15:00 2023 +6'
```

### `DROP ROLE`, `REASSIGN`

```sql
-- syntax --
DROP ROLE <role_name>
DROP USER <user_name>

-- examples --
DROP USER IF EXISTS galactus;

-- Change Owner
ALTER TABLE <table_name> OWNER TO <to_new_owner_name>;

ALTER TABLE galaxies OWNER TO sizar;

-- Reassign Role
REASSIGN OWNED BY <current_owner_name> to <new_owner_name>;
REASSIGN OWNED BY aurora to sizarcorpse;

-- Drop owned
DROP OWNED BY <owner_name>;
DROP OWNED BY <owner_name> CASCADE;
```

## **PRIVILEGES** `GRANT` & `REVOKE`

### Privileges Attributes and Abbreviations

| Privilege              | Applicable Object Types             | Abbreviation |
| ---------------------- | ----------------------------------- | ------------ |
| `SELECT`               | `TABLE`                             | `r`          |
| `INSERT`               | `TABLE`                             | `a`          |
| `UPDATE`               | `TABLE`                             | `w`          |
| `DELETE`               | `TABLE`                             | `d`          |
| `TRUNCATE`             | `TABLE`                             | `D`          |
| `REFERENCES`           | `TABLE`                             | `x`          |
| `TRIGGER`              | `TABLE`                             | `t`          |
| `ALL`                  | `TABLE`                             | ``           |
| `SELECT`               | `table_column`                      | `r`          |
| `INSERT`               | `table_column`                      | `a`          |
| `UPDATE`               | `table_column`                      | `w`          |
| `REFERENCES`           | `table_column`                      | ``           |
| `ALL`                  | `table_column`                      | ``           |
| `USAGE`                | `SEQUENCE`                          | `U`          |
| `SELECT`               | `SEQUENCE`                          | `r`          |
| `UPDATE`               | `SEQUENCE`                          | `w`          |
| `ALL`                  | `SEQUENCE`                          | ``           |
| `CREATE`               | `DATABASE`                          | `C`          |
| `CONNECT`              | `DATABASE`                          | `c`          |
| `TEMPORARY`            | `DATABASE`                          | `T`          |
| `TEMP`                 | `DATABASE`                          | ``           |
| `ALL`                  | `DATABASE`                          | ``           |
| `USAGE`                | `DOMAIN`                            | `U`          |
| `ALL`                  | `DOMAIN`                            | ``           |
| `USAGE`                | `FOREIGN DATA WRAPPER`              | `U`          |
| `ALL`                  | `FOREIGN DATA WRAPPER`              | ``           |
| `USAGE`                | `FOREIGN SERVER`                    | `U`          |
| `ALL`                  | `FOREIGN SERVER`                    | ``           |
| `EXECUTE`              | `FUNCTION`,`PROCEDURE`,`ROUTINE`    | `X`          |
| `ALL`                  | `FUNCTIONS`,`PROCEDURES`,`ROUTINES` | ``           |
| `USAGE`                | `LANGUAGE`                          | `U`          |
| `ALL`                  | `LANGUAGE`                          | ``           |
| `SELECT`               | `LARGE OBJECT`                      | `r`          |
| `UPDATE`               | `LARGE OBJECT`                      | `w`          |
| `ALL`                  | `LARGE OBJECT`                      | ``           |
| `SET`                  | `PARAMETER`                         | `s`          |
| `ALTER SYSTEM`         | `PARAMETER`                         | `A`          |
| `ALL`                  | `PARAMETER`                         | ``           |
| `CREATE`               | `SCHEMA`                            | `C`          |
| `USAGE`                | `SCHEMA`                            | `U`          |
| `ALL`                  | `SCHEMA`                            | ``           |
| `CREATE`               | `TABLESPACE`                        | `C`          |
| `ALL`                  | `TABLESPACE`                        | ``           |
| `USAGE`                | `TYPE`                              | `U`          |
| `ALL`                  | `TYPE`                              | ``           |
| --                     | --                                  | --           |
| `ALL TABLES IN SCHEMA` | ""                                  | ""           |

### `GRANT`

```sql
-- read_only = role
-- galactus = user

GRANT <sql_commands> ON <sql_objects> TO <role_name/user_name>

-- to user
GRANT CONNECT ON DATABASE universe TO galactus ;

-- to role
GRANT CONNECT ON DATABASE universe TO read_only ;

-- on table
GRANT SELECT,UPDATE ON TABLE galaxy TO galactus ;

-- on column
GRANT SELECT,UPDATE(galaxy_name,galaxy_type,galaxy_radius) ON TABLE galaxy TO galactus ;

-- all tables on schema
GRANT SELECT ON ALL TABLES IN SCHEMA private TO read_only ;
GRANT SELECT ON ALL TABLES IN SCHEMA private TO galactus ;

-- role
GRANT <role_name> TO <user_name>
GRANT <role_name> TO <user_name>[,...]

GRANT read_only TO galactus ;
```

### `REVOKE`

```sql
-- Show Search path
show search_path

-- Revoke all
revoke create on schema public from public
revoke all on database octopus from public
```

### `ALTER DEFAULT PRIVILEGES`

```sql
-- `IN SCHEMA`
-- `FOR ROLE`

-- Grant SELECT privilege to everyone for all tables
ALTER DEFAULT PRIVILEGES IN SCHEMA myschema GRANT SELECT ON TABLES TO PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA myschema GRANT INSERT ON TABLES TO webuser;

-- Revoke the above
ALTER DEFAULT PRIVILEGES IN SCHEMA myschema REVOKE SELECT ON TABLES FROM PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA myschema REVOKE INSERT ON TABLES FROM webuser;

-- Remove the public EXECUTE
ALTER DEFAULT PRIVILEGES FOR ROLE admin REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

```

### Few Examples

```sql
-- Read only
create role role_read_only;
grant connect on database octopus to role_read_only;
create schema new_schema;
grant usage on schema new_schema to role_read_only;
grant select on all tables in schema new_schema to role_read_only;
alter default privileges in schema new_schema grant select on tables to role_read_only;

-- read/write
CREATE ROLE role_read_write;
GRANT CONNECT ON DATABASE octopus TO role_read_write;
GRANT USAGE, CREATE ON SCHEMA new_schema TO role_read_write;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA new_schema TO role_read_write;
ALTER DEFAULT PRIVILEGES IN SCHEMA new_schema GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO role_read_write;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA new_schema TO role_read_write;
ALTER DEFAULT PRIVILEGES IN SCHEMA new_schema GRANT USAGE ON SEQUENCES TO role_read_write;
```
