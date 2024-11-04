CREATE TABLE kimia_farma.tabel_analisa AS -- CREATE TABLE digunakan untuk membuat tabel analisa baru
SELECT -- SELECT digunakan untuk mengambil kolom-kolom dari tabel
    t.transaction_id, -- mengambil id transaksi
    t.date, -- mengambil tanggal transaksi
    t.branch_id, -- mengambil id cabang
    b.branch_name, -- mengambil nama cabang
    b.kota, -- mengambil kota cabang
    b.provinsi, -- mengambil provinsi cabang
    b.rating AS rating_cabang, -- mengambil rating cabang
    t.customer_name, -- mengambil nama customer
    p.product_id, -- mengambil id produk obat
    p.product_name, -- mengambil nama produk obat
    t.price AS actual_price, -- mengambil harga obat
    t.discount_percentage, -- mengambil persentase diskon yg diberikan utk obat
    CASE -- digunakan CASE untuk menghitung persentase_gross_laba dan nett_profit
        WHEN t.price <= 50000 THEN 10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 25
        ELSE 30
    END AS persentase_gross_laba, --menghitung persentase gross laba berdasarkan harga
    (t.price - (t.price * t.discount_percentage / 100)) AS nett_sales, -- Menghitung nett sales setelah diskon
    ((t.price - (t.price * t.discount_percentage / 100)) * 
     CASE
         WHEN t.price <= 50000 THEN 0.1
         WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
         WHEN t.price > 100000 AND t.price <= 300000 THEN 0.2
         WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
         ELSE 0.3
     END) AS nett_profit, -- menghitung nett profit berdasarkan gross laba
    t.rating AS rating_transaksi -- mengambil rating transaksi
FROM -- kolom diambil dari t=kf_final_transaction, b=kf_kantor_cabang, p=kf_product, i=kf_inventory
     -- digunakan JOIN untuk menggabungkan tabel-tabel    
    `kimia_farma.kf_final_transaction` t
JOIN
    `kimia_farma.kf_product` p ON t.product_id = p.product_id
JOIN
    `kimia_farma.kf_inventory` i ON t.product_id = i.product_id AND t.branch_id = i.branch_id
JOIN
    `kimia_farma.kf_kantor_cabang` b ON t.branch_id = b.branch_id