{{ 
    config
	(
		materialized="table", 
		tags=["dim", "dates"],
		labels={"contains_pii":"no", "frequency":"daily"},
		partition_by={"field":"date", "data_type":"date", "granurity":"day_of_week"},
		cluster=["calendar_year", "calendar_month"],
		post_hook=[
				"DO $$ BEGIN
            	IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_constraint WHERE conname = '{{ this.name }}_pk') THEN
                	ALTER TABLE {{ this }} ADD CONSTRAINT {{ this.name }}_pk_new PRIMARY KEY (date_key);
            	END IF;
        		END $$;
				"
    		]
	)
}}

SELECT MD5(CAST(date AS VARCHAR)) AS date_key
	   , date
	   , CAST(date AS VARCHAR) AS date_as_str
	   , TO_CHAR(date, 'Day') AS day_of_week
	   , TO_CHAR(date, 'Month') AS  calendar_month
	   , TO_CHAR(date, 'YYYY') AS calendar_year
	   , CONCAT(TO_CHAR(date, 'Month'),'-',TO_CHAR(date, 'YYYY')) AS  calendar_month_year
	   , CONCAT('Q-', TO_CHAR(date, 'Q')) AS calendar_quarter
	   , CONCAT(CONCAT('Q-', TO_CHAR(date, 'Q')),'-',TO_CHAR(date, 'YYYY')) AS  calendar_quarter_year
	   --, 0 AS holiday_indicator
	   --, 'dummy_region' AS holiday_region
FROM  {{ ref('stg_historical_data_union') }}
GROUP BY date
