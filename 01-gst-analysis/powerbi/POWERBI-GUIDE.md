# Power BI Version of the GST Dashboard – Step-by-Step Guide

Time needed: about 2–3 hours, spread over a few days. Do one part per sitting.
Copy-paste formulas are in `dax-measures.txt` in this folder.

---

## Part 0 – Install Power BI Desktop (free)

1. Open the **Microsoft Store** app (search "Store" in the Windows Start menu).
2. Search **Power BI Desktop** → click **Get / Install**.
3. Open it. If it asks you to sign in, you can close that box. Power BI Desktop works without an account.

---

## Part 1 – Load the data (15 min)

1. Click **Get data** → **Text/CSV**.
2. Go to `01-gst-analysis\data\clean\` and choose **gst-collection-clean.csv** → **Open**.
3. A preview appears. Click **Transform Data** (not Load), which opens **Power Query**.
4. In Power Query:
   - Rename the query on the left from `gst-collection-clean` to **GST** (right-click → Rename).
   - Check the small icons on each column header:
     - `date` → should be a calendar icon (Date). If not, click the icon → **Date**.
     - `cgst`, `sgst`, `igst`, `cess`, `total_gst_excl_cess`, `total_gst` → **Decimal Number**
     - `year`, `month_num`, `state_code` → **Whole Number**
     - everything else → **Text**
5. Click **Close & Apply** (top left).

✅ Check: the **Data** pane on the right shows a table called **GST** with all the columns.

---

## Part 2 – Sort months correctly (5 min)

If you skip this, months show alphabetically (Apr, Aug, Dec...).

1. Click the **Table view** icon on the left side (it looks like a grid).
2. Click the `month` column header.
3. At the top, click **Sort by column** → choose **month_num**.

---

## Part 3 – Create measures (20 min)

Measures are Power BI's formulas, written in a language called **DAX**.

1. Go back to **Report view** (top icon on the left).
2. In the Data pane, right-click the **GST** table → **New measure**.
3. Paste the first formula from `dax-measures.txt` into the formula bar → press **Enter**.
4. Repeat for each measure.
5. Click each % measure → in the **Measure tools** tab, set the format to **Percentage**, with 1 decimal place.

✅ Check: you see measures with a calculator icon under the GST table.

---

## Part 4 – Build the dashboard (60–90 min)

Click on empty canvas before adding each new visual.

**Title**
- Insert → **Text box** → type *India GST Collection Dashboard*, size 24, bold.

**4 KPI cards (top row)**
- Visualizations pane → **Card** → drag in a measure. Make 4 cards:
  1. `GST FY25`, renamed in the Visualizations pane to "Total GST, FY 2024-25 (Rs crore)"
  2. `YoY Growth %`
  3. `Maharashtra Share`
  4. `Fastest Growing State`

**Top 10 states – bar chart**
- **Clustered bar chart** → Y-axis: `state_name`, X-axis: `Total GST`
- Filters pane → `state_name` → Filter type **Top N** → Show items: **Top 10**, By value: drag **Total GST** → **Apply filter**
- Click "..." on the chart → **Sort axis** → **Total GST**, **Sort descending**

**GST by financial year – column chart**
- **Clustered column chart** → X-axis: `financial_year`, Y-axis: `Total GST`

**Monthly trend – line chart**
- **Line chart** → X-axis: `date`, Y-axis: `Total GST`
- If the date splits into Year/Quarter/Month, click the small arrow next to `date` in the X-axis box → choose **date** (not Date Hierarchy).

**Slicers**
- **Slicer** → field: `category` → in Format → Slicer settings → Style: **Tile**
- **Slicer** → field: `financial_year` → Style: **Tile** or **Dropdown**

**Make it look good**
- View tab → **Themes** → choose one you like.
- Line visuals up neatly: select several (Ctrl + click) → Format → **Align**.
- Give every chart a clear title (Format → General → Title).

✅ Check: click "Union Territory" in the slicer. All charts should update and Delhi should top the bar chart.

---

## Part 5 – Save and share (10 min)

1. **File → Save as** → save in this `powerbi` folder as `gst-dashboard.pbix`.
2. Take a screenshot (Windows + Shift + S) → save it in `01-gst-analysis\screenshots\` as `gst-dashboard-powerbi.png`.
3. Optional: **File → Export → Export to PDF** for a version you can attach to job applications.

---

## Stuck?
Tell Claude **which Part and which step**, and what you see on screen (a screenshot helps: Windows + Shift + S, then Ctrl + V into the chat).

## Things to say in interviews
- "I used Power Query to set the correct data types."
- "I created DAX measures with CALCULATE, DIVIDE, and ALL."
- "I used a Top N filter and sorted months with Sort by Column."
- "The slicers filter all the visuals on the page."
