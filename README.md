
# [COVID-19 Impact Analysis Dashboard (Tableau)](https://public.tableau.com/app/profile/marwan.elhelaly/viz/Covid_Global_Impact_Dashboard/Vaccination_Rates)

## Overview
<div align="justify">
This project aims to analyze and visualize the global impact of COVID-19 by mapping key metrics such as total deaths, infection rates, and vaccination rates across continents and countries. The goal is to identify the regions most affected by the pandemic and dig deeper into how they are affected, track the progression over time, and observe the correlation between vaccination rates and the decline in infection rates and deaths.

## Features
- **Minimal Viable Product (MVP):**
  - Manual extraction, transformation, and loading (ETL) of COVID-19 data into a PostgreSQL database.
  - Creation of a Tableau dashboard displaying key metrics across continents and countries.

- [**Iteration 2 - Automation Enhancement:**] (https://github.com/MarwanH7/Automated-COVID-19-Impact-Analysis-Dashbaord-Looker_Studio-)
  - Implementation of automated data pipelines for periodic updates from the data source to the PostgreSQL database.
  - Automation of the dashboard refresh process based on updated data.

- **Iteration 3 - Analysis and Insights Integration:**
  - Statistical analysis to identify correlations between vaccination rates and death/infection rates.
  - Time series forcasting for important metrics such as a vaccination rates, deaths/infection rates, moratlity rates and more. 
  - Integration of Natural Language Processing (NLP) or statistical techniques to generate automated insights and conclusions regarding the relationships observed in the data.
  - Incorporation of these conclusions into the Tableau dashboard for periodic analysis (weekly, monthly, quarterly).

## Roadmap
1. **MVP:**
   - Manual ETL process.
   - Basic dashboard creation.

2. **Automation:**
   - Automated data pipelines.
   - Automated dashboard updates.

3. **Analysis and Insights:**
   - Statistical analysis for correlations.
   - Integration of automated insights into the dashboard.

## Usage
- **Data Collection:** Manually collect COVID-19 data and follow the ETL process outlined in the project documentation.
- **Dashboard Viewing:** Access the Tableau dashboard to visualize and analyze the impact of COVID-19 metrics globally.

## Project Structure
- **`/ETL_scripts`:** Contains scripts for data extraction, transformation, and loading into the PostgreSQL database.
- **`/Dashboard`:** Includes Tableau files for the visualizations and dashboard.
- **`/Analysis`:** Contains notebooks or scripts for statistical analysis and insights generation.

## Getting Started
1. Clone the repository.
2. Set up the PostgreSQL database as per the ETL instructions.
3. Access the Tableau dashboard for visualizing the COVID-19 impact metrics.

## Contributors
- [Marwan. E]

