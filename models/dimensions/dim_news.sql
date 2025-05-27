{{ 
    config
	(
		materialized="table", 
		tags=["dim", "date"],
		labels={"contains_pii":"no", "frequency":"daily"},
		partition_by={"field":"pub_date", "data_type":"date", "granurity":"name"},
		cluster=["name"],
		post_hook=[
				"DO $$ BEGIN
            	IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_constraint WHERE conname = '{{ this.name }}_pk') THEN
                	ALTER TABLE {{ this }} ADD CONSTRAINT {{ this.name }}_pk PRIMARY KEY (news_key);
            	END IF;
        		END $$;
				"
    		]
	)
}}

SELECT  
        DISTINCT ON (url)
          MD5(CONCAT(name, url, CAST(pub_date AS VARCHAR))) AS news_key
        , name
        , pub_date 
        , display_name
        , content_type
        , domain
        , url
        , original_url
        , title
        , caption
        , summary
        , description
        , site
        , region
        , lang 
        , editors_pick
        , is_premium_news
        , content__updated_at
        , content__updated_by
        , content__batch_id
        , _dlt_load_id
        , _dlt_id
FROM  {{ ref('stg_news_data_union') }}
ORDER BY url, pub_date DESC
