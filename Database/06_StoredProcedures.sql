-- =============================================
-- Script: Stored Procedures cho các truy vấn đặc biệt
-- Mô tả: 3 stored procedures tương ứng 3 truy vấn yêu cầu
-- =============================================

USE GlobalDB;
GO

-- =============================================
-- SP 1: Lấy danh sách cầu thủ theo câu lạc bộ
-- =============================================
CREATE PROCEDURE sp_GetCauThuTheoCLB
    @CLB NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT c.MaCT, c.HoTen, d.TenDB, d.CLB
    FROM vw_CauThu c
    INNER JOIN vw_DoiBong d ON c.MaDB = d.MaDB
    WHERE d.CLB = @CLB
    ORDER BY c.HoTen;
END;
GO

-- =============================================
-- SP 2: Đếm số trận cầu thủ đã tham gia
-- =============================================
CREATE PROCEDURE sp_GetSoTranThamGia
    @HoTen NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        c.MaCT,
        c.HoTen,
        COUNT(DISTINCT t.MaTD) AS SoTranThamGia,
        SUM(t.SoTrai) AS TongSoBanThang
    FROM vw_CauThu c
    LEFT JOIN vw_ThamGia t ON c.MaCT = t.MaCT
    WHERE c.HoTen LIKE '%' + @HoTen + '%'
    GROUP BY c.MaCT, c.HoTen;
END;
GO

-- =============================================
-- SP 3: Đếm số trận hòa tại một sân đấu
-- =============================================
CREATE PROCEDURE sp_GetSoTranHoaTaiSan
    @SanDau NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        td.SanDau,
        COUNT(*) AS SoTranHoa
    FROM vw_TranDau td
    WHERE td.SanDau = @SanDau
    AND (
        -- Tổng bàn thắng đội 1
        ISNULL((
            SELECT SUM(t1.SoTrai) 
            FROM vw_ThamGia t1 
            INNER JOIN vw_CauThu c1 ON t1.MaCT = c1.MaCT 
            WHERE t1.MaTD = td.MaTD AND c1.MaDB = td.MaDB1
        ), 0)
        =
        -- Tổng bàn thắng đội 2
        ISNULL((
            SELECT SUM(t2.SoTrai) 
            FROM vw_ThamGia t2 
            INNER JOIN vw_CauThu c2 ON t2.MaCT = c2.MaCT 
            WHERE t2.MaTD = td.MaTD AND c2.MaDB = td.MaDB2
        ), 0)
    )
    GROUP BY td.SanDau;
END;
GO

-- =============================================
-- SP 4: Lấy chi tiết kết quả trận đấu
-- =============================================
CREATE PROCEDURE sp_GetKetQuaTranDau
    @MaTD NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        td.MaTD,
        td.SanDau,
        td.TrongTai,
        db1.TenDB AS DoiNha,
        db2.TenDB AS DoiKhach,
        ISNULL((
            SELECT SUM(t1.SoTrai) 
            FROM vw_ThamGia t1 
            INNER JOIN vw_CauThu c1 ON t1.MaCT = c1.MaCT 
            WHERE t1.MaTD = td.MaTD AND c1.MaDB = td.MaDB1
        ), 0) AS BanThangDoiNha,
        ISNULL((
            SELECT SUM(t2.SoTrai) 
            FROM vw_ThamGia t2 
            INNER JOIN vw_CauThu c2 ON t2.MaCT = c2.MaCT 
            WHERE t2.MaTD = td.MaTD AND c2.MaDB = td.MaDB2
        ), 0) AS BanThangDoiKhach
    FROM vw_TranDau td
    INNER JOIN vw_DoiBong db1 ON td.MaDB1 = db1.MaDB
    INNER JOIN vw_DoiBong db2 ON td.MaDB2 = db2.MaDB
    WHERE td.MaTD = @MaTD;
END;
GO

-- =============================================
-- SP 5: Thống kê cầu thủ ghi bàn nhiều nhất
-- =============================================
CREATE PROCEDURE sp_GetTopGhiBan
    @Top INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@Top)
        c.MaCT,
        c.HoTen,
        d.TenDB,
        d.CLB,
        SUM(t.SoTrai) AS TongBanThang,
        COUNT(DISTINCT t.MaTD) AS SoTranDaThamGia
    FROM vw_CauThu c
    INNER JOIN vw_DoiBong d ON c.MaDB = d.MaDB
    INNER JOIN vw_ThamGia t ON c.MaCT = t.MaCT
    GROUP BY c.MaCT, c.HoTen, d.TenDB, d.CLB
    ORDER BY TongBanThang DESC, SoTranDaThamGia DESC;
END;
GO

PRINT N'✓ Đã tạo thành công 5 stored procedures';
GO

-- =============================================
-- Test các Stored Procedures
-- =============================================
PRINT N'';
PRINT N'========== TEST STORED PROCEDURES ==========';
GO

PRINT N'1. Cầu thủ thuộc Manchester United:';
EXEC sp_GetCauThuTheoCLB @CLB = N'Manchester United';
GO

PRINT N'';
PRINT N'2. Số trận Nguyễn Văn An đã tham gia:';
EXEC sp_GetSoTranThamGia @HoTen = N'Nguyễn Văn An';
GO

PRINT N'';
PRINT N'3. Số trận hòa tại Old Trafford:';
EXEC sp_GetSoTranHoaTaiSan @SanDau = N'Old Trafford';
GO

PRINT N'';
PRINT N'4. Top 5 cầu thủ ghi bàn nhiều nhất:';
EXEC sp_GetTopGhiBan @Top = 5;
GO
