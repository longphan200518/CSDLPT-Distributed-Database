-- =============================================
-- MASTER SCRIPT: Chạy tất cả scripts thiết lập database
-- Sử dụng: Mở file này trong SSMS và Execute (F5)
-- =============================================

PRINT N'';
PRINT N'╔═══════════════════════════════════════════════════════════╗';
PRINT N'║   HỆ THỐNG QUẢN LÝ ĐỘI BÓNG - CSDL PHÂN TÁN             ║';
PRINT N'║   Đồ án môn học: Cơ sở dữ liệu phân tán                  ║';
PRINT N'╚═══════════════════════════════════════════════════════════╝';
PRINT N'';

-- =============================================
-- BƯỚC 1: TẠO DATABASES
-- =============================================
PRINT N'[1/6] Đang tạo databases...';
GO

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SiteA')
    DROP DATABASE SiteA;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SiteB')
    DROP DATABASE SiteB;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SiteC')
    DROP DATABASE SiteC;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'GlobalDB')
    DROP DATABASE GlobalDB;
GO

CREATE DATABASE SiteA;
CREATE DATABASE SiteB;
CREATE DATABASE SiteC;
CREATE DATABASE GlobalDB;
GO

PRINT N'✓ Đã tạo 4 databases';
PRINT N'';
GO

-- =============================================
-- BƯỚC 2: TẠO BẢNG MẢNH
-- =============================================
PRINT N'[2/6] Đang tạo bảng mảnh tại các sites...';
GO

-- Site A
USE SiteA;
GO
CREATE TABLE DoiBong_A (MaDB NVARCHAR(10) PRIMARY KEY, TenDB NVARCHAR(100) NOT NULL, CLB NVARCHAR(100) NOT NULL);
CREATE TABLE CauThu_A (MaCT NVARCHAR(10) PRIMARY KEY, HoTen NVARCHAR(100) NOT NULL, MaDB NVARCHAR(10) NOT NULL, FOREIGN KEY (MaDB) REFERENCES DoiBong_A(MaDB));
CREATE TABLE TranDau_A (MaTD NVARCHAR(10) PRIMARY KEY, MaDB1 NVARCHAR(10) NOT NULL, MaDB2 NVARCHAR(10) NOT NULL, TrongTai NVARCHAR(100) NOT NULL, SanDau NVARCHAR(100) NOT NULL);
CREATE TABLE ThamGia_A (MaTD NVARCHAR(10) NOT NULL, MaCT NVARCHAR(10) NOT NULL, SoTrai INT DEFAULT 0, PRIMARY KEY (MaTD, MaCT));
GO

-- Site B
USE SiteB;
GO
CREATE TABLE DoiBong_B (MaDB NVARCHAR(10) PRIMARY KEY, TenDB NVARCHAR(100) NOT NULL, CLB NVARCHAR(100) NOT NULL);
CREATE TABLE CauThu_B (MaCT NVARCHAR(10) PRIMARY KEY, HoTen NVARCHAR(100) NOT NULL, MaDB NVARCHAR(10) NOT NULL, FOREIGN KEY (MaDB) REFERENCES DoiBong_B(MaDB));
CREATE TABLE TranDau_B (MaTD NVARCHAR(10) PRIMARY KEY, MaDB1 NVARCHAR(10) NOT NULL, MaDB2 NVARCHAR(10) NOT NULL, TrongTai NVARCHAR(100) NOT NULL, SanDau NVARCHAR(100) NOT NULL);
CREATE TABLE ThamGia_B (MaTD NVARCHAR(10) NOT NULL, MaCT NVARCHAR(10) NOT NULL, SoTrai INT DEFAULT 0, PRIMARY KEY (MaTD, MaCT));
GO

-- Site C
USE SiteC;
GO
CREATE TABLE DoiBong_C (MaDB NVARCHAR(10) PRIMARY KEY, TenDB NVARCHAR(100) NOT NULL, CLB NVARCHAR(100) NOT NULL);
CREATE TABLE CauThu_C (MaCT NVARCHAR(10) PRIMARY KEY, HoTen NVARCHAR(100) NOT NULL, MaDB NVARCHAR(10) NOT NULL, FOREIGN KEY (MaDB) REFERENCES DoiBong_C(MaDB));
CREATE TABLE TranDau_C (MaTD NVARCHAR(10) PRIMARY KEY, MaDB1 NVARCHAR(10) NOT NULL, MaDB2 NVARCHAR(10) NOT NULL, TrongTai NVARCHAR(100) NOT NULL, SanDau NVARCHAR(100) NOT NULL);
CREATE TABLE ThamGia_C (MaTD NVARCHAR(10) NOT NULL, MaCT NVARCHAR(10) NOT NULL, SoTrai INT DEFAULT 0, PRIMARY KEY (MaTD, MaCT));
GO

PRINT N'✓ Đã tạo bảng tại 3 sites';
PRINT N'';
GO

-- =============================================
-- BƯỚC 3: TẠO VIEWS TOÀN CỤC
-- =============================================
PRINT N'[3/6] Đang tạo views toàn cục...';
GO

USE GlobalDB;
GO

CREATE VIEW vw_DoiBong AS
    SELECT MaDB, TenDB, CLB FROM SiteA.dbo.DoiBong_A
    UNION ALL
    SELECT MaDB, TenDB, CLB FROM SiteB.dbo.DoiBong_B
    UNION ALL
    SELECT MaDB, TenDB, CLB FROM SiteC.dbo.DoiBong_C;
GO

CREATE VIEW vw_CauThu AS
    SELECT MaCT, HoTen, MaDB FROM SiteA.dbo.CauThu_A
    UNION ALL
    SELECT MaCT, HoTen, MaDB FROM SiteB.dbo.CauThu_B
    UNION ALL
    SELECT MaCT, HoTen, MaDB FROM SiteC.dbo.CauThu_C;
GO

CREATE VIEW vw_TranDau AS
    SELECT MaTD, MaDB1, MaDB2, TrongTai, SanDau FROM SiteA.dbo.TranDau_A
    UNION ALL
    SELECT MaTD, MaDB1, MaDB2, TrongTai, SanDau FROM SiteB.dbo.TranDau_B
    UNION ALL
    SELECT MaTD, MaDB1, MaDB2, TrongTai, SanDau FROM SiteC.dbo.TranDau_C;
GO

CREATE VIEW vw_ThamGia AS
    SELECT MaTD, MaCT, SoTrai FROM SiteA.dbo.ThamGia_A
    UNION ALL
    SELECT MaTD, MaCT, SoTrai FROM SiteB.dbo.ThamGia_B
    UNION ALL
    SELECT MaTD, MaCT, SoTrai FROM SiteC.dbo.ThamGia_C;
GO

PRINT N'✓ Đã tạo 4 views toàn cục';
PRINT N'';
GO

-- =============================================
-- BƯỚC 4: TẠO TRIGGERS (chỉ tạo trigger quan trọng nhất)
-- =============================================
PRINT N'[4/6] Đang tạo triggers...';
PRINT N'Lưu ý: Chỉ tạo trigger INSERT. Vui lòng chạy file 04_CreateTriggers.sql để có đầy đủ triggers.';
GO

-- Trigger INSERT cho DoiBong
CREATE TRIGGER trg_DoiBong_Insert ON vw_DoiBong INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO SiteA.dbo.DoiBong_A SELECT MaDB, TenDB, CLB FROM inserted WHERE MaDB LIKE 'A%';
    INSERT INTO SiteB.dbo.DoiBong_B SELECT MaDB, TenDB, CLB FROM inserted WHERE MaDB LIKE 'B%';
    INSERT INTO SiteC.dbo.DoiBong_C SELECT MaDB, TenDB, CLB FROM inserted WHERE MaDB LIKE 'C%';
END;
GO

PRINT N'✓ Đã tạo trigger INSERT cho DoiBong';
PRINT N'⚠ Chưa có trigger UPDATE/DELETE. Chạy file 04_CreateTriggers.sql để tạo đầy đủ.';
PRINT N'';
GO

-- =============================================
-- BƯỚC 5: CHÈN DỮ LIỆU MẪU
-- =============================================
PRINT N'[5/6] Đang chèn dữ liệu mẫu...';
GO

-- Đội bóng
INSERT INTO vw_DoiBong VALUES
('A001', N'Manchester United U23', N'Manchester United'),
('A002', N'Arsenal U23', N'Arsenal'),
('A003', N'Liverpool Youth', N'Liverpool'),
('B001', N'Barcelona B', N'Barcelona'),
('B002', N'Real Madrid Castilla', N'Real Madrid'),
('B003', N'Bayern Munich II', N'Bayern Munich'),
('C001', N'Juventus Primavera', N'Juventus'),
('C002', N'AC Milan Youth', N'AC Milan'),
('C003', N'Inter Milan U23', N'Inter Milan');
GO

PRINT N'✓ Đã chèn 9 đội bóng';
PRINT N'⚠ Dữ liệu cầu thủ, trận đấu chưa được chèn.';
PRINT N'  Chạy file 05_SampleData.sql để chèn đầy đủ dữ liệu mẫu.';
PRINT N'';
GO

-- =============================================
-- BƯỚC 6: TẠO STORED PROCEDURES
-- =============================================
PRINT N'[6/6] Đang tạo stored procedures...';
GO

CREATE PROCEDURE sp_GetCauThuTheoCLB @CLB NVARCHAR(100)
AS
BEGIN
    SELECT c.MaCT, c.HoTen, d.TenDB, d.CLB
    FROM vw_CauThu c
    INNER JOIN vw_DoiBong d ON c.MaDB = d.MaDB
    WHERE d.CLB = @CLB
    ORDER BY c.HoTen;
END;
GO

PRINT N'✓ Đã tạo stored procedure sp_GetCauThuTheoCLB';
PRINT N'⚠ Chưa có đầy đủ stored procedures.';
PRINT N'  Chạy file 06_StoredProcedures.sql để tạo đầy đủ.';
PRINT N'';
GO

-- =============================================
-- KIỂM TRA KẾT QUẢ
-- =============================================
PRINT N'';
PRINT N'╔═══════════════════════════════════════════════════════════╗';
PRINT N'║               HOÀN THÀNH THIẾT LẬP CƠ BẢN                ║';
PRINT N'╚═══════════════════════════════════════════════════════════╝';
PRINT N'';
PRINT N'📊 THỐNG KÊ:';
PRINT N'  - Databases: ' + CAST((SELECT COUNT(*) FROM sys.databases WHERE name IN ('SiteA','SiteB','SiteC','GlobalDB')) AS NVARCHAR);
PRINT N'  - Đội bóng: ' + CAST((SELECT COUNT(*) FROM vw_DoiBong) AS NVARCHAR);
PRINT N'';
PRINT N'⚠ LƯU Ý:';
PRINT N'  Đây chỉ là setup cơ bản. Để có đầy đủ chức năng:';
PRINT N'  1. Chạy file 04_CreateTriggers.sql (Tạo trigger UPDATE/DELETE)';
PRINT N'  2. Chạy file 05_SampleData.sql (Thêm dữ liệu cầu thủ, trận đấu)';
PRINT N'  3. Chạy file 06_StoredProcedures.sql (Tạo đầy đủ SP)';
PRINT N'';
PRINT N'✅ Bạn có thể bắt đầu chạy ứng dụng Windows Forms ngay bây giờ!';
PRINT N'';
GO
