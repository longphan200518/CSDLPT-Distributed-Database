# 🐳 HƯỚNG DẪN SETUP VỚI DOCKER

## 📋 YÊU CẦU

- **Docker Desktop** (Windows/Mac) hoặc **Docker Engine** (Linux)
- **.NET 8.0 SDK**
- **Visual Studio 2022** hoặc **VS Code**

---

## 🚀 BƯỚC 1: CÀI ĐẶT DOCKER (Nếu chưa có)

### Windows
1. Tải Docker Desktop: https://www.docker.com/products/docker-desktop
2. Cài đặt và khởi động Docker Desktop
3. Kiểm tra: Mở PowerShell và chạy:
```powershell
docker --version
docker-compose --version
```

### Linux
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io docker-compose -y
sudo systemctl start docker
sudo systemctl enable docker

# Kiểm tra
docker --version
docker-compose --version
```

---

## 🐳 BƯỚC 2: KHỞI ĐỘNG SQL SERVER TRONG DOCKER (2 phút)

### Cách 1: Sử dụng Docker Compose (Khuyến nghị)

```powershell
# Di chuyển vào thư mục dự án
cd C:\Users\Plonggg\Desktop\CSDLPT

# Khởi động SQL Server container
docker-compose up -d
```

**Giải thích:**
- `up`: Tạo và khởi động containers
- `-d`: Chạy ở chế độ detached (background)

**Kiểm tra container đang chạy:**
```powershell
docker ps
```

Bạn sẽ thấy:
```
CONTAINER ID   IMAGE                                        STATUS    PORTS
abc123...      mcr.microsoft.com/mssql/server:2022-latest   Up        0.0.0.0:1433->1433/tcp
```

### Cách 2: Sử dụng Docker CLI

```powershell
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" `
  -p 1433:1433 --name sqlserver-doibong `
  -d mcr.microsoft.com/mssql/server:2022-latest
```

---

## 💾 BƯỚC 3: KHỞI TẠO DATABASE (3 phút)

### Cách 1: Chạy scripts từ host machine

**Kết nối vào container và chạy scripts:**

```powershell
# Copy scripts vào container
docker cp Database/01_CreateDatabases.sql sqlserver-doibong:/tmp/
docker cp Database/02_CreateTables.sql sqlserver-doibong:/tmp/
docker cp Database/03_CreateViews.sql sqlserver-doibong:/tmp/
docker cp Database/04_CreateTriggers.sql sqlserver-doibong:/tmp/
docker cp Database/05_SampleData.sql sqlserver-doibong:/tmp/
docker cp Database/06_StoredProcedures.sql sqlserver-doibong:/tmp/

# Chạy từng script
docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -i /tmp/01_CreateDatabases.sql

docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -i /tmp/02_CreateTables.sql

docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -i /tmp/03_CreateViews.sql

docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -i /tmp/04_CreateTriggers.sql

docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -i /tmp/05_SampleData.sql

docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -i /tmp/06_StoredProcedures.sql
```

### Cách 2: Sử dụng Azure Data Studio hoặc SSMS

1. **Cài đặt Azure Data Studio**: https://aka.ms/azuredatastudio
2. **Kết nối đến SQL Server:**
   - Server: `localhost,1433`
   - Authentication: `SQL Login`
   - Username: `sa`
   - Password: `YourStrong@Passw0rd`
3. **Chạy từng script SQL** trong thư mục `Database/`

### Cách 3: Chạy script tự động (PowerShell)

Tạo file `init-database.ps1`:
```powershell
# init-database.ps1
$scripts = @(
    "01_CreateDatabases.sql",
    "02_CreateTables.sql",
    "03_CreateViews.sql",
    "04_CreateTriggers.sql",
    "05_SampleData.sql",
    "06_StoredProcedures.sql"
)

foreach ($script in $scripts) {
    Write-Host "Running $script..." -ForegroundColor Green
    
    docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
        -S localhost -U sa -P "YourStrong@Passw0rd" `
        -i "/usr/src/app/$script"
    
    Write-Host "✓ Completed $script" -ForegroundColor Green
}

Write-Host "`n✅ All scripts executed successfully!" -ForegroundColor Green
```

Chạy:
```powershell
.\init-database.ps1
```

---

## ✅ BƯỚC 4: KIỂM TRA DATABASE

### Kiểm tra từ command line:

```powershell
docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -Q "SELECT name FROM sys.databases WHERE name IN ('SiteA','SiteB','SiteC','GlobalDB')"
```

### Kiểm tra số lượng dữ liệu:

```powershell
docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -d GlobalDB `
  -Q "SELECT 'DoiBong' as [Table], COUNT(*) as [Count] FROM vw_DoiBong 
      UNION ALL 
      SELECT 'CauThu', COUNT(*) FROM vw_CauThu
      UNION ALL
      SELECT 'TranDau', COUNT(*) FROM vw_TranDau"
```

Kết quả mong đợi:
```
Table       Count
----------  -----
DoiBong     9
CauThu      27
TranDau     12
```

---

## 🖥️ BƯỚC 5: CHẠY ỨNG DỤNG

### Kiểm tra connection string

File: `Application/QuanLyDoiBong/DataAccess/DatabaseConnection.cs`

Đảm bảo connection string là:
```csharp
_connectionString = @"Server=localhost,1433;Database=GlobalDB;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;";
```

### Build và chạy ứng dụng:

```powershell
cd Application/QuanLyDoiBong
dotnet build
dotnet run
```

Hoặc mở trong Visual Studio và nhấn F5.

---

## 🛠️ CÁC LỆNH DOCKER HỮU ÍCH

### Xem logs của SQL Server:
```powershell
docker logs sqlserver-doibong
```

### Xem logs realtime:
```powershell
docker logs -f sqlserver-doibong
```

### Truy cập vào container (interactive shell):
```powershell
docker exec -it sqlserver-doibong bash
```

### Dừng container:
```powershell
docker-compose down
```

### Dừng và xóa volumes (xóa toàn bộ dữ liệu):
```powershell
docker-compose down -v
```

### Khởi động lại container:
```powershell
docker-compose restart
```

### Xem tài nguyên sử dụng:
```powershell
docker stats sqlserver-doibong
```

---

## 🔧 XỬ LÝ LỖI

### ❌ Lỗi: "Port 1433 already in use"

**Nguyên nhân:** Đã có SQL Server local đang chạy

**Giải pháp 1:** Dừng SQL Server local
```powershell
# Mở Services.msc
# Tìm "SQL Server (MSSQLSERVER)"
# Click Stop
```

**Giải pháp 2:** Đổi port trong docker-compose.yml
```yaml
ports:
  - "1434:1433"  # Dùng port 1434 thay vì 1433
```

Và cập nhật connection string:
```csharp
Server=localhost,1434;...
```

### ❌ Lỗi: "Cannot connect to SQL Server"

**Kiểm tra:**
1. Container đang chạy?
   ```powershell
   docker ps
   ```

2. SQL Server đã sẵn sàng?
   ```powershell
   docker logs sqlserver-doibong | Select-String "SQL Server is now ready"
   ```

3. Firewall có chặn không?
   - Tắt firewall tạm thời để test

### ❌ Lỗi: "Login failed for user 'sa'"

**Kiểm tra password:**
- Password phải khớp giữa docker-compose.yml và connection string
- Password phải đủ mạnh (chữ hoa, chữ thường, số, ký tự đặc biệt)

### ❌ Lỗi: "Database does not exist"

**Chạy lại scripts:**
```powershell
docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -Q "SELECT name FROM sys.databases"
```

Nếu không có GlobalDB, chạy lại script 01_CreateDatabases.sql

---

## 📊 BACKUP VÀ RESTORE

### Backup database:
```powershell
docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -Q "BACKUP DATABASE GlobalDB TO DISK = '/var/opt/mssql/backup/GlobalDB.bak'"

# Copy backup ra host
docker cp sqlserver-doibong:/var/opt/mssql/backup/GlobalDB.bak ./backup/
```

### Restore database:
```powershell
# Copy backup vào container
docker cp ./backup/GlobalDB.bak sqlserver-doibong:/var/opt/mssql/backup/

docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -Q "RESTORE DATABASE GlobalDB FROM DISK = '/var/opt/mssql/backup/GlobalDB.bak' WITH REPLACE"
```

---

## 🎯 TIPS & TRICKS

### 1. Tạo alias cho lệnh dài:
```powershell
# Thêm vào PowerShell profile
function sqlcmd-docker {
    docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
        -S localhost -U sa -P "YourStrong@Passw0rd" @args
}

# Sử dụng:
sqlcmd-docker -Q "SELECT @@VERSION"
```

### 2. Persist data khi xóa container:
Docker Compose đã cấu hình volume `sqlserver_data` để lưu dữ liệu.
Khi chạy `docker-compose down`, dữ liệu vẫn được giữ.

### 3. Xem dung lượng database:
```powershell
docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
  -S localhost -U sa -P "YourStrong@Passw0rd" `
  -Q "EXEC sp_spaceused"
```

---

## 🚀 PRODUCTION SETUP (Nâng cao)

### 1. Thay đổi SA password an toàn hơn:

Sử dụng environment variable:
```powershell
$env:SA_PASSWORD = "VerySecure@Password123"
docker-compose up -d
```

### 2. Sử dụng secrets (Docker Swarm):
```yaml
secrets:
  sa_password:
    file: ./secrets/sa_password.txt

services:
  sqlserver:
    secrets:
      - sa_password
    environment:
      - SA_PASSWORD_FILE=/run/secrets/sa_password
```

### 3. Monitoring với Prometheus:
Thêm SQL Server Exporter vào docker-compose.yml

---

## 📞 HỖ TRỢ

Nếu gặp vấn đề:
1. Xem logs: `docker logs sqlserver-doibong`
2. Kiểm tra health: `docker inspect sqlserver-doibong | Select-String "Health"`
3. Xem README.md chính để biết thêm chi tiết

---

**✅ HOÀN TẤT!**

Bây giờ bạn có một SQL Server chạy trong Docker với:
- 4 databases đã được tạo
- Dữ liệu mẫu đã được load
- Sẵn sàng để chạy ứng dụng

**Chạy ứng dụng:**
```powershell
cd Application/QuanLyDoiBong
dotnet run
```

🎉 **Chúc mừng!**
