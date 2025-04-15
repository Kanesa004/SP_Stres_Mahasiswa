-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 15 Apr 2025 pada 15.54
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `stresmahasiswa`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `diagnosa`
--

CREATE TABLE `diagnosa` (
  `idDiagnosa` varchar(5) NOT NULL,
  `Nama_Diagnosa` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `diagnosa`
--

INSERT INTO `diagnosa` (`idDiagnosa`, `Nama_Diagnosa`) VALUES
('S01', 'Stres Ringan'),
('S02', 'Stres Sedang'),
('S03', 'Stres Berat');

-- --------------------------------------------------------

--
-- Struktur dari tabel `gejala`
--

CREATE TABLE `gejala` (
  `idGejala` varchar(5) NOT NULL,
  `Nama_Gejala` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `gejala`
--

INSERT INTO `gejala` (`idGejala`, `Nama_Gejala`) VALUES
('G01', 'Sulit berkonsentrasi saat belajar'),
('G010', 'Sering merasa putus asa atau pesimis'),
('G011', 'Sulit mengontrol emosi dan sering menangis ta'),
('G012', 'Menghindari interaksi sosial atau menarik dir'),
('G013', 'Sering merasa tegang dan sulit rileks'),
('G014', 'Mengalami gangguan pencernaan seperti sakit p'),
('G015', 'Tidak menikmati aktivitas yang biasanya menye'),
('G02', 'Merasa cemas berlebihan tanpa alasan jelas'),
('G03', 'Kesulitan tidur atau mengalami insomnia'),
('G04', 'Mudah marah atau tersinggung'),
('G05', 'Kehilangan motivasi dalam belajar atau aktivi'),
('G06', 'Sering merasa lelah meskipun tidak melakukan '),
('G07', 'Jantung sering berdebar tanpa sebab yang jela'),
('G08', 'Sering mengalami sakit kepala atau nyeri otot'),
('G09', 'Mengalami perubahan nafsu makan (meningkat at');

-- --------------------------------------------------------

--
-- Struktur dari tabel `gejala_has_laporan`
--

CREATE TABLE `gejala_has_laporan` (
  `Gejala_idGejala` varchar(5) NOT NULL,
  `Laporan_idLaporan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `gejala_has_laporan`
--

INSERT INTO `gejala_has_laporan` (`Gejala_idGejala`, `Laporan_idLaporan`) VALUES
('G01', 1),
('G010', 1),
('G010', 2),
('G011', 1),
('G03', 2),
('G04', 2),
('G05', 2);

-- --------------------------------------------------------

--
-- Struktur dari tabel `laporan`
--

CREATE TABLE `laporan` (
  `idLaporan` int(11) NOT NULL,
  `Mahasiswa_idMahasiswa` int(11) NOT NULL,
  `Tanggal` datetime DEFAULT NULL,
  `Diagnosa_idDiagnosa` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `laporan`
--

INSERT INTO `laporan` (`idLaporan`, `Mahasiswa_idMahasiswa`, `Tanggal`, `Diagnosa_idDiagnosa`) VALUES
(1, 1, '2025-04-14 23:46:30', 'S01'),
(2, 2, '2025-04-14 23:47:16', 'S02');

-- --------------------------------------------------------

--
-- Struktur dari tabel `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `idMahasiswa` int(11) NOT NULL,
  `Nama` varchar(45) DEFAULT NULL,
  `Kelas` varchar(45) DEFAULT NULL,
  `Jurusan` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data untuk tabel `mahasiswa`
--

INSERT INTO `mahasiswa` (`idMahasiswa`, `Nama`, `Kelas`, `Jurusan`) VALUES
(1, 'Kanesa', '3B', 'TI'),
(2, 'Khanza', '3B', 'TI');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `diagnosa`
--
ALTER TABLE `diagnosa`
  ADD PRIMARY KEY (`idDiagnosa`);

--
-- Indeks untuk tabel `gejala`
--
ALTER TABLE `gejala`
  ADD PRIMARY KEY (`idGejala`);

--
-- Indeks untuk tabel `gejala_has_laporan`
--
ALTER TABLE `gejala_has_laporan`
  ADD PRIMARY KEY (`Gejala_idGejala`,`Laporan_idLaporan`),
  ADD KEY `fk_Gejala_has_Laporan_Laporan1` (`Laporan_idLaporan`),
  ADD KEY `fk_Gejala_has_Laporan_Gejala1` (`Gejala_idGejala`);

--
-- Indeks untuk tabel `laporan`
--
ALTER TABLE `laporan`
  ADD PRIMARY KEY (`idLaporan`,`Mahasiswa_idMahasiswa`,`Diagnosa_idDiagnosa`),
  ADD KEY `fk_Laporan_Mahasiswa` (`Mahasiswa_idMahasiswa`),
  ADD KEY `fk_Laporan_Diagnosa1` (`Diagnosa_idDiagnosa`);

--
-- Indeks untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`idMahasiswa`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `laporan`
--
ALTER TABLE `laporan`
  MODIFY `idLaporan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  MODIFY `idMahasiswa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `gejala_has_laporan`
--
ALTER TABLE `gejala_has_laporan`
  ADD CONSTRAINT `fk_Gejala_has_Laporan_Gejala1` FOREIGN KEY (`Gejala_idGejala`) REFERENCES `gejala` (`idGejala`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Gejala_has_Laporan_Laporan1` FOREIGN KEY (`Laporan_idLaporan`) REFERENCES `laporan` (`idLaporan`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Ketidakleluasaan untuk tabel `laporan`
--
ALTER TABLE `laporan`
  ADD CONSTRAINT `fk_Laporan_Diagnosa1` FOREIGN KEY (`Diagnosa_idDiagnosa`) REFERENCES `diagnosa` (`idDiagnosa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Laporan_Mahasiswa` FOREIGN KEY (`Mahasiswa_idMahasiswa`) REFERENCES `mahasiswa` (`idMahasiswa`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
