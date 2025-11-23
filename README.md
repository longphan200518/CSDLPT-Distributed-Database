# Đồ án CSDL Phân Tán – Quản lý Đội Bóng

## 📖 Tài liệu đầy đủ
👉 **[Báo cáo chi tiết (6 chương)](docs/BAO_CAO_CHI_TIET.md)**

## 1. Giới thiệu
Hệ thống quản lý đội bóng, cầu thủ, huấn luyện viên, trận đấu và tham gia, triển khai trên kiến trúc **Cơ sở Dữ liệu Phân tán** với SQL Server. 

### Đặc điểm chính
- ⚡ **Phân mảnh ngang**: DoiBong, CauThu, TranDau, ThamGia (theo `ABS(key) % 3`)
- 📊 **Phân mảnh dọc**: HuanLuyenVien (chia theo cột - Basic/Additional/History)
- 🔍 **Trong suốt**: Phân mảnh, vị trí, ánh xạ cục bộ
- 🐳 **Docker**: Triển khai nhanh với docker-compose
- 🌐 **Web UI**: PHP + Bootstrap responsive

### Kiến trúc
```
3 Site Databases (SiteA, SiteB, SiteC)
    ↓
GlobalDB (Views + Triggers)
    ↓
PHP Application (CRUD + Queries)
```

## 2. Cấu trúc dự án
```
CSDLPT/
├── docs/
│   └── BAO_CAO_CHI_TIET.md      # Báo cáo 6 chương đầy đủ
├── docker/
│   ├── docker-compose.yml        # Cấu hình services
│   ├── Dockerfile                # PHP + SQL Server drivers
│   └── sql/
├── sql/
│   └── init-db.sql               # Script khởi tạo DB
├── src/
│   ├── index.php                 # Trang chủ
│   ├── assets/style.css          # Giao diện
│   ├── crud/                     # Quản lý CRUD
│   │   ├── doibong.php
│   │   ├── cauthu.php
│   │   ├── trandau.php
│   │   ├── thamgia.php
│   │   └── huanluyenvien.php    # Phân mảnh dọc
│   ├── includes/
│   │   ├── db.php
│   │   ├── header.php
│   │   └── footer.php
│   └── queries/                  # Truy vấn đặc biệt
│       ├── clb_cauthu.php
│       ├── so_tran_cauthu.php
│       ├── so_tran_hoa.php
│       └── hlv_theo_giaidau.php
└── README.md
```

## 3. Hướng dẫn chạy

### 3.1. Yêu cầu hệ thống
- Docker Desktop (Windows/Mac/Linux)
- RAM: ≥ 4GB
- Port 8080, 1433 chưa bị chiếm

### 3.2. Khởi động dự án
```powershell
# 1. Di chuyển vào thư mục docker
cd docker

# 2. Khởi động containers
docker compose up -d --build

# 3. Kiểm tra trạng thái
docker compose ps

# 4. Chờ SQL Server khởi tạo (30-60s)
docker logs mssql -f

# 5. Chạy script khởi tạo database (nếu cần)
docker compose run --rm db-init
```

### 3.3. Truy cập ứng dụng
- **Web UI**: http://localhost:8080
- **SQL Server**: localhost:1433
  - User: `SA`
  - Password: `YourStrong!Passw0rd`
  - Database: `GlobalDB`

### 3.4. Dừng dự án
```powershell
docker compose down          # Dừng và xóa containers
docker compose down -v       # Xóa cả volumes (dữ liệu)
```

## 4. Kiến trúc phân mảnh

### 4.1. Phân mảnh ngang (Horizontal Fragmentation)
**Công thức**: `site = ABS(key) % 3`

| Key % 3 | Site | Ví dụ MaDB | Số đội |
|---------|------|------------|--------|
| 0 | SiteA | 1, 4, 6, 9, 12, 15, 18 | 6 |
| 1 | SiteB | 7, 10, 13, 16 | 6 |
| 2 | SiteC | 2, 3, 5, 8, 11, 14, 17 | 6 |

**Áp dụng cho**: DoiBong, CauThu, TranDau, ThamGia

**View toàn cục**:
```sql
CREATE VIEW DoiBong AS
SELECT * FROM SiteA.dbo.DoiBong UNION ALL
SELECT * FROM SiteB.dbo.DoiBong UNION ALL
SELECT * FROM SiteC.dbo.DoiBong;
```

### 4.2. Phân mảnh dọc (Vertical Fragmentation)
**Bảng HuanLuyenVien** được chia theo cột:

| Fragment | Thuộc tính | Site | Mục đích |
|----------|-----------|------|----------|
| HLV_Basic | MaHLV, HoTen, QuocTich | SiteA | Thông tin cơ bản |
| HLV_Additional | MaHLV, MaDB | SiteB | Thông tin bổ sung |
| HLV_History | MaHLV, NamKinhNghiem, ChucVuTruoc, ThanhTich | SiteC | Lịch sử (tuỳ chọn) |

**View toàn cục** (LEFT JOIN cho phép fragment không đầy đủ):
```sql
CREATE VIEW HuanLuyenVien AS
SELECT b.MaHLV, b.HoTen, b.QuocTich,
       a.MaDB, a.NgaySinh, a.SoDienThoai,
       h.NamKinhNghiem, h.ChucVuTruoc, h.ThanhTich
FROM SiteA.dbo.HLV_Basic b
LEFT JOIN SiteB.dbo.HLV_Additional a ON b.MaHLV = a.MaHLV
LEFT JOIN SiteC.dbo.HLV_History h ON b.MaHLV = h.MaHLV;
```

### 4.3. Trigger tự động định tuyến
```sql
CREATE TRIGGER trg_DoiBong_IO ON DoiBong INSTEAD OF INSERT, UPDATE, DELETE
AS BEGIN
    -- Xóa từ tất cả sites
    IF EXISTS(SELECT 1 FROM deleted) BEGIN
        DELETE FROM SiteA.dbo.DoiBong WHERE MaDB IN (SELECT MaDB FROM deleted);
        DELETE FROM SiteB.dbo.DoiBong WHERE MaDB IN (SELECT MaDB FROM deleted);
        DELETE FROM SiteC.dbo.DoiBong WHERE MaDB IN (SELECT MaDB FROM deleted);
    END
    
    -- Thêm/Sửa phân mảnh theo ABS(MaDB) % 3
    IF EXISTS(SELECT 1 FROM inserted) BEGIN
        MERGE SiteA.dbo.DoiBong USING 
            (SELECT * FROM inserted WHERE ABS(MaDB)%3=0) AS src ...
        -- Tương tự cho SiteB, SiteC
    END
END;
```

## 5. Chức năng hệ thống

### 5.1. CRUD Operations
| Module | Chức năng | Phân mảnh |
|--------|-----------|-----------|
| Đội bóng | Thêm/Sửa/Xóa/Xem | Ngang |
| Cầu thủ | Thêm/Sửa/Xóa/Xem | Ngang |
| Trận đấu | Thêm/Sửa/Xóa/Xem | Ngang |
| Tham gia | Thêm/Sửa/Xóa/Xem | Ngang |
| Huấn luyện viên | Thêm/Sửa/Xóa/Xem | **Dọc (3 fragments)** |

### 5.2. Truy vấn đặc biệt

**Phân mảnh ngang:**
1. **Cầu thủ theo CLB/Giải đấu**
   ```sql
   SELECT c.* FROM CauThu c 
   JOIN DoiBong d ON c.MaDB=d.MaDB 
   WHERE d.GiaiDau='Premier League';
   ```

2. **Số trận cầu thủ tham gia**
   ```sql
   SELECT c.HoTen, COUNT(t.MaTD) AS SoTran
   FROM CauThu c JOIN ThamGia t ON c.MaCT=t.MaCT
   WHERE c.HoTen='Erling Haaland'
   GROUP BY c.HoTen;
   ```

3. **Số trận hòa tại sân đấu**
   ```sql
   SELECT COUNT(*) FROM TranDau td
   WHERE td.SanDau='Etihad Stadium'
   AND (SELECT SUM(SoTrai) FROM ThamGia t1 JOIN CauThu c1 
        ON t1.MaCT=c1.MaCT WHERE t1.MaTD=td.MaTD AND c1.MaDB=td.MaDB1)
   = (SELECT SUM(SoTrai) FROM ThamGia t2 JOIN CauThu c2 
      ON t2.MaCT=c2.MaCT WHERE t2.MaTD=td.MaTD AND c2.MaDB=td.MaDB2);
   ```

**Phân mảnh dọc:**
4. **HLV theo giải đấu** (JOIN fragments dọc + phân mảnh ngang)
   ```sql
   SELECT h.HoTen, h.QuocTich, d.TenDB
   FROM HuanLuyenVien h
   JOIN DoiBong d ON h.MaDB=d.MaDB
   WHERE d.GiaiDau='La Liga'
   ORDER BY h.NamKinhNghiem DESC;
   ```

### 5.3. Dữ liệu mẫu
- **18 đội bóng** từ Premier League, La Liga, Serie A, Bundesliga, Ligue 1
- **45 cầu thủ** thực tế (Haaland, Salah, Mbappé, Kane...)
- **18 huấn luyện viên** (Guardiola, Klopp, Ancelotti...)
- **12 trận đấu** với kết quả chi tiết

## 6. Công nghệ sử dụng

| Thành phần | Công nghệ | Phiên bản |
|-----------|-----------|-----------|
| **Database** | Microsoft SQL Server | 2022 Express |
| **Backend** | PHP | 8.2 |
| **Web Server** | Apache | 2.4 |
| **Frontend** | Bootstrap | 5.3.3 |
| **Containerization** | Docker | Latest |
| **Driver** | SQL Server ODBC | 18 |
| **OS** | Debian (container) | 12 Bookworm |

## 7. Ưu điểm & Hạn chế

### ✅ Ưu điểm
- **Cân bằng tải**: Phân bố dữ liệu đều qua 3 site
- **Trong suốt**: Người dùng không cần biết cách phân mảnh
- **Linh hoạt**: Kết hợp cả phân mảnh ngang và dọc
- **Bảo mật**: Tách thông tin nhạy cảm (phân mảnh dọc)
- **Mở rộng**: Dễ thêm site mới
- **Performance**: Truy vấn cục bộ nhanh hơn

### ⚠️ Hạn chế
- **JOIN phân tán**: Truy vấn liên site chậm hơn
- **Độ phức tạp**: Trigger và view phức tạp hơn CSDL tập trung
- **Overhead**: Chi phí đồng bộ và quản lý
- **Transaction**: Giao dịch phân tán phức tạp (2PC)

## 8. Mở rộng & Ứng dụng

### 8.1. Mở rộng hiện tại
- [x] Phân mảnh ngang theo hash
- [x] Phân mảnh dọc cho HuanLuyenVien
- [x] View toàn cục + Triggers
- [x] CRUD đầy đủ
- [x] Truy vấn phức tạp

### 8.2. Hướng phát triển
- [ ] Replication cho high availability
- [ ] Sharding động khi dữ liệu tăng
- [ ] Caching layer (Redis)
- [ ] Authentication & Authorization
- [ ] RESTful API
- [ ] Mobile app

### 8.3. Ứng dụng tương tự
**Kiến trúc này có thể áp dụng cho:**
- 🛒 **E-commerce**: Phân mảnh theo khu vực/chi nhánh
- 🏦 **Banking**: Phân mảnh theo loại tài khoản/chi nhánh
- 📦 **Supply Chain**: Phân mảnh theo kho/vùng
- 🌐 **IoT**: Phân mảnh theo sensor/location
- 📊 **Big Data**: Phân mảnh theo thời gian/partition key

## 9. Troubleshooting

### Lỗi thường gặp

**1. SQL Server không khởi động**
```powershell
# Kiểm tra logs
docker logs mssql

# Tăng memory cho Docker (Settings > Resources > Memory: 4GB+)
# Chờ thêm 30-60s cho SQL Server khởi động hoàn tất
```

**2. Port 1433 hoặc 8080 bị chiếm**
```powershell
# Kiểm tra port
netstat -ano | findstr :1433
netstat -ano | findstr :8080

# Đổi port trong docker-compose.yml
# ports: "1434:1433"  # SQL Server
# ports: "8081:80"    # PHP
```

**3. Không kết nối được database**
```powershell
# Kiểm tra connection từ container
docker exec -it mssql /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U SA -P 'YourStrong!Passw0rd' `
  -Q "SELECT name FROM sys.databases"

# Kiểm tra GlobalDB đã tồn tại
docker exec -it mssql /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U SA -P 'YourStrong!Passw0rd' `
  -Q "SELECT * FROM GlobalDB.dbo.DoiBong"
```

**4. Init script không chạy**
```powershell
# Chạy thủ công
docker compose run --rm db-init

# Hoặc exec trực tiếp
docker exec -it mssql /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U SA -P 'YourStrong!Passw0rd' `
  -d master -i /init/init-db.sql
```

**5. Xóa hoàn toàn và chạy lại**
```powershell
docker compose down -v      # Xóa containers + volumes
docker system prune -a      # Xóa images cũ (optional)
docker compose up -d --build
```

## 10. Tài liệu tham khảo

### Lý thuyết
- [Distributed Database Systems - Özsu & Valduriez](https://www.springer.com/gp/book/9783030262525)
- [Database System Concepts - Silberschatz](https://www.db-book.com/)
- [Microsoft SQL Server Documentation](https://docs.microsoft.com/en-us/sql/)

### Công nghệ
- [Docker Documentation](https://docs.docker.com/)
- [PHP SQL Server Driver](https://docs.microsoft.com/en-us/sql/connect/php/)
- [Bootstrap 5 Documentation](https://getbootstrap.com/docs/5.3/)

### Báo cáo
- 📄 **[Báo cáo chi tiết 6 chương](docs/BAO_CAO_CHI_TIET.md)**

## 11. Liên hệ & Đóng góp

**Tác giả**: [Tên sinh viên]  
**Giảng viên hướng dẫn**: [Tên GV]  
**Môn học**: Cơ sở Dữ liệu Phân tán  
**Năm**: 2025

### Đóng góp
Mọi đóng góp đều được chào đón! Vui lòng:
1. Fork repository
2. Tạo branch mới (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

### License
MIT License - xem file [LICENSE](LICENSE) để biết chi tiết

---

⭐ **Nếu dự án hữu ích, hãy cho 1 star!**
