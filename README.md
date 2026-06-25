# Digital Payment Fraud Detection

Detecting fraudulent mobile money transactions using the PaySim dataset — a simulated financial dataset modeled on real transaction patterns.

This project covers end-to-end fraud detection: exploratory data analysis, feature engineering, machine learning with class imbalance handling, SQL-based risk analysis, and an interactive Tableau dashboard.

## 📌 Project Overview

| Detail | Info |
|---|---|
| **Dataset** | PaySim — Kaggle (6.3M transactions) |
| **Domain** | Fintech / Digital Payments |
| **Tools** | Python, PostgreSQL, Tableau Public |
| **Model** | Logistic Regression with SMOTE |
| **ROC-AUC** | 0.9937 |

## 🔍 Key Findings

- Fraud occurs **exclusively in TRANSFER and CASH_OUT** transaction types
- Fraudulent transactions are on average **4.7x larger** than legitimate ones ($1.47M vs $314K)
- Transactions above **$1M have a 2.07% fraud rate** — 10x higher than sub-$100K transactions
- **98% of fraud cases drain the sender's account to zero** — account wipeout is the strongest fraud signal
- Certain time steps show **100% fraud rate** — suggesting automated fraud bots operating during off-hours
- The trained model achieves a **recall of 0.97** — catching 97% of all fraudulent transactions

## 🛠️ Tools & Technologies

- **Python** — Pandas, NumPy, Matplotlib, Seaborn, Scikit-learn, Imbalanced-learn
- **PostgreSQL** — DBeaver, fraud_detection_db
- **Tableau Public** — Interactive 5-sheet dashboard
- **GitHub** — Version control and portfolio hosting

## 📂 Project Structure

```
digital-payment-fraud-detection/
│
├── notebooks/
│   └── fraud_detection_analysis.ipynb
│
├── sql/
│   └── Fraud-detection-analysis.sql
│
├── tableau/
│   ├── amount_distribution.png
│   ├── tableau_amount_bucket.csv
│   └── tableau_time_step.csv
│
└── README.md
```

## 🐍 Python Analysis

**Data Overview**
- 6,362,620 transactions across 5 transaction types
- Severe class imbalance — only 0.13% fraudulent (8,213 fraud vs 6,354,407 legitimate)
- Filtered to TRANSFER and CASH_OUT only (2,770,409 rows) since fraud only occurs in these types

**Feature Engineering**
- `balance_diff_orig` — amount drained from sender's account
- `orig_balance_zero` — flag for accounts drained to exactly zero
- `type_encoded` — binary encoding of transaction type (TRANSFER=1, CASH_OUT=0)

**Class Imbalance Handling**
- Applied **SMOTE** to oversample fraud cases in training set
- Used `class_weight='balanced'` in Logistic Regression
- Fraud increased from 0.13% to 10% of training data after SMOTE

**Model Performance**

| Metric | Score |
|---|---|
| ROC-AUC | 0.9937 |
| Fraud Recall | 0.97 |
| Fraud Precision | 0.09 |
| Accuracy | 0.97 |

**Top Features by Importance**
1. `orig_balance_zero` — strongest fraud signal
2. `oldbalanceOrg` — fraudsters target high balance accounts
3. `balance_diff_orig` — large balance drops indicate fraud

## 🗄️ SQL Analysis

Database: `fraud_detection_db` | Tool: DBeaver + PostgreSQL

**Query 1 — Fraud vs Legitimate Summary**
- Fraud averages $1.47M per transaction vs $314K for legitimate
- Total fraud amount: $12B across just 8,213 transactions

**Query 2 — Fraud Rate by Amount Bucket**
- Transactions above $1M have a 2.07% fraud rate
- 10x higher than sub-$100K transactions at 0.20%

**Query 3 — Top 10 Fraud Transactions**
- Every top fraud transaction hits the exact $10M limit
- Pattern suggests repeated maximum-limit extraction behavior

**Query 4 — Fraud by Time Step**
- Certain isolated time windows show concentrated fraud activity
- Early steps (step 22) show highest fraud volume
- Time-based rules could be an effective fraud detection layer

## 📊 Tableau Dashboard

**[View Live Dashboard](https://public.tableau.com/views/DigitalPaymentFraudDetectionDashboard/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

5 interactive sheets:
- Fraud vs Legitimate transaction count
- Fraud rate by transaction type
- Fraud rate by amount bucket
- Fraud count over time (730 steps)
- Average transaction amount by fraud label

## 💡 Business Recommendations

1. **Flag all TRANSFER and CASH_OUT transactions above $1M** for mandatory review
2. **Implement time-based alerts** for low-activity periods showing 100% fraud rate
3. **Monitor accounts drained to zero** — strongest single indicator of fraud
4. **Prioritize recall over precision** — missing fraud is far costlier than false alarms
