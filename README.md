# ❄️ Snowflake Data Warehouse Project – DataSecure Analytics Simulation

This project simulates a real-world business case requiring the setup of a Snowflake-based data warehouse. The goal was to create structured storage for sensitive customer data, ingest CSV files using SnowSQL, and run analytical queries for reporting.

---

## 🧱 Project Objectives

- Deploy a Snowflake warehouse with proper **zones (DB, schema, tables)**
- Configure file formats and a **Snowflake stage** for secure ingestion
- Upload and load CSV files using **SnowSQL and PUT commands**
- Execute multiple **SQL queries** to analyze users, orders, and products

---

## 📁 Snowflake Structure

- **Warehouse**: `DATASECURE_WH_<NAME>`
- **Database**: `DATASECURE_DB_<NAME>`
- **Schema**: `DATASECURE_SCHEMA_<NAME>`
- **Tables**:
  - `USER_T_<NAME>`
  - `ORDER_T_<NAME>`
  - `PRODUCT_INVENTORY_<NAME>`

---

## 🔄 Data Ingestion via SnowSQL

- Configured **file formats** for each dataset:
  - `FILE_FORMAT_USER`
  - `FILE_FORMAT_ORDER`
  - `FILE_FORMAT_PRODUCT`
- Created internal stage: `MYSTAGE_<NAME>`
- Used `PUT FILE` to upload local CSVs to Snowflake stage
- Loaded data into respective tables using `COPY INTO`

---

## 🔎 SQL Queries Executed

1. Display the first 50 users with age and location (post-anonymization check)
2. Calculate total order amount per user
3. Identify most frequently purchased products
4. Retrieve orders between specific dates
5. Join USERS and ORDERS tables to analyze user location and purchases

---

## ✅ Outcomes

- Built a clean Snowflake environment with full ingestion pipeline
- Gained hands-on experience with SnowSQL, file formats, and staging
- Executed relevant queries to support business reporting

---

## 🧠 Skills Practiced

- Snowflake warehouse setup & SQL DDL
- File ingestion with `PUT` and `COPY INTO`
- Query optimization & data exploration
- Data privacy considerations

---

## 👨‍💻 Author

**Abdirahman Abdillahi**  
[LinkedIn](https://www.linkedin.com/in/abdirahmanabdillahi) | [GitHub](https://github.com/Abdirahman283)  
*AWS Academy Data Engineer – 2025*
