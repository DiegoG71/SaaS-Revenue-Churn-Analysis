-- Preserve imported data subscriptions table

CREATE TABLE subscriptions_staging
LIKE subscriptions;

INSERT INTO subscriptions_staging
SELECT *
FROM subscriptions;

-- Preserve imported data for monthly revenue table

CREATE TABLE monthly_revenue_staging
LIKE monthly_revenue;

INSERT INTO monthly_revenue_staging
SELECT *
FROM monthly_revenue;


-- Data Quality Check (duplicates, nulls, etc...)

SELECT *
FROM subscriptions_staging
LIMIT 10;

SELECT *
FROM monthly_revenue_staging
LIMIT 10;

SELECT 
	customer_id,
    COUNT(*) AS customer_count
FROM subscriptions_staging
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT *
FROM monthly_revenue_staging
LIMIT 10;

SELECT 
	month,
    COUNT(*) as month_count
FROM monthly_revenue_staging
GROUP BY month
HAVING COUNT(*) > 1;

SELECT
	churned,
    COUNT(*) AS customers,
    SUM(churn_date IS NULL) AS null_churn_dates,
    SUM(churn_date = '') AS blank_churn_dates
FROM subscriptions_staging
GROUP BY churned;

SELECT
	churned,
    COUNT(*) AS customers,
    SUM(churn_reason IS NULL) AS null_reasons,
    SUM(churn_reason = ' ') AS blank_reasons
FROM subscriptions_staging
GROUP BY churned;

-- Check for duplicates

SELECT DISTINCT plan
FROM subscriptions_staging;

SELECT DISTINCT billing_cycle
FROM subscriptions_staging;

SELECT DISTINCT company_size
FROM subscriptions_staging;

SELECT DISTINCT acquisition_channel
FROM subscriptions_staging;

SELECT DISTINCT churned
FROM subscriptions_staging;

-- Convert blank churn dates to NULL

UPDATE subscriptions_staging
SET churn_date = NULL
WHERE churn_date = '';

SELECT
	churned,
    COUNT(*) customers,
    SUM(churn_date IS NULL) AS null_churn_dates
FROM subscriptions_staging
GROUP BY churned;

-- Convert signup_date to DATE format

ALTER TABLE subscriptions_staging
MODIFY COLUMN signup_date DATE;

ALTER TABLE subscriptions_staging
MODIFY COLUMN churn_date DATE;

ALTER TABLE monthly_revenue_staging
MODIFY COLUMN month DATE;

DESCRIBE subscriptions_staging;

SELECT
    customer_id,
    signup_date,
    churn_date,
    churned
FROM subscriptions_staging
LIMIT 10;

-- Standardize the month column in monthly_revenue_staging table 
-- to include the first day of each month. Also change the format for month to DATE.

UPDATE monthly_revenue_staging
SET month = CONCAT(month, '-01');

ALTER TABLE monthly_revenue_staging
MODIFY COLUMN month DATE;

-- Test that the dates work properly and checks ranges

SELECT
    MIN(signup_date) AS earliest_signup,
    MAX(signup_date) AS latest_signup,
    MIN(churn_date) AS earliest_churn,
    MAX(churn_date) AS latest_churn
FROM subscriptions_staging;

SELECT
	MIN(month) as earliest_month,
    MAX(month) as latest_month
FROM monthly_revenue_staging;

-- Checking MIN, MAX, AVG for important fields

SELECT
    MIN(seats) AS min_seats,
    MAX(seats) AS max_seats,
    AVG(seats) AS avg_seats,

    MIN(monthly_revenue) AS min_monthly_revenue,
    MAX(monthly_revenue) AS max_monthly_revenue,
    AVG(monthly_revenue) AS avg_monthly_revenue,

    MIN(support_tickets_12mo) AS min_support_tickets,
    MAX(support_tickets_12mo) AS max_support_tickets,
    AVG(support_tickets_12mo) AS avg_support_tickets,

    MIN(nps_score) AS min_nps,
    MAX(nps_score) AS max_nps,
    AVG(nps_score) AS avg_nps,

    MIN(feature_usage_pct) AS min_feature_usage,
    MAX(feature_usage_pct) AS max_feature_usage,
    AVG(feature_usage_pct) AS avg_feature_usage
FROM subscriptions_staging;


SELECT
    MIN(total_active_customers) AS min_active_customers,
    MAX(total_active_customers) AS max_active_customers,

    MIN(new_customers) AS min_new_customers,
    MAX(new_customers) AS max_new_customers,

    MIN(churned_customers) AS min_churned_customers,
    MAX(churned_customers) AS max_churned_customers,

    MIN(monthly_churn_rate_pct) AS min_churn_rate,
    MAX(monthly_churn_rate_pct) AS max_churn_rate,

    MIN(total_mrr) AS min_total_mrr,
    MAX(total_mrr) AS max_total_mrr,

    MIN(avg_revenue_per_customer) AS min_avg_revenue,
    MAX(avg_revenue_per_customer) AS max_avg_revenue,

    MIN(customer_acquisition_cost) AS min_cac,
    MAX(customer_acquisition_cost) AS max_cac
FROM monthly_revenue_staging;

-- What is the overall churn rate?

SELECT 
	COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) as overall_churn_rate
    FROM subscriptions_staging;
    
-- How has monthly churn trended over the past four years?
-- Is churn improving or getting worse?

SELECT
	month,
	monthly_churn_rate_pct
FROM monthly_revenue_staging
ORDER BY month;

-- AVG churn rate by year

SELECT
	YEAR(month) as year,
    ROUND(AVG(monthly_churn_rate_pct), 2) as avg_monthly_churn_rate
FROM monthly_revenue_staging
GROUP BY YEAR(month)
ORDER BY year;

-- Best and worst months for churn

SELECT
	month,
    monthly_churn_rate_pct
FROM monthly_revenue_staging
ORDER BY monthly_churn_rate_pct DESC
LIMIT 5;

SELECT
	month,
    monthly_churn_rate_pct
FROM monthly_revenue_staging
ORDER BY monthly_churn_rate_pct ASC
LIMIT 5;

-- Which plans have the highest churn?

SELECT
	plan,
    COUNT(*) as total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) as churned_customers,
    ROUND(
		SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
        FROM subscriptions_staging
        GROUP BY plan
        ORDER BY churn_rate DESC;
        
-- Does billing cycle (monthly vs annual) significantly impact retention?

SELECT
	billing_cycle,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) as churned_customers,
    ROUND(
		SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) as churn_rate
FROM subscriptions_staging
GROUP BY billing_cycle
ORDER BY churn_rate DESC;

SELECT
    plan,
    billing_cycle,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS churn_rate
FROM subscriptions_staging
GROUP BY plan, billing_cycle
ORDER BY plan, churn_rate DESC;

-- which customer segments are at highest risk of churn

SELECT
	company_size,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
		SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) as churn_rate
FROM subscriptions_staging
GROUP BY company_size
ORDER BY churn_rate DESC;

-- How does acquisition channel affect churn rates?

SELECT
	acquisition_channel,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
		SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) as churn_rate
FROM subscriptions_staging
GROUP BY acquisition_channel
ORDER BY churn_rate DESC;

-- Why are customers churning? What are the top 3 reaons customers churn? Do they differ by plan type or company size?

SELECT
	churn_reason,
	COUNT(*) as total_customers,
    ROUND(
		COUNT(*) * 100 / SUM(COUNT(*)) OVER()
        , 2) AS pct_of_churn
FROM subscriptions_staging
WHERE churned = 'Yes'
GROUP BY churn_reason
ORDER BY pct_of_churn;

SELECT
	plan,
    churn_reason,
    COUNT(*) AS churned_customers,
    ROUND(
		COUNT(*) * 100 / SUM(COUNT(*)) OVER(PARTITION BY plan), 2) as pct_of_plan_churn
FROM subscriptions_staging
WHERE churned = 'Yes'
GROUP BY plan, churn_reason
ORDER BY plan, pct_of_plan_churn DESC;

SELECT
	company_size,
    churn_reason,
    COUNT(*) as churned_customers,
    ROUND(
		COUNT(*) * 100 / 
		SUM(COUNT(*)) OVER (PARTITION BY company_size), 2) as pct_of_size_churn
FROM subscriptions_staging
WHERE churned = 'Yes'
GROUP BY company_size, churn_reason
ORDER BY company_size, pct_of_size_churn DESC;

-- REVENUE ANALYSIS; How has MRR evolved over the four years?

SELECT 
	month,
    total_mrr,
    total_active_customers,
    avg_revenue_per_customer
FROM monthly_revenue_staging
ORDER BY month;

SELECT
	YEAR(month) AS year,
	ROUND(AVG(total_mrr), 2) as avg_monthly_mrr,
    ROUND(MIN(total_mrr), 2) as min_monthly_mrr,
    ROUND(MAX(total_mrr), 2) as max_monthly_mrr,
    ROUND(AVG(avg_revenue_per_customer), 2) AS avg_revenue_per_customer
FROM monthly_revenue_staging
GROUP BY YEAR(month)
ORDER BY year;

-- Monthly mrr changes

SELECT
	month,
    total_mrr,
    LAG(total_mrr) OVER (ORDER BY  month) AS previous_month_mrr,
    ROUND(
		total_mrr - LAG(total_mrr) OVER (ORDER BY month), 2) AS mrr_change
FROM monthly_revenue_staging
ORDER BY month;


-- Investigate unsual months

WITH revenue_changes AS (
    SELECT
        month,
        total_active_customers,
        new_customers,
        churned_customers,
        monthly_churn_rate_pct,
        total_mrr,
        avg_revenue_per_customer,
        LAG(avg_revenue_per_customer)
            OVER (ORDER BY month) AS previous_month_arpc,
        ROUND(
            total_mrr - LAG(total_mrr)
            OVER (ORDER BY month),
            2
        ) AS mrr_change
    FROM monthly_revenue_staging
)

SELECT
    *,
    ROUND(
        avg_revenue_per_customer - previous_month_arpc,
        2
    ) AS arpc_change
FROM revenue_changes
WHERE mrr_change < 0
ORDER BY mrr_change;
        
-- UNIT ECONOMICS; Calculate average Customer Lifetime Value (CLV) by plan.
-- compare this to CAC. Which plans are most and least profitable?

SELECT
	customer_id,
    plan,
    signup_date,
    churn_date,
    TIMESTAMPDIFF(MONTH, signup_date, churn_date) AS lifespan_months,
    monthly_revenue
FROM subscriptions_staging
WHERE churned = 'Yes'
ORDER BY lifespan_months DESC;


WITH avg_mrr AS (
    SELECT
        plan,
        AVG(monthly_revenue) AS avg_mrr
    FROM subscriptions_staging
    GROUP BY plan
),

avg_lifespan AS (
    SELECT
        plan,
        AVG(TIMESTAMPDIFF(MONTH, signup_date, churn_date)) AS avg_lifespan_months
    FROM subscriptions_staging
    WHERE churned = 'Yes'
    GROUP BY plan
),

weighted_cac AS (
    SELECT
        SUM(customer_acquisition_cost * new_customers)
        / SUM(new_customers) AS avg_cac
    FROM monthly_revenue_staging
)

SELECT
    m.plan,
    ROUND(m.avg_mrr, 2) AS avg_mrr,
    ROUND(al.avg_lifespan_months, 2) AS avg_lifespan_months,
    ROUND(m.avg_mrr * al.avg_lifespan_months, 2) AS estimated_clv,
    ROUND(c.avg_cac, 2) AS avg_cac,
    ROUND(
        (m.avg_mrr * al.avg_lifespan_months) / c.avg_cac,
        2
    ) AS clv_cac_ratio
FROM avg_mrr AS m
JOIN avg_lifespan AS al
    ON m.plan = al.plan
CROSS JOIN weighted_cac AS c
ORDER BY clv_cac_ratio DESC;

-- Calculate avg CAC

SELECT
    ROUND(
        SUM(customer_acquisition_cost * new_customers)
        / SUM(new_customers),
        2
    ) AS weighted_avg_cac
FROM monthly_revenue_staging;


-- At-Risk Indicators, Customer Analysis; 
-- Analyze the relationship between feature usage, NPS, and churn.

SELECT 
	churned,
    COUNT(*) as total_customers,
    ROUND(AVG(feature_usage_pct), 2) AS avg_feature_usage,
    ROUND(AVG(nps_score), 2) AS avg_nps
FROM subscriptions_staging
GROUP BY churned;


SELECT
	CASE
		WHEN feature_usage_pct < 20 THEN '0-19%'
        WHEN feature_usage_pct < 30 THEN '20-29%'
        WHEN feature_usage_pct < 40 THEN '30-39%'
        WHEN feature_usage_pct < 50 THEN '40-49%'
        WHEN feature_usage_pct < 60 THEN '50-59%'
        ELSE '60%+'
	END AS usage_band,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) as churned_customers,
    ROUND(SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
    FROM subscriptions_staging
    GROUP BY usage_band
    ORDER BY MIN(feature_usage_pct);
    
-- NPS Score churn changes

SELECT
	nps_score,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) AS churned_custmoers,
    ROUND(SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM subscriptions_staging
GROUP BY nps_score
ORDER BY nps_score;

-- Customers at-risk calculations

SELECT
	CASE
		WHEN feature_usage_pct < 50 AND nps_score <= 6
			THEN 'Both Risk Factors'
		WHEN feature_usage_pct < 50
			THEN 'Low Feature Usage Only'
		WHEN nps_score <= 6
			THEN 'Low NPS Only'
		ELSE 'Neither Risk Factor Present'
	END AS risk_category,
    COUNT(*) AS active_customers
    FROM subscriptions_staging
    WHERE churned = 'No'
    GROUP BY risk_category
    ORDER BY active_customers DESC;
    
-- Now with all customers

SELECT
    CASE
        WHEN feature_usage_pct < 50 AND nps_score <= 6
            THEN 'Both Risk Factors'
        WHEN feature_usage_pct < 50
            THEN 'Low Feature Usage Only'
        WHEN nps_score <= 6
            THEN 'Low NPS Only'
        ELSE 'Neither Risk Factor Present'
    END AS risk_category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS churn_rate
FROM subscriptions_staging
GROUP BY risk_category
ORDER BY churn_rate DESC;