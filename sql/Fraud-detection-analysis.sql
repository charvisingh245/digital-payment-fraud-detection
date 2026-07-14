-- ============================================
-- Digital Payment Fraud Detection — SQL Analysis
-- Dataset: PaySim
-- ============================================



CREATE TABLE transactions (
    step                INT,
    type                VARCHAR(10),
    amount              NUMERIC(20,2),
    nameOrig            VARCHAR(20),
    oldbalanceOrg       NUMERIC(20,2),
    newbalanceOrig      NUMERIC(20,2),
    nameDest            VARCHAR(20),
    oldbalanceDest      NUMERIC(20,2),
    newbalanceDest      NUMERIC(20,2),
    isFraud             INT,
    isFlaggedFraud      INT,
    balance_diff_orig   NUMERIC(20,2),
    orig_balance_zero   INT,
    type_encoded        INT
);
-- Note: balance_diff_orig, orig_balance_zero, type_encoded are feature-engineered
-- columns used in the Python/ML model, not in the SQL queries below.


-- ============================================
-- 1. Fraud vs Legitimate Transaction Summary
-- Q: How rare is fraud in this dataset, and how does the amount compare?
-- ============================================


SELECT 
    isFraud,
    COUNT(*) AS transaction_count,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(SUM(amount), 2) AS total_amount
FROM transactions
GROUP BY isFraud;



-- ============================================
-- 2. Fraud Rate by Transaction Type
-- Q: Which transaction types does fraud actually occur in?
-- ============================================


SELECT
    type AS transaction_type,
    COUNT(*) AS total_count,
    SUM(isFraud) AS fraud_count,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM transactions
GROUP BY type
ORDER BY fraud_rate_pct DESC;



-- ============================================
-- 3. Fraud Rate by Amount Range
-- Q: Are larger transactions more likely to be fraudulent?
-- ============================================


SELECT
    CASE
        WHEN amount < 100000 THEN 'Below 100K'
        WHEN amount < 500000 THEN '100K to 500K'
        WHEN amount < 1000000 THEN '500K to 1M'
        ELSE 'Above 1M'
    END AS amount_bucket,
    COUNT(*) AS total_count,
    SUM(isFraud) AS fraud_count,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM transactions
GROUP BY amount_bucket
ORDER BY fraud_rate_pct DESC;



-- ============================================
-- 4. Top 10 Fraud Transactions by Amount
-- Q: What do the highest-value fraud cases look like?
-- ============================================


SELECT
    type AS transaction_type,
    amount,
    nameOrig AS sender_account,
    nameDest AS receiver_account,
    oldbalanceOrg AS sender_old_balance,
    newbalanceOrig AS sender_new_balance
FROM transactions
WHERE isFraud = 1
ORDER BY amount DESC
LIMIT 10;



-- ============================================
-- 5. Fraud Detection by Time (Step)
-- Q: Are fraud cases concentrated in specific time windows?
-- ============================================



SELECT
    step,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_count,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM transactions
GROUP BY step
ORDER BY fraud_count DESC
LIMIT 15;



-- ============================================
-- 6. Naive Flag vs Actual Fraud
-- Q: How well does the dataset's built-in isFlaggedFraud rule
--    identify actual fraud cases?
-- ============================================


SELECT
    isFraud,
    isFlaggedFraud,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY isFraud, isFlaggedFraud
ORDER BY isFraud, isFlaggedFraud;
