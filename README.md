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
Customer-level subscription data containing approximately 600 cstomers and fields such as:
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

