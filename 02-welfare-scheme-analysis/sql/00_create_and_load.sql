-- =============================================================
-- Project 02: MGNREGA - create the database and load the raw CSVs
-- Source: India Data Portal (Ministry of Rural Development, nrega.nic.in)
-- One row = one Gram Panchayat (GP) in one financial year
-- Run from the project folder:
--   mysql --defaults-extra-file=C:/Users/aliri/mysql-login.cnf < sql/00_create_and_load.sql
-- =============================================================

CREATE DATABASE IF NOT EXISTS mgnrega;
USE mgnrega;

-- -------------------------------------------------------------
-- Table 1: employment generated (job cards, demand, work given)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS employment;
CREATE TABLE employment (
    id                           INT PRIMARY KEY,
    fin_year                     VARCHAR(9),     -- e.g. 2024-2025
    state_name                   VARCHAR(60),
    state_code                   VARCHAR(4),
    district_name                VARCHAR(60),
    district_code                VARCHAR(6),
    block_name                   VARCHAR(60),
    block_code                   VARCHAR(8),
    gp_name                      VARCHAR(80),
    gp_code                      BIGINT,
    reg_hh                       INT,   -- households registered (job cards)
    reg_pers                     INT,   -- persons registered
    del_jobcards_hh              INT,   -- job cards deleted (households)
    del_jobcards_pers            INT,
    incl_jobcards_hh             INT,   -- job cards added (households)
    incl_jobcards_pers           INT,
    cumul_hh_jobcards_sc         INT,   -- SC households with job cards
    cumul_hh_jobcards_sts        INT,   -- ST households with job cards
    cumul_hh_jobcards_others     INT,
    emp_demand_hh                INT,   -- households that asked for work
    emp_demand_pers              INT,
    emp_offer_hh                 INT,   -- households offered work
    emp_offer_pers               INT,
    emp_avail_hh                 INT,   -- households that actually got work
    emp_avail_pers               INT,
    emp_avail_central_persondays BIGINT, -- person-days of work generated
    emp_avail_states_persondays  BIGINT,
    fam_completed_100_days       INT,   -- households that got the full 100 days
    land_reform_benef_hh         INT,
    disabled_benef_indiv         INT
);

LOAD DATA LOCAL INFILE 'data/raw/mgnrega-employment-generated.csv'
INTO TABLE employment
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''  -- some GP names contain a backslash (e.g. Khairi\Pat), so turn off backslash escaping
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, fin_year, state_name, state_code, district_name, @district_code, block_name, @block_code, gp_name, @gp_code,
 reg_hh, reg_pers, del_jobcards_hh, del_jobcards_pers, incl_jobcards_hh, incl_jobcards_pers,
 cumul_hh_jobcards_sc, cumul_hh_jobcards_sts, cumul_hh_jobcards_others,
 emp_demand_hh, emp_demand_pers, emp_offer_hh, emp_offer_pers, emp_avail_hh, emp_avail_pers,
 emp_avail_central_persondays, emp_avail_states_persondays, fam_completed_100_days,
 land_reform_benef_hh, disabled_benef_indiv)
SET district_code = NULLIF(@district_code, ''),
    block_code    = NULLIF(@block_code, ''),
    gp_code       = ROUND(NULLIF(@gp_code, ''));

-- -------------------------------------------------------------
-- Table 2: women workers and bank accounts
-- -------------------------------------------------------------
DROP TABLE IF EXISTS women_accounts;
CREATE TABLE women_accounts (
    id                                  INT PRIMARY KEY,
    fin_year                            VARCHAR(9),
    state_name                          VARCHAR(60),
    state_code                          VARCHAR(4),
    district_name                       VARCHAR(60),
    district_code                       VARCHAR(6),
    block_name                          VARCHAR(60),
    block_code                          VARCHAR(8),
    gp_name                             VARCHAR(80),
    gp_code                             BIGINT,
    join_acc_women                      INT,  -- women with joint bank accounts
    total_acc_women                     INT,  -- women with any bank account
    women_benef_workers_with_acc        INT,
    active_women_benef_workers_with_acc INT
);

LOAD DATA LOCAL INFILE 'data/raw/mgnrega-women-joint-accounts.csv'
INTO TABLE women_accounts
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''  -- some GP names contain a backslash (e.g. Khairi\Pat), so turn off backslash escaping
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, fin_year, state_name, state_code, district_name, @district_code, block_name, @block_code, gp_name, @gp_code,
 join_acc_women, total_acc_women, women_benef_workers_with_acc, active_women_benef_workers_with_acc)
SET district_code = NULLIF(@district_code, ''),
    block_code    = NULLIF(@block_code, ''),
    gp_code       = ROUND(NULLIF(@gp_code, ''));

-- Indexes make GROUP BY / JOIN queries on 3 million rows fast
CREATE INDEX idx_emp_year_state  ON employment (fin_year, state_name, district_name);
CREATE INDEX idx_wom_year_state  ON women_accounts (fin_year, state_name, district_name);

-- Quick check
SELECT 'employment' AS table_name, COUNT(*) AS row_count FROM employment
UNION ALL
SELECT 'women_accounts', COUNT(*) FROM women_accounts;
