# ✅ CHECKLIST TRƯỚC KHI NỘP BÀI

## � PHẦN A: KIỂM TRA DOCKER SETUP (Nếu dùng Docker)

### Bước 1: Kiểm tra Docker đang chạy
```powershell
docker ps
```
- [ ] Container `sqlserver-doibong` đang chạy
- [ ] Status = "Up"
- [ ] Port 1433 được map

### Bước 2: Kiểm tra kết nối
```powershell
docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -Q "SELECT @@VERSION"
```
- [ ] Kết nối thành công
- [ ] Hiển thị SQL Server version

### Bước 3: Kiểm tra databases trong container
```powershell
docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -Q "SELECT name FROM sys.databases WHERE name IN ('SiteA','SiteB','SiteC','GlobalDB')"
```
- [ ] SiteA tồn tại
- [ ] SiteB tồn tại
- [ ] SiteC tồn tại
- [ ] GlobalDB tồn tại

---

## �📋 PHẦN B: KIỂM TRA DATABASE

### Bước 1: Kiểm tra 4 databases đã được tạo
```sql
SELECT name FROM sys.databases 
WHERE name IN ('SiteA', 'SiteB', 'SiteC', 'GlobalDB');
```
- [ ] SiteA tồn tại
- [ ] SiteB tồn tại
- [ ] SiteC tồn tại
- [ ] GlobalDB tồn tại

### Bước 2: Kiểm tra bảng mảnh
```sql
-- Kiểm tra SiteA
USE SiteA;
SELECT COUNT(*) FROM DoiBong_A;  -- Phải có 3
SELECT COUNT(*) FROM CauThu_A;   -- Phải có 9
SELECT COUNT(*) FROM TranDau_A;  -- Phải có 4

-- Tương tự cho SiteB và SiteC
```
- [ ] SiteA: 3 đội, 9 cầu thủ, 4 trận
- [ ] SiteB: 3 đội, 9 cầu thủ, 4 trận
- [ ] SiteC: 3 đội, 9 cầu thủ, 4 trận

### Bước 3: Kiểm tra Views toàn cục
```sql
USE GlobalDB;
SELECT COUNT(*) FROM vw_DoiBong;   -- Phải = 9
SELECT COUNT(*) FROM vw_CauThu;    -- Phải = 27
SELECT COUNT(*) FROM vw_TranDau;   -- Phải = 12
SELECT COUNT(*) FROM vw_ThamGia;   -- > 0
```
- [ ] vw_DoiBong: 9 bản ghi
- [ ] vw_CauThu: 27 bản ghi
- [ ] vw_TranDau: 12 bản ghi
- [ ] vw_ThamGia: Có dữ liệu

### Bước 4: Kiểm tra Triggers
```sql
USE GlobalDB;
SELECT 
    OBJECT_NAME(parent_id) AS TableName,
    name AS TriggerName,
    type_desc
FROM sys.triggers
WHERE parent_id IN (
    OBJECT_ID('vw_DoiBong'),
    OBJECT_ID('vw_CauThu'),
    OBJECT_ID('vw_TranDau'),
    OBJECT_ID('vw_ThamGia')
);
```
- [ ] trg_DoiBong_Insert tồn tại
- [ ] trg_DoiBong_Update tồn tại
- [ ] trg_DoiBong_Delete tồn tại
- [ ] Tương tự cho CauThu, TranDau, ThamGia

### Bước 5: Kiểm tra Stored Procedures
```sql
SELECT name FROM sys.procedures
WHERE name LIKE 'sp_Get%';
```
- [ ] sp_GetCauThuTheoCLB
- [ ] sp_GetSoTranThamGia
- [ ] sp_GetSoTranHoaTaiSan
- [ ] sp_GetKetQuaTranDau (optional)
- [ ] sp_GetTopGhiBan (optional)

---

## 🖥️ KIỂM TRA ỨNG DỤNG

### Bước 1: Build thành công
```bash
cd Application/QuanLyDoiBong
dotnet build
```
- [ ] Build không có lỗi
- [ ] Không có warning quan trọng

### Bước 2: Kết nối database
```
1. Chạy ứng dụng
2. Menu "Hệ Thống" → "Kiểm tra kết nối"
```
- [ ] Kết nối thành công
- [ ] Hiển thị thông báo "Kết nối thành công"

### Bước 3: Test CRUD Đội Bóng
```
1. Menu "Quản Lý" → "Đội Bóng"
2. Thêm đội mới: MaDB = "A999", TenDB = "Test Team"
3. Sửa đội vừa thêm
4. Xóa đội vừa thêm
```
- [ ] Thêm thành công
- [ ] Sửa thành công
- [ ] Xóa thành công
- [ ] DataGridView refresh đúng

### Bước 4: Test CRUD Cầu Thủ
```
1. Menu "Quản Lý" → "Cầu Thủ"
2. ComboBox đội bóng hiển thị đúng
3. Thêm cầu thủ mới
4. Sửa và xóa
```
- [ ] ComboBox load đúng danh sách đội
- [ ] CRUD hoạt động bình thường

### Bước 5: Test Query 1 - Cầu thủ theo CLB
```
1. Menu "Truy Vấn" → "Cầu thủ theo CLB"
2. Chọn CLB: "Manchester United"
3. Click "Tìm kiếm"
```
- [ ] Hiển thị đúng số cầu thủ
- [ ] DataGridView hiển thị: MaCT, HoTen, TenDB, CLB

### Bước 6: Test Query 2 - Số trận tham gia
```
1. Menu "Truy Vấn" → "Số trận tham gia"
2. Nhập: "Nguyễn"
3. Click "Tìm kiếm"
```
- [ ] Hiển thị cầu thủ có tên chứa "Nguyễn"
- [ ] Hiển thị số trận tham gia

### Bước 7: Test Query 3 - Số trận hòa
```
1. Menu "Truy Vấn" → "Số trận hòa"
2. Chọn sân: "Old Trafford"
3. Click "Tìm kiếm"
```
- [ ] Hiển thị số trận hòa
- [ ] MessageBox hiển thị kết quả

---

## 📄 KIỂM TRA TÀI LIỆU

### File README.md
- [ ] Có phần giới thiệu đề tài
- [ ] Có hướng dẫn cài đặt chi tiết
- [ ] Có hướng dẫn sử dụng
- [ ] Có phần xử lý lỗi
- [ ] Có giải thích mức trong suốt

### File SETUP.md
- [ ] Hướng dẫn ngắn gọn, dễ hiểu
- [ ] 3 bước rõ ràng
- [ ] Có phần xử lý lỗi nhanh

### File ARCHITECTURE.md
- [ ] Giải thích kiến trúc hệ thống
- [ ] Có sơ đồ (ASCII art)
- [ ] Giải thích trigger
- [ ] Giải thích phân mảnh

### File PROJECT_SUMMARY.md
- [ ] Tổng hợp đầy đủ
- [ ] Thống kê số liệu
- [ ] Tự đánh giá

---

## 🧪 TEST PHÂN MẢNH TỰ ĐỘNG

### Test INSERT routing
```sql
USE GlobalDB;

-- Test 1: Insert vào Site A
INSERT INTO vw_DoiBong VALUES ('A888', 'Test A', 'Test CLB');
SELECT * FROM SiteA.dbo.DoiBong_A WHERE MaDB = 'A888';  -- Phải có
SELECT * FROM SiteB.dbo.DoiBong_B WHERE MaDB = 'A888';  -- Phải KHÔNG có

-- Test 2: Insert vào Site B
INSERT INTO vw_DoiBong VALUES ('B888', 'Test B', 'Test CLB');
SELECT * FROM SiteB.dbo.DoiBong_B WHERE MaDB = 'B888';  -- Phải có

-- Cleanup
DELETE FROM vw_DoiBong WHERE MaDB IN ('A888', 'B888');
```
- [ ] Dữ liệu vào đúng site
- [ ] Không có dữ liệu ở site sai

### Test UPDATE routing
```sql
UPDATE vw_DoiBong SET TenDB = 'Updated Name' WHERE MaDB = 'A001';
SELECT TenDB FROM SiteA.dbo.DoiBong_A WHERE MaDB = 'A001';  
-- Phải = 'Updated Name'
```
- [ ] Update đúng site
- [ ] Dữ liệu thay đổi chính xác

### Test DELETE routing
```sql
-- Thêm test data
INSERT INTO vw_DoiBong VALUES ('C888', 'Test C', 'Test CLB');

-- Xóa
DELETE FROM vw_DoiBong WHERE MaDB = 'C888';

-- Kiểm tra
SELECT * FROM SiteC.dbo.DoiBong_C WHERE MaDB = 'C888';  
-- Phải KHÔNG có
```
- [ ] Delete đúng site
- [ ] Dữ liệu bị xóa hoàn toàn

---

## 🎯 TEST TRUY VẤN PHỨC TẠP

### Test JOIN phân tán
```sql
-- Truy vấn cầu thủ và đội bóng từ nhiều sites
SELECT c.MaCT, c.HoTen, d.TenDB, d.CLB
FROM vw_CauThu c
INNER JOIN vw_DoiBong d ON c.MaDB = d.MaDB
ORDER BY d.CLB;
```
- [ ] Trả về 27 cầu thủ
- [ ] JOIN đúng giữa các sites

### Test Aggregate phân tán
```sql
-- Đếm cầu thủ theo CLB
SELECT d.CLB, COUNT(*) AS SoCauThu
FROM vw_CauThu c
INNER JOIN vw_DoiBong d ON c.MaDB = d.MaDB
GROUP BY d.CLB
ORDER BY SoCauThu DESC;
```
- [ ] Aggregate đúng
- [ ] Kết quả hợp lý

---

## 📦 CHUẨN BỊ NỘP BÀI

### File cần nộp
- [ ] Folder Database/ với 7 files SQL
- [ ] Folder Application/ với source code đầy đủ
- [ ] Folder Documentation/ với các file .md
- [ ] File README.md (root)
- [ ] File SETUP.md (root)
- [ ] File PROJECT_SUMMARY.md (root)

### Kiểm tra cuối cùng
- [ ] Xóa folder bin/, obj/, .vs/
- [ ] Đảm bảo không có file nhạy cảm (password, etc.)
- [ ] Zip toàn bộ folder CSDLPT
- [ ] Test giải nén và chạy lại từ đầu

### Presentation (nếu cần)
- [ ] Chuẩn bị slide giới thiệu
- [ ] Demo INSERT, UPDATE, DELETE
- [ ] Demo 3 truy vấn đặc biệt
- [ ] Giải thích cơ chế phân mảnh
- [ ] Giải thích trigger

---

## 🐛 CHECKLIST LỖI THƯỜNG GẶP

### Lỗi Database
- [ ] SQL Server đã được start
- [ ] Đã chạy đủ 6 file SQL
- [ ] Connection string đúng
- [ ] Firewall không chặn SQL Server

### Lỗi Application
- [ ] Đã install .NET 8.0 SDK
- [ ] Đã restore NuGet packages
- [ ] Connection string match với SQL Server
- [ ] TrustServerCertificate=True (nếu cần)

### Lỗi Logic
- [ ] MaDB bắt đầu bằng A, B hoặc C
- [ ] Foreign Key hợp lệ
- [ ] Không INSERT duplicate PRIMARY KEY

---

## 📊 KIỂM TRA CUỐI CÙNG

```
┌────────────────────────────────────────────┐
│  ✅ Database setup hoàn tất                │
│  ✅ Application chạy được                  │
│  ✅ Tất cả CRUD hoạt động                  │
│  ✅ Tất cả Query hoạt động                 │
│  ✅ Phân mảnh tự động đúng                 │
│  ✅ Tài liệu đầy đủ                        │
│  ✅ Code clean, có comment                 │
│  ✅ Sẵn sàng demo                          │
└────────────────────────────────────────────┘
```

---

## 🎉 SẴN SÀNG NỘP BÀI!

Nếu tất cả checklist trên đều ✅, bạn đã hoàn thành xuất sắc đồ án!

**Chúc bạn bảo vệ thành công! 🚀**

---

**Ngày kiểm tra**: _____________  
**Người kiểm tra**: _____________  
**Kết quả**: [ ] PASS  [ ] FAIL
