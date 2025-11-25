-- ============================================
-- Tabel: ongkir
-- Deskripsi: Menyimpan data ongkir yang dipilih pelanggan saat checkout
-- ============================================

-- Hapus tabel jika sudah ada (untuk testing/development)
-- DROP TABLE IF EXISTS `ongkir`;

CREATE TABLE IF NOT EXISTS `ongkir` (
  `id_ongkir` int(11) NOT NULL AUTO_INCREMENT,
  `kurir` varchar(50) NOT NULL COMMENT 'Nama kurir: JNE, J&T, SiCepat, dll',
  `layanan` varchar(50) NOT NULL COMMENT 'Layanan: REG, YES, EZ, dll',
  `harga` decimal(12,2) NOT NULL COMMENT 'Harga ongkir dalam rupiah',
  `estimasi` varchar(50) DEFAULT NULL COMMENT 'Estimasi pengiriman: 2-3 hari, 1 hari, dll',
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diperbarui_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_ongkir`),
  KEY `idx_ongkir_kurir` (`kurir`),
  KEY `idx_ongkir_layanan` (`layanan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================
-- Index untuk optimasi query
-- ============================================

-- Index sudah ditambahkan di CREATE TABLE di atas

-- ============================================
-- Contoh Data (Optional - untuk testing)
-- ============================================

-- INSERT INTO `ongkir` (`kurir`, `layanan`, `harga`, `estimasi`) VALUES
-- ('JNE', 'REG', 30000.00, '2-3 hari'),
-- ('JNE', 'YES', 45000.00, '1 hari'),
-- ('J&T', 'EZ', 25000.00, '2-4 hari'),
-- ('SiCepat', 'REG', 28000.00, '2-3 hari');

-- ============================================
-- Catatan:
-- ============================================
-- 1. Tabel ini digunakan untuk menyimpan data ongkir yang dipilih pelanggan
-- 2. Saat checkout, Laravel akan:
--    a. Insert data ongkir ke tabel ini
--    b. Ambil id_ongkir yang baru dibuat
--    c. Simpan id_ongkir ke tabel pesanan
-- 3. Admin bisa join dengan tabel pesanan untuk melihat detail ongkir
-- 4. Kolom kurir dan layanan di-index untuk optimasi query

