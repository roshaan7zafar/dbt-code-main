{{ config(database="DBT_PROD", tags=["stocks_batch"]) }}

-- CTE to get the highest value of the stock in 2 years
with
    max_high as (
        select round(max(high)) as max_high, ticker
        from dbt_staging.stock_market.yahoo_stocks_batch_data
        where date >= current_date - (365 * 2)
        group by 2
    ),

    -- Calculate the dates for the highs
    include_dates as (
        select m.ticker, b.date, m.max_high
        from {{ ref("YAHOO_STOCKS_BATCH_DATA") }} b
        inner join
            max_high m on round(b.high) = round(m.max_high) and b.ticker = m.ticker
    )

select distinct *
from include_dates
order by ticker asc, date asc
