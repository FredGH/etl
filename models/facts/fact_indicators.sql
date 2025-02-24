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
		ticker,
		open, 
		high,
		low,
		close,
		volume,
		dividends,
		stock_splits
FROM fact_indicators