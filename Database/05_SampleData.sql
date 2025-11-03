-- =============================================
-- Script: Dữ liệu mẫu cho hệ thống
-- Mô tả: Thêm dữ liệu test vào các bảng thông qua view toàn cục
-- =============================================

USE GlobalDB;
GO

PRINT N'Bắt đầu chèn dữ liệu mẫu...';
GO

-- =============================================
-- Chèn dữ liệu vào DoiBong
-- =============================================
INSERT INTO vw_DoiBong (MaDB, TenDB, CLB) VALUES
('A001', N'Manchester United U23', N'Manchester United'),
('A002', N'Arsenal U23', N'Arsenal'),
('A003', N'Liverpool Youth', N'Liverpool'),
('B001', N'Barcelona B', N'Barcelona'),
('B002', N'Real Madrid Castilla', N'Real Madrid'),
('B003', N'Bayern Munich II', N'Bayern Munich'),
('C001', N'Juventus Primavera', N'Juventus'),
('C002', N'AC Milan Youth', N'AC Milan'),
('C003', N'Inter Milan U23', N'Inter Milan');

PRINT N'✓ Đã chèn 9 đội bóng';
GO

-- =============================================
-- Chèn dữ liệu vào CauThu
-- =============================================
INSERT INTO vw_CauThu (MaCT, HoTen, MaDB) VALUES
-- Cầu thủ của đội A001
('CT001', N'Nguyễn Văn An', 'A001'),
('CT002', N'Trần Văn Bình', 'A001'),
('CT003', N'Lê Văn Cường', 'A001'),
-- Cầu thủ của đội A002
('CT004', N'Phạm Văn Dũng', 'A002'),
('CT005', N'Hoàng Văn Em', 'A002'),
('CT006', N'Võ Văn Phúc', 'A002'),
-- Cầu thủ của đội A003
('CT007', N'Đặng Văn Giang', 'A003'),
('CT008', N'Bùi Văn Hòa', 'A003'),
('CT009', N'Ngô Văn Tài', 'A003'),
-- Cầu thủ của đội B001
('CT010', N'Lionel Messi Jr', 'B001'),
('CT011', N'Pedro Rodriguez', 'B001'),
('CT012', N'Ansu Fati', 'B001'),
-- Cầu thủ của đội B002
('CT013', N'Raul Gonzalez', 'B002'),
('CT014', N'Alvaro Morata', 'B002'),
('CT015', N'Marco Asensio', 'B002'),
-- Cầu thủ của đội B003
('CT016', N'Thomas Muller Jr', 'B003'),
('CT017', N'Joshua Kimmich', 'B003'),
('CT018', N'Serge Gnabry', 'B003'),
-- Cầu thủ của đội C001
('CT019', N'Paulo Dybala', 'C001'),
('CT020', N'Federico Chiesa', 'C001'),
('CT021', N'Dejan Kulusevski', 'C001'),
-- Cầu thủ của đội C002
('CT022', N'Rafael Leao', 'C002'),
('CT023', N'Brahim Diaz', 'C002'),
('CT024', N'Daniel Maldini', 'C002'),
-- Cầu thủ của đội C003
('CT025', N'Lautaro Martinez', 'C003'),
('CT026', N'Nicolo Barella', 'C003'),
('CT027', N'Alessandro Bastoni', 'C003');

PRINT N'✓ Đã chèn 27 cầu thủ';
GO

-- =============================================
-- Chèn dữ liệu vào TranDau
-- =============================================
INSERT INTO vw_TranDau (MaTD, MaDB1, MaDB2, TrongTai, SanDau) VALUES
('TD001', 'A001', 'A002', N'Nguyễn Văn Xuân', N'Old Trafford'),
('TD002', 'A002', 'A003', N'Trần Văn Yên', N'Emirates Stadium'),
('TD003', 'A003', 'A001', N'Lê Văn Minh', N'Anfield'),
('TD004', 'B001', 'B002', N'Carlos Ramos', N'Camp Nou'),
('TD005', 'B002', 'B003', N'Felix Brych', N'Santiago Bernabeu'),
('TD006', 'B003', 'B001', N'Michael Oliver', N'Allianz Arena'),
('TD007', 'C001', 'C002', N'Daniele Orsato', N'Allianz Stadium'),
('TD008', 'C002', 'C003', N'Marco Guida', N'San Siro'),
('TD009', 'C003', 'C001', N'Maurizio Mariani', N'Giuseppe Meazza'),
('TD010', 'A001', 'B001', N'Howard Webb', N'Old Trafford'),
('TD011', 'B002', 'C002', N'Pierluigi Collina', N'Santiago Bernabeu'),
('TD012', 'C001', 'A002', N'Bjorn Kuipers', N'Allianz Stadium');

PRINT N'✓ Đã chèn 12 trận đấu';
GO

-- =============================================
-- Chèn dữ liệu vào ThamGia
-- =============================================
INSERT INTO vw_ThamGia (MaTD, MaCT, SoTrai) VALUES
-- Trận TD001: A001 vs A002
('TD001', 'CT001', 2), ('TD001', 'CT002', 1), ('TD001', 'CT003', 0),
('TD001', 'CT004', 1), ('TD001', 'CT005', 2), ('TD001', 'CT006', 0),
-- Trận TD002: A002 vs A003
('TD002', 'CT004', 0), ('TD002', 'CT005', 1), ('TD002', 'CT006', 1),
('TD002', 'CT007', 1), ('TD002', 'CT008', 1), ('TD002', 'CT009', 0),
-- Trận TD003: A003 vs A001 (Hòa)
('TD003', 'CT007', 1), ('TD003', 'CT008', 1), ('TD003', 'CT009', 0),
('TD003', 'CT001', 1), ('TD003', 'CT002', 1), ('TD003', 'CT003', 0),
-- Trận TD004: B001 vs B002
('TD004', 'CT010', 3), ('TD004', 'CT011', 1), ('TD004', 'CT012', 2),
('TD004', 'CT013', 1), ('TD004', 'CT014', 0), ('TD004', 'CT015', 1),
-- Trận TD005: B002 vs B003 (Hòa)
('TD005', 'CT013', 1), ('TD005', 'CT014', 1), ('TD005', 'CT015', 0),
('TD005', 'CT016', 1), ('TD005', 'CT017', 1), ('TD005', 'CT018', 0),
-- Trận TD006: B003 vs B001
('TD006', 'CT016', 2), ('TD006', 'CT017', 1), ('TD006', 'CT018', 1),
('TD006', 'CT010', 1), ('TD006', 'CT011', 0), ('TD006', 'CT012', 0),
-- Trận TD007: C001 vs C002 (Hòa)
('TD007', 'CT019', 1), ('TD007', 'CT020', 1), ('TD007', 'CT021', 0),
('TD007', 'CT022', 1), ('TD007', 'CT023', 1), ('TD007', 'CT024', 0),
-- Trận TD008: C002 vs C003
('TD008', 'CT022', 2), ('TD008', 'CT023', 1), ('TD008', 'CT024', 0),
('TD008', 'CT025', 1), ('TD008', 'CT026', 0), ('TD008', 'CT027', 0),
-- Trận TD009: C003 vs C001
('TD009', 'CT025', 3), ('TD009', 'CT026', 1), ('TD009', 'CT027', 0),
('TD009', 'CT019', 2), ('TD009', 'CT020', 0), ('TD009', 'CT021', 0),
-- Trận TD010: A001 vs B001
('TD010', 'CT001', 1), ('TD010', 'CT002', 0), ('TD010', 'CT003', 1),
('TD010', 'CT010', 2), ('TD010', 'CT011', 1), ('TD010', 'CT012', 0),
-- Trận TD011: B002 vs C002
('TD011', 'CT013', 2), ('TD011', 'CT014', 1), ('TD011', 'CT015', 1),
('TD011', 'CT022', 0), ('TD011', 'CT023', 1), ('TD011', 'CT024', 0),
-- Trận TD012: C001 vs A002
('TD012', 'CT019', 1), ('TD012', 'CT020', 2), ('TD012', 'CT021', 1),
('TD012', 'CT004', 1), ('TD012', 'CT005', 0), ('TD012', 'CT006', 1);

PRINT N'✓ Đã chèn thông tin tham gia trận đấu';
GO

-- =============================================
-- Kiểm tra dữ liệu đã chèn
-- =============================================
PRINT N'';
PRINT N'========== KIỂM TRA DỮ LIỆU ==========';
PRINT N'Tổng số đội bóng: ' + CAST((SELECT COUNT(*) FROM vw_DoiBong) AS NVARCHAR(10));
PRINT N'Tổng số cầu thủ: ' + CAST((SELECT COUNT(*) FROM vw_CauThu) AS NVARCHAR(10));
PRINT N'Tổng số trận đấu: ' + CAST((SELECT COUNT(*) FROM vw_TranDau) AS NVARCHAR(10));
PRINT N'Tổng số bản ghi tham gia: ' + CAST((SELECT COUNT(*) FROM vw_ThamGia) AS NVARCHAR(10));
PRINT N'';
PRINT N'Phân bố dữ liệu theo Site:';
PRINT N'  Site A - Đội bóng: ' + CAST((SELECT COUNT(*) FROM SiteA.dbo.DoiBong_A) AS NVARCHAR(10));
PRINT N'  Site B - Đội bóng: ' + CAST((SELECT COUNT(*) FROM SiteB.dbo.DoiBong_B) AS NVARCHAR(10));
PRINT N'  Site C - Đội bóng: ' + CAST((SELECT COUNT(*) FROM SiteC.dbo.DoiBong_C) AS NVARCHAR(10));
PRINT N'';
PRINT N'✓ Hoàn thành chèn dữ liệu mẫu!';
GO
