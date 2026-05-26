# DATA CLEANING 
# Solvable Issues
		# us_household_income/State_Name column - inconsistent spelling  SOLVED
		# us_household_income/Type column - inconsistent spelling SOLVED
        # duplicates  
        # us_household_income/Place column - missing data SOLVED
        
        
# Unsolvable Issues 
		# us_household_income/AWater column - 0 or missing data  NOT SOLVABLE 
        # us_household_income/ALand column - 0 or missing data  NOT SOLVABLE
		# income_statistics/Mean;Median;Stdev;sum_w columns - 0 or missing data 

        
SELECT * 
FROM us_household_income;

SELECT * 
FROM income_statistics;

SELECT COUNT(id)
FROM us_household_income;

SELECT COUNT(id) 
FROM income_statistics;


#duplicate identification and removal 
SELECT id , COUNT(id)
FROM income_statistics
GROUP BY id 
HAVING COUNT(id)>1; #no duplicates in income_statistics table

SELECT id , COUNT(id)
FROM us_household_income
GROUP BY id 
HAVING COUNT(id)>1; # 7 duplicates in us_household_income 

SELECT * 
FROM (
	SELECT row_id, 
	id, 
	ROW_NUMBER() OVER(PARTITION BY id ORDER BY ID) row_num
	FROM us_household_income
	) duplicates
WHERE row_num>1;

DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, 
		id, 
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY ID) row_num
		FROM us_household_income
		) duplicates
	WHERE row_num>1);


#identification and standardization of string inconsistencies   
SELECT DISTINCT State_Name, COUNT(State_Name)
FROM us_household_income
GROUP BY State_name
ORDER BY COUNT(State_Name);# 1 spelling error identified

UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

SELECT DISTINCT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type
ORDER BY COUNT(Type);# 1 spelling error identified


UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';



#missing value population
SELECT *
FROM us_household_income
WHERE Place IS NULL;

SELECT *
FROM us_household_income
WHERE County= 'Autauga County';

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'; 


#missing values that are not solvables
SELECT ALand, AWater
FROM us_household_income
WHERE ALand IS NULL OR ALand =' ' OR ALand = 0
AND AWater IS NULL OR AWater =' ' OR AWater = 0 ;

 



