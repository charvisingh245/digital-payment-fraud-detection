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




Query 1 — Fraud vs Legitimate Transaction Summary

SELECT 
    isFraud,
    COUNT(*) AS transaction_count,
    ROUND(AVG(amount), 2) AS avg_amount,
    ROUND(SUM(amount), 2) AS total_amount
FROM transactions
GROUP BY isFraud;




Query 2 — Fraud Rate by Amount range

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



Query 3 — Top 10 Fraud Transactions by Amount


SELECT
    type AS transaction_type,
    amount,
    nameOrig AS sender_account,
    nameDest AS receiver_account,
    oldbalanceOrg AS sender_old_balance,
    newbalanceOrig AS sender_new_balance
FROM transactions
WHERE isFraud = 1
ORDER BY amount desc
LIMIT 10;


Query 4 — Fraud Detection by Time (Step)

SELECT
    step,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_count,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM transactions
GROUP BY step
ORDER BY fraud_count DESC
LIMIT 15;
 


SELECT * FROM Transactions;