CREATE OR REPLACE VIEW retail.table_joined1 AS
SELECT 
    s.shop_id,
    s.date,
    s.sales_usd,
    w.avg_temp_f,
    w.humidity_pct,
    w.is_rain,
    sv.pct_family,
    sv.pct_female,
    sv.pct_male,

    -- Ranking sales within each shop
    RANK() OVER(PARTITION BY s.shop_id ORDER BY s.sales_usd DESC) AS sales_rank,

    -- Previous day sales
    LAG(s.sales_usd) OVER(PARTITION BY s.shop_id ORDER BY s.date) AS prev_day_sales,

    -- Day-over-day growth
    s.sales_usd - LAG(s.sales_usd) OVER(PARTITION BY s.shop_id ORDER BY s.date) AS sales_growth,

    -- 7-day rolling average
    AVG(s.sales_usd) OVER(
        PARTITION BY s.shop_id 
        ORDER BY s.date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_avg_7days

FROM retail.sales s
LEFT JOIN retail.weather w 
    ON s.date = w.date 
LEFT JOIN retail.survey sv 
    ON s.date = sv.date 
 

 
 