# Project 02: MGNREGA Analysis with SQL

**Scheme:** Mahatma Gandhi National Rural Employment Guarantee Act (MGNREGA). It guarantees every rural household up to 100 days of paid work a year.
**Tools:** MySQL (queries), then Power BI (dashboard)
**Data source:** [India Data Portal – MGNREGA](https://ckandev.indiadataportal.com/dataset/12259aba-a89a-458d-bf04-1db040b05bfd) (original source: Ministry of Rural Development, nrega.nic.in)

## About the data

| Table (MySQL database `mgnrega`) | Rows | What one row is |
|---|---|---|
| `employment` | 3,074,131 | One Gram Panchayat in one financial year: job cards, work demanded, work given, person-days |
| `women_accounts` | 3,074,161 | Same Gram Panchayats: women workers with bank accounts |

- **Covers:** FY 2014-15 to FY 2025-26, 34 states/UTs, 744 districts, about 2.6 lakh Gram Panchayats
- **Too big for Excel** (Excel stops at about 10 lakh rows). That's why this project uses SQL.
- Raw CSVs (about 820 MB) are in `data/raw/`. They aren't on GitHub because they're too large; download them from the link above.

**Key columns (`employment`):**
| Column | Meaning |
|---|---|
| `reg_hh` | Households registered (have a job card) |
| `emp_demand_hh` | Households that asked for work |
| `emp_avail_hh` | Households that actually got work |
| `emp_avail_central_persondays` | Person-days of work generated (1 person working 1 day = 1 person-day) |
| `fam_completed_100_days` | Households that got the full 100 days |
| `cumul_hh_jobcards_sc` / `_sts` | SC / ST households with job cards |

**Problems found while loading:**
1. 120 Gram Panchayat names contain a backslash (e.g. `Khairi\Pat`), which broke the import. Fixed with `ESCAPED BY ''` in `sql/00_create_and_load.sql`.
2. Some rows have blank district/block/GP codes.
3. A few rows have negative person-days (find them in Lesson 1, Task 7).

## Checklist
- [x] Download state/district/GP-wise data → `data/raw/`
- [x] Create the MySQL database and load the data → `sql/00_create_and_load.sql`
- [ ] **Lesson 1:** Explore: SELECT, WHERE, ORDER BY, GROUP BY → `sql/01_lesson1_explore.sql`
- [ ] Lesson 2: Calculations and HAVING: rates, averages, % of households getting 100 days
- [ ] Lesson 3: JOINs: combine `employment` and `women_accounts`
- [ ] Lesson 4: Year-on-year growth with window functions (LAG)
- [ ] Build a Power BI dashboard connected to MySQL → `powerbi/`
- [ ] Write insights, take screenshots, post on LinkedIn

## Questions to answer
1. How has work under MGNREGA changed year to year? What happened in 2020-21 (COVID)?
2. Which states and districts generate the most person-days?
3. What % of households that asked for work actually got it? Which states are worst?
4. What % of working households got the full 100 days?
5. How many women workers have bank accounts, and how does this vary by state?

## SQL skills
SELECT, WHERE, ORDER BY, GROUP BY, HAVING, JOIN, subqueries, CASE, window functions (LAG, RANK)

## Key insights
1.
2.
3.

## Problems I faced and how I solved them
-
