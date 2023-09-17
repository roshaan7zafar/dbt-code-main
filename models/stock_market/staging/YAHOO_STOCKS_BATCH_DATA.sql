-- Set target properties
{{
    config(
        database="DBT_STAGING",
        tags=["stocks_batch"],
        pre_hook="ALTER EXTERNAL TABLE DBT_RAW.LANDING_ZONE.BATCH_DATA_STOCKS REFRESH",
    )
}}

select
    date,
    ticker,
    round(open) as open,
    round(high) as high,
    round(low) as low,
    round(close) as close,
    volume
from dbt_raw.landing_zone.batch_data_stocks
