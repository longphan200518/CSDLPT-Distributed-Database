# ĐỒ ÁN MÔN HỌC: CƠ SỞ DỮ LIỆU PHÂN TÁN
## Hệ Thống Quản Lý Đội Bóng

---

## 📋 MỤC LỤC
1. [Giới thiệu](#giới-thiệu)
2. [Lược đồ cơ sở dữ liệu](#lược-đồ-cơ-sở-dữ-liệu)
3. [Kiến trúc hệ thống](#kiến-trúc-hệ-thống)
4. [Hướng dẫn cài đặt](#hướng-dẫn-cài-đặt)
5. [Hướng dẫn sử dụng](#hướng-dẫn-sử-dụng)
6. [Cấu trúc dự án](#cấu-trúc-dự-án)
7. [Mức trong suốt](#mức-trong-suốt)

---

## 🎯 GIỚI THIỆU

### Mô tả đề tài
Đề tài mô phỏng **hệ thống quản lý đội bóng, cầu thủ và trận đấu**, được triển khai trong môi trường **cơ sở dữ liệu phân tán**.

### Mục tiêu
- Triển khai hệ thống CSDL phân tán trên SQL Server
- Đảm bảo tính **trong suốt phân mảnh** và **trong suốt vị trí**
- Xây dựng ứng dụng Windows Forms cho phép CRUD trên dữ liệu toàn cục
- Thực hiện 3 truy vấn đặc biệt theo yêu cầu

### Công nghệ sử dụng
- **Database**: SQL Server (4 databases: SiteA, SiteB, SiteC, GlobalDB)
- **Backend**: C# .NET 8.0
- **Frontend**: Windows Forms
- **Pattern**: DAO Pattern

---

## 📊 LƯỢC ĐỒ CƠ SỞ DỮ LIỆU

### Global Schema

```
DoiBong(MaDB, TenDB, CLB)
CauThu(MaCT, HoTen, MaDB)
TranDau(MaTD, MaDB1, MaDB2, TrongTai, SanDau)
ThamGia(MaTD, MaCT, SoTrai)
```

### Ý nghĩa các bảng

| Bảng | Mô tả |
|------|-------|
| **DoiBong** | Thông tin đội bóng: mã đội, tên đội, câu lạc bộ |
| **CauThu** | Thông tin cầu thủ: mã cầu thủ, họ tên, mã đội |
| **TranDau** | Thông tin trận đấu: mã trận, 2 đội thi đấu, trọng tài, sân đấu |
| **ThamGia** | Cầu thủ tham gia trận nào, ghi được bao nhiêu bàn |

### Ràng buộc toàn vẹn
```sql
CauThu.MaDB → DoiBong.MaDB
ThamGia.MaCT → CauThu.MaCT
ThamGia.MaTD → TranDau.MaTD
```

---

## 🏗️ KIẾN TRÚC HỆ THỐNG

### Mô hình phân tán

```
┌─────────────────────────────────────────────┐
│         Ứng Dụng Windows Forms              │
│    (Chỉ thao tác trên View toàn cục)       │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│            GlobalDB (Database)              │
│  ┌─────────────────────────────────────┐   │
│  │  View toàn cục (UNION ALL)          │   │
│  │  - vw_DoiBong                       │   │
│  │  - vw_CauThu                        │   │
│  │  - vw_TranDau                       │   │
│  │  - vw_ThamGia                       │   │
│  └─────────────────────────────────────┘   │
│  ┌─────────────────────────────────────┐   │
│  │  INSTEAD OF Triggers                │   │
│  │  - Định tuyến INSERT/UPDATE/DELETE  │   │
│  └─────────────────────────────────────┘   │
└──────────┬──────────┬──────────┬────────────┘
           │          │          │
           ▼          ▼          ▼
    ┌──────────┐ ┌──────────┐ ┌──────────┐
    │  SiteA   │ │  SiteB   │ │  SiteC   │
    │ (MaDB=A*)│ │ (MaDB=B*)│ │ (MaDB=C*)│
    └──────────┘ └──────────┘ └──────────┘
```

### Chiến lược phân mảnh
- **Horizontal Fragmentation** (Phân mảnh ngang)
- **Phân mảnh theo MaDB**:
  - Site A: Lưu đội bóng có `MaDB LIKE 'A%'`
  - Site B: Lưu đội bóng có `MaDB LIKE 'B%'`
  - Site C: Lưu đội bóng có `MaDB LIKE 'C%'`

### Cơ chế INSTEAD OF Trigger
Khi người dùng thực hiện INSERT/UPDATE/DELETE trên view toàn cục:
1. Trigger chặn thao tác
2. Xác định site đích dựa trên MaDB
3. Thực thi trên bảng mảnh tương ứng

---

## 💾 HƯỚNG DẪN CÀI ĐẶT

### Yêu cầu hệ thống

**Option 1: Sử dụng Docker (Khuyến nghị)**
- **Docker Desktop** (Windows/Mac) hoặc **Docker Engine** (Linux)
- **.NET 8.0 SDK**
- **Visual Studio 2022** hoặc **VS Code**
- **4GB RAM** tối thiểu cho Docker

**Option 2: Sử dụng SQL Server Local**
- **SQL Server 2019+** (Express, Developer hoặc Enterprise)
- **.NET 8.0 SDK**
- **Visual Studio 2022** hoặc **VS Code**
- **Windows 10/11**

> **🐳 KHUYẾN NGHỊ**: Sử dụng Docker để dễ dàng setup và không cần cài SQL Server local!

---

### 🐳 OPTION 1: Setup với Docker (3 phút)

#### Bước 1.1: Cài đặt Docker Desktop

Tải và cài đặt Docker Desktop từ: https://www.docker.com/products/docker-desktop

Kiểm tra Docker đã cài thành công:
```powershell
docker --version
docker-compose --version
```

#### Bước 1.2: Khởi động SQL Server container

```powershell
# Di chuyển vào thư mục dự án
cd C:\Users\Plonggg\Desktop\CSDLPT

# Khởi động SQL Server trong Docker
docker-compose up -d
```

Kiểm tra container đang chạy:
```powershell
docker ps
```

#### Bước 1.3: Chạy các script SQL

**Cách 1: Copy và chạy từng script**
```powershell
# Copy scripts vào container
docker cp Database/01_CreateDatabases.sql sqlserver-doibong:/tmp/
docker cp Database/02_CreateTables.sql sqlserver-doibong:/tmp/
docker cp Database/03_CreateViews.sql sqlserver-doibong:/tmp/
docker cp Database/04_CreateTriggers.sql sqlserver-doibong:/tmp/
docker cp Database/05_SampleData.sql sqlserver-doibong:/tmp/
docker cp Database/06_StoredProcedures.sql sqlserver-doibong:/tmp/

# Chạy lần lượt các scripts
$scripts = @("01_CreateDatabases.sql", "02_CreateTables.sql", "03_CreateViews.sql", "04_CreateTriggers.sql", "05_SampleData.sql", "06_StoredProcedures.sql")
foreach ($script in $scripts) {
    Write-Host "Running $script..." -ForegroundColor Green
    docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
        -S localhost -U sa -P "YourStrong@Passw0rd" `
        -i "/tmp/$script"
}
```

**Cách 2: Sử dụng Azure Data Studio**
1. Tải Azure Data Studio: https://aka.ms/azuredatastudio
2. Kết nối:
   - Server: `localhost,1433`
   - Authentication: `SQL Login`
   - Username: `sa`
   - Password: `YourStrong@Passw0rd`
3. Chạy từng file SQL trong thư mục `Database/`

#### Bước 1.4: Kiểm tra database

```powershell
docker exec -it sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
    -S localhost -U sa -P "YourStrong@Passw0rd" `
    -d GlobalDB `
    -Q "SELECT COUNT(*) AS DoiBong FROM vw_DoiBong; SELECT COUNT(*) AS CauThu FROM vw_CauThu;"
```

Expected: DoiBong = 9, CauThu = 27

**➡️ Chuyển sang Bước 2**

---

### 💻 OPTION 2: Setup với SQL Server Local (5 phút)

### Bước 1: Cài đặt Database

#### 1.1. Mở SQL Server Management Studio (SSMS)

#### 1.2. Chạy các script theo thứ tự

```bash
cd Database
```

**Chạy lần lượt:**

1. `01_CreateDatabases.sql` - Tạo 4 databases
2. `02_CreateTables.sql` - Tạo bảng mảnh tại mỗi site
3. `03_CreateViews.sql` - Tạo view toàn cục
4. `04_CreateTriggers.sql` - Tạo trigger định tuyến
5. `05_SampleData.sql` - Chèn dữ liệu mẫu
6. `06_StoredProcedures.sql` - Tạo stored procedures

#### 1.3. Kiểm tra kết quả

```sql
-- Kiểm tra dữ liệu đã được phân bổ đúng
USE GlobalDB;
SELECT COUNT(*) FROM vw_DoiBong;   -- Phải có 9 đội
SELECT COUNT(*) FROM vw_CauThu;    -- Phải có 27 cầu thủ
SELECT COUNT(*) FROM vw_TranDau;   -- Phải có 12 trận

-- Kiểm tra phân bố tại site
SELECT COUNT(*) FROM SiteA.dbo.DoiBong_A;  -- 3 đội
SELECT COUNT(*) FROM SiteB.dbo.DoiBong_B;  -- 3 đội
SELECT COUNT(*) FROM SiteC.dbo.DoiBong_C;  -- 3 đội
```

### Bước 2: Cấu hình Connection String

**Nếu dùng Docker (Option 1):**

Connection string đã được cấu hình sẵn:
```csharp
Server=localhost,1433;Database=GlobalDB;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True
```

✅ **Không cần thay đổi gì!** Chuyển sang Bước 3.

---

**Nếu dùng SQL Server Local (Option 2):**

Mở file `Application/QuanLyDoiBong/DataAccess/DatabaseConnection.cs`

Sửa connection string thành:

```csharp
_connectionString = @"Server=.;Database=GlobalDB;Integrated Security=True;TrustServerCertificate=True";
```

**Lưu ý:**
- `Server=.` → Máy local
- `Server=localhost` hoặc `Server=127.0.0.1` cũng được
- Nếu dùng SQL Authentication: `User Id=sa;Password=yourpassword`

### Bước 3: Build và chạy ứng dụng

#### 3.1. Sử dụng Visual Studio
```
1. Mở file QuanLyDoiBong.csproj
2. Nhấn F5 hoặc chọn Debug > Start Debugging
```

#### 3.2. Sử dụng Command Line
```bash
cd Application/QuanLyDoiBong
dotnet build
dotnet run
```

---

## 📖 HƯỚNG DẪN SỬ DỤNG

### Menu chính

Sau khi khởi động ứng dụng, bạn sẽ thấy menu:

```
┌─────────────────────────────────────────┐
│ Quản Lý | Truy Vấn | Hệ Thống          │
└─────────────────────────────────────────┘
```

### 1️⃣ Menu Quản Lý (CRUD)

#### Quản lý Đội Bóng
- **Thêm**: Nhập MaDB (bắt buộc bắt đầu A, B hoặc C), TenDB, CLB → Nhấn "Thêm"
- **Sửa**: Click chọn dòng trên DataGridView → Sửa thông tin → Nhấn "Sửa"
- **Xóa**: Click chọn dòng → Nhấn "Xóa" → Xác nhận
- **Làm mới**: Xóa form và tải lại dữ liệu

#### Quản lý Cầu Thủ
- Tương tự Đội Bóng
- Chọn đội bóng từ ComboBox

#### Quản lý Trận Đấu
- Nhập thông tin trận đấu
- Chọn đội 1 và đội 2 từ ComboBox

#### Quản lý Tham Gia
- Chọn trận đấu
- Chọn cầu thủ
- Nhập số bàn thắng

### 2️⃣ Menu Truy Vấn

#### Query 1: Cầu thủ theo CLB
```
Mục đích: Tìm tất cả cầu thủ thuộc một câu lạc bộ
Input: Chọn CLB từ ComboBox
Output: Danh sách cầu thủ (MaCT, HoTen, TenDB, CLB)
```

**Ví dụ:**
- Chọn CLB: "Manchester United"
- Kết quả: 3 cầu thủ thuộc MU

#### Query 2: Số trận cầu thủ tham gia
```
Mục đích: Đếm số trận đấu một cầu thủ đã tham gia
Input: Nhập họ tên cầu thủ (có thể nhập một phần)
Output: MaCT, HoTen, Số trận tham gia, Tổng bàn thắng
```

**Ví dụ:**
- Nhập: "Nguyễn"
- Kết quả: Tất cả cầu thủ có họ "Nguyễn" và số trận của họ

#### Query 3: Số trận hòa tại sân
```
Mục đích: Đếm số trận hòa tại một sân đấu
Input: Chọn sân đấu từ ComboBox
Output: Sân đấu, Số trận hòa
```

**Ví dụ:**
- Chọn: "Old Trafford"
- Kết quả: 1 trận hòa

### 3️⃣ Menu Hệ Thống

#### Kiểm tra kết nối
- Kiểm tra xem kết nối tới GlobalDB có thành công không
- Hiển thị thông báo lỗi nếu không kết nối được

#### Thoát
- Đóng ứng dụng

---

## 📁 CẤU TRÚC DỰ ÁN

```
CSDLPT/
│
├── Database/                           # SQL Scripts
│   ├── 01_CreateDatabases.sql         # Tạo 4 databases
│   ├── 02_CreateTables.sql            # Tạo bảng mảnh
│   ├── 03_CreateViews.sql             # Tạo view toàn cục
│   ├── 04_CreateTriggers.sql          # Tạo INSTEAD OF triggers
│   ├── 05_SampleData.sql              # Dữ liệu mẫu
│   └── 06_StoredProcedures.sql        # Stored procedures
│
├── Application/                        # Ứng dụng Windows Forms
│   └── QuanLyDoiBong/
│       ├── Models/                     # Lớp Entity
│       │   ├── DoiBong.cs
│       │   ├── CauThu.cs
│       │   ├── TranDau.cs
│       │   └── ThamGia.cs
│       │
│       ├── DataAccess/                 # Lớp truy cập dữ liệu (DAO)
│       │   ├── DatabaseConnection.cs
│       │   ├── DoiBongDAO.cs
│       │   ├── CauThuDAO.cs
│       │   ├── TranDauDAO.cs
│       │   ├── ThamGiaDAO.cs
│       │   └── QueryDAO.cs
│       │
│       ├── Forms/                      # Các form giao diện
│       │   ├── frmDoiBong.cs          # CRUD Đội bóng
│       │   ├── frmCauThu.cs           # CRUD Cầu thủ
│       │   ├── frmTranDau.cs          # CRUD Trận đấu
│       │   ├── frmThamGia.cs          # CRUD Tham gia
│       │   ├── frmQuery1.cs           # Query theo CLB
│       │   ├── frmQuery2.cs           # Query số trận
│       │   └── frmQuery3.cs           # Query trận hòa
│       │
│       ├── Form1.cs                    # Main Form (Menu chính)
│       ├── Program.cs                  # Entry point
│       └── QuanLyDoiBong.csproj       # Project file
│
└── Documentation/                      # Tài liệu
    └── README.md                       # File này
```

---

## 🔍 MỨC TRONG SUỐT

### 1. Trong suốt phân mảnh (Fragmentation Transparency)

**Định nghĩa:** Người dùng không cần biết dữ liệu được phân mảnh như thế nào.

**Thể hiện:**
- Ứng dụng chỉ thao tác trên `vw_DoiBong`, `vw_CauThu`, `vw_TranDau`, `vw_ThamGia`
- Không cần quan tâm dữ liệu nằm ở bảng `DoiBong_A`, `DoiBong_B` hay `DoiBong_C`

**Ví dụ:**
```csharp
// Người dùng chỉ thấy:
SELECT * FROM vw_DoiBong;

// Thực tế SQL Server thực hiện:
SELECT * FROM SiteA.dbo.DoiBong_A
UNION ALL
SELECT * FROM SiteB.dbo.DoiBong_B
UNION ALL
SELECT * FROM SiteC.dbo.DoiBong_C
```

### 2. Trong suốt vị trí (Location Transparency)

**Định nghĩa:** Người dùng không cần biết dữ liệu được lưu ở site nào.

**Thể hiện:**
- View toàn cục tham chiếu trực tiếp đến database site: `SiteA.dbo.DoiBong_A`
- INSTEAD OF Trigger tự động định tuyến INSERT/UPDATE/DELETE đến đúng site

**Ví dụ:**
```sql
-- Người dùng thực hiện:
INSERT INTO vw_DoiBong VALUES ('A001', 'Arsenal', 'Arsenal FC');

-- Trigger tự động chuyển thành:
INSERT INTO SiteA.dbo.DoiBong_A VALUES ('A001', 'Arsenal', 'Arsenal FC');
```

### 3. Không đạt được (trong phạm vi đề tài)

❌ **Trong suốt sao chép (Replication Transparency)**
- Không triển khai replication
- Dữ liệu chỉ tồn tại 1 bản duy nhất tại mỗi site

❌ **Trong suốt lỗi (Failure Transparency)**
- Không xử lý lỗi tự động recover
- Nếu 1 site lỗi → Không thể truy cập dữ liệu site đó

---

## 🧪 TEST CASE

### Test 1: Kiểm tra phân mảnh tự động

```sql
-- Thêm đội bóng vào view toàn cục
INSERT INTO GlobalDB.dbo.vw_DoiBong VALUES ('A999', 'Test Team A', 'Test CLB');
INSERT INTO GlobalDB.dbo.vw_DoiBong VALUES ('B999', 'Test Team B', 'Test CLB');

-- Kiểm tra dữ liệu đã vào đúng site
SELECT * FROM SiteA.dbo.DoiBong_A WHERE MaDB = 'A999';  -- Phải có
SELECT * FROM SiteB.dbo.DoiBong_B WHERE MaDB = 'B999';  -- Phải có
```

### Test 2: Kiểm tra trigger UPDATE

```sql
UPDATE GlobalDB.dbo.vw_DoiBong 
SET TenDB = 'Updated Name' 
WHERE MaDB = 'A001';

SELECT * FROM SiteA.dbo.DoiBong_A WHERE MaDB = 'A001';  -- Phải thấy tên mới
```

### Test 3: Kiểm tra truy vấn toàn cục

```sql
EXEC GlobalDB.dbo.sp_GetCauThuTheoCLB @CLB = 'Manchester United';
EXEC GlobalDB.dbo.sp_GetSoTranThamGia @HoTen = 'Nguyễn Văn An';
EXEC GlobalDB.dbo.sp_GetSoTranHoaTaiSan @SanDau = 'Old Trafford';
```

---

## 🐛 XỬ LÝ LỖI THƯỜNG GẶP

### Lỗi 1: Không kết nối được database
```
Lỗi: "Cannot open database 'GlobalDB'"
```
**Giải pháp:**
- Kiểm tra SQL Server đã khởi động
- Chạy lại `01_CreateDatabases.sql`
- Kiểm tra connection string

### Lỗi 2: Trigger không hoạt động
```
Lỗi: "The INSERT statement conflicted with the FOREIGN KEY constraint"
```
**Giải pháp:**
- Đảm bảo đã chạy `04_CreateTriggers.sql`
- Kiểm tra MaDB phải bắt đầu bằng A, B hoặc C

### Lỗi 3: View trả về dữ liệu trùng lặp
```
Hiện tượng: Dữ liệu bị double
```
**Giải pháp:**
- Kiểm tra không có dữ liệu duplicate ở các site
- Dùng UNION ALL (không phải UNION) để tăng performance

---

## 📚 TÀI LIỆU THAM KHẢO

1. **Distributed Database Systems** - M. Tamer Özsu, Patrick Valduriez
2. **SQL Server Documentation** - Microsoft Docs
3. **C# Windows Forms Best Practices** - Microsoft Learn

---

## 👥 THÔNG TIN

**Đồ án môn học:** Cơ sở dữ liệu phân tán  
**Năm học:** 2024-2025  
**Công nghệ:** SQL Server, C#, Windows Forms  

---

## 📞 HỖ TRỢ

Nếu gặp vấn đề khi cài đặt hoặc chạy ứng dụng:
1. Kiểm tra lại từng bước trong hướng dẫn
2. Xem phần "Xử lý lỗi thường gặp"
3. Kiểm tra log trong SSMS

---

**CHI TI TẾT KỸ THUẬT BỔ SUNG**

## Cơ chế hoạt động của INSTEAD OF Trigger

```sql
-- Ví dụ trigger INSERT cho DoiBong
CREATE TRIGGER trg_DoiBong_Insert
ON vw_DoiBong
INSTEAD OF INSERT
AS
BEGIN
    -- Lấy dữ liệu từ bảng inserted (bảng ảo)
    INSERT INTO SiteA.dbo.DoiBong_A (MaDB, TenDB, CLB)
    SELECT MaDB, TenDB, CLB
    FROM inserted
    WHERE MaDB LIKE 'A%';  -- Điều kiện phân mảnh
    
    -- Tương tự cho Site B và C
END;
```

**Giải thích:**
1. Khi user INSERT vào `vw_DoiBong`
2. Trigger chặn thao tác gốc
3. Kiểm tra `MaDB` bắt đầu bằng ký tự nào
4. Chuyển INSERT sang bảng mảnh tương ứng

---

**HẾT TÀI LIỆU HƯỚNG DẪN**
