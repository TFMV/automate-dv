CAST(MD5_BINARY(NULLIF(CONCAT(
    IFNULL(NULLIF(UPPER(TRIM(CAST("CUSTOMER_ID" AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST("PHONE" AS VARCHAR))), ''), '^^'), '||',
    IFNULL(NULLIF(UPPER(TRIM(CAST("DOB" AS VARCHAR))), ''), '^^')
), '^^||^^||^^')) AS BINARY(16)) AS CUSTOMER_PK