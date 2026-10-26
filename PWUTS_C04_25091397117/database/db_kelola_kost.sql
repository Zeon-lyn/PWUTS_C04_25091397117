-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 26, 2026 at 07:19 AM
-- Server version: 10.4.32-MariaDB-log
-- PHP Version: 8.2.12

CREATE DATABASE IF NOT EXISTS `db_kelola_kost` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `db_kelola_kost`;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_kelola_kost`
--

-- --------------------------------------------------------

--
-- Table structure for table `kamar`
--

CREATE TABLE `kamar` (
  `id_kamar` int(10) UNSIGNED NOT NULL,
  `id_kost` int(10) UNSIGNED NOT NULL,
  `nomor_kamar` varchar(10) NOT NULL,
  `fasilitas_kamar` text DEFAULT NULL,
  `harga_kost` decimal(12,2) NOT NULL,
  `status_kamar` enum('kosong','terisi') NOT NULL DEFAULT 'kosong',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kamar`
--

INSERT INTO `kamar` (`id_kamar`, `id_kost`, `nomor_kamar`, `fasilitas_kamar`, `harga_kost`, `status_kamar`, `created_at`, `updated_at`) VALUES
(1, 1, '101', 'Kasur, Lemari, Meja belajar, Kamar mandi dalam', 1200000.00, 'terisi', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(2, 1, '102', 'Kasur, Lemari, Meja belajar, AC', 1500000.00, 'terisi', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(3, 1, '103', 'Kasur, Lemari, Kipas angin', 900000.00, 'terisi', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(4, 1, '104', 'Kasur, Lemari, Kamar mandi dalam', 1100000.00, 'kosong', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(5, 2, '201', 'Kasur, Lemari, AC, Kamar mandi dalam', 1600000.00, 'kosong', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(6, 2, '202', 'Kasur, Lemari, Kipas angin', 950000.00, 'kosong', '2026-10-07 19:39:04', '2026-10-07 19:39:04');

-- --------------------------------------------------------

--
-- Table structure for table `keluhan`
--

CREATE TABLE `keluhan` (
  `id_keluhan` int(10) UNSIGNED NOT NULL,
  `id_penghuni` int(10) UNSIGNED NOT NULL,
  `judul_keluhan` varchar(150) NOT NULL,
  `isi_keluhan` text NOT NULL,
  `kategori_keluhan` varchar(50) DEFAULT NULL,
  `foto_pendukung` varchar(255) DEFAULT NULL,
  `tanggal_keluhan` date NOT NULL,
  `tanggapan_owner` text DEFAULT NULL,
  `status_keluhan` enum('menunggu','diproses','selesai') NOT NULL DEFAULT 'menunggu',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `keluhan`
--

INSERT INTO `keluhan` (`id_keluhan`, `id_penghuni`, `judul_keluhan`, `isi_keluhan`, `tanggal_keluhan`, `tanggapan_owner`, `status_keluhan`, `created_at`, `updated_at`) VALUES
(1, 1, 'Lampu kamar mati', 'Lampu di kamar 101 mati sejak kemarin.', '2026-10-02', 'Teknisi akan datang besok pagi.', 'diproses', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(2, 2, 'AC kurang dingin', 'AC kamar 102 tidak terasa dingin.', '2026-10-03', 'AC sudah diservis pada 5 Oktober.', 'selesai', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(3, 3, 'Keran air bocor', 'Keran di kamar mandi bersama lantai 1 bocor.', '2026-10-06', NULL, 'menunggu', '2026-10-07 19:39:04', '2026-10-07 19:39:04');

-- --------------------------------------------------------

--
-- Table structure for table `kost`
--

CREATE TABLE `kost` (
  `id_kost` int(10) UNSIGNED NOT NULL,
  `id_owner` int(10) UNSIGNED NOT NULL,
  `nama_kost` varchar(100) NOT NULL,
  `alamat` text NOT NULL,
  `kontak` varchar(20) NOT NULL,
  `fasilitas` text DEFAULT NULL,
  `foto_kost` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kost`
--

INSERT INTO `kost` (`id_kost`, `id_owner`, `nama_kost`, `alamat`, `kontak`, `fasilitas`, `foto_kost`, `created_at`, `updated_at`) VALUES
(1, 1, 'Kost Melati', 'Jl. Ketintang Madya No. 12, Surabaya', '081234567801', 'WiFi, Dapur bersama, Parkir motor, CCTV', 'kost_melati.jpg', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(2, 1, 'Kost Mawar', 'Jl. Gayungsari Barat No. 5, Surabaya', '081234567802', 'WiFi, Laundry, Parkir motor, Musholla', 'kost_mawar.jpg', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(3, 1, 'Kost Anggrek', 'Jl. Wonokromo Tengah No. 20, Surabaya', '081234567803', 'WiFi, Parkir mobil, Ruang tamu, CCTV', 'kost_anggrek.jpg', '2026-10-07 19:39:04', '2026-10-07 19:39:04');

-- --------------------------------------------------------

--
-- Table structure for table `owner`
--

CREATE TABLE `owner` (
  `id_owner` int(10) UNSIGNED NOT NULL,
  `id_user` int(10) UNSIGNED NOT NULL,
  `nama_owner` varchar(100) NOT NULL,
  `nomor_hp` varchar(20) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `owner`
--

INSERT INTO `owner` (`id_owner`, `id_user`, `nama_owner`, `nomor_hp`, `alamat`, `created_at`, `updated_at`) VALUES
(1, 1, 'Hartono Wijaya', '081234567800', 'Jl. Ketintang Madya No. 10, Surabaya', '2026-10-07 19:39:04', '2026-10-07 19:39:04');

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `id_pembayaran` int(10) UNSIGNED NOT NULL,
  `id_tagihan` int(10) UNSIGNED NOT NULL,
  `tanggal_pembayaran` date NOT NULL,
  `jumlah_bayar` decimal(12,2) NOT NULL,
  `bukti_pembayaran` varchar(255) NOT NULL,
  `status_verifikasi` enum('menunggu','diterima','ditolak') NOT NULL DEFAULT 'menunggu',
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pembayaran`
--

INSERT INTO `pembayaran` (`id_pembayaran`, `id_tagihan`, `tanggal_pembayaran`, `jumlah_bayar`, `bukti_pembayaran`, `status_verifikasi`, `keterangan`, `created_at`, `updated_at`) VALUES
(1, 1, '2026-09-08', 1200000.00, 'bukti_budi_sep2026.jpg', 'diterima', 'Pembayaran sesuai', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(2, 2, '2026-09-09', 1500000.00, 'bukti_siti_sep2026.jpg', 'diterima', 'Pembayaran sesuai', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(3, 3, '2026-10-07', 900000.00, 'bukti_andi_okt2026.jpg', 'menunggu', NULL, '2026-10-07 19:39:04', '2026-10-07 19:39:04');

-- --------------------------------------------------------

--
-- Table structure for table `pengajuan_keluar`
--

CREATE TABLE `pengajuan_keluar` (
  `id_pengajuan` int(10) UNSIGNED NOT NULL,
  `id_penghuni` int(10) UNSIGNED NOT NULL,
  `tanggal_pengajuan` date NOT NULL,
  `tanggal_keluar` date NOT NULL,
  `alasan_keluar` text NOT NULL,
  `status_pengajuan` enum('menunggu','dikonfirmasi','ditolak') NOT NULL DEFAULT 'menunggu',
  `konfirmasi_owner` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pengajuan_keluar`
--

INSERT INTO `pengajuan_keluar` (`id_pengajuan`, `id_penghuni`, `tanggal_pengajuan`, `tanggal_keluar`, `alasan_keluar`, `status_pengajuan`, `konfirmasi_owner`, `created_at`, `updated_at`) VALUES
(1, 4, '2026-08-15', '2026-09-01', 'Pindah kerja ke luar kota.', 'dikonfirmasi', 'Pengajuan disetujui, kunci dikembalikan pada 1 September.', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(2, 3, '2026-10-05', '2026-12-31', 'Lulus kuliah dan kembali ke Jember.', 'menunggu', NULL, '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(3, 2, '2026-10-01', '2026-10-31', 'Ingin pindah ke kost lebih dekat kampus.', 'ditolak', 'Mohon ajukan ulang dengan tanggal keluar minimal 30 hari ke depan.', '2026-10-07 19:39:04', '2026-10-07 19:39:04');

-- --------------------------------------------------------

--
-- Table structure for table `penghuni`
--

CREATE TABLE `penghuni` (
  `id_penghuni` int(10) UNSIGNED NOT NULL,
  `id_user` int(10) UNSIGNED NOT NULL,
  `id_kamar` int(10) UNSIGNED DEFAULT NULL COMMENT 'NULL jika sudah tidak menempati kamar',
  `nama_penghuni` varchar(100) NOT NULL,
  `asal_kota` varchar(100) DEFAULT NULL,
  `nomor_hp` varchar(20) DEFAULT NULL,
  `tanggal_masuk` date NOT NULL,
  `status_penghuni` enum('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `penghuni`
--

INSERT INTO `penghuni` (`id_penghuni`, `id_user`, `id_kamar`, `nama_penghuni`, `asal_kota`, `nomor_hp`, `tanggal_masuk`, `status_penghuni`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 'Budi Santoso', 'Malang', '082111111111', '2026-01-05', 'aktif', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(2, 3, 2, 'Siti Aminah', 'Sidoarjo', '082222222222', '2026-02-10', 'aktif', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(3, 4, 3, 'Andi Pratama', 'Jember', '082333333333', '2026-03-15', 'aktif', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(4, 5, NULL, 'Rina Lestari', 'Madiun', '082444444444', '2025-08-01', 'nonaktif', '2026-10-07 19:39:04', '2026-10-07 19:39:04');

-- --------------------------------------------------------

--
-- Table structure for table `pengumuman`
--

CREATE TABLE `pengumuman` (
  `id_pengumuman` int(10) UNSIGNED NOT NULL,
  `id_owner` int(10) UNSIGNED NOT NULL,
  `judul` varchar(150) NOT NULL,
  `isi_pengumuman` text NOT NULL,
  `tanggal_publish` datetime NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pengumuman`
--

INSERT INTO `pengumuman` (`id_pengumuman`, `id_owner`, `judul`, `isi_pengumuman`, `tanggal_publish`, `created_at`, `updated_at`) VALUES
(1, 1, 'Jadwal Pembayaran Kost', 'Pembayaran kost paling lambat tanggal 10 setiap bulan.', '2026-10-01 08:00:00', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(2, 1, 'Pemeliharaan Air', 'Air akan dimatikan pada Sabtu, 10 Oktober 2026 pukul 09.00-12.00.', '2026-10-05 10:00:00', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(3, 1, 'Tata Tertib Kebersihan', 'Mohon menjaga kebersihan dapur bersama dan membuang sampah pada tempatnya.', '2026-10-06 09:30:00', '2026-10-07 19:39:04', '2026-10-07 19:39:04');

-- --------------------------------------------------------

--
-- Table structure for table `tagihan`
--

CREATE TABLE `tagihan` (
  `id_tagihan` int(10) UNSIGNED NOT NULL,
  `id_penghuni` int(10) UNSIGNED NOT NULL,
  `periode_bulan` date NOT NULL COMMENT 'Isi tanggal 1 pada bulan tagihan',
  `jumlah_tagihan` decimal(12,2) NOT NULL,
  `tanggal_jatuh_tempo` date NOT NULL,
  `status_tagihan` enum('belum_bayar','menunggu_verifikasi','lunas') NOT NULL DEFAULT 'belum_bayar',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tagihan`
--

INSERT INTO `tagihan` (`id_tagihan`, `id_penghuni`, `periode_bulan`, `jumlah_tagihan`, `tanggal_jatuh_tempo`, `status_tagihan`, `created_at`, `updated_at`) VALUES
(1, 1, '2026-09-01', 1200000.00, '2026-09-10', 'lunas', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(2, 2, '2026-09-01', 1500000.00, '2026-09-10', 'lunas', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(3, 3, '2026-10-01', 900000.00, '2026-10-10', 'menunggu_verifikasi', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(4, 1, '2026-10-01', 1200000.00, '2026-10-10', 'belum_bayar', '2026-10-07 19:39:04', '2026-10-07 19:39:04');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id_user` int(10) UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('owner','penghuni') NOT NULL DEFAULT 'penghuni',
  `status_akun` enum('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id_user`, `username`, `password`, `role`, `status_akun`, `created_at`, `updated_at`) VALUES
(1, 'owner', 'owner123', 'owner', 'aktif', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(2, 'budi', 'budi123', 'penghuni', 'aktif', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(3, 'siti', 'siti123', 'penghuni', 'aktif', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(4, 'andi', 'andi123', 'penghuni', 'aktif', '2026-10-07 19:39:04', '2026-10-07 19:39:04'),
(5, 'rina', 'rina123', 'penghuni', 'nonaktif', '2026-10-07 19:39:04', '2026-10-07 19:39:04');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kamar`
--
ALTER TABLE `kamar`
  ADD PRIMARY KEY (`id_kamar`),
  ADD UNIQUE KEY `uq_kamar_kost_nomor` (`id_kost`,`nomor_kamar`);

--
-- Indexes for table `keluhan`
--
ALTER TABLE `keluhan`
  ADD PRIMARY KEY (`id_keluhan`),
  ADD KEY `fk_keluhan_penghuni` (`id_penghuni`);

--
-- Indexes for table `kost`
--
ALTER TABLE `kost`
  ADD PRIMARY KEY (`id_kost`),
  ADD KEY `fk_kost_owner` (`id_owner`);

--
-- Indexes for table `owner`
--
ALTER TABLE `owner`
  ADD PRIMARY KEY (`id_owner`),
  ADD UNIQUE KEY `uq_owner_user` (`id_user`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`id_pembayaran`),
  ADD KEY `fk_pembayaran_tagihan` (`id_tagihan`);

--
-- Indexes for table `pengajuan_keluar`
--
ALTER TABLE `pengajuan_keluar`
  ADD PRIMARY KEY (`id_pengajuan`),
  ADD KEY `fk_pengajuan_penghuni` (`id_penghuni`);

--
-- Indexes for table `penghuni`
--
ALTER TABLE `penghuni`
  ADD PRIMARY KEY (`id_penghuni`),
  ADD UNIQUE KEY `uq_penghuni_user` (`id_user`),
  ADD KEY `fk_penghuni_kamar` (`id_kamar`);

--
-- Indexes for table `pengumuman`
--
ALTER TABLE `pengumuman`
  ADD PRIMARY KEY (`id_pengumuman`),
  ADD KEY `fk_pengumuman_owner` (`id_owner`);

--
-- Indexes for table `tagihan`
--
ALTER TABLE `tagihan`
  ADD PRIMARY KEY (`id_tagihan`),
  ADD UNIQUE KEY `uq_tagihan_penghuni_periode` (`id_penghuni`,`periode_bulan`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `uq_users_username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kamar`
--
ALTER TABLE `kamar`
  MODIFY `id_kamar` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `keluhan`
--
ALTER TABLE `keluhan`
  MODIFY `id_keluhan` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `kost`
--
ALTER TABLE `kost`
  MODIFY `id_kost` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `owner`
--
ALTER TABLE `owner`
  MODIFY `id_owner` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `id_pembayaran` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pengajuan_keluar`
--
ALTER TABLE `pengajuan_keluar`
  MODIFY `id_pengajuan` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `penghuni`
--
ALTER TABLE `penghuni`
  MODIFY `id_penghuni` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `pengumuman`
--
ALTER TABLE `pengumuman`
  MODIFY `id_pengumuman` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tagihan`
--
ALTER TABLE `tagihan`
  MODIFY `id_tagihan` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kamar`
--
ALTER TABLE `kamar`
  ADD CONSTRAINT `fk_kamar_kost` FOREIGN KEY (`id_kost`) REFERENCES `kost` (`id_kost`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `keluhan`
--
ALTER TABLE `keluhan`
  ADD CONSTRAINT `fk_keluhan_penghuni` FOREIGN KEY (`id_penghuni`) REFERENCES `penghuni` (`id_penghuni`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `kost`
--
ALTER TABLE `kost`
  ADD CONSTRAINT `fk_kost_owner` FOREIGN KEY (`id_owner`) REFERENCES `owner` (`id_owner`) ON UPDATE CASCADE;

--
-- Constraints for table `owner`
--
ALTER TABLE `owner`
  ADD CONSTRAINT `fk_owner_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `fk_pembayaran_tagihan` FOREIGN KEY (`id_tagihan`) REFERENCES `tagihan` (`id_tagihan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pengajuan_keluar`
--
ALTER TABLE `pengajuan_keluar`
  ADD CONSTRAINT `fk_pengajuan_penghuni` FOREIGN KEY (`id_penghuni`) REFERENCES `penghuni` (`id_penghuni`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `penghuni`
--
ALTER TABLE `penghuni`
  ADD CONSTRAINT `fk_penghuni_kamar` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_penghuni_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pengumuman`
--
ALTER TABLE `pengumuman`
  ADD CONSTRAINT `fk_pengumuman_owner` FOREIGN KEY (`id_owner`) REFERENCES `owner` (`id_owner`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tagihan`
--
ALTER TABLE `tagihan`
  ADD CONSTRAINT `fk_tagihan_penghuni` FOREIGN KEY (`id_penghuni`) REFERENCES `penghuni` (`id_penghuni`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
