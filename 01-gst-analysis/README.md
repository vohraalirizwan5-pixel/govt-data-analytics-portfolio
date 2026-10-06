# Project 01: State-wise GST Collection Analysis

**Tools:** Excel (Week 1), then Power BI (Weeks 2–3)
**Data source:** data.gov.in (search "GST collection state wise"), or gstcouncil.gov.in / PIB monthly press releases

## About the data (already downloaded)

**File:** `data/raw/gst-collection-statewise.csv` (3,570 rows)
**From:** India Data Portal, "Tax collection on GST Portal" (original source: gst.gov.in > Downloads > GST Statistics)
**Columns:** `id, date, state_name, state_code, cgst, sgst, igst, cess`. Amounts are probably in **₹ crore** (check this on gst.gov.in).
**Covers:** July 2017 to January 2026, monthly, 39 "states"

**Problems found (fixing these is your Day 2 cleaning task):**
1. **Not all rows are states.** `Cbic`, `Oidar` (online services from abroad) and `Other Territory` are special categories. Decide whether to remove them or keep them in an "Other" group.
2. **July 2017 is nearly zero** (GST started that month), so leave it out of growth calculations.
3. **Months are missing:** April–July 2025 and September–December 2025 aren't in the file.
4. **August 2025 and January 2026 totals look almost double** the earlier months. Check whether they're measured differently before comparing them.
5. **There's no total column.** Add one: `= cgst + sgst + igst + cess`.

Tip: write down how you handled each problem in "Problems I faced" below. This is exactly what interviewers ask about.

## Week 1 checklist (Excel)

- [x] Day 1 – Download the data and save it in `data/raw/`
- [x] Day 2 – Clean it → saved as `data/clean/gst-collection-clean.xlsx` (see the Cleaning_Log sheet)
- [x] Day 3 – Write down the questions below
- [x] Day 4–5 – Answer them with Pivot Tables, SUMIFS, and growth % formulas (sheets: Top_States, By_Month, Growth)
- [x] Day 6 – Build charts and a dashboard with slicers → `Dashboard` sheet in `data/clean/gst-collection-clean.xlsx`, image in `screenshots/gst-dashboard.png`
- [ ] Day 7 – Write insights below, screenshot the dashboard into `screenshots/`, post on LinkedIn

## Weeks 2–3 checklist (Power BI)

- [x] Load the clean data into Power BI (Power Query, typed columns)
- [x] Rebuild the dashboard: 4 KPI cards, Top 10 states bar chart, FY column chart, monthly trend line → `powerbi/gst-dashboard.pbip`, image in `screenshots/gst-dashboard-powerbi.png`
- [x] Add slicers for State/UT and financial year
- [ ] Practise: rebuild one visual yourself from scratch, and add a map visual (needs map visuals enabled in Options → Security)
- [ ] Share on LinkedIn / GitHub

## Power BI dashboard

![Power BI dashboard](screenshots/gst-dashboard-powerbi.png)

Open `powerbi/gst-dashboard.pbip` in Power BI Desktop. It's saved as a Power BI Project (plain-text files that work well with GitHub). The DAX measures are in `powerbi/gst-dashboard.SemanticModel/definition/tables/GST.tmdl`.

## Questions to answer

1. Which 5 states collect the most GST?
2. Which states grew fastest compared with last year (YoY growth %)?
3. What share of total GST comes from the top 5 states?
4. Which months have the highest collections? Is there a seasonal pattern?
5. _(add your own)_

## Skills used
- Data cleaning: removing bad rows, spotting a data error, standardising names, adding calculated columns
- Excel Tables (named table `GSTData`)
- Pivot Tables: Sum vs Average, sorting, Tabular layout, pivot charts
- Formulas: SUMIFS, IFERROR, growth % = (this year − last year) ÷ last year, CAGR = (end ÷ start)^(1/years) − 1
- Conditional formatting (colour scales)

## Key insights
_Period: Aug 2017 – Jan 2026. All amounts are ₹ crore, excluding cess._

1. **GST is concentrated in a few states.** Maharashtra alone contributes about **21%** of all state GST (₹17.3 lakh crore), more than double the next state, Karnataka. The top 5 states (Maharashtra, Karnataka, Gujarat, Tamil Nadu, Haryana) contribute about **53.5%**, more than half of the total.
2. **Haryana and Delhi are growing fastest.** In FY 2024-25, Haryana grew **16.3%** and Delhi **16.1%**, against India's overall growth of **10.3%**. Maharashtra is the largest state and still grew at a strong 12.5%.
3. **Some north-eastern states declined.** Arunachal Pradesh (−8.2%), Meghalaya (−2.6%) and Nagaland (−1.0%) collected less GST in FY 2024-25 than in FY 2023-24.
4. **Long-term growth is steady.** From FY 2018-19 to FY 2024-25, state GST grew about **11.7% per year** on average.
5. **COVID shows clearly in the data.** Monthly GST fell sharply in April–May 2020 during the lockdown, then recovered by late 2020 and has grown steadily since. FY 2024-25 collections were about double FY 2018-19.
6. **There is a clear seasonal pattern.** April is the highest month on average, because GST is paid the month after the sale and March is the financial year-end rush. May is the lowest, after the rush ends.

**Limitations:** 8 months of 2025 are missing from the source, and cess for Aug 2025 and Jan 2026 looked wrong, so it was excluded. Small states and UTs (e.g. Lakshadweep) show large % changes because their amounts are very small.

## Problems I faced and how I solved them
- **Non-state rows** (CBIC, OIDAR, Other Territory) → moved to a separate sheet so they don't distort state comparisons
- **July 2017 near zero** (GST launch month) → removed
- **Cess about 11x too high in Aug 2025 and Jan 2026**, while CGST/SGST/IGST looked normal → treated as a data error, blanked the cess and flagged those rows. I use `total_gst_excl_cess` as the main measure so every month is comparable.
- **8 months missing in 2025** → left as gaps rather than inventing numbers; I mention this when presenting trends
- **Inconsistent names** ("Jammu And Kashmir") → standardised
- **Added columns:** total, financial year (Apr–Mar), State/UT category

## Cleaned data columns (`data/clean/gst-collection-clean.xlsx`, sheet Clean_Data)
| Column | Meaning |
|---|---|
| date, year, month_num, month | When |
| financial_year | Indian FY, e.g. 2024-25 = Apr 2024 to Mar 2025 |
| state_name, state_code, category | Where (category = State or Union Territory) |
| cgst, sgst, igst, cess | Tax components (₹ crore) |
| total_gst_excl_cess | **Use this for comparisons.** CGST + SGST + IGST |
| total_gst | Includes cess; blank for Aug 2025 and Jan 2026 |
| cess_flag | Marks the rows where cess was removed |
