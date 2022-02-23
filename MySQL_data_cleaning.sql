-- Create a new database

CREATE DATABASE sharktank;

USE sharktank;


-- Tables 'deals' and 'presenters' imported with [Table Data Import Wizard]

-- View deals table

SELECT *
FROM deals;


-- View presenters table

SELECT *
FROM presenters;


-- Make a new table 'sti_data' by joining delas and presenters table 

CREATE TABLE sti_data AS
SELECT deals.*, 
	   presenters.no_of_presenters, presenters.male_presenter, female_presenter
FROM deals
INNER JOIN presenters 
		ON deals.pitch_no = presenters.pitch_no;
        
SELECT * 
FROM sti_data;


-- Breaking down deal column into other columns so that data is more easy to understand 

ALTER TABLE sti_data
ADD deal_amount TEXT;

ALTER TABLE sti_data
ADD deal_equity TEXT;

ALTER TABLE sti_data
ADD deal_debt TEXT;

SELECT *
FROM sti_data;


-- Extract Deal Amount from deal column to deal_amount column

UPDATE sti_data
SET deal_amount = SUBSTRING_INDEX(deal, "for", 1)
WHERE deal like '%equity%';

UPDATE sti_data
SET deal_amount = REPLACE(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(deal_amount, 
								' lakhs', ''), 
								' Lakhs', ''),
								' lakh', ''),
                                ' crore', '00'),
                                ' Crore', '00');

SELECT *
FROM sti_data;


-- Extract Deal Equity from deal column to deal_equity column

UPDATE sti_data
SET deal_equity = SUBSTRING_INDEX(
					SUBSTRING_INDEX(deal, 
						"%", 1), 
                        " ", -1)
WHERE deal like '%quity%';

SELECT *
FROM sti_data;


-- Extract Deal Deabt from deal column to deal_debt column

UPDATE sti_data
SET deal_debt = SUBSTRING_INDEX(
					SUBSTRING_INDEX(
						SUBSTRING_INDEX(LOWER(deal), 
							"equity" , -1), 
                            " " , -3), 
                            "lakh" , 1)
WHERE deal like '%debt%';

SELECT *
FROM sti_data;


-- Cleaning sti_data table        

ALTER TABLE sti_data
DROP COLUMN deal;

UPDATE sti_data
SET deal_debt = '25'
WHERE deal_debt = 'â‚¹25 ';


-- Replace 'Y' with '1'

UPDATE sti_data
SET ashneer = CASE
	WHEN ashneer = 'Y' THEN '1'
	WHEN ashneer = 'N' THEN '0'
	WHEN ashneer = 'N/A' THEN '0'
END,
namita = CASE
	WHEN namita = 'Y' THEN '1'
	WHEN namita = 'N' THEN '0'
	WHEN namita = 'N/A' THEN '0'
END,
anupam = CASE
	WHEN anupam = 'Y' THEN '1'
	WHEN anupam = 'N' THEN '0'
	WHEN anupam = 'N/A' THEN '0'
END,
vineeta = CASE
	WHEN vineeta = 'Y' THEN '1'
	WHEN vineeta = 'N' THEN '0'
	WHEN vineeta = 'N/A' THEN '0'
END,
aman = CASE
	WHEN aman = 'Y' THEN '1'
	WHEN aman = 'N' THEN '0'
	WHEN aman = 'N/A' THEN '0'
END,
peyush = CASE
	WHEN peyush = 'Y' THEN '1'
	WHEN peyush = 'N' THEN '0'
	WHEN peyush = 'N/A' THEN '0'
END,
ghazal = CASE
	WHEN ghazal = 'Y' THEN '1'
	WHEN ghazal = 'N' THEN '0'
	WHEN ghazal = 'N/A' THEN '0'
END;

SELECT * 
FROM sti_data;


-- Fill null values with 0

UPDATE sti_data
SET deal_amount = 0
WHERE deal_amount IS NULL;

UPDATE sti_data
SET deal_equity = 0
WHERE deal_equity IS NULL;
 
UPDATE sti_data
SET deal_debt = 0
WHERE deal_debt IS NULL;

SELECT * 
FROM sti_data;


-- Trim fields in columns we extracted from deal column

UPDATE sti_data
SET deal_amount = TRIM(deal_amount);

UPDATE sti_data
SET deal_equity = TRIM(deal_equity);

UPDATE sti_data
SET deal_debt = TRIM(deal_debt);


-- Change data types 

ALTER TABLE sti_data
MODIFY COLUMN ashneer INT;

ALTER TABLE sti_data
MODIFY COLUMN namita INT;

ALTER TABLE sti_data
MODIFY COLUMN anupam INT;

ALTER TABLE sti_data
MODIFY COLUMN vineeta INT;

ALTER TABLE sti_data
MODIFY COLUMN aman INT;

ALTER TABLE sti_data
MODIFY COLUMN peyush INT;

ALTER TABLE sti_data
MODIFY COLUMN ghazal INT;

ALTER TABLE sti_data
MODIFY COLUMN deal_amount FLOAT;

ALTER TABLE sti_data
MODIFY COLUMN deal_equity FLOAT;

ALTER TABLE sti_data
MODIFY COLUMN deal_debt FLOAT;


