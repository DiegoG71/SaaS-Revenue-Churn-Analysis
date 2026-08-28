# SaaS-Revenue-Churn-Analysis

## Project Overview

CloudTask Pro is a fictional B2B SaaS company that provides project management software. The company grew from 0 to 600 customers between 2022 and 2025, but leadership becane concerned about customer churn despite continued revenue growth.

This project analyzes customer subscriptions, monthly recurring revenue (MRR), churn behavior, unit economics, and customer engagement to identify the company's highest-risk customer segments and opportunities for improving retention and revenue growth.

The analysis was completed using MySQL for data cleaning, preperation, and anlysis. Power BI was used for data visualization and dashboard development.

## Business Questions

This analysis focuses on the following questions:
- What is the overall churn rate, and how has monthly churn changed over time?
- Which subscription plans have the highest churn rates?
- Does annual billing improve customer retention compared with monthly billing?
- Which company sizes and acquisition channels have the highest churn?
- What are the most common reasons customer churn?
- Do churn reasons differ across subscription plans and company sizes?
- How has monthly recurring revenue changed between 2022 and 2025?
- Which subscription plans have the strongest customer lifetime value?
- How does Customer Lifetime Value compare with Customer Acquisition Cost?
- How are feature usage and NPS related to churn?
- Which currently active customers show the strongest churn-risk indicators?

## Tech Stack

- MySQL -- data cleaning, transformation, exploratory analysis, KPI calculations, and analytical views
- Power BI -- data modeling, DAX measures, interactive dashboards, and visualization

## Dataset

The project uses two data sets "subscriptions" and "monthly_revenue"

## Subcriptions

Customer-level subscription data containing approximately 600 customers and fields such as:
- Subscription plan
- Billing cycle
- Company size
- Number of seats
- Monthly revenue
- Acquisition channel
- Signup date
- Churn date
- Churn status
- Churn reason
- Support tickets
- NPS score
- Feature usage
- Upgrade status

## Monthly Revenue

Monthly company-level data covering January 2022 through December 2025 including:
- Active customers
- New customers
- Churned customers
- Monthly churn rate
- Total MRR
- Average revenue per customer
- Customer acquisition cost

## Data Preparation

The raw CSV files were imported into MySQL and copied into staging tables to preserve the original data.

Data preparation included:
- Checking row counts and duplicate customer IDs
- Reviweing null and blank values
- Validating categorical fields
- Converting signup and churn dates into proper date formats
- Converting the monthly reporting period from YYYY-MM into a MySQL date
- Converting blank churn dates to NULL
- Validating numeric ranges and identifying potential outliers
- Checking for invalid records such as churn dates occuring before signup dates
- Creating SQL views for use in Power BI


## Key Findings

### Churn Trend
The overall observed customer churn rate was 52.17%, with 313 of the 600 customers in the dataset having churned.
However, monthly churn improved considerably over time:

| Year | Average Monthly Churn Rate
| -------- | --------
| 2022   | 6.81%
| 2023   | 4.12%
| 2024   | 3.56%
| 2025   | 3.60%

Average monthly churn declined substantially between 2022 and 2024, although the improvement plateaued in 2025.

### Churn by Subscription Plan

| Plan | Churn Rate |
| -------- | -------- |
| Starter | 70.51% |
| Professional | 47.98% |
| Business | 41.25% |
| Enterprise | 22.00% |

The "Starter" plan had the highest churn rate, while "Enterprise" customers demonstrated substantially stronger retention.

### Billing Cycle and Retention
Monthly customers had significantly higher observed chunr than annual customers
- Monthly billing: 60.51%
- Annual billing 40.32%

The relationship remained visible within "Starter", "Professional", and "Business" plans, suggesting that annual subscription are associated with stronger retention.

### Customer Segments
The 500+ employee segment had the highest observed company-size churn rate at 63.16%, although this group also had the smallest number of customers.

By acquisitional channel:
-  Referral -- 61.29%
-  Partner -- 58.00%
-  Social Media -- 55.77%
-  Paid Ads -- 53.04%
-  Organic Search -- 43.79%
-  Direct Sales -- 39.29%

"Direct Sales" customers had the lowest observed churn rate.

### Top Churn Reasons

The three most common churn reasons were:

1. Budget Cuts -- 16.93%
2. Price Too High -- 16.29%
3. Company Closed -- 15.34%

Together, these reasons represented 48.56% of all churn.

"Budget Cuts" and "Price Too High" alone represented 33.22%, highlighting pricing and budget pressure as important retention considerations.

Churn drivers also differed by plan. "Starter" and "Professional" customers showed stronger price and budget sensitivity, while "Missing Features" was the most common churn reason among "Business" customers.

### Revenue Trends

Average monthly MRR increased significantly during the four-year period:

| Year | Average Monthly MRR | Average Revenue per Customer |
| -------- | -------- | -------- |
| 2022 | $46,081 | $908.91 |
| 2023 | $147,849 | $1,019.61 |
| 2024 | $222,196 | $1,039.89 |
| 2025 | $283,427 | $1,072.47 |

Revenue growth was driven by both customer growth and increasing revenue per customer/

Several months experienced MRR contractions, with the largest occuring in October 2025. In this month, MRR declined approximately $10,735 even though new customers exceeded churn customers.

During the same month, average revenue per customer declined approximately $56, suggesting that customer mix and revenue per customer can affect MRR even when customer counts remain positive.

## Unit Economics

Customer Lifetime Value was estimated using:

Estimated CLV = Average Monthly Revenue x Average Completed Customer Lifespan

| Plan | Avg. MRR | Avg. Lifespan | Estimated CLV | CLV:CAC |
| -------- | -------- | -------- | -------- | -------- |
| Enterprise | $2,984.99 | 14.36 months | $42,875.25 | 212.04x |
| Business | $1,303.64 | 14.18 months | $18,487.91 | 91.43x |
| Professional | $497.04 | 10.24 months | $5,090.20 | 25.17x |
| Starter | $215.54 | 6.22 months | $1,339.75 | 6.63x |

The weighted average Customer Acquisition Cost was approximately $202.20

"Enterprise" customers demonstrated the strongest estimated unit economics due to both higher monthly revenue and longer customers lifetimes. "Starter" customers had the lowest estimated CLV and shortest average completed lifespan. 

### Customer Risk Analysis

Customer engagement showed a strong relationship with churn.

### Feature Usage

Average feature usage:
- Churned customers: 27.45%
- Retained customers: 55.02%

Customers below 50% feature usage experienced considerable higher churn than customers above that level.

### NPS

Average NPS:
- Customer customers: 3.04
- Retained customers: 5.81

Customers with NPS scores of 6 or lower showed substantially greater churn than customers with higher scores.

### High-Risk Customer Definition

A customer was classified as high risk when both the following conditions were presents:
- Feature usage below 50%
- NPS score of 6 or lower

Customers who met both conditions historically had a churn rate of about 82%.

Among currently active customers, 68 customers met both conditions and were indentified as the highest-priority retention segment.

## Business Recommendations

Based on the analysis performed, CloudTask Pro should consider the following:
- Increasing conversion from monthly to annual billing, particularly for "Starter", "Professional", and "Business" customers
- Investigating pricing and value perception among "Starter" and "Professional" customers
- Improving product capabilities and customer support for "Business" customers
- Prioritizing retention outreach toward active customers with both low feature usage and low NPS
- Reviewing acquisition strategies for channels with higher churn, particularly "Referal" and "Partner" customers
- Monitoring both customer counts and revenue per customer when evaluating MRR performance

## Dashboard

The Power BI report contains three pages:

### SaaS Revenue and Churn

Provides a high-level view of:
- Current MRR
- Active customers
- Overall churn
- High-risk active customers
- MRR trends
- Monthly churn trends
- Churn by subcription plan
- Top churn reaons

### Churn & Retention

Provides deeper segmentation by:
- Billing cycle
- Company size
- Acquisition Channel
- Churn reason
- Subscription plan

### Unit Economics & Customer Risk
- Customer Lifetime Value
- Customer Acquisition Cost
- CLV ratio
- Customer lifespan
- Feature usage
- NPS
- Customer risk categories

## Limitations

Several limitations should be considered when interpreting this analysis, such as:
- CLV is revenue-based because gross margin and customer servicing costs were not available
- Average customer lifespan is based on customers with completed churn dates
- CAC is available at the company level rather than by subscription plan, so the same weighted average CAC is used when comparing plan-level CLV ratios
- Churn relationships are observational and should not be interpreted as proof of causations
- The feature-usage and NPS risk thresholds were identified from the same dataset used to evaluate churn and would require validation on new data before being used as a predictive model
