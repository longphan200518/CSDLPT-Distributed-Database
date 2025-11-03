# 🎥 KỊCH BẢN DEMO ĐỒ ÁN

## 📝 THÔNG TIN DEMO
- **Thời lượng**: 10-15 phút
- **Mục tiêu**: Chứng minh hệ thống hoạt động đúng yêu cầu
- **Chuẩn bị**: Mở sẵn SSMS và Application

---

## 🎬 PHẦN 1: GIỚI THIỆU (2 phút)

### Slide 1: Thông tin đề tài
```
📌 Nội dung nói:
"Xin chào thầy/cô và các bạn. Em xin giới thiệu đồ án 
Hệ thống Quản lý Đội bóng - CSDL Phân tán.

Đề tài gồm:
- 4 databases: GlobalDB và 3 sites vật lý
- Phân mảnh ngang theo MaDB
- Ứng dụng Windows Forms với CRUD và 3 truy vấn đặc biệt"
```

### Slide 2: Lược đồ CSDL
```
📌 Trình bày:
"Hệ thống gồm 4 bảng:
- DoiBong: Thông tin đội bóng
- CauThu: Thông tin cầu thủ  
- TranDau: Thông tin trận đấu
- ThamGia: Cầu thủ tham gia trận nào, ghi bao nhiêu bàn"
```

### Slide 3: Kiến trúc phân tán
```
📌 Giải thích:
"Dữ liệu được phân mảnh ngang:
- Site A: Lưu đội có MaDB bắt đầu = A
- Site B: Lưu đội có MaDB bắt đầu = B  
- Site C: Lưu đội có MaDB bắt đầu = C

User thao tác trên view toàn cục, 
trigger tự động định tuyến đến site phù hợp."
```

---

## 🗄️ PHẦN 2: DEMO DATABASE (3 phút)

### Bước 1: Mở SSMS và hiển thị 4 databases
```sql
-- Chạy query này và show kết quả
SELECT name FROM sys.databases 
WHERE name IN ('SiteA', 'SiteB', 'SiteC', 'GlobalDB')
ORDER BY name;
```
```
📌 Nói:
"Hệ thống có 4 databases: GlobalDB chứa view toàn cục,
và 3 sites vật lý chứa dữ liệu mảnh."
```

### Bước 2: Kiểm tra phân bố dữ liệu
```sql
-- Show dữ liệu tại Site A
USE SiteA;
SELECT * FROM DoiBong_A;
```
```
📌 Nói:
"Site A lưu 3 đội: A001, A002, A003.
Tất cả đều có MaDB bắt đầu bằng chữ A."
```

```sql
-- Show dữ liệu tại Site B
USE SiteB;
SELECT * FROM DoiBong_B;
```
```
📌 Nói:
"Tương tự Site B lưu B001, B002, B003."
```

### Bước 3: Demo View toàn cục
```sql
USE GlobalDB;
SELECT * FROM vw_DoiBong;
```
```
📌 Nói:
"View toàn cục hợp nhất dữ liệu từ 3 sites
bằng UNION ALL. User chỉ thấy 1 bảng duy nhất,
không cần biết dữ liệu ở đâu."
```

### Bước 4: Demo Trigger
```sql
-- INSERT vào view toàn cục
INSERT INTO vw_DoiBong VALUES ('A999', 'Demo Team', 'Demo CLB');

-- Kiểm tra dữ liệu vào Site A
SELECT * FROM SiteA.dbo.DoiBong_A WHERE MaDB = 'A999';
```
```
📌 Nói:
"Em INSERT vào view toàn cục với MaDB = A999.
Trigger tự động nhận diện và đưa dữ liệu vào Site A.
Đây là cơ chế phân mảnh tự động."
```

```sql
-- Cleanup
DELETE FROM vw_DoiBong WHERE MaDB = 'A999';
```

---

## 💻 PHẦN 3: DEMO APPLICATION (5 phút)

### Bước 1: Khởi động ứng dụng
```
📌 Thao tác:
1. Chạy application
2. Hiển thị menu chính
```
```
📌 Nói:
"Đây là giao diện chính của ứng dụng.
Gồm 3 menu: Quản Lý, Truy Vấn, và Hệ Thống."
```

### Bước 2: Test kết nối
```
📌 Thao tác:
Menu "Hệ Thống" → "Kiểm tra kết nối"
```
```
📌 Nói:
"Trước tiên em kiểm tra kết nối database.
Kết nối thành công!"
```

### Bước 3: Demo CRUD Đội Bóng
```
📌 Thao tác:
1. Menu "Quản Lý" → "Đội Bóng"
2. DataGridView hiển thị 9 đội
```
```
📌 Nói:
"Form này hiển thị tất cả đội bóng từ cả 3 sites.
Bây giờ em sẽ thêm 1 đội mới."
```

**INSERT:**
```
📌 Thao tác:
1. Nhập: MaDB = "C999"
2. Nhập: TenDB = "Test Team Demo"
3. Nhập: CLB = "Demo Club"
4. Click "Thêm"
```
```
📌 Nói:
"Em thêm đội với MaDB = C999.
Dữ liệu sẽ tự động vào Site C."
```

**UPDATE:**
```
📌 Thao tác:
1. Click chọn đội vừa thêm
2. Sửa TenDB = "Updated Team"
3. Click "Sửa"
```
```
📌 Nói:
"Cập nhật thông tin đội thành công."
```

**DELETE:**
```
📌 Thao tác:
1. Click chọn đội vừa thêm
2. Click "Xóa"
3. Xác nhận
```
```
📌 Nói:
"Xóa đội thành công. Dữ liệu đã được xóa ở Site C."
```

### Bước 4: Demo CRUD Cầu Thủ
```
📌 Thao tác:
Menu "Quản Lý" → "Cầu Thủ"
```
```
📌 Nói:
"Form Cầu thủ có ComboBox để chọn đội bóng.
Đảm bảo foreign key hợp lệ."
```

---

## 🔍 PHẦN 4: DEMO 3 TRUY VẤN ĐẶC BIỆT (3 phút)

### Query 1: Cầu thủ theo CLB
```
📌 Thao tác:
1. Menu "Truy Vấn" → "Cầu thủ theo CLB"
2. Chọn CLB: "Manchester United"
3. Click "Tìm kiếm"
```
```
📌 Nói:
"Truy vấn 1: Tìm tất cả cầu thủ thuộc câu lạc bộ Manchester United.
Kết quả: 3 cầu thủ thuộc MU."
```

**Giải thích kỹ thuật:**
```sql
-- Show stored procedure
USE GlobalDB;
EXEC sp_Helptext 'sp_GetCauThuTheoCLB';
```
```
📌 Nói:
"Stored procedure JOIN giữa vw_CauThu và vw_DoiBong,
filter theo CLB. Đây là truy vấn phân tán vì dữ liệu
có thể nằm ở nhiều sites khác nhau."
```

### Query 2: Số trận cầu thủ tham gia
```
📌 Thao tác:
1. Menu "Truy Vấn" → "Số trận tham gia"
2. Nhập: "Nguyễn Văn An"
3. Click "Tìm kiếm"
```
```
📌 Nói:
"Truy vấn 2: Đếm số trận cầu thủ Nguyễn Văn An đã tham gia.
Kết quả: Cầu thủ này đã tham gia X trận."
```

### Query 3: Số trận hòa tại sân
```
📌 Thao tác:
1. Menu "Truy Vấn" → "Số trận hòa"
2. Chọn sân: "Old Trafford"
3. Click "Tìm kiếm"
```
```
📌 Nói:
"Truy vấn 3: Đếm số trận hòa tại sân Old Trafford.
Truy vấn này phức tạp vì phải tính tổng bàn thắng 
của cả 2 đội trong mỗi trận, sau đó so sánh."
```

**Show logic phức tạp:**
```sql
-- Giải thích query
SELECT td.SanDau, COUNT(*) AS SoTranHoa
FROM vw_TranDau td
WHERE td.SanDau = 'Old Trafford'
AND (
    (SELECT SUM(SoTrai) FROM vw_ThamGia t1 
     JOIN vw_CauThu c1 ON t1.MaCT = c1.MaCT 
     WHERE t1.MaTD = td.MaTD AND c1.MaDB = td.MaDB1)
    =
    (SELECT SUM(SoTrai) FROM vw_ThamGia t2 
     JOIN vw_CauThu c2 ON t2.MaCT = c2.MaCT 
     WHERE t2.MaTD = td.MaTD AND c2.MaDB = td.MaDB2)
)
GROUP BY td.SanDau;
```

---

## 🎯 PHẦN 5: CHỨNG MINH TRONG SUỐT (2 phút)

### Trong suốt phân mảnh
```
📌 Demo:
1. Mở form Đội Bóng
2. SELECT * FROM vw_DoiBong
```
```
📌 Nói:
"User chỉ thấy 1 view duy nhất.
Không cần biết dữ liệu được chia thành 3 mảnh.
Đây là trong suốt phân mảnh."
```

### Trong suốt vị trí
```
📌 Demo:
INSERT vào vw_DoiBong
```
```
📌 Nói:
"Khi INSERT, user không cần chỉ định site.
Trigger tự động định tuyến dựa vào MaDB.
Đây là trong suốt vị trí."
```

### Kiểm tra lại trong SSMS
```sql
-- Show dữ liệu vừa INSERT
USE SiteC;
SELECT * FROM DoiBong_C WHERE MaDB = 'C999';
```
```
📌 Nói:
"Dữ liệu đã được lưu tự động vào Site C
mà user không cần biết."
```

---

## 📊 PHẦN 6: TỔNG KẾT (1 phút)

### Slide: Điểm nổi bật
```
📌 Nói:
"Tóm lại, đồ án đã hoàn thành:

✅ Phân mảnh ngang tự động theo MaDB
✅ View toàn cục UNION ALL 3 sites
✅ INSTEAD OF Trigger định tuyến INSERT/UPDATE/DELETE
✅ Ứng dụng Windows Forms CRUD đầy đủ
✅ 3 truy vấn phân tán phức tạp
✅ Đảm bảo trong suốt phân mảnh và vị trí

Cảm ơn thầy cô và các bạn đã theo dõi!"
```

---

## 💡 CÂU HỎI THƯỜNG GẶP TRONG DEMO

### Câu hỏi 1: "Tại sao dùng UNION ALL thay vì UNION?"
**Trả lời:**
```
"Em dùng UNION ALL vì:
1. Hiệu suất cao hơn (không cần loại bỏ trùng)
2. Dữ liệu đảm bảo không trùng do PRIMARY KEY
3. Đây là best practice cho Partitioned View"
```

### Câu hỏi 2: "Nếu Site A bị lỗi thì sao?"
**Trả lời:**
```
"Nếu Site A lỗi:
- View toàn cục vẫn query được Site B và C
- Nhưng dữ liệu của Site A sẽ không accessible
- Đây là limitation của mô hình này
- Giải pháp: Triển khai Replication và Failover"
```

### Câu hỏi 3: "Làm sao đảm bảo Foreign Key giữa các sites?"
**Trả lời:**
```
"Foreign Key được đảm bảo vì:
1. Cầu thủ và Đội bóng được phân mảnh CÙNG CHIẾN LƯỢC
2. CauThu.MaDB = 'A001' → Cả 2 đều ở Site A
3. Ràng buộc FK được enforce cục bộ tại mỗi site
4. Application logic validate trước khi INSERT"
```

### Câu hỏi 4: "Có xử lý concurrency không?"
**Trả lời:**
```
"Hiện tại chưa triển khai distributed locking.
SQL Server tự xử lý concurrency ở mức local transaction.
Để xử lý đầy đủ cần:
- Two-phase commit (2PC)
- Distributed Transaction Coordinator
- Đây là hướng phát triển của đồ án"
```

---

## 📋 CHECKLIST TRƯỚC KHI DEMO

- [ ] SQL Server đang chạy
- [ ] Đã chạy đủ 6 file SQL
- [ ] Application build thành công
- [ ] SSMS mở sẵn
- [ ] Application mở sẵn
- [ ] Đã chuẩn bị slide
- [ ] Test demo 1 lần trước
- [ ] Backup database (phòng lỗi)

---

## 🎬 FLOW DEMO NHANH (5 phút)

Nếu thời gian có hạn, demo theo flow này:

```
1. Giới thiệu (30s)
   → "4 databases, phân mảnh ngang, CRUD + 3 queries"

2. Show SSMS (1p)
   → "4 databases"
   → "View toàn cục"
   → "INSERT → Trigger → Site A"

3. Demo App (2p)
   → "CRUD Đội Bóng: INSERT + UPDATE + DELETE"
   → "Query 1: Cầu thủ theo CLB"

4. Kết luận (30s)
   → "Đạt được trong suốt phân mảnh và vị trí"

5. Q&A (1p)
```

---

**CHI TIẾT LIÊN HỆ**

Nếu có câu hỏi về kịch bản demo:
- Xem lại README.md
- Xem video demo mẫu (nếu có)
- Tham khảo ARCHITECTURE.md

**CHÚC BẠN DEMO THÀNH CÔNG! 🎉**
