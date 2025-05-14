{{ 
    config(materialized='table') 
}}

SELECT MD5(CAST(date AS VARCHAR)) AS date_key,
	   date, 
	   CAST(date AS VARCHAR) AS date_as_str,
	   TO_CHAR(date, 'Day') AS day_of_week,
	   TO_CHAR(date, 'Month') AS  calendar_month,
	   TO_CHAR(date, 'YYYY') AS calendar_year,
	   CONCAT(TO_CHAR(date, 'Month'),'-',TO_CHAR(date, 'YYYY')) AS  calendar_month_year,
	   CONCAT('Q-', TO_CHAR(date, 'Q')) AS calendar_quarter,
	   CONCAT(CONCAT('Q-', TO_CHAR(date, 'Q')),'-',TO_CHAR(date, 'YYYY')) AS  calendar_quarter_year,
	   0 AS holiday_indicator,
	   'dummy_region' AS holiday_region
--FROM {{ source('landing_stock_src','historical_data') }}
FROM  {{ ref('stg_historical_data_union') }}
GROUP BY date
