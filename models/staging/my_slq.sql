
{{ 
    config(materialized='table') 
}}

select * from  {{ source('financial_markets_db', 'analyst_price_targets') }}