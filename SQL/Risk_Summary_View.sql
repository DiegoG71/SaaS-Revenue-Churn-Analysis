CREATE VIEW risk_summary AS
SELECT
    CASE
        WHEN feature_usage_pct < 50
             AND nps_score <= 6
            THEN 'Both Risk Factors'
        WHEN feature_usage_pct < 50
            THEN 'Low Feature Usage Only'
        WHEN nps_score <= 6
            THEN 'Low NPS Only'
        ELSE 'Neither Risk Factor Present'
    END AS risk_category,

    COUNT(*) AS total_customers,

    SUM(
        CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END
    ) AS churned_customers,

    ROUND(
        SUM(CASE WHEN churned = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS churn_rate

FROM subscriptions_staging
GROUP BY risk_category;