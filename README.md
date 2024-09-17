# 🎬 Netflix Data ETL and Analysis Project

This project demonstrates the **ETL (Extract, Transform, Load)** process on Netflix data using **PostgreSQL** and **Python (Jupyter Notebook)**. The dataset contains information about movies and TV shows on Netflix, including titles, directors, actors, genres, and more. The goal is to analyze the data to gain insights about Netflix's catalog.

## 📊 Dataset Overview

The dataset used in this project includes information such as:
- **🎬 Titles**: Names of movies and shows.
- **🎥 Directors**: Names of directors.
- **🗺️ Country**: Country of production.
- **🕒 Duration**: Length of the movie or show.
- **⭐ Rating**: Ratings for content.
- **📅 Release Year**: Year of release.
- **🎭 Genre**: Categories like Comedy, Drama, etc.

**Source**: [Netflix Shows Dataset on Kaggle](https://www.kaggle.com/shivamb/netflix-shows)

## 🎯 Project Objectives

The project involves the following objectives:
1. Extracting Netflix data from a CSV file.
2. Transforming and cleaning the data using SQL and Python.
3. Loading the cleaned data into a PostgreSQL database.
4. Analyzing the data using SQL queries and Python to extract insights.

## 🛠️ Technologies Used

The following tools were used to build this project:
- **Python**: Data manipulation and processing.
- **Pandas**: For reading and cleaning the CSV data.
- **SQLAlchemy**: For connecting to PostgreSQL from Python.
- **PostgreSQL**: To store and query the data.
- **Jupyter Notebook**: For Python-based analysis and exploration.

## 🛠️ ETL Process

### 1. Extract

The Netflix dataset is extracted in CSV format using **Pandas**.

```python
import pandas as pd
df = pd.read_csv('netflix_titles.csv')

2. Transform
Transformations are applied to clean and reshape the data, such as handling missing values and creating separate tables for genres, directors, and countries.

-- SQL Query to split the 'director' column into a new table
CREATE TABLE netflix_directors AS
SELECT show_id, TRIM(REGEXP_SPLIT_TO_TABLE(director, ',')) AS director
FROM netflix_raw;

3. Load
The transformed data is loaded into a PostgreSQL database using SQLAlchemy in Python.

python
Copy code
import sqlalchemy as sal
engine = sal.create_engine('postgresql://username:password@localhost:5432/netflix_data')
conn = engine.connect()
df.to_sql('netflix_raw', con=conn, index=False, if_exists='append')
conn.close()

📝 Data Analysis
Several SQL queries and Python functions were used to analyze the cleaned data, including:

Top Directors: Identifying directors with the highest number of shows or movies.
Most Popular Genres: Finding the most frequent genres on Netflix.
Country Analysis: Analyzing which countries produce the most content.
Duration and Ratings: Finding relationships between content duration and rating categories.

Sample Python Code for Analysis:
python
Copy code
df[df['show_id'] == 's5023']

🚀 How to Run the Project
Clone the repository:
git clone https://github.com/Gagann01/netflix-data-etl-analysis.git
Set up PostgreSQL:

Install PostgreSQL and create a new database named netflix_data.
Install the dependencies:

pip install pandas sqlalchemy psycopg2
Run the Jupyter Notebook to perform the ETL and analysis:


📈 Summary of Insights
Through the analysis, several key insights were derived:
The top directors and genres contributing to Netflix's content library were identified.
Relationships between show durations, genres, and ratings were explored.
SQL queries helped uncover trends in countries producing the most content and the average content duration for each genre.

🚀 Future Enhancements
Some potential improvements:
Adding a recommendation system based on ratings and user preferences.
Analyzing trends over time, such as the rise in a particular genre or director.
Expanding the dataset with real-time scraping from Netflix's website.






