CREATE VIEW churn_reason_summary AS
SELECT
    churn_reason,
    COUNT(*) AS churned_customers,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS pct_of_churn
FROM subscriptions_staging
WHERE churned = 'Yes'
GROUP BY churn_reason;

CREATE VIEW churn_reason_by_plan AS
SELECT
    plan,
    churn_reason,
    COUNT(*) AS churned_customers,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY plan),
        2
    ) AS pct_of_plan_churn
FROM subscriptions_staging
WHERE churned = 'Yes'
GROUP BY plan, churn_reason;