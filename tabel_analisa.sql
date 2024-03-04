with temp_1 as(
  SELECT
  ft.transaction_id,
  ft.date,
  kc.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating as rating_cabang,
  ft.customer_name,
  ft.product_id,
  p.product_name,
  ft.price as actual_price,
  ft.discount_percentage,
  CASE
     WHEN ft.price <= 50000 THEN 10/100
     WHEN ft.price > 50000 AND ft.price >= 100000 THEN 15/100
     WHEN ft.price > 100000 AND ft.price >= 300000 THEN 20/100
     WHEN ft.price > 300000 AND ft.price >= 500000 THEN 25/100
     ELSE 30
  END AS persentase_gross_laba,
  (1-ft.discount_percentage)*ft.price AS net_sales,
  ft.rating as rating_transaksi
FROM rakamin-kf-analytics-416120.kimia_farma.kf_final_transaction ft
LEFT JOIN rakamin-kf-analytics-416120.kimia_farma.kf_kantor_cabang kc
ON ft.branch_id = kc.branch_id
LEFT JOIN rakamin-kf-analytics-416120.kimia_farma.kf_product p
ON ft.product_id = p.product_id
)

SELECT *, 
  persentase_gross_laba*net_sales AS nett_profit 
FROM temp_1
