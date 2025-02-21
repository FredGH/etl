{{ 
    config(materialized='table') 
}}

WITH stock_historical_data AS (

	SELECT MD5(CONCAT(date)) AS date_key,
	FROM { source('financial_markets_db', 'stock_historical_data') }
	GROUP BY date
),
fact_indicators AS (
	SELECT  MD5(CONCAT(name, date)) AS indicator_key,
			date_key, 
			name AS ticker,
			date,
			open, 
			high,
			low,
			close,
			volume,
			dividends,
			stock_splits
	FROM {{ source('financial_markets_db', 'stock_historical_data') }} AS stock_historical_data
	LEFT JOIN stock_historical_data AS shd ON fact.date = shd.date   
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
