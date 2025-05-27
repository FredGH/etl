{{ 
    config(materialized='table') 
}}

WITH  data_union AS (
	{% set relations = [
		  source('landing_stock_src','historical_data')
		, source('landing_index_src','historical_data')
		, source('landing_currency_src','historical_data')
		, source('landing_commodity_src','historical_data')
	] %}
	{{ dbt_utils.union_relations(relations=relations) }}
)

--, source('landing_bond_src','historical_data')
--, source('landing_crypto_src','historical_data')

SELECT date
    , open
    , high
    , low
    , close
    , volume
    , dividends
    , stock_splits
    , name
    , updated_at
    , updated_by
    , batch_id
    , _dlt_load_id
    , _dlt_id
FROM data_union
