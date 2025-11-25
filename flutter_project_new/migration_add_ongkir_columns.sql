-- Migration: Tambah kolom ongkir langsung di tabel pesanan (Opsi A)
-- Gunakan ini jika ingin data ongkir langsung di tabel pesanan tanpa join

ALTER TABLE `pesanan`
ADD COLUMN `kurir_pengiriman` varchar(50) DEFAULT NULL AFTER `ongkir_id`,
ADD COLUMN `layanan_pengiriman` varchar(50) DEFAULT NULL AFTER `kurir_pengiriman`,
ADD COLUMN `harga_ongkir` decimal(12,2) DEFAULT 0.00 AFTER `layanan_pengiriman`,
ADD COLUMN `estimasi_pengiriman` varchar(50) DEFAULT NULL AFTER `harga_ongkir`;

-- Catatan:
-- Jika menggunakan opsi ini, data ongkir akan langsung tersimpan di tabel pesanan
-- Tidak perlu insert ke tabel ongkir terlebih dahulu
-- Tapi tetap bisa gunakan ongkir_id untuk referensi jika diperlukan

