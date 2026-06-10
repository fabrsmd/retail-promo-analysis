# Promotion Effectiveness Analysis & Revenue Impact Estimation

## Business Question

- The company runs promotions regularly but has limited visibility into whether they actually generate value.
- The goal of this project was to understand:
  - Do promotions increase profit or simply reduce margins?
  - Which products benefit from discounts?
  - What discount level delivers the highest return on investment?

## Dataset

- [Online Retail Dataset (UCI Machine Learning Repository)](https://archive.ics.uci.edu/dataset/352/online+retail)
- No promotion flag was available in the original data
- Promotional sales were reconstructed by comparing transaction prices to each product's most frequent selling price (reference price)

## Tech Stack

| Step | Tool |
|------|------|
| Data Cleaning & Transformation | PostgreSQL |
| Analysis & Modeling | R / RStudio |
| Data Visualization | Power BI |
| Version Control | Git / GitHub |

## What I Did

### Data Preparation (PostgreSQL)

- Cleaned transactional data
- Removed cancellations and invalid records
- Filtered out negative quantities and zero-price transactions
- Built a star schema for reporting and analysis
- Created business-oriented views for downstream analytics

### Analysis & Modeling (R)

- Performed exploratory data analysis (EDA)
- Calculated key sales and promotion KPIs
- Estimated price elasticity using log-log regression models
- Identified products with different levels of price sensitivity
- Simulated multiple discount scenarios
- Measured the impact of promotions on revenue, margin, and ROI

### Dashboarding (Power BI)

- Built a dashboard for high-level business monitoring
- Developed an operational dashboard for product-level analysis
- Created an interactive what-if simulator to evaluate different discount strategies

## Key Findings

- Total Revenue: **£10,67M**
- Average Order Value: **£534,4**
- Revenue Generated Through Promotions: **32%**
- Estimated Overall Price Elasticity: **-0,86**

Despite 32% of revenue being generated under promotional pricing,
simulations show that no discount level produces a positive ROI.
A 5% discount — the least damaging scenario — still results in
an estimated margin loss of £76k (ROI: -16%).

**Conclusion: blanket promotions destroy margin. Targeted promotion on elastic products is recommended.**

## Business Insights

- **Promotions are widespread but inefficient.** 32% of revenue
  is generated under promotional pricing, yet no discount scenario
  produces a positive return — indicating that discounts are applied
  too broadly across the portfolio.

- **Demand is price-inelastic at the portfolio level.** An elasticity
  of -0.86 means a 10% price cut only drives 8.6% more volume —
  insufficient to offset the margin loss.

- **Not all products behave the same.** Product-level elasticity
  analysis reveals a subset of items where demand responds strongly
  to price reductions. These are the only products where promotions
  can generate incremental value.

- **The bigger the discount, the bigger the loss.** Margin erosion
  scales linearly with discount depth: from -£76k at 5% to -£490k
  at 25%. There is no discount threshold that becomes profitable
  at the portfolio level.

---

## Recommendations

1. **Stop broad discounting immediately.** With an overall ROI
   of -16% at the lowest tested discount level, applying promotions
   across all products is value-destructive.

2. **Concentrate promotions on elastic products only.** Target
   the products identified with elasticity ≤ -1, where volume
   uplift is strong enough to offset the price reduction.

3. **Set a maximum discount cap of 5%.** If promotions must be
   run broadly, 5% is the least damaging scenario (-£76k vs -£490k
   at 25%). Never exceed this threshold without product-level
   elasticity validation.

4. **Monitor promotional ROI monthly** via the Power BI dashboard.
   Track margin per product before and after each campaign to build
   a real elasticity database over time.

5. **Invest savings from reduced discounting into retention.**
   The repeat purchase rate indicates an engaged customer base —
   loyalty programmes may deliver better ROI than price cuts.

## Project Outcome

- Built an end-to-end analytics workflow from raw transactional data to business recommendations.
- Combined SQL, statistical analysis, and visualization tools to evaluate promotional performance.
- Delivered actionable insights to support data-driven pricing and promotion strategies.

## Dashboards

to complete

## Reproducing the Project

1. Restore the PostgreSQL database and run the SQL scripts in sequence.
2. Execute the R scripts from data preparation to modeling.
3. Open the Power BI dashboard file.

## Author

Fabio R
