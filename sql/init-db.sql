/* Initialization script: creates site databases, global database, tables, views, triggers */
IF DB_ID('SiteA') IS NULL CREATE DATABASE SiteA;
GO
IF DB_ID('SiteB') IS NULL CREATE DATABASE SiteB;
GO
IF DB_ID('SiteC') IS NULL CREATE DATABASE SiteC;
GO
IF DB_ID('GlobalDB') IS NULL CREATE DATABASE GlobalDB;
GO

/* Create tables in each site */
USE SiteA;
GO
IF OBJECT_ID('DoiBong') IS NULL CREATE TABLE DoiBong (MaDB INT PRIMARY KEY, TenDB NVARCHAR(100), CLB NVARCHAR(100), GiaiDau NVARCHAR(100));
IF OBJECT_ID('CauThu') IS NULL CREATE TABLE CauThu (MaCT INT PRIMARY KEY, HoTen NVARCHAR(100), MaDB INT REFERENCES DoiBong(MaDB), ViTri NVARCHAR(50));
IF OBJECT_ID('TranDau') IS NULL CREATE TABLE TranDau (MaTD INT PRIMARY KEY, MaDB1 INT, MaDB2 INT, TrongTai NVARCHAR(100), SanDau NVARCHAR(100));
IF OBJECT_ID('ThamGia') IS NULL CREATE TABLE ThamGia (MaTD INT, MaCT INT, SoTrai INT DEFAULT 0, PRIMARY KEY(MaTD, MaCT));
/* Vertical fragmentation: Basic info */
IF OBJECT_ID('HLV_Basic') IS NULL CREATE TABLE HLV_Basic (MaHLV INT PRIMARY KEY, HoTen NVARCHAR(100), QuocTich NVARCHAR(50));
GO
USE SiteB;
GO
IF OBJECT_ID('DoiBong') IS NULL CREATE TABLE DoiBong (MaDB INT PRIMARY KEY, TenDB NVARCHAR(100), CLB NVARCHAR(100), GiaiDau NVARCHAR(100));
IF OBJECT_ID('CauThu') IS NULL CREATE TABLE CauThu (MaCT INT PRIMARY KEY, HoTen NVARCHAR(100), MaDB INT REFERENCES DoiBong(MaDB), ViTri NVARCHAR(50));
IF OBJECT_ID('TranDau') IS NULL CREATE TABLE TranDau (MaTD INT PRIMARY KEY, MaDB1 INT, MaDB2 INT, TrongTai NVARCHAR(100), SanDau NVARCHAR(100));
IF OBJECT_ID('ThamGia') IS NULL CREATE TABLE ThamGia (MaTD INT, MaCT INT, SoTrai INT DEFAULT 0, PRIMARY KEY(MaTD, MaCT));
/* Vertical fragmentation: Additional info */
IF OBJECT_ID('HLV_Additional') IS NULL CREATE TABLE HLV_Additional (MaHLV INT PRIMARY KEY, MaDB INT, NgaySinh DATE, SoDienThoai NVARCHAR(20));
GO
USE SiteC;
GO
IF OBJECT_ID('DoiBong') IS NULL CREATE TABLE DoiBong (MaDB INT PRIMARY KEY, TenDB NVARCHAR(100), CLB NVARCHAR(100), GiaiDau NVARCHAR(100));
IF OBJECT_ID('CauThu') IS NULL CREATE TABLE CauThu (MaCT INT PRIMARY KEY, HoTen NVARCHAR(100), MaDB INT REFERENCES DoiBong(MaDB), ViTri NVARCHAR(50));
IF OBJECT_ID('TranDau') IS NULL CREATE TABLE TranDau (MaTD INT PRIMARY KEY, MaDB1 INT, MaDB2 INT, TrongTai NVARCHAR(100), SanDau NVARCHAR(100));
IF OBJECT_ID('ThamGia') IS NULL CREATE TABLE ThamGia (MaTD INT, MaCT INT, SoTrai INT DEFAULT 0, PRIMARY KEY(MaTD, MaCT));
/* Vertical fragmentation: Career history */
IF OBJECT_ID('HLV_History') IS NULL CREATE TABLE HLV_History (MaHLV INT PRIMARY KEY, NamKinhNghiem INT, ChucVuTruoc NVARCHAR(100), ThanhTich NVARCHAR(MAX));
GO

/* Real football data - Teams with club and league info */
USE SiteA;
GO
/* Vertical fragmentation data - Basic coach info */
MERGE HLV_Basic AS target USING (VALUES 
  (1,N'Pep Guardiola',N'Tây Ban Nha'),
  (2,N'Mikel Arteta',N'Tây Ban Nha'),
  (3,N'Jürgen Klopp',N'Đức'),
  (4,N'Carlo Ancelotti',N'Ý'),
  (5,N'Xavi Hernández',N'Tây Ban Nha'),
  (6,N'Diego Simeone',N'Argentina'),
  (7,N'Mauricio Pochettino',N'Argentina'),
  (8,N'Erik ten Hag',N'Hà Lan'),
  (9,N'Thomas Tuchel',N'Đức'),
  (10,N'Edin Terzić',N'Bosnia'),
  (11,N'Simone Inzaghi',N'Ý'),
  (12,N'Stefano Pioli',N'Ý'),
  (13,N'Massimiliano Allegri',N'Ý'),
  (14,N'Luis Enrique',N'Tây Ban Nha'),
  (15,N'Ange Postecoglou',N'Úc'),
  (16,N'Eddie Howe',N'Anh'),
  (17,N'Marco Rose',N'Đức'),
  (18,N'Rudi Garcia',N'Pháp')
) AS src(MaHLV,HoTen,QuocTich) ON target.MaHLV=src.MaHLV 
WHEN NOT MATCHED THEN INSERT(MaHLV,HoTen,QuocTich) VALUES(src.MaHLV,src.HoTen,src.QuocTich);
GO

MERGE DoiBong AS target USING (VALUES 
  -- Premier League
  (1,N'Manchester City',N'Manchester City FC',N'Premier League'),
  (2,N'Arsenal',N'Arsenal FC',N'Premier League'),
  (3,N'Liverpool',N'Liverpool FC',N'Premier League'),
  -- La Liga
  (4,N'Real Madrid',N'Real Madrid CF',N'La Liga'),
  (5,N'Barcelona',N'FC Barcelona',N'La Liga'),
  (6,N'Atletico Madrid',N'Club Atlético de Madrid',N'La Liga')
) AS src(MaDB,TenDB,CLB,GiaiDau) ON target.MaDB=src.MaDB 
WHEN NOT MATCHED THEN INSERT(MaDB,TenDB,CLB,GiaiDau) VALUES(src.MaDB,src.TenDB,src.CLB,src.GiaiDau);
GO

USE SiteB;
GO
/* Vertical fragmentation data - Additional coach info */
MERGE HLV_Additional AS target USING (VALUES 
  (1,1,'1971-01-18','+34-123-456-001'),
  (2,2,'1982-03-26','+34-123-456-002'),
  (3,3,'1967-06-16','+49-123-456-003'),
  (4,4,'1959-06-10','+39-123-456-004'),
  (5,5,'1980-01-25','+34-123-456-005'),
  (6,6,'1970-04-28','+54-123-456-006'),
  (7,7,'1972-03-02','+54-123-456-007'),
  (8,8,'1970-02-02','+31-123-456-008'),
  (9,9,'1973-08-29','+49-123-456-009'),
  (10,10,'1982-10-30','+387-123-456-010'),
  (11,11,'1976-04-05','+39-123-456-011'),
  (12,12,'1965-10-20','+39-123-456-012'),
  (13,13,'1967-08-11','+39-123-456-013'),
  (14,14,'1970-05-08','+34-123-456-014'),
  (15,15,'1965-08-27','+61-123-456-015'),
  (16,16,'1977-11-29','+44-123-456-016'),
  (17,17,'1976-09-11','+49-123-456-017'),
  (18,18,'1964-02-20','+33-123-456-018')
) AS src(MaHLV,MaDB,NgaySinh,SoDienThoai) ON target.MaHLV=src.MaHLV 
WHEN NOT MATCHED THEN INSERT(MaHLV,MaDB,NgaySinh,SoDienThoai) VALUES(src.MaHLV,src.MaDB,src.NgaySinh,src.SoDienThoai);
GO

MERGE DoiBong AS target USING (VALUES 
  -- Premier League
  (7,N'Chelsea',N'Chelsea FC',N'Premier League'),
  (8,N'Manchester United',N'Manchester United FC',N'Premier League'),
  -- Bundesliga
  (9,N'Bayern Munich',N'FC Bayern München',N'Bundesliga'),
  (10,N'Borussia Dortmund',N'Borussia Dortmund',N'Bundesliga'),
  -- Serie A
  (11,N'Inter Milan',N'FC Internazionale Milano',N'Serie A'),
  (12,N'AC Milan',N'AC Milan',N'Serie A')
) AS src(MaDB,TenDB,CLB,GiaiDau) ON target.MaDB=src.MaDB 
WHEN NOT MATCHED THEN INSERT(MaDB,TenDB,CLB,GiaiDau) VALUES(src.MaDB,src.TenDB,src.CLB,src.GiaiDau);
GO

USE SiteC;
GO
/* Vertical fragmentation data - Coach career history */
MERGE HLV_History AS target USING (VALUES 
  (1,15,N'HLV Barcelona B',N'4 Premier League, 2 Champions League'),
  (2,5,N'Trợ lý HLV Man City',N'1 FA Cup với Arsenal'),
  (3,12,N'HLV Mainz, Dortmund',N'1 Premier League, 1 Champions League'),
  (4,28,N'HLV Juventus, Milan',N'5 Champions League, nhiều giải quốc gia'),
  (5,4,N'HLV Barcelona B, Al Sadd',N'La Liga 2022-23'),
  (6,13,N'Cầu thủ Atletico',N'2 La Liga, 2 Europa League'),
  (7,15,N'HLV Espanyol, Southampton',N'Á quân Champions League với Tottenham'),
  (8,4,N'HLV Ajax',N'3 Eredivisie, 1 Champions League'),
  (9,12,N'HLV Mainz, Dortmund, PSG',N'1 Champions League, nhiều giải quốc gia'),
  (10,3,N'Trợ lý HLV Dortmund',N'DFB-Pokal 2020-21'),
  (11,8,N'HLV Lazio',N'Coppa Italia, Supercoppa Italiana'),
  (12,7,N'HLV Fiorentina, Lazio',N'Scudetto 2021-22'),
  (13,9,N'HLV Cagliari, Milan',N'Nhiều Serie A với Juventus'),
  (14,14,N'HLV Barcelona',N'1 Champions League, nhiều La Liga'),
  (15,2,N'HLV Yokohama, Celtic',N'Treble với Celtic'),
  (16,4,N'HLV Bournemouth',N'Top 4 Premier League'),
  (17,6,N'HLV Salzburg, Gladbach',N'Vô địch Áo, top Bundesliga'),
  (18,8,N'HLV Marseille, Lyon',N'Ligue 1 runners-up')
) AS src(MaHLV,NamKinhNghiem,ChucVuTruoc,ThanhTich) ON target.MaHLV=src.MaHLV 
WHEN NOT MATCHED THEN INSERT(MaHLV,NamKinhNghiem,ChucVuTruoc,ThanhTich) VALUES(src.MaHLV,src.NamKinhNghiem,src.ChucVuTruoc,src.ThanhTich);
GO

MERGE DoiBong AS target USING (VALUES 
  -- Serie A
  (13,N'Juventus',N'Juventus FC',N'Serie A'),
  -- Ligue 1
  (14,N'Paris Saint-Germain',N'Paris Saint-Germain FC',N'Ligue 1'),
  -- Premier League
  (15,N'Tottenham',N'Tottenham Hotspur FC',N'Premier League'),
  (16,N'Newcastle',N'Newcastle United FC',N'Premier League'),
  -- Bundesliga
  (17,N'RB Leipzig',N'RB Leipzig',N'Bundesliga'),
  -- Serie A
  (18,N'Napoli',N'SSC Napoli',N'Serie A')
) AS src(MaDB,TenDB,CLB,GiaiDau) ON target.MaDB=src.MaDB 
WHEN NOT MATCHED THEN INSERT(MaDB,TenDB,CLB,GiaiDau) VALUES(src.MaDB,src.TenDB,src.CLB,src.GiaiDau);
GO

/* Real players with positions */
USE SiteA;
GO
MERGE CauThu AS t USING (VALUES 
  -- Manchester City
  (1,N'Erling Haaland',1,N'Tiền đạo'),
  (2,N'Kevin De Bruyne',1,N'Tiền vệ'),
  (3,N'Phil Foden',1,N'Tiền vệ'),
  (4,N'Rodri',1,N'Tiền vệ'),
  -- Arsenal
  (5,N'Bukayo Saka',2,N'Tiền đạo'),
  (6,N'Martin Ødegaard',2,N'Tiền vệ'),
  (7,N'Declan Rice',2,N'Tiền vệ'),
  -- Liverpool
  (8,N'Mohamed Salah',3,N'Tiền đạo'),
  (9,N'Virgil van Dijk',3,N'Hậu vệ'),
  (10,N'Trent Alexander-Arnold',3,N'Hậu vệ'),
  -- Real Madrid
  (11,N'Jude Bellingham',4,N'Tiền vệ'),
  (12,N'Vinicius Junior',4,N'Tiền đạo'),
  (13,N'Federico Valverde',4,N'Tiền vệ'),
  -- Barcelona
  (14,N'Robert Lewandowski',5,N'Tiền đạo'),
  (15,N'Gavi',5,N'Tiền vệ'),
  (16,N'Pedri',5,N'Tiền vệ'),
  -- Atletico Madrid
  (17,N'Antoine Griezmann',6,N'Tiền đạo'),
  (18,N'Álvaro Morata',6,N'Tiền đạo')
) AS s(MaCT,HoTen,MaDB,ViTri) ON t.MaCT=s.MaCT 
WHEN NOT MATCHED THEN INSERT(MaCT,HoTen,MaDB,ViTri) VALUES(s.MaCT,s.HoTen,s.MaDB,s.ViTri);
GO

USE SiteB;
GO
MERGE CauThu AS t USING (VALUES 
  -- Chelsea
  (19,N'Cole Palmer',7,N'Tiền vệ'),
  (20,N'Enzo Fernández',7,N'Tiền vệ'),
  -- Manchester United
  (21,N'Bruno Fernandes',8,N'Tiền vệ'),
  (22,N'Marcus Rashford',8,N'Tiền đạo'),
  (23,N'Rasmus Højlund',8,N'Tiền đạo'),
  -- Bayern Munich
  (24,N'Harry Kane',9,N'Tiền đạo'),
  (25,N'Jamal Musiala',9,N'Tiền vệ'),
  (26,N'Leroy Sané',9,N'Tiền đạo'),
  -- Borussia Dortmund
  (27,N'Julian Brandt',10,N'Tiền vệ'),
  (28,N'Karim Adeyemi',10,N'Tiền đạo'),
  -- Inter Milan
  (29,N'Lautaro Martínez',11,N'Tiền đạo'),
  (30,N'Hakan Çalhanoğlu',11,N'Tiền vệ'),
  -- AC Milan
  (31,N'Rafael Leão',12,N'Tiền đạo'),
  (32,N'Christian Pulisic',12,N'Tiền vệ')
) AS s(MaCT,HoTen,MaDB,ViTri) ON t.MaCT=s.MaCT 
WHEN NOT MATCHED THEN INSERT(MaCT,HoTen,MaDB,ViTri) VALUES(s.MaCT,s.HoTen,s.MaDB,s.ViTri);
GO

USE SiteC;
GO
MERGE CauThu AS t USING (VALUES 
  -- Juventus
  (33,N'Dušan Vlahović',13,N'Tiền đạo'),
  (34,N'Federico Chiesa',13,N'Tiền đạo'),
  -- PSG
  (35,N'Kylian Mbappé',14,N'Tiền đạo'),
  (36,N'Ousmane Dembélé',14,N'Tiền đạo'),
  (37,N'Marquinhos',14,N'Hậu vệ'),
  -- Tottenham
  (38,N'Son Heung-min',15,N'Tiền đạo'),
  (39,N'James Maddison',15,N'Tiền vệ'),
  -- Newcastle
  (40,N'Alexander Isak',16,N'Tiền đạo'),
  (41,N'Bruno Guimarães',16,N'Tiền vệ'),
  -- RB Leipzig
  (42,N'Dani Olmo',17,N'Tiền vệ'),
  (43,N'Xavi Simons',17,N'Tiền vệ'),
  -- Napoli
  (44,N'Victor Osimhen',18,N'Tiền đạo'),
  (45,N'Khvicha Kvaratskhelia',18,N'Tiền đạo')
) AS s(MaCT,HoTen,MaDB,ViTri) ON t.MaCT=s.MaCT 
WHEN NOT MATCHED THEN INSERT(MaCT,HoTen,MaDB,ViTri) VALUES(s.MaCT,s.HoTen,s.MaDB,s.ViTri);
GO

/* Real matches from multiple leagues */
USE SiteA;
GO
MERGE TranDau AS t USING (VALUES 
  (1,1,2,N'Michael Oliver',N'Etihad Stadium'),
  (2,3,8,N'Anthony Taylor',N'Anfield'),
  (3,4,5,N'Antonio Mateu Lahoz',N'Santiago Bernabéu'),
  (4,5,6,N'Jesús Gil Manzano',N'Camp Nou')
) AS s(MaTD,MaDB1,MaDB2,TrongTai,SanDau) ON t.MaTD=s.MaTD 
WHEN NOT MATCHED THEN INSERT(MaTD,MaDB1,MaDB2,TrongTai,SanDau) VALUES(s.MaTD,s.MaDB1,s.MaDB2,s.TrongTai,s.SanDau);
GO

USE SiteB;
GO
MERGE TranDau AS t USING (VALUES 
  (5,7,15,N'Paul Tierney',N'Stamford Bridge'),
  (6,9,10,N'Felix Brych',N'Allianz Arena'),
  (7,11,12,N'Daniele Orsato',N'San Siro'),
  (8,2,16,N'Stuart Attwell',N'Emirates Stadium')
) AS s(MaTD,MaDB1,MaDB2,TrongTai,SanDau) ON t.MaTD=s.MaTD 
WHEN NOT MATCHED THEN INSERT(MaTD,MaDB1,MaDB2,TrongTai,SanDau) VALUES(s.MaTD,s.MaDB1,s.MaDB2,s.TrongTai,s.SanDau);
GO

USE SiteC;
GO
MERGE TranDau AS t USING (VALUES 
  (9,13,18,N'Marco Guida',N'Allianz Stadium'),
  (10,14,5,N'François Letexier',N'Parc des Princes'),
  (11,17,9,N'Tobias Stieler',N'Red Bull Arena'),
  (12,1,3,N'Chris Kavanagh',N'Etihad Stadium')
) AS s(MaTD,MaDB1,MaDB2,TrongTai,SanDau) ON t.MaTD=s.MaTD 
WHEN NOT MATCHED THEN INSERT(MaTD,MaDB1,MaDB2,TrongTai,SanDau) VALUES(s.MaTD,s.MaDB1,s.MaDB2,s.TrongTai,s.SanDau);
GO

/* Match participation with goals */
USE SiteA;
GO
MERGE ThamGia AS t USING (VALUES 
  -- Match 1: Man City vs Arsenal
  (1,1,2),(1,2,1),(1,3,0),(1,5,1),(1,6,0),(1,7,0),
  -- Match 2: Liverpool vs Man United
  (2,8,2),(2,9,0),(2,10,1),(2,21,0),(2,22,1),
  -- Match 3: Real Madrid vs Barcelona
  (3,11,1),(3,12,2),(3,13,0),(3,14,1),(3,15,0),(3,16,1),
  -- Match 4: Barcelona vs Atletico
  (4,14,1),(4,15,1),(4,16,0),(4,17,2),(4,18,1)
) AS s(MaTD,MaCT,SoTrai) ON t.MaTD=s.MaTD AND t.MaCT=s.MaCT 
WHEN NOT MATCHED THEN INSERT(MaTD,MaCT,SoTrai) VALUES(s.MaTD,s.MaCT,s.SoTrai);
GO

USE SiteB;
GO
MERGE ThamGia AS t USING (VALUES 
  -- Match 5: Chelsea vs Tottenham
  (5,19,1),(5,20,0),(5,38,2),(5,39,1),
  -- Match 6: Bayern vs Dortmund
  (6,24,3),(6,25,1),(6,26,0),(6,27,1),(6,28,1),
  -- Match 7: Inter vs Milan
  (7,29,2),(7,30,0),(7,31,1),(7,32,1),
  -- Match 8: Arsenal vs Newcastle
  (8,5,1),(8,6,1),(8,40,2),(8,41,0)
) AS s(MaTD,MaCT,SoTrai) ON t.MaTD=s.MaTD AND t.MaCT=s.MaCT 
WHEN NOT MATCHED THEN INSERT(MaTD,MaCT,SoTrai) VALUES(s.MaTD,s.MaCT,s.SoTrai);
GO

USE SiteC;
GO
MERGE ThamGia AS t USING (VALUES 
  -- Match 9: Juventus vs Napoli
  (9,33,1),(9,34,0),(9,44,2),(9,45,1),
  -- Match 10: PSG vs Barcelona
  (10,35,2),(10,36,1),(10,37,0),(10,14,1),(10,15,1),
  -- Match 11: Leipzig vs Bayern
  (11,42,1),(11,43,0),(11,24,2),(11,25,1),
  -- Match 12: Man City vs Liverpool (draw)
  (12,1,2),(12,2,0),(12,3,1),(12,8,2),(12,9,0),(12,10,1)
) AS s(MaTD,MaCT,SoTrai) ON t.MaTD=s.MaTD AND t.MaCT=s.MaCT 
WHEN NOT MATCHED THEN INSERT(MaTD,MaCT,SoTrai) VALUES(s.MaTD,s.MaCT,s.SoTrai);
GO

/* Global views */
USE GlobalDB;
GO
IF OBJECT_ID('DoiBong','V') IS NOT NULL DROP VIEW DoiBong;
GO
CREATE VIEW DoiBong AS
SELECT * FROM SiteA.dbo.DoiBong UNION ALL
SELECT * FROM SiteB.dbo.DoiBong UNION ALL
SELECT * FROM SiteC.dbo.DoiBong;
GO
IF OBJECT_ID('CauThu','V') IS NOT NULL DROP VIEW CauThu;
GO
CREATE VIEW CauThu AS
SELECT * FROM SiteA.dbo.CauThu UNION ALL
SELECT * FROM SiteB.dbo.CauThu UNION ALL
SELECT * FROM SiteC.dbo.CauThu;
GO
IF OBJECT_ID('TranDau','V') IS NOT NULL DROP VIEW TranDau;
GO
CREATE VIEW TranDau AS
SELECT * FROM SiteA.dbo.TranDau UNION ALL
SELECT * FROM SiteB.dbo.TranDau UNION ALL
SELECT * FROM SiteC.dbo.TranDau;
GO
IF OBJECT_ID('ThamGia','V') IS NOT NULL DROP VIEW ThamGia;
GO
CREATE VIEW ThamGia AS
SELECT * FROM SiteA.dbo.ThamGia UNION ALL
SELECT * FROM SiteB.dbo.ThamGia UNION ALL
SELECT * FROM SiteC.dbo.ThamGia;
GO
/* Vertical fragmentation view - JOIN all fragments */
IF OBJECT_ID('HuanLuyenVien','V') IS NOT NULL DROP VIEW HuanLuyenVien;
GO
CREATE VIEW HuanLuyenVien AS
SELECT 
    b.MaHLV, b.HoTen, b.QuocTich,
    a.MaDB, a.NgaySinh, a.SoDienThoai,
    h.NamKinhNghiem, h.ChucVuTruoc, h.ThanhTich
FROM SiteA.dbo.HLV_Basic b
JOIN SiteB.dbo.HLV_Additional a ON b.MaHLV = a.MaHLV
JOIN SiteC.dbo.HLV_History h ON b.MaHLV = h.MaHLV;
GO

/* Helper function to choose site by key */
IF OBJECT_ID('dbo.fn_SelectSite','FN') IS NOT NULL DROP FUNCTION dbo.fn_SelectSite;
GO
CREATE FUNCTION dbo.fn_SelectSite(@Key INT)
RETURNS NVARCHAR(10)
AS BEGIN
    DECLARE @Site NVARCHAR(10);
    DECLARE @m INT = ABS(@Key) % 3;
    SET @Site = CASE @m WHEN 0 THEN 'SiteA' WHEN 1 THEN 'SiteB' ELSE 'SiteC' END;
    RETURN @Site;
END;
GO

/* INSTEAD OF trigger for DoiBong view */
IF OBJECT_ID('trg_DoiBong_IO','TR') IS NOT NULL DROP TRIGGER trg_DoiBong_IO;
GO
CREATE TRIGGER trg_DoiBong_IO ON DoiBong INSTEAD OF INSERT, UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM deleted) BEGIN
        DELETE a FROM SiteA.dbo.DoiBong a JOIN deleted d ON a.MaDB=d.MaDB;
        DELETE b FROM SiteB.dbo.DoiBong b JOIN deleted d ON b.MaDB=d.MaDB;
        DELETE c FROM SiteC.dbo.DoiBong c JOIN deleted d ON c.MaDB=d.MaDB;
    END
    IF EXISTS(SELECT 1 FROM inserted) BEGIN
        MERGE SiteA.dbo.DoiBong AS t USING (SELECT * FROM inserted WHERE ABS(MaDB)%3=0) AS s(MaDB,TenDB,CLB,GiaiDau)
        ON t.MaDB=s.MaDB WHEN MATCHED THEN UPDATE SET TenDB=s.TenDB, CLB=s.CLB, GiaiDau=s.GiaiDau WHEN NOT MATCHED THEN INSERT(MaDB,TenDB,CLB,GiaiDau) VALUES(s.MaDB,s.TenDB,s.CLB,s.GiaiDau);
        MERGE SiteB.dbo.DoiBong AS t USING (SELECT * FROM inserted WHERE ABS(MaDB)%3=1) AS s(MaDB,TenDB,CLB,GiaiDau)
        ON t.MaDB=s.MaDB WHEN MATCHED THEN UPDATE SET TenDB=s.TenDB, CLB=s.CLB, GiaiDau=s.GiaiDau WHEN NOT MATCHED THEN INSERT(MaDB,TenDB,CLB,GiaiDau) VALUES(s.MaDB,s.TenDB,s.CLB,s.GiaiDau);
        MERGE SiteC.dbo.DoiBong AS t USING (SELECT * FROM inserted WHERE ABS(MaDB)%3=2) AS s(MaDB,TenDB,CLB,GiaiDau)
        ON t.MaDB=s.MaDB WHEN MATCHED THEN UPDATE SET TenDB=s.TenDB, CLB=s.CLB, GiaiDau=s.GiaiDau WHEN NOT MATCHED THEN INSERT(MaDB,TenDB,CLB,GiaiDau) VALUES(s.MaDB,s.TenDB,s.CLB,s.GiaiDau);
    END
END;
GO

/* Similar triggers (simplified) for other views */
IF OBJECT_ID('trg_CauThu_IO','TR') IS NOT NULL DROP TRIGGER trg_CauThu_IO;
GO
CREATE TRIGGER trg_CauThu_IO ON CauThu INSTEAD OF INSERT, UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM deleted) BEGIN
        DELETE a FROM SiteA.dbo.CauThu a JOIN deleted d ON a.MaCT=d.MaCT;
        DELETE b FROM SiteB.dbo.CauThu b JOIN deleted d ON b.MaCT=d.MaCT;
        DELETE c FROM SiteC.dbo.CauThu c JOIN deleted d ON c.MaCT=d.MaCT;
    END
    IF EXISTS(SELECT 1 FROM inserted) BEGIN
        MERGE SiteA.dbo.CauThu AS t USING (SELECT * FROM inserted WHERE ABS(MaCT)%3=0) AS s(MaCT,HoTen,MaDB,ViTri)
        ON t.MaCT=s.MaCT WHEN MATCHED THEN UPDATE SET HoTen=s.HoTen, MaDB=s.MaDB, ViTri=s.ViTri WHEN NOT MATCHED THEN INSERT(MaCT,HoTen,MaDB,ViTri) VALUES(s.MaCT,s.HoTen,s.MaDB,s.ViTri);
        MERGE SiteB.dbo.CauThu AS t USING (SELECT * FROM inserted WHERE ABS(MaCT)%3=1) AS s(MaCT,HoTen,MaDB,ViTri)
        ON t.MaCT=s.MaCT WHEN MATCHED THEN UPDATE SET HoTen=s.HoTen, MaDB=s.MaDB, ViTri=s.ViTri WHEN NOT MATCHED THEN INSERT(MaCT,HoTen,MaDB,ViTri) VALUES(s.MaCT,s.HoTen,s.MaDB,s.ViTri);
        MERGE SiteC.dbo.CauThu AS t USING (SELECT * FROM inserted WHERE ABS(MaCT)%3=2) AS s(MaCT,HoTen,MaDB,ViTri)
        ON t.MaCT=s.MaCT WHEN MATCHED THEN UPDATE SET HoTen=s.HoTen, MaDB=s.MaDB, ViTri=s.ViTri WHEN NOT MATCHED THEN INSERT(MaCT,HoTen,MaDB,ViTri) VALUES(s.MaCT,s.HoTen,s.MaDB,s.ViTri);
    END
END;
GO

IF OBJECT_ID('trg_TranDau_IO','TR') IS NOT NULL DROP TRIGGER trg_TranDau_IO;
GO
CREATE TRIGGER trg_TranDau_IO ON TranDau INSTEAD OF INSERT, UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM deleted) BEGIN
        DELETE a FROM SiteA.dbo.TranDau a JOIN deleted d ON a.MaTD=d.MaTD;
        DELETE b FROM SiteB.dbo.TranDau b JOIN deleted d ON b.MaTD=d.MaTD;
        DELETE c FROM SiteC.dbo.TranDau c JOIN deleted d ON c.MaTD=d.MaTD;
    END
    IF EXISTS(SELECT 1 FROM inserted) BEGIN
        MERGE SiteA.dbo.TranDau AS t USING (SELECT * FROM inserted WHERE ABS(MaTD)%3=0) AS s(MaTD,MaDB1,MaDB2,TrongTai,SanDau)
        ON t.MaTD=s.MaTD WHEN MATCHED THEN UPDATE SET MaDB1=s.MaDB1, MaDB2=s.MaDB2, TrongTai=s.TrongTai, SanDau=s.SanDau WHEN NOT MATCHED THEN INSERT(MaTD,MaDB1,MaDB2,TrongTai,SanDau) VALUES(s.MaTD,s.MaDB1,s.MaDB2,s.TrongTai,s.SanDau);
        MERGE SiteB.dbo.TranDau AS t USING (SELECT * FROM inserted WHERE ABS(MaTD)%3=1) AS s(MaTD,MaDB1,MaDB2,TrongTai,SanDau)
        ON t.MaTD=s.MaTD WHEN MATCHED THEN UPDATE SET MaDB1=s.MaDB1, MaDB2=s.MaDB2, TrongTai=s.TrongTai, SanDau=s.SanDau WHEN NOT MATCHED THEN INSERT(MaTD,MaDB1,MaDB2,TrongTai,SanDau) VALUES(s.MaTD,s.MaDB1,s.MaDB2,s.TrongTai,s.SanDau);
        MERGE SiteC.dbo.TranDau AS t USING (SELECT * FROM inserted WHERE ABS(MaTD)%3=2) AS s(MaTD,MaDB1,MaDB2,TrongTai,SanDau)
        ON t.MaTD=s.MaTD WHEN MATCHED THEN UPDATE SET MaDB1=s.MaDB1, MaDB2=s.MaDB2, TrongTai=s.TrongTai, SanDau=s.SanDau WHEN NOT MATCHED THEN INSERT(MaTD,MaDB1,MaDB2,TrongTai,SanDau) VALUES(s.MaTD,s.MaDB1,s.MaDB2,s.TrongTai,s.SanDau);
    END
END;
GO

IF OBJECT_ID('trg_ThamGia_IO','TR') IS NOT NULL DROP TRIGGER trg_ThamGia_IO;
GO
CREATE TRIGGER trg_ThamGia_IO ON ThamGia INSTEAD OF INSERT, UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM deleted) BEGIN
        DELETE a FROM SiteA.dbo.ThamGia a JOIN deleted d ON a.MaTD=d.MaTD AND a.MaCT=d.MaCT;
        DELETE b FROM SiteB.dbo.ThamGia b JOIN deleted d ON b.MaTD=d.MaTD AND b.MaCT=d.MaCT;
        DELETE c FROM SiteC.dbo.ThamGia c JOIN deleted d ON c.MaTD=d.MaTD AND c.MaCT=d.MaCT;
    END
    IF EXISTS(SELECT 1 FROM inserted) BEGIN
        MERGE SiteA.dbo.ThamGia AS t USING (SELECT * FROM inserted WHERE ABS(MaTD)%3=0) AS s(MaTD,MaCT,SoTrai)
        ON t.MaTD=s.MaTD AND t.MaCT=s.MaCT WHEN MATCHED THEN UPDATE SET SoTrai=s.SoTrai WHEN NOT MATCHED THEN INSERT(MaTD,MaCT,SoTrai) VALUES(s.MaTD,s.MaCT,s.SoTrai);
        MERGE SiteB.dbo.ThamGia AS t USING (SELECT * FROM inserted WHERE ABS(MaTD)%3=1) AS s(MaTD,MaCT,SoTrai)
        ON t.MaTD=s.MaTD AND t.MaCT=s.MaCT WHEN MATCHED THEN UPDATE SET SoTrai=s.SoTrai WHEN NOT MATCHED THEN INSERT(MaTD,MaCT,SoTrai) VALUES(s.MaTD,s.MaCT,s.SoTrai);
        MERGE SiteC.dbo.ThamGia AS t USING (SELECT * FROM inserted WHERE ABS(MaTD)%3=2) AS s(MaTD,MaCT,SoTrai)
        ON t.MaTD=s.MaTD AND t.MaCT=s.MaCT WHEN MATCHED THEN UPDATE SET SoTrai=s.SoTrai WHEN NOT MATCHED THEN INSERT(MaTD,MaCT,SoTrai) VALUES(s.MaTD,s.MaCT,s.SoTrai);
    END
END;
GO

/* Vertical fragmentation trigger - distribute to different fragments */
IF OBJECT_ID('trg_HuanLuyenVien_IO','TR') IS NOT NULL DROP TRIGGER trg_HuanLuyenVien_IO;
GO
CREATE TRIGGER trg_HuanLuyenVien_IO ON HuanLuyenVien INSTEAD OF INSERT, UPDATE, DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM deleted) BEGIN
        DELETE FROM SiteA.dbo.HLV_Basic WHERE MaHLV IN (SELECT MaHLV FROM deleted);
        DELETE FROM SiteB.dbo.HLV_Additional WHERE MaHLV IN (SELECT MaHLV FROM deleted);
        DELETE FROM SiteC.dbo.HLV_History WHERE MaHLV IN (SELECT MaHLV FROM deleted);
    END
    IF EXISTS(SELECT 1 FROM inserted) BEGIN
        -- Insert/Update to SiteA (Basic info)
        MERGE SiteA.dbo.HLV_Basic AS t 
        USING (SELECT MaHLV, HoTen, QuocTich FROM inserted) AS s
        ON t.MaHLV = s.MaHLV
        WHEN MATCHED THEN UPDATE SET HoTen=s.HoTen, QuocTich=s.QuocTich
        WHEN NOT MATCHED THEN INSERT(MaHLV, HoTen, QuocTich) VALUES(s.MaHLV, s.HoTen, s.QuocTich);
        
        -- Insert/Update to SiteB (Additional info)
        MERGE SiteB.dbo.HLV_Additional AS t 
        USING (SELECT MaHLV, MaDB, NgaySinh, SoDienThoai FROM inserted) AS s
        ON t.MaHLV = s.MaHLV
        WHEN MATCHED THEN UPDATE SET MaDB=s.MaDB, NgaySinh=s.NgaySinh, SoDienThoai=s.SoDienThoai
        WHEN NOT MATCHED THEN INSERT(MaHLV, MaDB, NgaySinh, SoDienThoai) VALUES(s.MaHLV, s.MaDB, s.NgaySinh, s.SoDienThoai);
        
        -- Insert/Update to SiteC (History)
        MERGE SiteC.dbo.HLV_History AS t 
        USING (SELECT MaHLV, NamKinhNghiem, ChucVuTruoc, ThanhTich FROM inserted) AS s
        ON t.MaHLV = s.MaHLV
        WHEN MATCHED THEN UPDATE SET NamKinhNghiem=s.NamKinhNghiem, ChucVuTruoc=s.ChucVuTruoc, ThanhTich=s.ThanhTich
        WHEN NOT MATCHED THEN INSERT(MaHLV, NamKinhNghiem, ChucVuTruoc, ThanhTich) VALUES(s.MaHLV, s.NamKinhNghiem, s.ChucVuTruoc, s.ThanhTich);
    END
END;
GO

PRINT 'Initialization complete - Horizontal & Vertical Fragmentation ready.';
