{{ 
    config(materialized='table') 
}}

SELECT MD5(CONCAT(date)) AS date_key,
	   date, 
	   to_char(date, 'Day') AS day_of_week,
	   to_char(date, 'Month') AS  calendar_month,
	   to_char(date, 'YYYY') AS calendar_year,
	   CONCAT(to_char(date, 'Month'),'-',to_char(date, 'YYYY')) AS  calendar_month_year,
	   CONCAT('Q-', to_char(date, 'Q')) AS calendar_quarter,
	   CONCAT(CONCAT('Q-', to_char(date, 'Q')),'-',to_char(date, 'YYYY')) AS  calendar_quarter_year,
	   0 AS holiday_indicator,
	   'dummy_region' AS holiday_region
FROM {{ source('financial_markets_db', 'stock_historical_data') }}
GROUP BY date
