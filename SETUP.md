# HƯỚNG DẪN SETUP NHANH

> **🐳 KHUYẾN NGHỊ**: Sử dụng Docker để setup nhanh hơn!  
> Xem file [DOCKER_SETUP.md](DOCKER_SETUP.md) để biết chi tiết.

---

## � OPTION 1: SETUP VỚI DOCKER (KHUYẾN NGHỊ - 3 phút)

### Bước 1: Cài đặt Docker Desktop
Tải và cài: https://www.docker.com/products/docker-desktop

### Bước 2: Khởi động SQL Server
```powershell
cd C:\Users\Plonggg\Desktop\CSDLPT
docker-compose up -d
```

### Bước 3: Chạy scripts khởi tạo
```powershell
# Copy scripts vào container
docker cp Database/01_CreateDatabases.sql sqlserver-doibong:/tmp/
docker cp Database/02_CreateTables.sql sqlserver-doibong:/tmp/
docker cp Database/03_CreateViews.sql sqlserver-doibong:/tmp/
docker cp Database/04_CreateTriggers.sql sqlserver-doibong:/tmp/
docker cp Database/05_SampleData.sql sqlserver-doibong:/tmp/
docker cp Database/06_StoredProcedures.sql sqlserver-doibong:/tmp/

# Chạy scripts
$scripts = @("01_CreateDatabases.sql", "02_CreateTables.sql", "03_CreateViews.sql", "04_CreateTriggers.sql", "05_SampleData.sql", "06_StoredProcedures.sql")
foreach ($s in $scripts) {
    docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -i "/tmp/$s"
}
```

**Kiểm tra:**
```powershell
docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -d GlobalDB -Q "SELECT COUNT(*) FROM vw_DoiBong"
```

➡️ **Bỏ qua Option 2, chuyển sang Bước 2 bên dưới**

---

## 💻 OPTION 2: SETUP VỚI SQL SERVER LOCAL (5 phút)

### Mở SQL Server Management Studio (SSMS)

### Chạy lần lượt các file SQL trong thư mục `Database/`:

```
1. 01_CreateDatabases.sql      ✅ Tạo 4 databases
2. 02_CreateTables.sql         ✅ Tạo bảng mảnh
3. 03_CreateViews.sql          ✅ Tạo view toàn cục  
4. 04_CreateTriggers.sql       ✅ Tạo triggers
5. 05_SampleData.sql           ✅ Chèn dữ liệu mẫu
6. 06_StoredProcedures.sql     ✅ Tạo stored procedures
```

### Kiểm tra:
```sql
USE GlobalDB;
SELECT COUNT(*) FROM vw_DoiBong;   -- Phải có 9
SELECT COUNT(*) FROM vw_CauThu;    -- Phải có 27
SELECT COUNT(*) FROM vw_TranDau;   -- Phải có 12
```

---

## 🖥️ BƯỚC 2: CẤU HÌNH CONNECTION STRING (1 phút)

### Nếu dùng Docker (Option 1):
File đã được cấu hình sẵn với:
```
Server=localhost,1433
User Id=sa
Password=YourStrong@Passw0rd
```

✅ Không cần thay đổi gì!

### Nếu dùng SQL Server Local (Option 2):
Mở file: `Application/QuanLyDoiBong/DataAccess/DatabaseConnection.cs`

Thay đổi connection string thành:
```csharp
_connectionString = @"Server=.;Database=GlobalDB;Integrated Security=True;TrustServerCertificate=True";
```

---

## ▶️ BƯỚC 3: CHẠY ỨNG DỤNG (1 phút)

### Cách 1: Dùng Visual Studio
```
1. Mở file: Application/QuanLyDoiBong/QuanLyDoiBong.csproj
2. Nhấn F5
```

### Cách 2: Dùng Command Line
```bash
cd Application/QuanLyDoiBong
dotnet build
dotnet run
```

---

## ✅ KIỂM TRA

Sau khi ứng dụng chạy:
1. Menu "Hệ Thống" → "Kiểm tra kết nối"
2. Nếu thành công → OK
3. Nếu lỗi → Xem phần "Xử lý lỗi" trong README.md

---

## 🎯 TEST NHANH

### Test CRUD:
1. Menu "Quản Lý" → "Đội Bóng"
2. Thêm đội mới với MaDB bắt đầu = A/B/C
3. Kiểm tra trong SSMS xem dữ liệu vào đúng site chưa

### Test Query:
1. Menu "Truy Vấn" → "Cầu thủ theo CLB"
2. Chọn "Manchester United"
3. Xem kết quả

---

## 🐛 LỖI THƯỜNG GẶP

### ❌ Docker: "Port 1433 already in use"
→ Dừng SQL Server local hoặc đổi port trong docker-compose.yml

### ❌ Docker: "Cannot connect to SQL Server"  
→ Kiểm tra container đang chạy: `docker ps`  
→ Xem logs: `docker logs sqlserver-doibong`

### ❌ "Cannot open database 'GlobalDB'"
→ Chưa chạy script SQL, chạy lại `01_CreateDatabases.sql`

### ❌ "The type or namespace name 'Forms' does not exist"
→ Build lại project: `dotnet build --no-incremental`

### ❌ "Login failed for user"
→ Sai connection string, kiểm tra lại username/password

---

## 📞 CẦN TRỢ GIÚP?

Xem file **README.md** để biết hướng dẫn chi tiết!
