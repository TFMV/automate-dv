WITH STG_1 AS (
    SELECT DISTINCT
    a.CUSTOMER_PK, a.CUSTOMER_ID, a.LOADDATE, a.RECORD_SOURCE
    FROM (
        SELECT CUSTOMER_PK, CUSTOMER_ID, LOADDATE, RECORD_SOURCE,
        ROW_NUMBER() OVER(
            PARTITION BY CUSTOMER_PK 
            ORDER BY LOADDATE ASC)
        AS RN
        FROM DBT_VAULT.TEST.raw_source
    ) AS a
    WHERE RN = 1
),
STG_2 AS (
    SELECT DISTINCT
    a.CUSTOMER_PK, a.CUSTOMER_ID, a.LOADDATE, a.RECORD_SOURCE
    FROM (
        SELECT CUSTOMER_PK, CUSTOMER_ID, LOADDATE, RECORD_SOURCE,
        ROW_NUMBER() OVER(
            PARTITION BY CUSTOMER_PK 
            ORDER BY LOADDATE ASC)
        AS RN
        FROM DBT_VAULT.TEST.raw_source
    ) AS a
    WHERE RN = 1
),
STG AS (
    SELECT DISTINCT
    b.CUSTOMER_PK, b.CUSTOMER_ID, b.LOADDATE, b.RECORD_SOURCE
    FROM (
            SELECT *,
            ROW_NUMBER() OVER(
                PARTITION BY CUSTOMER_PK 
                ORDER BY LOADDATE, RECORD_SOURCE ASC) 
            AS RN
            FROM (
                SELECT * FROM STG_1
                UNION ALL
                SELECT * FROM STG_2
            )
        WHERE CUSTOMER_PK <> MD5_BINARY('^^')
        AND CUSTOMER_PK <> MD5_BINARY('')
    ) AS b
    WHERE RN = 1
)

SELECT c.* FROM STG AS c
LEFT JOIN DBT_VAULT.TEST.test_hub_macro_incremental_multi_source AS d 
ON c.CUSTOMER_PK = d.CUSTOMER_PK
WHERE d.CUSTOMER_PK IS NULL