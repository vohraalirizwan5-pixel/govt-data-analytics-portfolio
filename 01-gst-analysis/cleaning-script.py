"""
Cleans the raw GST collection data for Project 01.

Input:  data/raw/gst-collection-statewise.csv
Output: data/clean/gst-collection-clean.csv
        data/clean/gst-collection-clean.xlsx  (sheets: Clean_Data, Other_Categories, Cleaning_Log)

You'll learn to write scripts like this in Project 04 (Python). Run it with:
    python cleaning-script.py
"""
from pathlib import Path

import pandas as pd

HERE = Path(__file__).parent
RAW = HERE / "data" / "raw" / "gst-collection-statewise.csv"
CLEAN = HERE / "data" / "clean"

UNION_TERRITORIES = {
    "Andaman and Nicobar Islands", "Chandigarh", "Dadra and Nagar Haveli and Daman and Diu",
    "Delhi", "Jammu and Kashmir", "Ladakh", "Lakshadweep", "Puducherry",
}
# Not states: CBIC (central collections), OIDAR (online services from abroad), Other Territory
OTHER_CATEGORIES = {"Cbic": "CBIC", "Oidar": "OIDAR", "Other Territory": "Other Territory"}

log = []

df = pd.read_csv(RAW, parse_dates=["date"])
log.append(f"Loaded {len(df)} rows from the raw file.")

# 1. Fix state names: "Jammu And Kashmir" -> "Jammu and Kashmir", etc.
df["state_name"] = (
    df["state_name"]
    .str.replace(" And ", " and ", regex=False)
    .str.replace("The Dadra", "Dadra", regex=False)
    .replace(OTHER_CATEGORIES)
)
log.append("Fixed state names ('And' -> 'and', removed 'The' from Dadra and Nagar Haveli).")

# 2. Remove July 2017: GST launched that month, collections are almost zero
before = len(df)
df = df[df["date"] >= "2017-08-01"]
log.append(f"Removed July 2017 (GST launch month, near-zero values): {before - len(df)} rows.")

# 3. Cess in Aug 2025 and Jan 2026 is ~11x normal while CGST/SGST/IGST look normal,
#    so treat it as a data error: blank it and flag the rows.
bad_cess_months = ["2025-08-01", "2026-01-01"]
df["cess_flag"] = ""
mask = df["date"].isin(pd.to_datetime(bad_cess_months))
df.loc[mask, "cess"] = None
df.loc[mask, "cess_flag"] = "Cess removed - suspected data error"
log.append(f"Blanked cess for Aug 2025 and Jan 2026 (about 11x normal - suspected error): {mask.sum()} rows.")

# 4. Add useful columns
df["year"] = df["date"].dt.year
df["month_num"] = df["date"].dt.month
df["month"] = df["date"].dt.strftime("%b")
fy_start = df["year"].where(df["month_num"] >= 4, df["year"] - 1)
df["financial_year"] = fy_start.astype(str) + "-" + (fy_start + 1).astype(str).str[-2:]
df["category"] = df["state_name"].apply(
    lambda s: "Other" if s in OTHER_CATEGORIES.values()
    else "Union Territory" if s in UNION_TERRITORIES else "State"
)
# Main measure: same for every month, so it's safe to compare across time
df["total_gst_excl_cess"] = df[["cgst", "sgst", "igst"]].sum(axis=1).round(2)
# Full total: blank in the two months where cess is unreliable
df["total_gst"] = (df["total_gst_excl_cess"] + df["cess"]).round(2)
log.append("Added year, month, financial_year (Apr-Mar), category, total_gst_excl_cess, total_gst.")

columns = [
    "date", "financial_year", "year", "month_num", "month", "state_name", "state_code", "category",
    "cgst", "sgst", "igst", "cess", "total_gst_excl_cess", "total_gst", "cess_flag",
]
df = df[columns].sort_values(["date", "state_name"])

# 5. Separate the non-state categories so they don't distort state comparisons
states = df[df["category"] != "Other"]
others = df[df["category"] == "Other"]
log.append(f"Split into {len(states)} state/UT rows and {len(others)} 'Other' category rows (CBIC, OIDAR, Other Territory).")

all_months = pd.date_range(df["date"].min(), df["date"].max(), freq="MS")
missing = [m.strftime("%b %Y") for m in all_months if m not in set(df["date"])]
log.append("Months missing in the source (not filled in): " + ", ".join(missing) + ".")
log.append("Amounts are assumed to be in Rs crore - verify on gst.gov.in.")

CLEAN.mkdir(parents=True, exist_ok=True)
states.to_csv(CLEAN / "gst-collection-clean.csv", index=False, date_format="%Y-%m-%d")
with pd.ExcelWriter(CLEAN / "gst-collection-clean.xlsx", engine="openpyxl", date_format="DD-MMM-YYYY") as xl:
    states.to_excel(xl, sheet_name="Clean_Data", index=False)
    others.to_excel(xl, sheet_name="Other_Categories", index=False)
    pd.DataFrame({"Step": range(1, len(log) + 1), "What was done": log}).to_excel(
        xl, sheet_name="Cleaning_Log", index=False
    )
    for ws in xl.book.worksheets:
        ws.freeze_panes = "A2"
        ws.auto_filter.ref = ws.dimensions
        for col in ws.columns:
            width = max(len(str(c.value or "")) for c in col[:200]) + 2
            ws.column_dimensions[col[0].column_letter].width = min(width, 90)

print("\n".join(log))
