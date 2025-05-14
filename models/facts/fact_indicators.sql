{{ 
    config
	(
		materialized="table", 
		cluster_by="type",
		tags=["fact", "indicators"],
		labels={"contains_pii":"no", "frequency":"daily"}
	)
}}

-- partition and cluster review on type
-- dim date partion on year
-- add PK and FK, check (https://docs.getdbt.com/reference/resource-properties/constraints)
-- data_type: text (https://docs.getdbt.com/reference/resource-properties/constraints)

WITH dim_date AS (
	SELECT date_key,
		   date
	FROM {{ ref('dim_date') }}
	GROUP BY date_key, 
			 date
),
fact_indicators AS (
	SELECT  MD5(CONCAT(shdu.name, dd.date_key)) AS indicator_key,
			dd.date_key,
			dd.date, --degenerated attribute 
			shdu.name AS ticker,
			CASE WHEN sad.type IS NULL THEN '{{var("not_available")}}' ELSE sad.type END AS type,
			shdu.open, 
			shdu.high,
			shdu.low,
			shdu.close,
			shdu.volume,
			shdu.dividends,
			shdu.stock_splits
	FROM  {{ ref('stg_historical_data_union') }} AS shdu
	LEFT JOIN dim_date AS dd ON dd.date = shdu.date
	LEFT JOIN {{ ref('stg_asset_description') }} AS sad ON shdu.name =  sad.name
)
SELECT indicator_key,
		date_key,
		date, 
		ticker,
		type,
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