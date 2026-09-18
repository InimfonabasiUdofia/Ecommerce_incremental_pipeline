# E-Commerce Data Warehouse & Analytics Pipeline

## 📌 Project Overview

This project implements an end-to-end **e-commerce data engineering and analytics pipeline** using **Apache Airflow, Databricks, dbt, SQL, and PostgreSQL**.

The pipeline ingests and transforms e-commerce data through multiple layers, performs data cleaning and standardization, creates an **One Big Table (OBT)** for analytical exploration, and builds a **dimensional/star schema** for analytics and reporting.

The project also implements **Slowly Changing Dimension Type 2 (SCD Type 2)** to preserve historical changes in dimension records.

**Apache Airflow** is used to orchestrate and schedule the data pipeline and coordinate the different transformation stages.

---

# 🏗️ Architecture

```text
                         E-Commerce Source Data from postgresql
                                  │
                                  ▼
                         ┌─────────────────┐
                         │  Apache Airflow │
                         │  Orchestration  │
                         └────────┬────────┘
                                  │
                                  ▼
                         ┌─────────────────┐
                         │    Databricks   │
                         │      Bronze     │
                         │   Raw / Ingested │
                         └────────┬────────┘
                                  │
                                  ▼
                         ┌─────────────────┐
                         │    Databricks   │
                         │     Silver      │
                         │ Cleaned/Conformed│
                         └────────┬────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    ▼                           ▼
             ┌───────────────┐          ┌────────────────┐
             │      OBT      │          │ SCD Type 2     │
             │ One Big Table │          │ Dimensions     │
             └───────┬───────┘          └───────┬────────┘
                     │                           │
                     └─────────────┬─────────────┘
                                   ▼
                          ┌─────────────────┐
                          │ Dimensional     │
                          │ Model / Gold    │
                          └────────┬────────┘
                                   │
                    ┌──────────────┴──────────────┐
                    ▼                             ▼
              Fact Tables                  Dimension Tables
                    │                             │
                    └──────────────┬──────────────┘
                                   ▼
                           Analytics / BI
```

---

# 🛠️ Technologies Used

| Technology         | Purpose                                           |
| ------------------ | ------------------------------------------------- |
| **Apache Airflow** | Workflow orchestration and scheduling             |
| **Databricks**     | Data processing and data warehouse environment    |
| **dbt**            | SQL-based transformation and data modeling        |
| **SQL**            | Data transformation and analytics                 |
| **Python**         | Pipeline and orchestration development            |
| **PostgreSQL**     | Relational database / supporting data environment |
| **Git & GitHub**   | Version control and project management            |

---

# 🔄 Data Pipeline

The pipeline is organized into multiple transformation stages.

## 1. Ingestion

Source e-commerce data is loaded into the data platform using databricks data ingestion.

The datasets include:

* Customers
* Orders
* Order Items
* Payments
* Reviews
* Products
* Sellers
* Geolocation

Apache Airflow orchestrates the execution of the pipeline and ensures that downstream tasks execute after their dependencies have completed.

---

## 2. Bronze Layer

The Bronze layer stores the raw or minimally transformed source data.

The purpose of this layer is to:

* Preserve source data
* Maintain a raw historical copy
* Provide a reliable source for downstream processing
* Separate ingestion from transformation

---

## 3. Silver Layer

The Silver layer contains cleaned and standardized datasets.

Transformations include:

* Column standardization
* Data type conversions
* Null handling
* Data cleaning
* Surrogate key generation
* Timestamp standardization
* Data quality checks

Example models:

```text
customers
orders
o_items
o_payments
o_reviews
products
sellers
geolocation
```

---

# 📊 One Big Table (OBT)

An **One Big Table** is created by joining the major Silver-layer datasets.

```text
Customers
    │
    ▼
Orders
    │
    ├── Order Items ─── Products
    │        │
    │        └──────── Sellers ─── Geolocation
    │
    ├── Payments
    │
    └── Reviews
```

The OBT provides a denormalized view of the e-commerce data and is useful for exploratory analysis.

However, the final analytical model uses a **star schema** to provide better organization, reusability, and analytical performance.

---

# ⭐ Dimensional Model

The Gold layer follows a **dimensional/star schema**.

## Fact Tables

### `fact_order_items`

**Grain:** One row per order item.

Key measures include:

* Item quantity
* Product price
* Freight value
* Total item value
* Total payment value
* Payment count
* Average review score
* Review count
* Delivery days
* Delivery delay days

---

### `fact_payments`

Stores payment-level transactional information.

Example measures:

* Payment value
* Payment installments
* Payment count

---

# 📐 Dimension Tables

The dimensional model contains:

```text
dim_customer
dim_product
dim_seller
dim_review
dim_geolocation
dim_date
```

These dimensions provide descriptive attributes used by the fact tables.

---

# 🔁 Slowly Changing Dimension Type 2

The project implements **Slowly Changing Dimension Type 2 (SCD Type 2)** to preserve the history of changes to dimension records.

Instead of overwriting an existing dimension record when an attribute changes, a new version of the record is created.

For example, if a customer's state changes:

```text
Before:

Customer
──────────────
Customer ID: 1001
State: SP
Current: TRUE


After:

Customer ID: 1001
State: SP
Valid From: 2024-01-01
Valid To:   2025-03-15
Current: FALSE

Customer ID: 1001
State: RJ
Valid From: 2025-03-16
Valid To:   NULL
Current: TRUE
```

This allows historical analysis based on the attributes that were valid at a particular point in time.

### SCD Type 2 attributes

Typical SCD Type 2 metadata includes:

```text
effective_from
effective_to
is_current
```

A surrogate key is also used to distinguish different versions of the same business entity.

For example:

```text
customer_surrogate_key
```

This allows the warehouse to retain multiple historical versions of a customer.

---

# 🔄 Airflow Orchestration

**Apache Airflow** is used to orchestrate the end-to-end pipeline.

The DAG manages task dependencies and controls the execution order of the pipeline.

A simplified workflow is:

```text
                 Start
                   │
                   ▼
            Ingest Source Data
                   │
                   ▼
             Bronze Layer
                   │
                   ▼
             Silver Layer
                   │
                   ▼
             Data Quality
                   │
                   ▼
                  OBT
                   │
                   ▼
             SCD Type 2
             Dimensions
                   │
                   ▼
             Fact Tables
                   │
                   ▼
              Data Tests
                   │
                   ▼
                  End
```

Airflow provides:

* Scheduling
* Task dependencies
* Retry handling
* Monitoring
* Failure management
* Pipeline automation
* Workflow visibility

---

# 📁 Project Structure

```text
ecommerce-data-engineering/
│
├── dags/
│   └── ecommerce_pipeline.py
│
├── models/
│   │
│   ├── bronze/
│   │
│   ├── silver/
│   │   ├── customers.sql
│   │   ├── orders.sql
│   │   ├── o_items.sql
│   │   ├── o_payments.sql
│   │   ├── o_reviews.sql
│   │   ├── products.sql
│   │   ├── sellers.sql
│   │   └── geolocation.sql
│   │
│   ├── silver_obt/
│   │   └── obt.sql
│   │
│   └── gold/
│       │
│       ├── dimensions/
│       │   ├── dim_customer.sql
│       │   ├── dim_product.sql
│       │   ├── dim_seller.sql
│       │   ├── dim_order.sql
│       │   ├── dim_payment.sql
│       │   ├── dim_review.sql
│       │   ├── dim_geolocation.sql
│       │   └── dim_date.sql
│       │
│       └── facts/
│           ├── fact_order_items.sql
│           └── fact_payments.sql
│
├── tests/
├── macros/
├── seeds/
├── snapshots/
│
├── dbt_project.yml
├── profiles.yml
├── requirements.txt
├── .env
├── .gitignore
└── README.md
```

---

# ⚙️ Setup

## Prerequisites

Install:

* Python
* Apache Airflow
* dbt
* dbt-Databricks
* Git
* Access to a Databricks workspace
* PostgreSQL, if required by the project

---

## Install dbt

```powershell
pip install dbt-databricks
```

Verify:

```powershell
dbt --version
```

---

# 🔐 Environment Variables

Create a `.env` file containing your environment-specific configuration.

```env
DATABRICKS_AUTH_TYPE=pat
DATABRICKS_DATABASE=ecommerce
DATABRICKS_SCHEMA=silver
DATABRICKS_HOST=your-databricks-host
DATABRICKS_HTTP_PATH=your-http-path
DATABRICKS_TOKEN=your-token
DATABRICKS_THREADS=4
```


---

# 🔧 dbt Configuration

Example `profiles.yml`:

```yaml
ecommerce:
  target: dev

  outputs:
    dev:
      type: databricks
      database: "{{ env_var('DATABRICKS_DATABASE') }}"
      schema: "{{ env_var('DATABRICKS_SCHEMA') }}"
      host: "{{ env_var('DATABRICKS_HOST') }}"
      http_path: "{{ env_var('DATABRICKS_HTTP_PATH') }}"
      auth_type: "{{ env_var('DATABRICKS_AUTH_TYPE') }}"
      token: "{{ env_var('DATABRICKS_TOKEN') }}"
      threads: "{{ env_var('DATABRICKS_THREADS') | int }}"
```

---

# ▶️ Running dbt

Validate the configuration:

```powershell
dbt debug
```

Install packages:

```powershell
dbt deps
```

Compile the project:

```powershell
dbt compile
```

Run models:

```powershell
dbt run
```

Run tests:

```powershell
dbt test
```

Run models and tests:

```powershell
dbt build
```

---

# 🚀 Running Airflow

Start the Airflow services according to your local Airflow setup.

The main DAG orchestrates the different stages of the data pipeline.

Example DAG flow:

```text
Ingestion
    ↓
Bronze
    ↓
Silver
    ↓
Data Quality
    ↓
OBT
    ↓
SCD Type 2
    ↓
Dimensions
    ↓
Facts
    ↓
Final Validation
```

---

# 🧪 Data Quality

Data quality checks are implemented to ensure that the warehouse contains reliable data.

Examples include:

* `not_null`
* `unique`
* `relationships`
* `accepted_values`

Example:

```yaml
columns:
  - name: customer_id
    tests:
      - not_null
      - unique
```

Relationship tests are used to validate foreign keys between fact and dimension tables.

---

# 📈 Analytical Use Cases

The warehouse supports analysis such as:

### Customer Analysis

* Customer purchasing behavior
* Customer order frequency
* Customer geographic distribution
* Historical customer changes

### Product Analysis

* Product revenue
* Product category performance
* Product popularity

### Seller Analysis

* Seller performance
* Seller revenue
* Seller geographic distribution

### Order & Delivery Analysis

* Order status
* Delivery performance
* Delivery delays
* Estimated vs actual delivery

### Payment Analysis

* Payment methods
* Payment installments
* Payment values

### Review Analysis

* Review scores
* Review trends
* Customer feedback

---

# 🎯 Project Objectives

This project demonstrates practical data engineering concepts including:

* Data ingestion
* ETL/ELT pipeline design
* Data lake/warehouse architecture
* Databricks
* dbt transformations
* One Big Table modeling
* Dimensional modeling
* Star schema design
* Fact and dimension tables
* Slowly Changing Dimensions Type 2
* Surrogate keys
* Data quality testing
* Airflow orchestration
* Pipeline scheduling
* SQL transformations
* Data warehouse design
* Git version control

---


---



**Technologies:**
Apache Airflow · Databricks · dbt · SQL · Python · PostgreSQL · Git .Docker
