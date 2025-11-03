# KIẾN TRÚC HỆ THỐNG - CHI TIẾT KỸ THUẬT

## 📐 TỔNG QUAN KIẾN TRÚC

### 1. Kiến trúc 3 tầng (3-Tier Architecture)

```
┌─────────────────────────────────────────────────┐
│          PRESENTATION LAYER (Tầng giao diện)    │
│  ┌────────────────────────────────────────┐    │
│  │  Windows Forms                         │    │
│  │  - frmDoiBong, frmCauThu               │    │
│  │  - frmTranDau, frmThamGia              │    │
│  │  - frmQuery1, frmQuery2, frmQuery3     │    │
│  └────────────────────────────────────────┘    │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│          BUSINESS LOGIC LAYER (Tầng xử lý)      │
│  ┌────────────────────────────────────────┐    │
│  │  Data Access Objects (DAO)             │    │
│  │  - DoiBongDAO                          │    │
│  │  - CauThuDAO                           │    │
│  │  - TranDauDAO                          │    │
│  │  - ThamGiaDAO                          │    │
│  │  - QueryDAO                            │    │
│  └────────────────────────────────────────┘    │
│  ┌────────────────────────────────────────┐    │
│  │  Models (Entities)                     │    │
│  │  - DoiBong, CauThu                     │    │
│  │  - TranDau, ThamGia                    │    │
│  └────────────────────────────────────────┘    │
└─────────────────┬───────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────┐
│          DATA LAYER (Tầng dữ liệu)              │
│  ┌────────────────────────────────────────┐    │
│  │  GlobalDB (Database toàn cục)          │    │
│  │  ┌──────────────────────────────────┐  │    │
│  │  │  Views (UNION ALL)               │  │    │
│  │  │  - vw_DoiBong                    │  │    │
│  │  │  - vw_CauThu                     │  │    │
│  │  │  - vw_TranDau                    │  │    │
│  │  │  - vw_ThamGia                    │  │    │
│  │  └──────────────────────────────────┘  │    │
│  │  ┌──────────────────────────────────┐  │    │
│  │  │  INSTEAD OF Triggers             │  │    │
│  │  │  - Định tuyến INSERT/UPDATE/DELETE│  │    │
│  │  └──────────────────────────────────┘  │    │
│  │  ┌──────────────────────────────────┐  │    │
│  │  │  Stored Procedures               │  │    │
│  │  │  - sp_GetCauThuTheoCLB           │  │    │
│  │  │  - sp_GetSoTranThamGia           │  │    │
│  │  │  - sp_GetSoTranHoaTaiSan         │  │    │
│  │  └──────────────────────────────────┘  │    │
│  └────────────────────────────────────────┘    │
│                                                 │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐        │
│  │ SiteA   │  │ SiteB   │  │ SiteC   │        │
│  │ (A*)    │  │ (B*)    │  │ (C*)    │        │
│  └─────────┘  └─────────┘  └─────────┘        │
└─────────────────────────────────────────────────┘
```

---

## 🗂️ PHÂN TÍCH CƠ CHẾ PHÂN MẢNH

### Horizontal Fragmentation (Phân mảnh ngang)

**Nguyên tắc:**
- Dữ liệu được chia theo **hàng** (rows)
- Mỗi site chứa một tập con các bản ghi
- Tổng hợp tất cả sites = dữ liệu toàn cục

**Công thức phân mảnh:**

```sql
DoiBong = DoiBong_A ∪ DoiBong_B ∪ DoiBong_C

Trong đó:
- DoiBong_A = σ(MaDB LIKE 'A%')(DoiBong)
- DoiBong_B = σ(MaDB LIKE 'B%')(DoiBong)
- DoiBong_C = σ(MaDB LIKE 'C%')(DoiBong)

σ = Phép chọn (Selection)
```

**Ưu điểm:**
✅ Tăng hiệu suất truy vấn (chỉ truy vấn site cần thiết)
✅ Dễ mở rộng (thêm site mới)
✅ Tăng tính khả dụng (1 site lỗi không ảnh hưởng sites khác)

**Nhược điểm:**
❌ Truy vấn JOIN giữa các sites phức tạp
❌ Cần cơ chế định tuyến (trigger)

---

## 🔄 CƠ CHẾ INSTEAD OF TRIGGER

### Luồng hoạt động khi INSERT:

```
┌─────────────────────────────────────────────────────┐
│  1. User thực hiện                                  │
│     INSERT INTO vw_DoiBong VALUES ('A001', ...)     │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│  2. Trigger trg_DoiBong_Insert được kích hoạt      │
│     (INSTEAD OF = Thay thế thao tác gốc)           │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│  3. Kiểm tra giá trị MaDB trong bảng 'inserted'    │
│     IF MaDB LIKE 'A%' → Route to SiteA             │
│     IF MaDB LIKE 'B%' → Route to SiteB             │
│     IF MaDB LIKE 'C%' → Route to SiteC             │
└──────────────────┬──────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────┐
│  4. Thực thi INSERT vào bảng mảnh tương ứng        │
│     INSERT INTO SiteA.dbo.DoiBong_A                │
│     SELECT * FROM inserted WHERE MaDB LIKE 'A%'    │
└─────────────────────────────────────────────────────┘
```

### Code mẫu:

```sql
CREATE TRIGGER trg_DoiBong_Insert
ON vw_DoiBong
INSTEAD OF INSERT
AS
BEGIN
    -- Bảng 'inserted' là bảng ảo chứa dữ liệu được INSERT
    
    -- Route tới Site A
    INSERT INTO SiteA.dbo.DoiBong_A (MaDB, TenDB, CLB)
    SELECT MaDB, TenDB, CLB
    FROM inserted
    WHERE MaDB LIKE 'A%';
    
    -- Route tới Site B
    INSERT INTO SiteB.dbo.DoiBong_B (MaDB, TenDB, CLB)
    SELECT MaDB, TenDB, CLB
    FROM inserted
    WHERE MaDB LIKE 'B%';
    
    -- Route tới Site C
    INSERT INTO SiteC.dbo.DoiBong_C (MaDB, TenDB, CLB)
    SELECT MaDB, TenDB, CLB
    FROM inserted
    WHERE MaDB LIKE 'C%';
END;
```

---

## 📊 CƠ CHẾ VIEW TOÀN CỤC

### UNION ALL vs UNION

**Sử dụng UNION ALL:**
```sql
CREATE VIEW vw_DoiBong AS
    SELECT MaDB, TenDB, CLB FROM SiteA.dbo.DoiBong_A
    UNION ALL  -- Không loại bỏ trùng lặp
    SELECT MaDB, TenDB, CLB FROM SiteB.dbo.DoiBong_B
    UNION ALL
    SELECT MaDB, TenDB, CLB FROM SiteC.dbo.DoiBong_C;
```

**Tại sao dùng UNION ALL?**
1. ✅ **Hiệu suất cao hơn**: Không cần kiểm tra trùng lặp
2. ✅ **Đảm bảo tính đúng đắn**: Mỗi MaDB chỉ tồn tại ở 1 site (do ràng buộc PRIMARY KEY)
3. ✅ **Tránh overhead**: UNION phải sort và so sánh toàn bộ kết quả

---

## 🔐 RÀNG BUỘC TOÀN VẸN PHÂN TÁN

### Foreign Key trong môi trường phân tán

**Vấn đề:**
- Cầu thủ tại Site A có thể tham chiếu đến đội bóng tại Site B/C?

**Giải pháp trong đồ án:**
```sql
-- Ràng buộc cục bộ (tại mỗi site)
-- Site A
ALTER TABLE CauThu_A 
ADD CONSTRAINT FK_CauThu_DoiBong_A
FOREIGN KEY (MaDB) REFERENCES DoiBong_A(MaDB);

-- Điều kiện ngầm định: 
-- Cầu thủ chỉ thuộc đội bóng CÙNG SITE
-- (Do cả 2 đều được phân mảnh theo cùng thuộc tính MaDB)
```

**Ràng buộc toàn cục được đảm bảo bởi:**
1. Trigger kiểm tra MaDB trước khi INSERT
2. Application logic validate trước khi submit

---

## 🚀 TỐI ƯU HÓA TRUY VẤN

### Query Optimization Strategies

#### 1. Predicate Pushdown

**Truy vấn gốc:**
```sql
SELECT * FROM vw_DoiBong WHERE MaDB = 'A001';
```

**SQL Server tự động tối ưu thành:**
```sql
-- Chỉ truy vấn SiteA, bỏ qua SiteB và SiteC
SELECT * FROM SiteA.dbo.DoiBong_A WHERE MaDB = 'A001';
```

#### 2. Index tại mỗi site

```sql
-- Tạo index trên MaDB tại mỗi site
CREATE INDEX IX_DoiBong_A_MaDB ON SiteA.dbo.DoiBong_A(MaDB);
CREATE INDEX IX_DoiBong_B_MaDB ON SiteB.dbo.DoiBong_B(MaDB);
CREATE INDEX IX_DoiBong_C_MaDB ON SiteC.dbo.DoiBong_C(MaDB);
```

#### 3. Partitioned View Optimization

SQL Server nhận biết view này là **Partitioned View** nếu:
- Sử dụng UNION ALL
- Mỗi bảng thành viên có CHECK constraint rõ ràng

**Ví dụ cải tiến:**
```sql
-- Thêm CHECK constraint tại Site A
ALTER TABLE SiteA.dbo.DoiBong_A
ADD CONSTRAINT CK_DoiBong_A_MaDB 
CHECK (MaDB LIKE 'A%');

-- Tương tự cho B và C
```

Với constraint này, SQL Server sẽ tối ưu tốt hơn!

---

## 🔍 PHÂN TÍCH TRUY VẤN ĐẶC BIỆT

### Query 1: Cầu thủ theo CLB

```sql
EXEC sp_GetCauThuTheoCLB @CLB = 'Manchester United';
```

**Execution Plan:**
```
1. Scan vw_CauThu (UNION ALL 3 sites)
2. Scan vw_DoiBong (UNION ALL 3 sites)
3. JOIN c.MaDB = d.MaDB
4. Filter d.CLB = 'Manchester United'
```

**Tối ưu hóa:**
- Nếu biết trước CLB thuộc site nào → Chỉ query site đó
- Trong thực tế: Cần bảng mapping CLB → Site

### Query 3: Số trận hòa tại sân

**Logic phức tạp:**
```sql
-- Phải tính tổng bàn thắng của 2 đội trong mỗi trận
SELECT COUNT(*) AS SoTranHoa
FROM TranDau td
WHERE td.SanDau = @SanDau
AND (
    SUM(SoTrai của đội 1) = SUM(SoTrai của đội 2)
)
```

**Vấn đề:**
- Cầu thủ đội 1 có thể ở Site A
- Cầu thủ đội 2 có thể ở Site B
- Cần JOIN cross-site

---

## 📡 GIAO TIẾP GIỮA CÁC TẦNG

### 1. Presentation → Business Logic

```csharp
// Form gọi DAO
private void BtnThem_Click(object sender, EventArgs e)
{
    DoiBong db = new DoiBong
    {
        MaDB = txtMaDB.Text,
        TenDB = txtTenDB.Text,
        CLB = txtCLB.Text
    };
    
    DoiBongDAO dao = new DoiBongDAO();
    bool success = dao.Insert(db);
    
    if (success)
        MessageBox.Show("Thành công");
}
```

### 2. Business Logic → Data Layer

```csharp
public bool Insert(DoiBong db)
{
    using (SqlConnection conn = DatabaseConnection.GetConnection())
    {
        string query = "INSERT INTO vw_DoiBong (MaDB, TenDB, CLB) " +
                       "VALUES (@MaDB, @TenDB, @CLB)";
        
        SqlCommand cmd = new SqlCommand(query, conn);
        cmd.Parameters.AddWithValue("@MaDB", db.MaDB);
        cmd.Parameters.AddWithValue("@TenDB", db.TenDB);
        cmd.Parameters.AddWithValue("@CLB", db.CLB);
        
        conn.Open();
        int rows = cmd.ExecuteNonQuery();
        return rows > 0;
    }
}
```

---

## 🛡️ BẢO MẬT & PHÂN QUYỀN

### Chiến lược phân quyền (nếu mở rộng)

```sql
-- Tạo login cho từng site
CREATE LOGIN SiteA_User WITH PASSWORD = 'password';
CREATE LOGIN SiteB_User WITH PASSWORD = 'password';

-- Phân quyền chỉ đọc site của mình
GRANT SELECT ON SiteA.dbo.DoiBong_A TO SiteA_User;
DENY SELECT ON SiteB.dbo.DoiBong_B TO SiteA_User;
```

---

## 📈 KHẢ NĂNG MỞ RỘNG

### Thêm Site D

**Bước 1:** Tạo database và bảng
```sql
CREATE DATABASE SiteD;
USE SiteD;
CREATE TABLE DoiBong_D (...);
```

**Bước 2:** Cập nhật view
```sql
ALTER VIEW vw_DoiBong AS
    SELECT ... FROM SiteA...
    UNION ALL
    SELECT ... FROM SiteB...
    UNION ALL
    SELECT ... FROM SiteC...
    UNION ALL
    SELECT ... FROM SiteD.dbo.DoiBong_D;  -- Thêm dòng này
```

**Bước 3:** Cập nhật trigger
```sql
ALTER TRIGGER trg_DoiBong_Insert ...
AS
BEGIN
    ...
    -- Thêm routing cho Site D
    INSERT INTO SiteD.dbo.DoiBong_D
    SELECT ... FROM inserted WHERE MaDB LIKE 'D%';
END;
```

---

## 🎯 KẾT LUẬN

Kiến trúc này đạt được:
✅ **Tính trong suốt phân mảnh**
✅ **Tính trong suốt vị trí**
✅ **Khả năng mở rộng**
✅ **Hiệu suất cao**

Chưa đạt được:
❌ Tính sẵn sàng cao (High Availability)
❌ Cân bằng tải tự động
❌ Replication và Failover
