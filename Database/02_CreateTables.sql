-- =============================================
-- Script: Tạo các bảng mảnh tại mỗi Site
-- Mô tả: Tạo cấu trúc bảng DoiBong, CauThu, TranDau, ThamGia tại mỗi site
-- =============================================

-- =============================================
-- SITE A - Tạo các bảng mảnh
-- =============================================
USE SiteA;
GO

-- Bảng DoiBong_A: Lưu các đội bóng có MaDB bắt đầu bằng 'A'
CREATE TABLE DoiBong_A (
    MaDB NVARCHAR(10) PRIMARY KEY,
    TenDB NVARCHAR(100) NOT NULL,
    CLB NVARCHAR(100) NOT NULL
);

-- Bảng CauThu_A: Lưu các cầu thủ thuộc đội bóng của Site A
CREATE TABLE CauThu_A (
    MaCT NVARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    MaDB NVARCHAR(10) NOT NULL,
    FOREIGN KEY (MaDB) REFERENCES DoiBong_A(MaDB)
);

-- Bảng TranDau_A: Lưu các trận đấu có MaDB1 thuộc Site A
CREATE TABLE TranDau_A (
    MaTD NVARCHAR(10) PRIMARY KEY,
    MaDB1 NVARCHAR(10) NOT NULL,
    MaDB2 NVARCHAR(10) NOT NULL,
    TrongTai NVARCHAR(100) NOT NULL,
    SanDau NVARCHAR(100) NOT NULL
);

-- Bảng ThamGia_A: Lưu thông tin tham gia trận đấu của Site A
CREATE TABLE ThamGia_A (
    MaTD NVARCHAR(10) NOT NULL,
    MaCT NVARCHAR(10) NOT NULL,
    SoTrai INT DEFAULT 0,
    PRIMARY KEY (MaTD, MaCT)
);

PRINT N'✓ Đã tạo bảng tại SiteA';
GO

-- =============================================
-- SITE B - Tạo các bảng mảnh
-- =============================================
USE SiteB;
GO

CREATE TABLE DoiBong_B (
    MaDB NVARCHAR(10) PRIMARY KEY,
    TenDB NVARCHAR(100) NOT NULL,
    CLB NVARCHAR(100) NOT NULL
);

CREATE TABLE CauThu_B (
    MaCT NVARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    MaDB NVARCHAR(10) NOT NULL,
    FOREIGN KEY (MaDB) REFERENCES DoiBong_B(MaDB)
);

CREATE TABLE TranDau_B (
    MaTD NVARCHAR(10) PRIMARY KEY,
    MaDB1 NVARCHAR(10) NOT NULL,
    MaDB2 NVARCHAR(10) NOT NULL,
    TrongTai NVARCHAR(100) NOT NULL,
    SanDau NVARCHAR(100) NOT NULL
);

CREATE TABLE ThamGia_B (
    MaTD NVARCHAR(10) NOT NULL,
    MaCT NVARCHAR(10) NOT NULL,
    SoTrai INT DEFAULT 0,
    PRIMARY KEY (MaTD, MaCT)
);

PRINT N'✓ Đã tạo bảng tại SiteB';
GO

-- =============================================
-- SITE C - Tạo các bảng mảnh
-- =============================================
USE SiteC;
GO

CREATE TABLE DoiBong_C (
    MaDB NVARCHAR(10) PRIMARY KEY,
    TenDB NVARCHAR(100) NOT NULL,
    CLB NVARCHAR(100) NOT NULL
);

CREATE TABLE CauThu_C (
    MaCT NVARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    MaDB NVARCHAR(10) NOT NULL,
    FOREIGN KEY (MaDB) REFERENCES DoiBong_C(MaDB)
);

CREATE TABLE TranDau_C (
    MaTD NVARCHAR(10) PRIMARY KEY,
    MaDB1 NVARCHAR(10) NOT NULL,
    MaDB2 NVARCHAR(10) NOT NULL,
    TrongTai NVARCHAR(100) NOT NULL,
    SanDau NVARCHAR(100) NOT NULL
);

CREATE TABLE ThamGia_C (
    MaTD NVARCHAR(10) NOT NULL,
    MaCT NVARCHAR(10) NOT NULL,
    SoTrai INT DEFAULT 0,
    PRIMARY KEY (MaTD, MaCT)
);

PRINT N'✓ Đã tạo bảng tại SiteC';
GO

PRINT N'✓ Hoàn thành tạo tất cả bảng mảnh tại 3 sites';
