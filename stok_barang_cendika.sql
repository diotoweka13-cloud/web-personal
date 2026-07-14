-- ============================================================
-- DATABASE: stok_barang_cendika
-- Sistem Informasi Stok Barang - Toko Cendika
-- ============================================================

CREATE DATABASE IF NOT EXISTS `stok_barang_cendika`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

USE `stok_barang_cendika`;

-- ------------------------------------------------------------
-- TABEL: user
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `user` (
  `id_user`   INT(11)      NOT NULL AUTO_INCREMENT,
  `username`  VARCHAR(50)  NOT NULL,
  `password`  VARCHAR(255) NOT NULL,
  `nama`      VARCHAR(100) NOT NULL,
  `role`      ENUM('admin','owner','staff') NOT NULL DEFAULT 'staff',
  `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- TABEL: supplier
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `supplier` (
  `id_supplier`   INT(11)      NOT NULL AUTO_INCREMENT,
  `nama_supplier` VARCHAR(100) NOT NULL,
  `alamat`        TEXT,
  `no_hp`         VARCHAR(20),
  `email`         VARCHAR(100),
  `created_at`    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_supplier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- TABEL: barang
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `barang` (
  `id_barang`    INT(11)        NOT NULL AUTO_INCREMENT,
  `kode_barang`  VARCHAR(20)    NOT NULL,
  `nama_barang`  VARCHAR(100)   NOT NULL,
  `kategori`     VARCHAR(50),
  `satuan`       VARCHAR(20)    NOT NULL DEFAULT 'pcs',
  `stok`         INT(11)        NOT NULL DEFAULT 0,
  `stok_minimum` INT(11)        NOT NULL DEFAULT 5,
  `harga_beli`   DECIMAL(15,2)  NOT NULL DEFAULT 0,
  `harga_jual`   DECIMAL(15,2)  NOT NULL DEFAULT 0,
  `id_supplier`  INT(11),
  `keterangan`   TEXT,
  `created_at`   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_barang`),
  UNIQUE KEY `kode_barang` (`kode_barang`),
  CONSTRAINT `fk_barang_supplier`
    FOREIGN KEY (`id_supplier`) REFERENCES `supplier`(`id_supplier`)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- TABEL: barang_masuk
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `barang_masuk` (
  `id_masuk`    INT(11)   NOT NULL AUTO_INCREMENT,
  `kode_masuk`  VARCHAR(20) NOT NULL,
  `tanggal`     DATE      NOT NULL,
  `id_barang`   INT(11)   NOT NULL,
  `jumlah`      INT(11)   NOT NULL,
  `harga_beli`  DECIMAL(15,2) NOT NULL DEFAULT 0,
  `id_supplier` INT(11),
  `id_user`     INT(11)   NOT NULL,
  `keterangan`  TEXT,
  `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_masuk`),
  CONSTRAINT `fk_masuk_barang`
    FOREIGN KEY (`id_barang`) REFERENCES `barang`(`id_barang`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_masuk_user`
    FOREIGN KEY (`id_user`) REFERENCES `user`(`id_user`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_masuk_supplier`
    FOREIGN KEY (`id_supplier`) REFERENCES `supplier`(`id_supplier`)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- TABEL: barang_keluar
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `barang_keluar` (
  `id_keluar`   INT(11)   NOT NULL AUTO_INCREMENT,
  `kode_keluar` VARCHAR(20) NOT NULL,
  `tanggal`     DATE      NOT NULL,
  `id_barang`   INT(11)   NOT NULL,
  `jumlah`      INT(11)   NOT NULL,
  `harga_jual`  DECIMAL(15,2) NOT NULL DEFAULT 0,
  `id_user`     INT(11)   NOT NULL,
  `keterangan`  TEXT,
  `created_at`  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_keluar`),
  CONSTRAINT `fk_keluar_barang`
    FOREIGN KEY (`id_barang`) REFERENCES `barang`(`id_barang`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_keluar_user`
    FOREIGN KEY (`id_user`) REFERENCES `user`(`id_user`)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- SEEDER DATA
-- ============================================================

-- Default Users (password = password_asli di bawah)
-- admin123  -> bcrypt hash
-- owner123  -> bcrypt hash
-- staff123  -> bcrypt hash
INSERT INTO `user` (`username`, `password`, `nama`, `role`) VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrator', 'admin'),
('owner', '$2y$10$mFwqDWiaMUvDkgQ6ZB1bYOhGpIwBzSE0MKi.m7FZQP1.cxNX9kJKy', 'Pemilik Toko', 'owner'),
('staff', '$2y$10$TKh8H1.PfuBsGXPL.MuLEe5bPRB2R5R5JeRV6uAVZ9QvV5.2Oq1JC', 'Staff Gudang', 'staff');

-- Sample Supplier
INSERT INTO `supplier` (`nama_supplier`, `alamat`, `no_hp`, `email`) VALUES
('PT. Sumber Makmur', 'Jl. Raya Industri No. 10, Jakarta', '08111222333', 'sumber@makmur.co.id'),
('CV. Mitra Sejati', 'Jl. Pahlawan No. 45, Surabaya', '08222333444', 'mitra@sejati.com'),
('UD. Karya Mandiri', 'Jl. Sudirman No. 7, Bandung', '08333444555', 'karya@mandiri.id');

-- Sample Barang
INSERT INTO `barang` (`kode_barang`, `nama_barang`, `kategori`, `satuan`, `stok`, `stok_minimum`, `harga_beli`, `harga_jual`, `id_supplier`) VALUES
('BRG-001', 'Kertas HVS A4 80gr', 'Alat Tulis', 'Rim', 50, 10, 35000, 45000, 1),
('BRG-002', 'Pulpen Ballpoint Biru', 'Alat Tulis', 'Lusin', 30, 5, 12000, 18000, 2),
('BRG-003', 'Tinta Printer Hitam', 'Printer', 'Botol', 20, 3, 55000, 75000, 1),
('BRG-004', 'Staples Kecil', 'Alat Tulis', 'Box', 15, 5, 8000, 15000, 3),
('BRG-005', 'Map Plastik Bening', 'Alat Tulis', 'Pack', 25, 5, 15000, 22000, 2),
('BRG-006', 'Penggaris 30cm', 'Alat Tulis', 'Pcs', 40, 10, 5000, 8000, 3),
('BRG-007', 'Buku Tulis 40 Lembar', 'Alat Tulis', 'Lusin', 60, 10, 18000, 28000, 2),
('BRG-008', 'Kalkulator Casio', 'Elektronik', 'Pcs', 10, 2, 85000, 120000, 1);

-- Sample Barang Masuk
INSERT INTO `barang_masuk` (`kode_masuk`, `tanggal`, `id_barang`, `jumlah`, `harga_beli`, `id_supplier`, `id_user`, `keterangan`) VALUES
('MSK-001', '2026-04-01', 1, 30, 35000, 1, 1, 'Pembelian awal bulan'),
('MSK-002', '2026-04-05', 2, 20, 12000, 2, 3, 'Restock pulpen'),
('MSK-003', '2026-04-10', 3, 10, 55000, 1, 1, 'Pembelian tinta printer'),
('MSK-004', '2026-04-15', 4, 10, 8000, 3, 3, 'Restock staples'),
('MSK-005', '2026-04-20', 7, 30, 18000, 2, 1, 'Beli buku tulis'),
('MSK-006', '2026-05-01', 1, 20, 35000, 1, 3, 'Restock kertas bulan Mei');

-- Sample Barang Keluar
INSERT INTO `barang_keluar` (`kode_keluar`, `tanggal`, `id_barang`, `jumlah`, `harga_jual`, `id_user`, `keterangan`) VALUES
('KLR-001', '2026-04-03', 1, 10, 45000, 3, 'Penjualan ke pelanggan'),
('KLR-002', '2026-04-08', 2, 5, 18000, 3, 'Penjualan ke toko retail'),
('KLR-003', '2026-04-12', 3, 3, 75000, 1, 'Dipakai internal kantor'),
('KLR-004', '2026-04-22', 7, 12, 28000, 3, 'Penjualan buku'),
('KLR-005', '2026-05-01', 6, 5, 8000, 3, 'Penjualan penggaris');
