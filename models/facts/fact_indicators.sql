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
            	IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_constraint WHERE conname = 'dim_dates_date_key_fk') THEN
                	ALTER TABLE {{ this }} ADD CONSTRAINT  dim_dates_date_key_fk FOREIGN KEY (date_key) REFERENCES {{ ref('dim_dates') }} (date_key);
            	END IF;
        		END $$;
				",
			"DO $$ BEGIN
            	IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_constraint WHERE conname = 'dim_news_news_key_fk') THEN
                	ALTER TABLE {{ this }} ADD CONSTRAINT dim_news_news_key_fk FOREIGN KEY (news_key) REFERENCES {{ ref('dim_news') }} (news_key);
            	END IF;
        		END $$;
				",
    		]
	)
}}


-- partition and cluster review on type


WITH dim_dates AS (
	SELECT  date_key
		   , date
	FROM {{ ref('dim_dates') }}
	GROUP BY   date_key 
			 , date
),
fact_indicators AS (
	SELECT  MD5(CONCAT(shdu.name, dd.date_key)) AS indicator_key
			, dd.date_key
			, dn.news_key
			, CAST(dd.date AS DATE) AS date --degenerated attribute 
			, shdu.name AS ticker
			, CASE WHEN sad.type IS NULL THEN '{{var("not_available")}}' ELSE sad.type END AS type
			, shdu.open
			, shdu.high
			, shdu.low
			, shdu.close
			, shdu.volume
			, shdu.dividends
			, shdu.stock_splits
	FROM  {{ ref('stg_historical_data_union') }} AS shdu
	LEFT JOIN dim_dates AS dd ON dd.date = shdu.date
	LEFT JOIN {{ ref('dim_news') }} AS dn ON dn.ticker = shdu.name AND dn.pub_date = shdu.date 
	LEFT JOIN {{ ref('stg_asset_description') }} AS sad ON shdu.name =  sad.name
)
SELECT 	indicator_key
		, date_key
		, news_key
		, date
		, ticker
		, type
		, open 
		, high
		, low
		, close
		, volume
		, dividends
		, stock_splits
		--, -1.0 AS acc_dist_line_adl
		--, -1.0 AS return_log
		--, -1.0 AS ci_return_lower 
    	--, -1.0 AS ci_return_upper 
FROM fact_indicators