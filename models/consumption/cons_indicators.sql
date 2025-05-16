{{ 
    config(materialized='table') 
}}


SELECT  shd.indicator_key,
		dd.date_key,
	    dd.date, 
	    dd.date_as_str,
	    dd.day_of_week,
	    dd.calendar_month,
	    dd.calendar_year,
	    dd.calendar_month_year,
	    dd.calendar_quarter,
	    dd.calendar_quarter_year,
	    dd.holiday_indicator,
	    dd.holiday_region,
		shd.ticker,
		shd.open, 
		shd.high,
		shd.low,
		shd.close,
		shd.volume,
		shd.dividends,
		shd.stock_splits
FROM  {{ ref('fact_indicators') }} AS shd
LEFT JOIN  {{ ref('dim_date') }} AS dd ON dd.date_key = shd.date_key   
