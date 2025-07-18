-- Data Cleaning Project

SET SQL_SAFE_UPDATES = 0;

Select * 
from layoffs;

# Creating the new table and keep the raw dataset available

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging 
SELECT * 
FROM layoffs;

SELECT * FROM layoffs_staging;

-- 1. Remove Duplicates

# FIND THE DUPLICATE ROW  
WITH duplicate_cte AS 
(
SELECT * , 
ROW_NUMBER() # Row_number in window function find the 
OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1; 


# Delected the duplicate columns

# CREATE THE NEW TABLE to in store the row_num
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2;

# Insert the value into the new table 
INSERT INTO layoffs_staging2
SELECT * , 
ROW_NUMBER() # Row_number in window function find the 
OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1
;

SELECT * 
FROM layoffs_staging2
;

-- 2. Standardize the Data
# Get ride of space  
SELECT company, TRIM(company)
FROM layoffs_staging2
;
##  COMPANY
UPDATE layoffs_staging2
SET company = TRIM(company);

##  INDUSTRY
SELECT DISTINCT industry 
FROM layoffs_staging2 
ORDER BY 1;

# Ensure all the Crypto are all name same 
SELECT *
FROM layoffs_staging2 
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2 
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

##  COUNTRY
SELECT DISTINCT country
FROM layoffs_staging2 
ORDER BY 1;

SELECT *
FROM layoffs_staging2 
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2 
ORDER BY 1;

UPDATE layoffs_staging2 
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

## DATE
# convert string to date
SELECT `date` ,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2 ;

UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

# NEVER DO THIS IN RAW TABLE !!!!
ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE;

-- 3. Null Values or blanks values
SELECT * FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL
;

# Update the NULL columns where the industry columns is ''
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company 
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
;


-- 4. Remove Any Columns and rows 

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2;


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;












