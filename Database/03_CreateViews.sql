-- =============================================
-- Script: Tạo các View toàn cục
-- Mô tả: UNION ALL các bảng mảnh từ 3 sites để tạo view toàn cục
-- =============================================

USE GlobalDB;
GO

-- =============================================
-- View DoiBong - Hợp nhất tất cả đội bóng từ 3 sites
-- =============================================
CREATE VIEW vw_DoiBong AS
    SELECT MaDB, TenDB, CLB FROM SiteA.dbo.DoiBong_A
    UNION ALL
    SELECT MaDB, TenDB, CLB FROM SiteB.dbo.DoiBong_B
    UNION ALL
    SELECT MaDB, TenDB, CLB FROM SiteC.dbo.DoiBong_C;
GO

-- =============================================
-- View CauThu - Hợp nhất tất cả cầu thủ từ 3 sites
-- =============================================
CREATE VIEW vw_CauThu AS
    SELECT MaCT, HoTen, MaDB FROM SiteA.dbo.CauThu_A
    UNION ALL
    SELECT MaCT, HoTen, MaDB FROM SiteB.dbo.CauThu_B
    UNION ALL
    SELECT MaCT, HoTen, MaDB FROM SiteC.dbo.CauThu_C;
GO

-- =============================================
-- View TranDau - Hợp nhất tất cả trận đấu từ 3 sites
-- =============================================
CREATE VIEW vw_TranDau AS
    SELECT MaTD, MaDB1, MaDB2, TrongTai, SanDau FROM SiteA.dbo.TranDau_A
    UNION ALL
    SELECT MaTD, MaDB1, MaDB2, TrongTai, SanDau FROM SiteB.dbo.TranDau_B
    UNION ALL
    SELECT MaTD, MaDB1, MaDB2, TrongTai, SanDau FROM SiteC.dbo.TranDau_C;
GO

-- =============================================
-- View ThamGia - Hợp nhất tất cả thông tin tham gia từ 3 sites
-- =============================================
CREATE VIEW vw_ThamGia AS
    SELECT MaTD, MaCT, SoTrai FROM SiteA.dbo.ThamGia_A
    UNION ALL
    SELECT MaTD, MaCT, SoTrai FROM SiteB.dbo.ThamGia_B
    UNION ALL
    SELECT MaTD, MaCT, SoTrai FROM SiteC.dbo.ThamGia_C;
GO

PRINT N'✓ Đã tạo thành công 4 views toàn cục: vw_DoiBong, vw_CauThu, vw_TranDau, vw_ThamGia';
GO
