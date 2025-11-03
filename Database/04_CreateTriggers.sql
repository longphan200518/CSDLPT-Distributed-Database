-- =============================================
-- Script: Tạo các INSTEAD OF Trigger
-- Mô tả: Xử lý INSERT, UPDATE, DELETE trên view toàn cục
--        và định tuyến đến site phù hợp
-- =============================================

USE GlobalDB;
GO

-- =============================================
-- TRIGGER cho vw_DoiBong
-- =============================================

-- Trigger INSERT cho DoiBong
CREATE TRIGGER trg_DoiBong_Insert
ON vw_DoiBong
INSTEAD OF INSERT
AS
BEGIN
    -- Chèn vào Site A nếu MaDB bắt đầu bằng 'A'
    INSERT INTO SiteA.dbo.DoiBong_A (MaDB, TenDB, CLB)
    SELECT MaDB, TenDB, CLB
    FROM inserted
    WHERE MaDB LIKE 'A%';

    -- Chèn vào Site B nếu MaDB bắt đầu bằng 'B'
    INSERT INTO SiteB.dbo.DoiBong_B (MaDB, TenDB, CLB)
    SELECT MaDB, TenDB, CLB
    FROM inserted
    WHERE MaDB LIKE 'B%';

    -- Chèn vào Site C nếu MaDB bắt đầu bằng 'C'
    INSERT INTO SiteC.dbo.DoiBong_C (MaDB, TenDB, CLB)
    SELECT MaDB, TenDB, CLB
    FROM inserted
    WHERE MaDB LIKE 'C%';
END;
GO

-- Trigger UPDATE cho DoiBong
CREATE TRIGGER trg_DoiBong_Update
ON vw_DoiBong
INSTEAD OF UPDATE
AS
BEGIN
    -- Update Site A
    UPDATE SiteA.dbo.DoiBong_A
    SET TenDB = i.TenDB, CLB = i.CLB
    FROM SiteA.dbo.DoiBong_A db
    INNER JOIN inserted i ON db.MaDB = i.MaDB
    WHERE db.MaDB LIKE 'A%';

    -- Update Site B
    UPDATE SiteB.dbo.DoiBong_B
    SET TenDB = i.TenDB, CLB = i.CLB
    FROM SiteB.dbo.DoiBong_B db
    INNER JOIN inserted i ON db.MaDB = i.MaDB
    WHERE db.MaDB LIKE 'B%';

    -- Update Site C
    UPDATE SiteC.dbo.DoiBong_C
    SET TenDB = i.TenDB, CLB = i.CLB
    FROM SiteC.dbo.DoiBong_C db
    INNER JOIN inserted i ON db.MaDB = i.MaDB
    WHERE db.MaDB LIKE 'C%';
END;
GO

-- Trigger DELETE cho DoiBong
CREATE TRIGGER trg_DoiBong_Delete
ON vw_DoiBong
INSTEAD OF DELETE
AS
BEGIN
    -- Delete từ Site A
    DELETE FROM SiteA.dbo.DoiBong_A
    WHERE MaDB IN (SELECT MaDB FROM deleted WHERE MaDB LIKE 'A%');

    -- Delete từ Site B
    DELETE FROM SiteB.dbo.DoiBong_B
    WHERE MaDB IN (SELECT MaDB FROM deleted WHERE MaDB LIKE 'B%');

    -- Delete từ Site C
    DELETE FROM SiteC.dbo.DoiBong_C
    WHERE MaDB IN (SELECT MaDB FROM deleted WHERE MaDB LIKE 'C%');
END;
GO

-- =============================================
-- TRIGGER cho vw_CauThu
-- =============================================

-- Trigger INSERT cho CauThu
CREATE TRIGGER trg_CauThu_Insert
ON vw_CauThu
INSTEAD OF INSERT
AS
BEGIN
    -- Chèn vào Site A nếu MaDB thuộc Site A
    INSERT INTO SiteA.dbo.CauThu_A (MaCT, HoTen, MaDB)
    SELECT MaCT, HoTen, MaDB
    FROM inserted
    WHERE MaDB LIKE 'A%';

    -- Chèn vào Site B nếu MaDB thuộc Site B
    INSERT INTO SiteB.dbo.CauThu_B (MaCT, HoTen, MaDB)
    SELECT MaCT, HoTen, MaDB
    FROM inserted
    WHERE MaDB LIKE 'B%';

    -- Chèn vào Site C nếu MaDB thuộc Site C
    INSERT INTO SiteC.dbo.CauThu_C (MaCT, HoTen, MaDB)
    SELECT MaCT, HoTen, MaDB
    FROM inserted
    WHERE MaDB LIKE 'C%';
END;
GO

-- Trigger UPDATE cho CauThu
CREATE TRIGGER trg_CauThu_Update
ON vw_CauThu
INSTEAD OF UPDATE
AS
BEGIN
    -- Update Site A
    UPDATE SiteA.dbo.CauThu_A
    SET HoTen = i.HoTen, MaDB = i.MaDB
    FROM SiteA.dbo.CauThu_A ct
    INNER JOIN inserted i ON ct.MaCT = i.MaCT
    WHERE ct.MaDB LIKE 'A%' OR i.MaDB LIKE 'A%';

    -- Update Site B
    UPDATE SiteB.dbo.CauThu_B
    SET HoTen = i.HoTen, MaDB = i.MaDB
    FROM SiteB.dbo.CauThu_B ct
    INNER JOIN inserted i ON ct.MaCT = i.MaCT
    WHERE ct.MaDB LIKE 'B%' OR i.MaDB LIKE 'B%';

    -- Update Site C
    UPDATE SiteC.dbo.CauThu_C
    SET HoTen = i.HoTen, MaDB = i.MaDB
    FROM SiteC.dbo.CauThu_C ct
    INNER JOIN inserted i ON ct.MaCT = i.MaCT
    WHERE ct.MaDB LIKE 'C%' OR i.MaDB LIKE 'C%';
END;
GO

-- Trigger DELETE cho CauThu
CREATE TRIGGER trg_CauThu_Delete
ON vw_CauThu
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM SiteA.dbo.CauThu_A
    WHERE MaCT IN (SELECT MaCT FROM deleted WHERE MaDB LIKE 'A%');

    DELETE FROM SiteB.dbo.CauThu_B
    WHERE MaCT IN (SELECT MaCT FROM deleted WHERE MaDB LIKE 'B%');

    DELETE FROM SiteC.dbo.CauThu_C
    WHERE MaCT IN (SELECT MaCT FROM deleted WHERE MaDB LIKE 'C%');
END;
GO

-- =============================================
-- TRIGGER cho vw_TranDau
-- =============================================

-- Trigger INSERT cho TranDau
CREATE TRIGGER trg_TranDau_Insert
ON vw_TranDau
INSTEAD OF INSERT
AS
BEGIN
    -- Định tuyến dựa vào MaDB1 (đội chủ nhà)
    INSERT INTO SiteA.dbo.TranDau_A (MaTD, MaDB1, MaDB2, TrongTai, SanDau)
    SELECT MaTD, MaDB1, MaDB2, TrongTai, SanDau
    FROM inserted
    WHERE MaDB1 LIKE 'A%';

    INSERT INTO SiteB.dbo.TranDau_B (MaTD, MaDB1, MaDB2, TrongTai, SanDau)
    SELECT MaTD, MaDB1, MaDB2, TrongTai, SanDau
    FROM inserted
    WHERE MaDB1 LIKE 'B%';

    INSERT INTO SiteC.dbo.TranDau_C (MaTD, MaDB1, MaDB2, TrongTai, SanDau)
    SELECT MaTD, MaDB1, MaDB2, TrongTai, SanDau
    FROM inserted
    WHERE MaDB1 LIKE 'C%';
END;
GO

-- Trigger UPDATE cho TranDau
CREATE TRIGGER trg_TranDau_Update
ON vw_TranDau
INSTEAD OF UPDATE
AS
BEGIN
    UPDATE SiteA.dbo.TranDau_A
    SET MaDB1 = i.MaDB1, MaDB2 = i.MaDB2, TrongTai = i.TrongTai, SanDau = i.SanDau
    FROM SiteA.dbo.TranDau_A td
    INNER JOIN inserted i ON td.MaTD = i.MaTD
    WHERE td.MaDB1 LIKE 'A%';

    UPDATE SiteB.dbo.TranDau_B
    SET MaDB1 = i.MaDB1, MaDB2 = i.MaDB2, TrongTai = i.TrongTai, SanDau = i.SanDau
    FROM SiteB.dbo.TranDau_B td
    INNER JOIN inserted i ON td.MaTD = i.MaTD
    WHERE td.MaDB1 LIKE 'B%';

    UPDATE SiteC.dbo.TranDau_C
    SET MaDB1 = i.MaDB1, MaDB2 = i.MaDB2, TrongTai = i.TrongTai, SanDau = i.SanDau
    FROM SiteC.dbo.TranDau_C td
    INNER JOIN inserted i ON td.MaTD = i.MaTD
    WHERE td.MaDB1 LIKE 'C%';
END;
GO

-- Trigger DELETE cho TranDau
CREATE TRIGGER trg_TranDau_Delete
ON vw_TranDau
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM SiteA.dbo.TranDau_A
    WHERE MaTD IN (SELECT MaTD FROM deleted WHERE MaDB1 LIKE 'A%');

    DELETE FROM SiteB.dbo.TranDau_B
    WHERE MaTD IN (SELECT MaTD FROM deleted WHERE MaDB1 LIKE 'B%');

    DELETE FROM SiteC.dbo.TranDau_C
    WHERE MaTD IN (SELECT MaTD FROM deleted WHERE MaDB1 LIKE 'C%');
END;
GO

-- =============================================
-- TRIGGER cho vw_ThamGia
-- =============================================

-- Trigger INSERT cho ThamGia
CREATE TRIGGER trg_ThamGia_Insert
ON vw_ThamGia
INSTEAD OF INSERT
AS
BEGIN
    -- Định tuyến dựa vào MaTD (thuộc site nào)
    INSERT INTO SiteA.dbo.ThamGia_A (MaTD, MaCT, SoTrai)
    SELECT i.MaTD, i.MaCT, i.SoTrai
    FROM inserted i
    WHERE EXISTS (SELECT 1 FROM SiteA.dbo.TranDau_A WHERE MaTD = i.MaTD);

    INSERT INTO SiteB.dbo.ThamGia_B (MaTD, MaCT, SoTrai)
    SELECT i.MaTD, i.MaCT, i.SoTrai
    FROM inserted i
    WHERE EXISTS (SELECT 1 FROM SiteB.dbo.TranDau_B WHERE MaTD = i.MaTD);

    INSERT INTO SiteC.dbo.ThamGia_C (MaTD, MaCT, SoTrai)
    SELECT i.MaTD, i.MaCT, i.SoTrai
    FROM inserted i
    WHERE EXISTS (SELECT 1 FROM SiteC.dbo.TranDau_C WHERE MaTD = i.MaTD);
END;
GO

-- Trigger UPDATE cho ThamGia
CREATE TRIGGER trg_ThamGia_Update
ON vw_ThamGia
INSTEAD OF UPDATE
AS
BEGIN
    UPDATE SiteA.dbo.ThamGia_A
    SET SoTrai = i.SoTrai
    FROM SiteA.dbo.ThamGia_A tg
    INNER JOIN inserted i ON tg.MaTD = i.MaTD AND tg.MaCT = i.MaCT;

    UPDATE SiteB.dbo.ThamGia_B
    SET SoTrai = i.SoTrai
    FROM SiteB.dbo.ThamGia_B tg
    INNER JOIN inserted i ON tg.MaTD = i.MaTD AND tg.MaCT = i.MaCT;

    UPDATE SiteC.dbo.ThamGia_C
    SET SoTrai = i.SoTrai
    FROM SiteC.dbo.ThamGia_C tg
    INNER JOIN inserted i ON tg.MaTD = i.MaTD AND tg.MaCT = i.MaCT;
END;
GO

-- Trigger DELETE cho ThamGia
CREATE TRIGGER trg_ThamGia_Delete
ON vw_ThamGia
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM SiteA.dbo.ThamGia_A
    WHERE EXISTS (
        SELECT 1 FROM deleted d 
        WHERE SiteA.dbo.ThamGia_A.MaTD = d.MaTD 
        AND SiteA.dbo.ThamGia_A.MaCT = d.MaCT
    );

    DELETE FROM SiteB.dbo.ThamGia_B
    WHERE EXISTS (
        SELECT 1 FROM deleted d 
        WHERE SiteB.dbo.ThamGia_B.MaTD = d.MaTD 
        AND SiteB.dbo.ThamGia_B.MaCT = d.MaCT
    );

    DELETE FROM SiteC.dbo.ThamGia_C
    WHERE EXISTS (
        SELECT 1 FROM deleted d 
        WHERE SiteC.dbo.ThamGia_C.MaTD = d.MaTD 
        AND SiteC.dbo.ThamGia_C.MaCT = d.MaCT
    );
END;
GO

PRINT N'✓ Đã tạo thành công tất cả triggers cho 4 views';
GO
