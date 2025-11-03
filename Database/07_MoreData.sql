-- =============================================
-- THÊM DỮ LIỆU ĐỘI BÓNG VÀ CẦU THỦ NỔI TIẾNG THẾ GIỚI
-- =============================================

USE GlobalDB;
GO

PRINT N'Bắt đầu thêm dữ liệu đội bóng và cầu thủ thế giới...';
GO

-- =============================================
-- SITE A: THÊM ĐỘI BÓNG ANH & PHÁP
-- =============================================

-- Thêm đội bóng Site A (MaDB, TenDB, CLB)
INSERT INTO vw_DoiBong (MaDB, TenDB, CLB) VALUES
('A004', N'Chelsea U23', N'Chelsea FC'),
('A005', N'Tottenham Hotspur Youth', N'Tottenham Hotspur'),
('A006', N'PSG Academy', N'Paris Saint-Germain');

-- Thêm cầu thủ Chelsea (A004) - MaCT, HoTen, MaDB
INSERT INTO vw_CauThu (MaCT, HoTen, MaDB) VALUES
('CT028', N'Cole Palmer', 'A004'),
('CT029', N'Enzo Fernandez', 'A004'),
('CT030', N'Nicolas Jackson', 'A004'),
('CT031', N'Moises Caicedo', 'A004');

-- Thêm cầu thủ Tottenham (A005)
INSERT INTO vw_CauThu (MaCT, HoTen, MaDB) VALUES
('CT032', N'Son Heung-min', 'A005'),
('CT033', N'James Maddison', 'A005'),
('CT034', N'Dejan Kulusevski', 'A005'),
('CT035', N'Cristian Romero', 'A005');

-- Thêm cầu thủ PSG (A006)
INSERT INTO vw_CauThu (MaCT, HoTen, MaDB) VALUES
('CT036', N'Kylian Mbappe', 'A006'),
('CT037', N'Ousmane Dembele', 'A006'),
('CT038', N'Goncalo Ramos', 'A006'),
('CT039', N'Warren Zaire-Emery', 'A006');

-- =============================================
-- SITE B: THÊM ĐỘI BÓNG TÂY BAN NHA & ĐỨC
-- =============================================

-- Thêm đội bóng Site B
INSERT INTO vw_DoiBong (MaDB, TenDB, CLB) VALUES
('B004', N'Bayern Munich II', N'Bayern Munich'),
('B005', N'Borussia Dortmund U23', N'Borussia Dortmund'),
('B006', N'Sevilla FC Juvenil', N'Sevilla FC');

-- Thêm cầu thủ Bayern Munich (B004)
INSERT INTO vw_CauThu (MaCT, HoTen, MaDB) VALUES
('CT040', N'Jamal Musiala', 'B004'),
('CT041', N'Harry Kane', 'B004'),
('CT042', N'Leroy Sane', 'B004'),
('CT043', N'Joshua Kimmich', 'B004');

-- Thêm cầu thủ Dortmund (B005)
INSERT INTO vw_CauThu (MaCT, HoTen, MaDB) VALUES
('CT044', N'Jude Bellingham', 'B005'),
('CT045', N'Julian Brandt', 'B005'),
('CT046', N'Karim Adeyemi', 'B005'),
('CT047', N'Gio Reyna', 'B005');

-- Thêm cầu thủ Sevilla (B006)
INSERT INTO vw_CauThu (MaCT, HoTen, MaDB) VALUES
('CT048', N'Lucas Ocampos', 'B006'),
('CT049', N'Erik Lamela', 'B006'),
('CT050', N'Youssef En-Nesyri', 'B006'),
('CT051', N'Ivan Rakitic', 'B006');

-- =============================================
-- SITE C: THÊM ĐỘI BÓNG Ý & HÀ LAN
-- =============================================

-- Thêm đội bóng Site C
INSERT INTO vw_DoiBong (MaDB, TenDB, CLB) VALUES
('C004', N'Napoli Primavera', N'SSC Napoli'),
('C005', N'AS Roma Youth', N'AS Roma'),
('C006', N'Ajax Amsterdam Youth', N'AFC Ajax');

-- Thêm cầu thủ Napoli (C004)
INSERT INTO vw_CauThu (MaCT, HoTen, MaDB) VALUES
('CT052', N'Victor Osimhen', 'C004'),
('CT053', N'Khvicha Kvaratskhelia', 'C004'),
('CT054', N'Stanislav Lobotka', 'C004'),
('CT055', N'Giovanni Di Lorenzo', 'C004');

-- Thêm cầu thủ AS Roma (C005)
INSERT INTO vw_CauThu (MaCT, HoTen, MaDB) VALUES
('CT056', N'Paulo Dybala', 'C005'),
('CT057', N'Lorenzo Pellegrini', 'C005'),
('CT058', N'Tammy Abraham', 'C005'),
('CT059', N'Nicolo Zaniolo', 'C005');

-- Thêm cầu thủ Ajax (C006)
INSERT INTO vw_CauThu (MaCT, HoTen, MaDB) VALUES
('CT060', N'Brian Brobbey', 'C006'),
('CT061', N'Steven Bergwijn', 'C006'),
('CT062', N'Kenneth Taylor', 'C006'),
('CT063', N'Jorrel Hato', 'C006');

-- =============================================
-- THÊM TRẬN ĐẤU MỚI
-- =============================================

-- Trận đấu Site A (MaTD, MaDB1, MaDB2, TrongTai, SanDau)
INSERT INTO vw_TranDau (MaTD, MaDB1, MaDB2, TrongTai, SanDau) VALUES
('TD013', 'A004', 'A005', N'Michael Oliver', N'Stamford Bridge'),
('TD014', 'A005', 'A006', N'Anthony Taylor', N'Tottenham Hotspur Stadium'),
('TD015', 'A006', 'A001', N'Clement Turpin', N'Parc des Princes'),
('TD016', 'A002', 'A004', N'Paul Tierney', N'Anfield');

-- Trận đấu Site B
INSERT INTO vw_TranDau (MaTD, MaDB1, MaDB2, TrongTai, SanDau) VALUES
('TD017', 'B004', 'B005', N'Felix Brych', N'Allianz Arena'),
('TD018', 'B005', 'B006', N'Deniz Aytekin', N'Signal Iduna Park'),
('TD019', 'B006', 'B001', N'Antonio Mateu Lahoz', N'Ramon Sanchez Pizjuan'),
('TD020', 'B002', 'B004', N'Carlos del Cerro', N'Santiago Bernabeu');

-- Trận đấu Site C
INSERT INTO vw_TranDau (MaTD, MaDB1, MaDB2, TrongTai, SanDau) VALUES
('TD021', 'C004', 'C005', N'Daniele Orsato', N'Stadio Diego Armando Maradona'),
('TD022', 'C005', 'C006', N'Marco Guida', N'Stadio Olimpico'),
('TD023', 'C006', 'C001', N'Danny Makkelie', N'Johan Cruyff Arena'),
('TD024', 'C002', 'C004', N'Massimiliano Irrati', N'San Siro');

-- =============================================
-- THÊM THÔNG TIN THAM GIA TRẬN ĐẤU
-- =============================================

-- TD013: Chelsea vs Tottenham (MaTD, MaCT, SoTrai)
INSERT INTO vw_ThamGia (MaTD, MaCT, SoTrai) VALUES
('TD013', 'CT028', 1), -- Cole Palmer
('TD013', 'CT029', 0), -- Enzo Fernandez
('TD013', 'CT030', 1), -- Nicolas Jackson
('TD013', 'CT032', 0), -- Son Heung-min
('TD013', 'CT033', 0), -- James Maddison
('TD013', 'CT034', 0); -- Kulusevski

-- TD014: Tottenham vs PSG
INSERT INTO vw_ThamGia (MaTD, MaCT, SoTrai) VALUES
('TD014', 'CT032', 1), -- Son Heung-min
('TD014', 'CT033', 0), -- Maddison
('TD014', 'CT036', 1), -- Mbappe
('TD014', 'CT037', 0); -- Dembele

-- TD015: PSG vs Man Utd
INSERT INTO vw_ThamGia (MaTD, MaCT, SoTrai) VALUES
('TD015', 'CT036', 2), -- Mbappe
('TD015', 'CT038', 1), -- Ramos
('TD015', 'CT001', 0), -- Nguyễn Văn An
('TD015', 'CT002', 0); -- Trần Văn Bình

-- TD017: Bayern vs Dortmund
INSERT INTO vw_ThamGia (MaTD, MaCT, SoTrai) VALUES
('TD017', 'CT040', 1), -- Musiala
('TD017', 'CT041', 2), -- Harry Kane
('TD017', 'CT044', 1), -- Bellingham
('TD017', 'CT046', 0); -- Adeyemi

-- TD018: Dortmund vs Sevilla
INSERT INTO vw_ThamGia (MaTD, MaCT, SoTrai) VALUES
('TD018', 'CT044', 2), -- Bellingham
('TD018', 'CT046', 1), -- Adeyemi
('TD018', 'CT048', 0); -- Ocampos

-- TD021: Napoli vs Roma
INSERT INTO vw_ThamGia (MaTD, MaCT, SoTrai) VALUES
('TD021', 'CT052', 1), -- Osimhen
('TD021', 'CT053', 0), -- Kvaratskhelia
('TD021', 'CT056', 0), -- Dybala
('TD021', 'CT057', 0); -- Pellegrini

-- TD022: Roma vs Ajax
INSERT INTO vw_ThamGia (MaTD, MaCT, SoTrai) VALUES
('TD022', 'CT056', 1), -- Dybala
('TD022', 'CT058', 1), -- Abraham
('TD022', 'CT060', 1), -- Brobbey
('TD022', 'CT061', 0); -- Bergwijn

-- TD023: Ajax vs Juventus
INSERT INTO vw_ThamGia (MaTD, MaCT, SoTrai) VALUES
('TD023', 'CT060', 2), -- Brobbey
('TD023', 'CT061', 1), -- Bergwijn
('TD023', 'CT019', 0); -- Paulo Dybala (Juventus)

GO

-- =============================================
-- KIỂM TRA DỮ LIỆU MỚI
-- =============================================

PRINT N'';
PRINT N'========== KIỂM TRA DỮ LIỆU MỚI ==========';
GO

PRINT N'Tổng số đội bóng:';
SELECT COUNT(*) as TongSoDoiBong FROM vw_DoiBong;
GO

PRINT N'Tổng số cầu thủ:';
SELECT COUNT(*) as TongSoCauThu FROM vw_CauThu;
GO

PRINT N'Tổng số trận đấu:';
SELECT COUNT(*) as TongSoTranDau FROM vw_TranDau;
GO

PRINT N'Phân bổ đội bóng theo Site:';
SELECT 
    CASE 
        WHEN MaDB LIKE 'A%' THEN 'Site A'
        WHEN MaDB LIKE 'B%' THEN 'Site B'
        WHEN MaDB LIKE 'C%' THEN 'Site C'
    END AS Site,
    COUNT(*) as SoDoiBong
FROM vw_DoiBong
GROUP BY CASE 
    WHEN MaDB LIKE 'A%' THEN 'Site A'
    WHEN MaDB LIKE 'B%' THEN 'Site B'
    WHEN MaDB LIKE 'C%' THEN 'Site C'
END;
GO

PRINT N'Phân bổ cầu thủ theo Site:';
SELECT 
    CASE 
        WHEN MaDB LIKE 'A%' THEN 'Site A'
        WHEN MaDB LIKE 'B%' THEN 'Site B'
        WHEN MaDB LIKE 'C%' THEN 'Site C'
    END AS Site,
    COUNT(*) as SoCauThu
FROM vw_CauThu
GROUP BY CASE 
    WHEN MaDB LIKE 'A%' THEN 'Site A'
    WHEN MaDB LIKE 'B%' THEN 'Site B'
    WHEN MaDB LIKE 'C%' THEN 'Site C'
END;
GO

PRINT N'Danh sách các đội bóng mới:';
SELECT MaDB, TenDB, CLB 
FROM vw_DoiBong 
WHERE MaDB IN ('A004','A005','A006','B004','B005','B006','C004','C005','C006')
ORDER BY MaDB;
GO

PRINT N'';
PRINT N'✅ Đã thêm thành công:';
PRINT N'   - 9 đội bóng mới (Chelsea, Tottenham, PSG, Bayern, Dortmund, Sevilla, Napoli, Roma, Ajax)';
PRINT N'   - 36 cầu thủ nổi tiếng (Mbappe, Kane, Son, Bellingham, Osimhen, Dybala, v.v.)';
PRINT N'   - 12 trận đấu mới';
PRINT N'   - Nhiều bản ghi tham gia trận đấu';
GO
