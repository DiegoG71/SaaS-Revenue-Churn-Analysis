CREATE VIEW monthly_revenue_clean AS
SELECT
    month,
    total_active_customers,
    new_customers,
    churned_customers,
    monthly_churn_rate_pct,
    total_mrr,
    avg_revenue_per_customer,
    customer_acquisition_cost,

    ROUND(
        total_mrr -
        LAG(total_mrr) OVER (ORDER BY month),
        2
    ) AS mrr_change,

    ROUND(
        avg_revenue_per_customer -
        LAG(avg_revenue_per_customer) OVER (ORDER BY month),
        2
    ) AS arpc_change

FROM monthly_revenue_staging;