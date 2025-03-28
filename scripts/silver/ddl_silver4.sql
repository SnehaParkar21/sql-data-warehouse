SELECT
cid,
bdate,
gen FROM bronze.erp_cust_az12


SELECT * FROM [silver].[crm_cust_info];

SELECT
cid,
bdate,
gen FROM bronze.erp_cust_az12
WHERE cid LIKE '%AW00011000%'

SELECT DISTINCT bdate
FROM bronze.erp_cust_az12
WHERE bdate <'1924-01-01' OR bdate> GETDATE()

SELECT DISTINCT gen,
CASE
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'n/a'
			END AS gen -- Normalize gender values and handle unknown cases
		FROM bronze.erp_cust_az12;

SELECT DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate <'1924-01-01' OR bdate> GETDATE()

SELECT DISTINCT gen
FROM silver.erp_cust_az12

SELECT * FROM silver.erp_cust_az12


INSERT INTO silver.erp_cust_az12 (
			cid,
			bdate,
			gen
		)
		SELECT
			CASE
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- Remove 'NAS' prefix if present
				ELSE cid
			END AS cid, 
			CASE
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
			END AS bdate, -- Set future birthdates to NULL
			CASE
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'n/a'
			END AS gen -- Normalize gender values and handle unknown cases
		FROM bronze.erp_cust_az12;
