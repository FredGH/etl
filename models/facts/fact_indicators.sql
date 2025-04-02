{{ 
    config(materialized='table') 
}}

WITH dim_date AS (
	SELECT date_key,
		   date
	FROM {{ ref('dim_date') }}
	GROUP BY date_key, 
			 date
),
fact_indicators AS (
	SELECT  MD5(CONCAT(name, date_key)) AS indicator_key,
			date_key,
			dd.date, --degenerated attribute 
			name AS ticker,
			open, 
			high,
			low,
			close,
			volume,
			dividends,
			stock_splits
	FROM {{ source('financial_markets_db', 'stock_historical_data') }} AS shd
	LEFT JOIN dim_date AS dd ON dd.date = shd.date   
)
SELECT indicator_key,
		date_key,
		date, 
		ticker,
		open, 
		high,
		low,
		close,
		volume,
		dividends,
		stock_splits,
		-1.0 AS acc_dist_line_adl,
		-1.0 AS return_log,
		-1.0 AS ci_return_lower, 
    	-1.0 AS ci_return_upper 
FROM fact_indicators