CREATE VIEW churn_by_billing_cycle AS
SELECT
    billing_cycle,
    COUNT(*) AS total_customers,
    SUM(churned = 'Yes') AS churned_customers,
    ROUND(
        SUM(churned = 'Yes') / COUNT(*) * 100,
        2
    ) AS churn_rate
FROM subscriptions_staging
GROUP BY billing_cycle;