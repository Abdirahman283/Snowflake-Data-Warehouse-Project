------------Configuration-----------------
--Create a warehouse DATASECURE_WH_JOHNDOE
USE ROLE TRAINING_ROLE;
CREATE WAREHOUSE IF NOT EXISTS DATASECURE_WH_JOHNDOE;



--Create a database DATASECURE_DB_JOHNDOE
USE WAREHOUSE DATASECURE_WH_JOHNDOE;
CREATE DATABASE IF NOT EXISTS DATASECURE_DB_JOHNDOE;


--Create a schema DATASECURE_SCHEMA_JOHNDOE
USE WAREHOUSE DATASECURE_WH_JOHNDOE;
USE DATABASE DATASECURE_DB_JOHNDOE;
CREATE SCHEMA DATASECURE_SCHEMA_JOHNDOE;


--Create a table called USER_T_JOHNDOE
USE WAREHOUSE DATASECURE_WH_JOHNDOE;
USE DATABASE DATASECURE_DB_JOHNDOE;
USE SCHEMA DATASECURE_SCHEMA_JOHNDOE;
CREATE TABLE IF NOT EXISTS USER_T_JOHNDOE (
       UserID NUMBER(38,0) NOT NULL,
       FirstName      VARCHAR(150),
       LastName      VARCHAR(150),
       Email      VARCHAR(150),
       Age NUMBER(38,0),
       Location      VARCHAR(150),
       CardType      VARCHAR(150),
       ZipCode NUMBER(38,0),
       CreditCardNumber   VARCHAR(150));

--Creer a table ORDER_T_JOHNDOE
USE WAREHOUSE DATASECURE_WH_JOHNDOE;
USE DATABASE DATASECURE_DB_JOHNDOE;
USE SCHEMA DATASECURE_SCHEMA_JOHNDOE;
CREATE TABLE IF NOT EXISTS ORDER_T_JOHNDOE (
        OrderID NUMBER(38,0) NOT NULL,
        UserID NUMBER(38,0) NOT NULL,
        Product VARCHAR(150),
        Amount  NUMBER(38,3),
        OrderDate DATE);

--Create a table PRODUCT_INVENTORY_JOHNDOE
USE WAREHOUSE DATASECURE_WH_JOHNDOE;
USE DATABASE DATASECURE_DB_JOHNDOE;
USE SCHEMA DATASECURE_SCHEMA_JOHNDOE;
CREATE TABLE IF NOT EXISTS PRODUCT_INVENTORY_JOHNDOE (
        ProductID NUMBER(38,0) NOT NULL,
        Category VARCHAR(150),
        ProductName VARCHAR(150),
        Price NUMBER(38,3),
        StockQuantity NUMBER(38,0));

--Create file format
USE WAREHOUSE DATASECURE_WH_JOHNDOE;
USE DATABASE DATASECURE_DB_JOHNDOE;
--1
CREATE OR REPLACE FILE FORMAT FILE_FORMAT_USER
  TYPE = CSV
  COMPRESSION = GZIP
  FIELD_DELIMITER = ','
  FILE_EXTENSION = 'gz'
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
  SKIP_HEADER = 1;;

--2
CREATE OR REPLACE FILE FORMAT FILE_FORMAT_ORDER 
  TYPE = CSV
  COMPRESSION = GZIP
  FIELD_DELIMITER = ','
  FILE_EXTENSION = 'gz'
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
  SKIP_HEADER = 1;

--3
CREATE OR REPLACE FILE FORMAT FILE_FORMAT_PRODUCT
  TYPE = CSV
  COMPRESSION = GZIP
  FIELD_DELIMITER = ','
  FILE_EXTENSION = 'gz'
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
  SKIP_HEADER = 1;



--Create an internal stage MYSTAGE_JOHNDOE
USE WAREHOUSE DATASECURE_WH_JOHNDOE;
USE DATABASE DATASECURE_DB_JOHNDOE;
USE SCHEMA DATASECURE_SCHEMA_JOHNDOE;
CREATE STAGE MYSTAGE_JOHNDOE;


--Copy data in tables
--1
USE WAREHOUSE DATASECURE_WH_JOHNDOE;
USE DATABASE DATASECURE_DB_JOHNDOE;
USE SCHEMA DATASECURE_SCHEMA_JOHNDOE;
COPY INTO USER_T_JOHNDOE
FROM @MYSTAGE_JOHNDOE
FILES =('users_raw_large_with_name_split_formated.csv.gz')
FILE_FORMAT = (FORMAT_NAME = FILE_FORMAT_USER)
ON_ERROR = CONTINUE;

--2
USE WAREHOUSE DATASECURE_WH_JOHNDOE;
USE DATABASE DATASECURE_DB_JOHNDOE;
USE SCHEMA DATASECURE_SCHEMA_JOHNDOE;
COPY INTO ORDER_T_JOHNDOE
FROM @MYSTAGE_JOHNDOE
FILES =('orders_large.csv.gz')
FILE_FORMAT = (FORMAT_NAME = FILE_FORMAT_ORDER)
ON_ERROR = CONTINUE;

--3
USE WAREHOUSE DATASECURE_WH_JOHNDOE;
USE DATABASE DATASECURE_DB_JOHNDOE;
USE SCHEMA DATASECURE_SCHEMA_JOHNDOE;
COPY INTO PRODUCT_INVENTORY_JOHNDOE
FROM @MYSTAGE_JOHNDOE
FILES =('products_inventory.csv.gz')
FILE_FORMAT = (FORMAT_NAME = FILE_FORMAT_PRODUCT)
ON_ERROR = CONTINUE;


-----queries------
--query 1 : List 10 first users with age and localisation. 
SELECT 
    USERID,
    AGE,
    LOCATION
FROM 
    USER_T_JOHNDOE
LIMIT 10;

--query 2 : Calculate total amout of orders for each user 
SELECT 
    USERID,
    SUM(AMOUNT)
FROM 
    ORDER_T_JOHNDOE 
GROUP BY 
    USERID;

--query 3 : Identify les best selling products and numbers of orders for each one. 
SELECT 
    PRODUCT, 
    COUNT(*) AS ORDERED_NB
FROM 
    ORDER_T_JOHNDOE
GROUP BY 
    PRODUCT
ORDER BY 
    ORDERED_NB DESC;

---query 4 : Get order between two specific date, for example between Octobre 1rst 2024 et le Octobre 15th 2024
SELECT
    PRODUCT,
    ORDERDATE
FROM 
    ORDER_T_JOHNDOE
WHERE ORDERDATE  BETWEEN '2024-10-01' AND '2024-10-15';

---query 5 : Combine data of tables USERS et ORDERS to see locations informations of users and orders détails
SELECT LOCATION,ZIPCODE,PRODUCT 
FROM ORDER_T_JOHNDOE O
JOIN USER_T_JOHNDOE U ON (O.USERID = U.USERID) ;
