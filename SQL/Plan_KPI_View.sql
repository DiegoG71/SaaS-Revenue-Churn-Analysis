CREATE VIEW plan_summary AS

WITH churn_metrics AS (
    SELECT
        plan,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
        SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
            / COUNT(*) * 100 AS churn_rate,
        AVG(monthly_revenue) AS avg_mrr
    FROM subscriptions_staging
    GROUP BY plan
),

avg_lifespan AS (
    SELECT
        plan,
        AVG(
            TIMESTAMPDIFF(MONTH, signup_date, churn_date)
        ) AS avg_lifespan_months
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
    cm.plan,
    cm.total_customers,
    cm.churned_customers,
    ROUND(cm.churn_rate, 2) AS churn_rate,
    ROUND(cm.avg_mrr, 2) AS avg_mrr,
    ROUND(al.avg_lifespan_months, 2) AS avg_lifespan_months,
    ROUND(
        cm.avg_mrr * al.avg_lifespan_months,
        2
    ) AS estimated_clv,
    ROUND(wc.avg_cac, 2) AS avg_cac,
    ROUND(
        (cm.avg_mrr * al.avg_lifespan_months)
        / wc.avg_cac,
        2
    ) AS clv_cac_ratio

FROM churn_metrics AS cm
JOIN avg_lifespan AS al
    ON cm.plan = al.plan
CROSS JOIN weighted_cac AS wc;