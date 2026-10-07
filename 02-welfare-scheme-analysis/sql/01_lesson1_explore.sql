-- =============================================================
-- LESSON 1: Explore the data (SELECT, WHERE, ORDER BY, GROUP BY)
-- Time: about 1-1.5 hours
--
-- How to run a query in MySQL Workbench:
--   put the cursor on the query and press Ctrl + Enter
--   (Ctrl + Shift + Enter runs the whole file)
--
-- Write your answer under each "-- YOUR QUERY:" line.
-- When you finish a task, tell Claude your query and your result to check it.
-- =============================================================

USE mgnrega;

-- -------------------------------------------------------------
-- Task 1: Look at the data
-- Show the first 10 rows of the employment table.
-- Hint: SELECT * FROM table_name LIMIT 10;
-- -------------------------------------------------------------
-- YOUR QUERY:



-- -------------------------------------------------------------
-- Task 2: How big is it?
-- Count the rows in the employment table.
-- Hint: COUNT(*)
-- Check: you should get 3,074,131
-- -------------------------------------------------------------
-- YOUR QUERY:



-- -------------------------------------------------------------
-- Task 3: Which years are covered?
-- List each financial year ONCE (no repeats), in order.
-- Hint: SELECT DISTINCT ... ORDER BY ...
-- Check: 12 years, from 2014-2015 to 2025-2026
-- -------------------------------------------------------------
-- YOUR QUERY:



-- -------------------------------------------------------------
-- Task 4: Filter rows
-- Show all Gram Panchayats in Pune district (Maharashtra) for 2024-2025.
-- Only show: block_name, gp_name, emp_avail_hh, emp_avail_central_persondays
-- Hint: WHERE condition1 AND condition2 AND condition3
--       Text values go in single quotes: 'Pune'
-- -------------------------------------------------------------
-- YOUR QUERY:



-- -------------------------------------------------------------
-- Task 5: Your first GROUP BY  (the most important SQL skill)
-- For each financial year, show the total person-days of work generated.
-- Column: emp_avail_central_persondays
-- Hint: SELECT fin_year, SUM(...) AS total_persondays
--       FROM ... GROUP BY fin_year ORDER BY fin_year;
-- Question to think about: which year is highest, and why?
-- -------------------------------------------------------------
-- YOUR QUERY:



-- -------------------------------------------------------------
-- Task 6: Top 5 states
-- Which 5 states generated the most person-days in 2024-2025?
-- Hint: WHERE (filter the year) + GROUP BY state_name
--       + ORDER BY ... DESC + LIMIT 5
-- -------------------------------------------------------------
-- YOUR QUERY:



-- -------------------------------------------------------------
-- Task 7 (data detective): Find bad data
-- Person-days can never be negative. How many rows have
-- emp_avail_central_persondays below 0? Which states are they in?
-- (Real government data always has errors like this. Finding them
--  is part of the job, and interviewers love to hear about it.)
-- -------------------------------------------------------------
-- YOUR QUERY:


