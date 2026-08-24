CREATE VIEW subscriptions_clean AS
SELECT
    customer_id,
    plan,
    billing_cycle,
    company_size,
    seats,
    monthly_revenue,
    acquisition_channel,
    signup_date,
    churn_date,
    churned,
    churn_reason,
    support_tickets_12mo,
    nps_score,
    feature_usage_pct,
    upgraded,

    CASE
        WHEN feature_usage_pct < 50
             AND nps_score <= 6
            THEN 'High Risk'
        WHEN feature_usage_pct < 50
            THEN 'Low Usage Only'
        WHEN nps_score <= 6
            THEN 'Low NPS Only'
        ELSE 'Low Risk'
    END AS risk_category

FROM subscriptions_staging;