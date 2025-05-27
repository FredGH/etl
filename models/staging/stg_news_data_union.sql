{{ 
    config(materialized='table') 
}}

WITH  data_union AS (
	{% set relations = [
		  source('landing_stock_src','news_data')
		, source('landing_index_src','news_data')
		, source('landing_currency_src','news_data')
		, source('landing_commodity_src','news_data')
	] %}
	{{ dbt_utils.union_relations(relations=relations) }}
)

SELECT name
    , content__pub_date::DATE AS pub_date 
    , content__provider__display_name AS display_name
    , content__content_type AS content_type
    , content__thumbnail__original_url AS original_url
    , content__title AS title
    , content__thumbnail__caption AS caption
    , content__summary AS summary
    , content__description AS description
    , content__provider__url AS domain
    , content__canonical_url__url AS url
    , content__canonical_url__site AS site
    , content__canonical_url__region AS region
    , content__canonical_url__lang AS lang 
    , content__metadata__editors_pick AS editors_pick
    , content__finance__premium_finance__is_premium_news AS is_premium_news
    , content__updated_at
    , content__updated_by
    , content__batch_id
    , _dlt_load_id
    , _dlt_id
FROM data_union
