# Global Layoffs (2020–2023): Data Cleaning with SQL

This project demonstrates how to clean and prepare real-world layoff data using **SQL (MySQL)**. The dataset spans from 2020 to 2023 and includes detailed information on global layoffs by company, location, industry, and more. The goal is to make the dataset analysis-ready by performing essential data cleaning operations in SQL.

---

##  Overview

The raw dataset contains inconsistencies, null values, and unstandardized entries typical of real-world data. Using **MySQL**, the project walks through the entire cleaning process: removing duplicates, trimming white space, handling nulls, converting data types, and preparing fields for better filtering and grouping.

This cleaned data can then be exported to a BI tool such as **Power BI** or **Tableau** for further visualization and reporting.

---

## Features

- Data cleaning and exploration in **MySQL**
- CTE-based duplicate removal
- Data standardization using string functions
- Null value handling and data imputation
- Date extraction and derived columns (e.g., Year, Month)
- Ready-to-analyze dataset for visualization and insights

---

## Dataset Info

- **Source**: [Layoffs.csv](layoffs.csv) / AlexTheAnalyst 
- **Format**: CSV → Imported into MySQL  
- **Size**: 10,000+ rows (approximate)  
- **Key Fields**:
  - `company`
  - `location`
  - `industry`
  - `total_laid_off`
  - `percentage_laid_off`
  - `date`
  - `stage` (e.g., Seed, Series A, etc.)
  - `country`
  - `funds_raised`

---

## Cleaning Techniques (SQL)

Examples of key SQL operations used:

```sql
-- Trim whitespace from company names
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Remove exact duplicate rows using ROW_NUMBER()
DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- Extract year from date field
UPDATE layoffs_staging2
SET year = YEAR(date);
