{{ 
    config
	(
		materialized="table", 
		cluster_by="type",
		tags=["fact", "indicators"],
		labels={"contains_pii":"no", "frequency":"daily"},
		post_hook=[
			 "DO $$ BEGIN
            	IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_constraint WHERE conname = '{{ this.name }}_pk') THEN
                	ALTER TABLE {{ this }} ADD CONSTRAINT {{ this.name }}_pk PRIMARY KEY (indicator_key);
            	END IF;
        		END $$;
				",
			"DO $$ BEGIN
            	IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_constraint WHERE conname = '{{ ref('dim_date') }}_pk') THEN
                	ALTER TABLE {{ this }} ADD CONSTRAINT fk_date_key FOREIGN KEY (date_key) REFERENCES {{ ref('dim_date') }} (date_key);
            	END IF;
        		END $$;
				",
			
    		]
	)
}}

-- do the primary key creation with check in dim_date
-- enfore type generation for teach col
-- diff between meta and constraints? for PK/FK
-- contraints on value, like vol >0
-- partition and cluster review on type

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