# 🎬 Netflix Data ETL Project

This project involves the extraction, transformation, and loading (ETL) of Netflix data using SQL and Python. The goal is to clean, structure, and analyze Netflix data to derive actionable insights.

## 📊 Dataset Overview

The dataset includes the following columns:

- **show_id**: Unique identifier for each show.
- **type**: Type of content (Movie/TV Show).
- **title**: Title of the show.
- **director**: Director(s) of the show.
- **cast**: Cast members.
- **country**: Country where the show was produced.
- **date_added**: Date when the show was added to Netflix.
- **release_year**: Release year of the show.
- **rating**: Rating of the show.
- **duration**: Duration of the show.
- **listed_in**: Genres listed for the show.
- **description**: Description of the show.

## 🎯 Project Objectives

The project aims to achieve the following objectives:

- **ETL Process**: Load raw Netflix data into a PostgreSQL database and clean the data by removing duplicates and handling missing values.
- **Data Transformation**: Redesign the database structure and create normalized tables for directors, listed_in, country, and cast.
- **Data Analysis**: Perform various analyses to answer specific questions about the data.

## 🔄 ETL Process

- **Extract**: Read data from a CSV file using Python and Pandas.
- **Transform**: Clean and transform the data using SQL, including:
  - Removing duplicates
  - Filling missing values
  - Creating normalized tables
- **Load**: Insert the transformed data into the PostgreSQL database.

- ### Python Code

```python
import pandas as pd
df = pd.read_csv('netflix_titles.csv')
import sqlalchemy as sal
engine = sal.create_engine('postgresql://postgres:1Loveche&&@localhost:5432/netflix_data')
conn = engine.connect()
df.to_sql('netflix_raw', con = conn, index = False, if_exists = 'append')
conn.close()
df[df.show_id=='s5023'] python```
## 📈 Analysis Summary 

The analysis covers several key insights, including:

- **Directors**: Counting the number of movies and TV shows created by directors who have worked on both.
- **Comedy Shows**: Identifying the country with the highest number of comedy movies.
- **Director Performance**: Analyzing which director had the most movies released each year.
- **Average Movie Duration**: Calculating the average duration of movies in each genre.
- **Genre Analysis**: Finding directors who have created both horror and comedy movies.

## 🚀 How to Use

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/yourusername/netflix-data-etl.git
    ```

2. **Install Dependencies:** Make sure you have Python and PostgreSQL installed. Install required Python libraries:

    ```bash
    pip install pandas sqlalchemy psycopg2
    ```

3. **Setup Database:**
   - Create a PostgreSQL database named `netflix_data`.
   - Update the connection string in the Python code if needed.

4. **Run the ETL Process:** Execute the Python script to load data into the database.

5. **Perform Analysis:** Use the provided SQL queries to analyze the data in PostgreSQL.
