-- =============================================
-- Script: Tạo các Database Site cho hệ thống phân tán
-- Mô tả: Tạo 3 site vật lý và 1 database toàn cục
-- =============================================

USE master;
GO

-- Xóa các database nếu đã tồn tại (để test lại từ đầu)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SiteA')
    DROP DATABASE SiteA;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SiteB')
    DROP DATABASE SiteB;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SiteC')
    DROP DATABASE SiteC;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'GlobalDB')
    DROP DATABASE GlobalDB;
GO

-- Tạo Site A - Lưu trữ mảnh dữ liệu của các đội bóng có MaDB bắt đầu bằng 'A'
CREATE DATABASE SiteA;
GO

-- Tạo Site B - Lưu trữ mảnh dữ liệu của các đội bóng có MaDB bắt đầu bằng 'B'
CREATE DATABASE SiteB;
GO

-- Tạo Site C - Lưu trữ mảnh dữ liệu của các đội bóng có MaDB bắt đầu bằng 'C'
CREATE DATABASE SiteC;
GO

-- Tạo Global Database - Chứa các view toàn cục và trigger
CREATE DATABASE GlobalDB;
GO

PRINT N'✓ Đã tạo thành công 4 databases: SiteA, SiteB, SiteC, GlobalDB';
GO
