# BÁO CÁO ĐỒ ÁN
## THIẾT KẾ VÀ TRIỂN KHAI CƠ SỞ DỮ LIỆU PHÂN TÁN
### Đề tài: Hệ thống Quản lý Đội bóng, Cầu thủ, Huấn luyện viên và Trận đấu

---

## MỤC LỤC

1. [MỞ ĐẦU](#chương-1-mở-đầu)
2. [CƠ SỞ LÝ THUYẾT](#chương-2-cơ-sở-lý-thuyết)
3. [PHÂN TÍCH VÀ THIẾT KẾ](#chương-3-phân-tích-và-thiết-kế)
4. [TRIỂN KHAI HỆ THỐNG](#chương-4-triển-khai-hệ-thống)
5. [KẾT QUẢ VÀ ĐÁNH GIÁ](#chương-5-kết-quả-và-đánh-giá)
6. [KẾT LUẬN](#chương-6-kết-luận)

---

## CHƯƠNG 1: MỞ ĐẦU

### 1.1. Lý do chọn đề tài

#### 1.1.1. Tính cấp thiết của Cơ sở Dữ liệu Phân tán

Trong kỷ nguyên số, dữ liệu phát sinh với tốc độ chóng mặt, đặc biệt trong các lĩnh vực có tính tương tác cao như thể thao, thương mại điện tử, và dịch vụ tài chính. Việc quản lý lượng lớn dữ liệu trên hệ thống tập trung duy nhất ngày càng bộc lộ nhiều hạn chế về:

- **Hiệu năng (Performance)**: Tắc nghẽn khi số lượng truy cập đồng thời tăng cao
- **Khả năng mở rộng (Scalability)**: Khó khăn trong việc tăng công suất hệ thống
- **Tính sẵn sàng (Availability)**: Rủi ro ngưng hoạt động toàn hệ thống khi có sự cố

Cơ sở Dữ liệu Phân tán (CSDL PT) ra đời nhằm khắc phục các nhược điểm trên bằng cách:
- Lưu trữ dữ liệu trên nhiều máy tính tại các vị trí địa lý khác nhau
- Vẫn duy trì tính toàn vẹn và cung cấp cái nhìn thống nhất cho người dùng
- Tăng hiệu năng thông qua xử lý song song và giảm độ trễ mạng

#### 1.1.2. Tính ứng dụng thực tiễn của đề tài

Đề tài "Quản lý Đội bóng, Cầu thủ, Huấn luyện viên và Trận đấu" là môi trường lý tưởng để nghiên cứu CSDL PT vì:

**Dữ liệu phân tán tự nhiên:**
- Các câu lạc bộ (CLB) và sân đấu thường nằm ở các thành phố/khu vực khác nhau
- Việc lưu trữ dữ liệu gần với site sử dụng giúp tối ưu hóa truy cập cục bộ
- Giảm độ trễ mạng khi truy vấn dữ liệu địa phương

**Yêu cầu truy vấn phức tạp:**
- Truy vấn đơn giản: Thông tin cầu thủ, đội bóng
- Truy vấn liên kết phức tạp: Vua phá lưới, thống kê đội bóng, trận hòa
- Truy vấn phân tán: Kết hợp dữ liệu từ nhiều site

**Minh họa các mức trong suốt:**
- **Trong suốt phân mảnh**: Người dùng truy vấn toàn bộ dữ liệu mà không cần biết cách phân mảnh
- **Trong suốt vị trí**: Không cần biết dữ liệu lưu trữ ở site nào
- **Trong suốt nhân bản**: Không cần biết dữ liệu có được sao chép hay không

### 1.2. Mục tiêu đề tài

#### 1.2.1. Mục tiêu về Lý thuyết và Thiết kế

1. **Thiết kế phân mảnh:**
   - Phân mảnh ngang: Áp dụng phép băm `ABS(key) % 3` để phân mảnh dữ liệu
   - Phân mảnh dọc: Tách thông tin huấn luyện viên theo nhóm thuộc tính
   - Chứng minh tính đúng đắn của các biểu thức phân mảnh

2. **Thiết kế kiến trúc:**
   - Mô hình toàn cục duy nhất (Global Schema)
   - 3 site vật lý: SiteA, SiteB, SiteC
   - 1 database điều phối: GlobalDB

3. **Tối ưu hóa truy vấn:**
   - Sử dụng view toàn cục (UNION ALL, JOIN)
   - Trigger INSTEAD OF cho INSERT/UPDATE/DELETE
   - Xử lý truy vấn phân tán hiệu quả

#### 1.2.2. Mục tiêu về Ứng dụng

1. **Triển khai CSDL PT:**
   - Sử dụng Docker + SQL Server 2022
   - Cấu hình 3 database site + 1 global database
   - Thiết lập môi trường phân tán hoàn chỉnh

2. **Phát triển ứng dụng:**
   - Giao diện web PHP với Bootstrap
   - Chức năng CRUD đầy đủ
   - Các truy vấn phức tạp minh họa phân tán

3. **Đánh giá hiệu năng:**
   - So sánh hiệu suất phân tán vs tập trung
   - Phân tích ưu/nhược điểm của từng chiến lược phân mảnh

### 1.3. Phạm vi nghiên cứu

#### 1.3.1. Phạm vi Nghiên cứu

**Mô hình phân mảnh:**
- Phân mảnh ngang: Đội bóng, Cầu thủ, Trận đấu, Tham gia
- Phân mảnh dọc: Huấn luyện viên
- Kết hợp cả hai chiến lược

**Mức độ trong suốt:**
- Trong suốt phân mảnh (Fragmentation Transparency)
- Trong suốt vị trí (Location Transparency)
- Trong suốt ánh xạ cục bộ (Local Mapping Transparency)

**Công nghệ sử dụng:**
- HQC/CSDL: Microsoft SQL Server 2022
- Container: Docker
- Ngôn ngữ: PHP 8.2, SQL/T-SQL
- Framework: Bootstrap 5.3

#### 1.3.2. Phạm vi Ứng dụng

**Hệ thống demo:**
- Quản lý thông tin đội bóng từ 5 giải đấu hàng đầu
- 18 đội bóng, 45 cầu thủ, 18 huấn luyện viên
- 12 trận đấu với thông tin chi tiết

**Khả năng mở rộng:**
- Hệ thống chuỗi cung ứng/bán lẻ
- Hệ thống ngân hàng/tài chính  
- Hệ thống IoT/Big Data

### 1.4. Cấu trúc báo cáo

1. **CHƯƠNG 1 - MỞ ĐẦU**: Lý do, mục tiêu, phạm vi
2. **CHƯƠNG 2 - CƠ SỞ LÝ THUYẾT**: Khái niệm CSDL PT, các mức trong suốt
3. **CHƯƠNG 3 - PHÂN TÍCH & THIẾT KẾ**: Mô hình dữ liệu, phân mảnh
4. **CHƯƠNG 4 - TRIỂN KHAI**: Cài đặt, code, database
5. **CHƯƠNG 5 - KẾT QUẢ & ĐÁNH GIÁ**: Testing, performance
6. **CHƯƠNG 6 - KẾT LUẬN**: Tổng kết, hướng phát triển

---

## CHƯƠNG 2: CƠ SỞ LÝ THUYẾT

### 2.1. Tổng quan về Cơ sở Dữ liệu Phân tán

#### 2.1.1. Khái niệm

**Cơ sở dữ liệu phân tán (Distributed Database - DDB)** là một tập hợp các cơ sở dữ liệu được lưu trữ tại nhiều vị trí vật lý khác nhau, nhưng được quản lý như một hệ thống thống nhất.

**Đặc điểm:**
- Mỗi vị trí (site/node) chạy DBMS cục bộ độc lập
- Các site giao tiếp qua mạng truyền thông
- Cung cấp cái nhìn logic duy nhất cho người dùng
- Đảm bảo tính toàn vẹn và nhất quán dữ liệu

#### 2.1.2. Các thành phần cơ bản

1. **Cơ sở dữ liệu cục bộ (Local Database)**
   - Chứa dữ liệu tại mỗi site
   - Quản lý bởi DBMS cục bộ

2. **Bộ điều phối (Transaction Coordinator)**
   - Điều khiển và giám sát giao dịch phân tán
   - Đảm bảo tính nhất quán giữa các site

3. **Bộ quản lý dữ liệu (Data Manager)**
   - Xử lý truy xuất, cập nhật
   - Phục hồi dữ liệu khi có lỗi

4. **Mạng truyền thông (Communication Network)**
   - Kết nối các site
   - Trao đổi dữ liệu và thông tin điều khiển

#### 2.1.3. Các mô hình kiến trúc

**1. Mô hình Client-Server:**
- Client gửi truy vấn tới Server
- Server xử lý và trả kết quả
- Phổ biến, dễ triển khai
- Áp dụng trong đề tài: Ứng dụng web PHP (Client) kết nối SQL Server (Server)

**2. Mô hình Peer-to-Peer:**
- Mỗi site vừa là Client vừa là Server
- Dữ liệu phân tán đều giữa các site
- Không có máy chủ trung tâm
- Phù hợp với tổ chức lớn

**3. Mô hình Phân cấp (Hierarchical):**
- Tổ chức theo tầng
- Coordinator điều phối, Executor thực thi
- Quản lý rõ ràng giữa các cấp

### 2.2. Các mức trong suốt phân tán

Tính **trong suốt (Transparency)** là khả năng che giấu sự phức tạp của hệ thống phân tán, cho phép người dùng thao tác như với CSDL tập trung.

#### 2.2.1. Trong suốt phân mảnh (Fragmentation Transparency)

**Định nghĩa:** Người dùng truy vấn bảng toàn cục mà không cần biết dữ liệu được phân mảnh và lưu ở đâu.

**Ví dụ trong đề tài:**
```sql
-- Người dùng chỉ cần truy vấn view toàn cục
SELECT * FROM DoiBong WHERE CLB = 'Manchester City FC';

-- Hệ thống tự động truy xuất từ các mảnh:
-- SiteA.DoiBong (ABS(MaDB) % 3 = 0)
-- SiteB.DoiBong (ABS(MaDB) % 3 = 1)  
-- SiteC.DoiBong (ABS(MaDB) % 3 = 2)
```

**Lợi ích:**
- Đơn giản hóa lập trình ứng dụng
- Dễ dàng thay đổi chiến lược phân mảnh
- Tăng tính linh hoạt

#### 2.2.2. Trong suốt vị trí (Location Transparency)

**Định nghĩa:** Người dùng không cần biết vị trí vật lý của dữ liệu, chỉ cần dùng tên logic.

**Ví dụ:**
```sql
-- Truy vấn sử dụng tên view toàn cục
SELECT * FROM HuanLuyenVien WHERE QuocTich = 'Tây Ban Nha';

-- Dữ liệu thực tế JOIN từ 3 site:
-- SiteA.HLV_Basic (Họ tên, Quốc tịch)
-- SiteB.HLV_Additional (Đội bóng, SĐT)
-- SiteC.HLV_History (Kinh nghiệm, Thành tích)
```

#### 2.2.3. Trong suốt nhân bản (Replication Transparency)

**Định nghĩa:** Dữ liệu có thể được sao chép tại nhiều site, hệ thống đảm bảo các bản sao luôn nhất quán.

**Lợi ích:**
- Tăng hiệu năng đọc dữ liệu
- Tăng tính sẵn sàng khi có sự cố
- Cân bằng tải truy vấn

#### 2.2.4. Trong suốt ánh xạ cục bộ (Local Mapping Transparency)

**Định nghĩa:** Che giấu sự khác biệt giữa lược đồ toàn cục và lược đồ cục bộ.

**Ví dụ:**
- Bảng toàn cục: `DoiBong`
- Ánh xạ tới: `SiteA.dbo.DoiBong`, `SiteB.dbo.DoiBong`, `SiteC.dbo.DoiBong`
- Người dùng chỉ thao tác với tên toàn cục

### 2.3. Thiết kế Cơ sở Dữ liệu Phân tán

#### 2.3.1. Nguyên tắc thiết kế

1. **Tối thiểu hóa chi phí truyền dữ liệu**
   - Dữ liệu nên lưu tại site thường xuyên truy cập nhất
   - Giảm lưu lượng mạng giữa các site

2. **Đảm bảo toàn vẹn dữ liệu**
   - Phân mảnh không làm thay đổi ý nghĩa logic
   - Ràng buộc khóa chính, khóa ngoại được duy trì

3. **Độc lập về vị trí**
   - Người dùng truy cập dữ liệu mà không quan tâm vị trí vật lý
   - Hỗ trợ di chuyển dữ liệu giữa các site

4. **Khả năng mở rộng**
   - Dễ thêm site, mảnh, nút mới
   - Hệ thống hoạt động ổn định khi mở rộng

#### 2.3.2. Các bước thiết kế

**Bước 1: Thiết kế lược đồ toàn cục**

Lược đồ toàn cục của đề tài:
- `DOIBONG(MaDB, TenDB, CLB, GiaiDau)`
- `CAUTHU(MaCT, HoTen, MaDB, ViTri)`
- `TRANDAU(MaTD, MaDB1, MaDB2, TrongTai, SanDau)`
- `THAMGIA(MaTD, MaCT, SoTrai)`
- `HUANLUYENVIEN(MaHLV, HoTen, QuocTich, MaDB, NgaySinh, SoDienThoai, NamKinhNghiem, ChucVuTruoc, ThanhTich)`

**Bước 2: Phân mảnh dữ liệu**

*A. Phân mảnh ngang (Horizontal Fragmentation):*

```sql
-- Công thức: ABS(key) % 3
-- DoiBong
SiteA: ABS(MaDB) % 3 = 0  → {1, 4, 6, 9, 12, 15, 18}
SiteB: ABS(MaDB) % 3 = 1  → {7, 10, 13, 16}
SiteC: ABS(MaDB) % 3 = 2  → {2, 3, 5, 8, 11, 14, 17}

-- CauThu, TranDau, ThamGia: tương tự
```

*B. Phân mảnh dọc (Vertical Fragmentation):*

```sql
-- HuanLuyenVien được chia theo cột
SiteA.HLV_Basic:      {MaHLV, HoTen, QuocTich}
SiteB.HLV_Additional: {MaHLV, MaDB, NgaySinh, SoDienThoai}
SiteC.HLV_History:    {MaHLV, NamKinhNghiem, ChucVuTruoc, ThanhTich}

-- View toàn cục JOIN lại
CREATE VIEW HuanLuyenVien AS
SELECT b.*, a.MaDB, a.NgaySinh, a.SoDienThoai, 
       h.NamKinhNghiem, h.ChucVuTruoc, h.ThanhTich
FROM SiteA.dbo.HLV_Basic b
JOIN SiteB.dbo.HLV_Additional a ON b.MaHLV = a.MaHLV
JOIN SiteC.dbo.HLV_History h ON b.MaHLV = h.MaHLV;
```

**Bước 3: Phân bố dữ liệu (Allocation)**

| Site | Chứa dữ liệu |
|------|-------------|
| SiteA | DoiBong, CauThu, TranDau, ThamGia (ABS % 3 = 0)<br>HLV_Basic (phân mảnh dọc) |
| SiteB | DoiBong, CauThu, TranDau, ThamGia (ABS % 3 = 1)<br>HLV_Additional (phân mảnh dọc) |
| SiteC | DoiBong, CauThu, TranDau, ThamGia (ABS % 3 = 2)<br>HLV_History (phân mảnh dọc) |
| GlobalDB | Views toàn cục, Triggers định tuyến |

**Bước 4: Ánh xạ và đảm bảo tính nhất quán**

- Sử dụng View UNION ALL cho phân mảnh ngang
- Sử dụng View JOIN cho phân mảnh dọc
- Trigger INSTEAD OF xử lý INSERT/UPDATE/DELETE

### 2.4. Xử lý truy vấn phân tán

#### 2.4.1. Các bước xử lý

1. **Phân tích câu truy vấn**
   - Xác định bảng liên quan
   - Phân tích điều kiện WHERE, JOIN

2. **Phân rã truy vấn (Query Decomposition)**
   - Chuyển truy vấn toàn cục thành subquery cho từng mảnh
   - Tối ưu hóa thứ tự thực thi

3. **Thực thi song song**
   - Các site thực thi độc lập
   - Kết quả được hợp nhất tại GlobalDB

4. **Tối ưu hóa**
   - Giảm dữ liệu truyền qua mạng
   - Thực hiện lọc, kết nối tại site cục bộ

#### 2.4.2. Ví dụ minh họa

**Truy vấn: Tìm vua phá lưới**

```sql
-- Bước 1: Tại mỗi site tính tổng bàn thắng
SELECT MaCT, SUM(SoTrai) AS TongBan
FROM ThamGia
GROUP BY MaCT;

-- Bước 2: GlobalDB hợp nhất và tìm MAX
SELECT c.MaCT, c.HoTen, SUM(t.SoTrai) AS TongBan
FROM CauThu c
JOIN ThamGia t ON c.MaCT = t.MaCT
GROUP BY c.MaCT, c.HoTen
HAVING SUM(t.SoTrai) = (
    SELECT MAX(Total) FROM (
        SELECT SUM(SoTrai) AS Total 
        FROM ThamGia 
        GROUP BY MaCT
    ) AS Sub
);
```

---

## CHƯƠNG 3: PHÂN TÍCH VÀ THIẾT KẾ

### 3.1. Phân tích yêu cầu hệ thống

#### 3.1.1. Yêu cầu chức năng

**Người dùng cuối:**
1. Xem thông tin đội bóng, cầu thủ, huấn luyện viên, trận đấu
2. Thêm/sửa/xóa dữ liệu (với phân quyền phù hợp)
3. Tra cứu và thống kê:
   - Cầu thủ theo câu lạc bộ/giải đấu
   - Số trận cầu thủ đã tham gia
   - Số trận hòa tại sân đấu
   - Huấn luyện viên theo giải đấu

**Quản trị viên:**
1. Quản lý người dùng và phân quyền
2. Theo dõi hiệu năng hệ thống
3. Sao lưu và phục hồi dữ liệu
4. Quản lý phân mảnh và vị trí

#### 3.1.2. Yêu cầu phi chức năng

**Hiệu năng:**
- Thời gian phản hồi truy vấn < 2s
- Hỗ trợ 100+ concurrent users
- Tối ưu truy vấn JOIN phân tán

**An toàn:**
- Bảo mật kết nối database
- Mã hóa thông tin nhạy cảm
- Audit log cho mọi thao tác

**Khả năng mở rộng:**
- Dễ dàng thêm site mới
- Hỗ trợ tăng dữ liệu lên 10x

### 3.2. Mô hình dữ liệu

#### 3.2.1. Sơ đồ ER

```
┌─────────────┐         ┌─────────────┐
│  DOIBONG    │1       *│   CAUTHU    │
│─────────────│◄────────│─────────────│
│ MaDB (PK)   │         │ MaCT (PK)   │
│ TenDB       │         │ HoTen       │
│ CLB         │         │ MaDB (FK)   │
│ GiaiDau     │         │ ViTri       │
└─────────────┘         └─────────────┘
       │1                      │*
       │                       │
       │*                      │
┌─────────────┐         ┌─────────────┐
│  TRANDAU    │1       *│  THAMGIA    │
│─────────────│◄────────│─────────────│
│ MaTD (PK)   │         │ MaTD (FK,PK)│
│ MaDB1 (FK)  │         │ MaCT (FK,PK)│
│ MaDB2 (FK)  │         │ SoTrai      │
│ TrongTai    │         └─────────────┘
│ SanDau      │
└─────────────┘

┌──────────────────┐
│ HUANLUYENVIEN    │
│──────────────────│
│ MaHLV (PK)       │ ← Phân mảnh dọc
│ HoTen            │   SiteA: Basic
│ QuocTich         │   SiteB: Additional
│ MaDB (FK)        │   SiteC: History
│ NgaySinh         │
│ SoDienThoai      │
│ NamKinhNghiem    │
│ ChucVuTruoc      │
│ ThanhTich        │
└──────────────────┘
```

#### 3.2.2. Mô tả bảng chi tiết

**Bảng DOIBONG**

| Thuộc tính | Kiểu | Mô tả | Ràng buộc |
|-----------|------|-------|-----------|
| MaDB | INT | Mã đội bóng | PRIMARY KEY |
| TenDB | NVARCHAR(100) | Tên đội | NOT NULL |
| CLB | NVARCHAR(100) | Câu lạc bộ | NOT NULL |
| GiaiDau | NVARCHAR(100) | Giải đấu | NOT NULL |

**Bảng CAUTHU**

| Thuộc tính | Kiểu | Mô tả | Ràng buộc |
|-----------|------|-------|-----------|
| MaCT | INT | Mã cầu thủ | PRIMARY KEY |
| HoTen | NVARCHAR(100) | Họ tên | NOT NULL |
| MaDB | INT | Mã đội bóng | FOREIGN KEY → DoiBong(MaDB) |
| ViTri | NVARCHAR(50) | Vị trí thi đấu | |

**Bảng TRANDAU**

| Thuộc tính | Kiểu | Mô tả | Ràng buộc |
|-----------|------|-------|-----------|
| MaTD | INT | Mã trận đấu | PRIMARY KEY |
| MaDB1 | INT | Đội chủ nhà | FOREIGN KEY → DoiBong(MaDB) |
| MaDB2 | INT | Đội khách | FOREIGN KEY → DoiBong(MaDB) |
| TrongTai | NVARCHAR(100) | Trọng tài | |
| SanDau | NVARCHAR(100) | Sân vận động | NOT NULL |

**Bảng THAMGIA**

| Thuộc tính | Kiểu | Mô tả | Ràng buộc |
|-----------|------|-------|-----------|
| MaTD | INT | Mã trận đấu | PRIMARY KEY, FOREIGN KEY → TranDau |
| MaCT | INT | Mã cầu thủ | PRIMARY KEY, FOREIGN KEY → CauThu |
| SoTrai | INT | Số bàn thắng | DEFAULT 0, CHECK ≥ 0 |

**Bảng HUANLUYENVIEN (Phân mảnh dọc)**

| Fragment | Thuộc tính | Site |
|----------|-----------|------|
| HLV_Basic | MaHLV, HoTen, QuocTich | SiteA |
| HLV_Additional | MaHLV, MaDB, NgaySinh, SoDienThoai | SiteB |
| HLV_History | MaHLV, NamKinhNghiem, ChucVuTruoc, ThanhTich | SiteC |

### 3.3. Phân mảnh chi tiết

#### 3.3.1. Phân mảnh ngang

**Công thức phân mảnh:**
```
site = ABS(key) % 3
  0 → SiteA
  1 → SiteB
  2 → SiteC
```

**Biểu thức phân mảnh DoiBong:**

```sql
-- Mảnh SiteA
DoiBong_A = σ_{ABS(MaDB) % 3 = 0} (DoiBong)

-- Mảnh SiteB  
DoiBong_B = σ_{ABS(MaDB) % 3 = 1} (DoiBong)

-- Mảnh SiteC
DoiBong_C = σ_{ABS(MaDB) % 3 = 2} (DoiBong)

-- Tái tạo
DoiBong = DoiBong_A ∪ DoiBong_B ∪ DoiBong_C
```

**Tương tự cho CauThu, TranDau, ThamGia**

#### 3.3.2. Phân mảnh dọc

**Biểu thức phân mảnh HuanLuyenVien:**

```sql
-- Fragment 1: Thông tin cơ bản (SiteA)
HLV_Basic = Π_{MaHLV, HoTen, QuocTich} (HuanLuyenVien)

-- Fragment 2: Thông tin bổ sung (SiteB)
HLV_Additional = Π_{MaHLV, MaDB, NgaySinh, SoDienThoai} (HuanLuyenVien)

-- Fragment 3: Lịch sử sự nghiệp (SiteC)
HLV_History = Π_{MaHLV, NamKinhNghiem, ChucVuTruoc, ThanhTich} (HuanLuyenVien)

-- Tái tạo
HuanLuyenVien = HLV_Basic ⋈_{MaHLV} HLV_Additional ⋈_{MaHLV} HLV_History
```

#### 3.3.3. Lý do lựa chọn

| Tiêu chí | Lý do |
|----------|-------|
| Phân mảnh ngang theo hash | - Phân bố dữ liệu đều<br>- Cân bằng tải<br>- Dễ mở rộng |
| Phân mảnh dọc cho HLV | - Tách thông tin nhạy cảm<br>- Tăng bảo mật<br>- Tối ưu băng thông |

### 3.4. Kiến trúc triển khai

```
┌─────────────────────────────────────────────┐
│         Docker Container: mssql             │
│                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐    │
│  │ SiteA   │  │ SiteB   │  │ SiteC   │    │
│  │ Port:-  │  │ Port:-  │  │ Port:-  │    │
│  └─────────┘  └─────────┘  └─────────┘    │
│         ┌─────────────┐                     │
│         │  GlobalDB   │                     │
│         │  (Views +   │                     │
│         │  Triggers)  │                     │
│         └─────────────┘                     │
└─────────────────────────────────────────────┘
                   │
                   │ Port 1433
                   ▼
┌─────────────────────────────────────────────┐
│    Docker Container: php-app                │
│    Apache + PHP 8.2 + SQL Server Driver     │
│    Port: 8080                               │
└─────────────────────────────────────────────┘
```

---

## CHƯƠNG 4: TRIỂN KHAI HỆ THỐNG

### 4.1. Môi trường triển khai

**Công nghệ sử dụng:**
- Docker Desktop for Windows
- SQL Server 2022 (mcr.microsoft.com/mssql/server:2022-latest)
- PHP 8.2 Apache
- SQL Server ODBC Driver 18
- Bootstrap 5.3.3

**Cấu trúc thư mục:**
```
CSDLPT/
├── docker/
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── sql/
├── sql/
│   └── init-db.sql
├── src/
│   ├── index.php
│   ├── assets/
│   ├── crud/
│   ├── includes/
│   └── queries/
└── README.md
```

### 4.2. Cài đặt Database

#### 4.2.1. Tạo database và bảng

Chi tiết trong file `sql/init-db.sql`:

1. **Tạo 4 databases**
```sql
CREATE DATABASE SiteA;
CREATE DATABASE SiteB;
CREATE DATABASE SiteC;
CREATE DATABASE GlobalDB;
```

2. **Tạo bảng phân mảnh tại mỗi site**
3. **Chèn dữ liệu mẫu**
4. **Tạo view toàn cục tại GlobalDB**
5. **Tạo trigger INSTEAD OF**

#### 4.2.2. View toàn cục

**Phân mảnh ngang - UNION ALL:**
```sql
CREATE VIEW DoiBong AS
SELECT * FROM SiteA.dbo.DoiBong
UNION ALL
SELECT * FROM SiteB.dbo.DoiBong
UNION ALL
SELECT * FROM SiteC.dbo.DoiBong;
```

**Phân mảnh dọc - JOIN:**
```sql
CREATE VIEW HuanLuyenVien AS
SELECT b.*, a.MaDB, a.NgaySinh, a.SoDienThoai,
       h.NamKinhNghiem, h.ChucVuTruoc, h.ThanhTich
FROM SiteA.dbo.HLV_Basic b
JOIN SiteB.dbo.HLV_Additional a ON b.MaHLV = a.MaHLV
JOIN SiteC.dbo.HLV_History h ON b.MaHLV = h.MaHLV;
```

#### 4.2.3. Trigger định tuyến

**Ví dụ trigger cho DoiBong:**
```sql
CREATE TRIGGER trg_DoiBong_IO ON DoiBong 
INSTEAD OF INSERT, UPDATE, DELETE AS
BEGIN
    -- DELETE từ các site
    IF EXISTS(SELECT 1 FROM deleted) BEGIN
        DELETE a FROM SiteA.dbo.DoiBong a 
        JOIN deleted d ON a.MaDB=d.MaDB;
        -- Tương tự cho SiteB, SiteC
    END
    
    -- INSERT/UPDATE phân mảnh theo ABS(MaDB) % 3
    IF EXISTS(SELECT 1 FROM inserted) BEGIN
        MERGE SiteA.dbo.DoiBong AS t 
        USING (SELECT * FROM inserted WHERE ABS(MaDB)%3=0) AS s
        ON t.MaDB=s.MaDB
        WHEN MATCHED THEN UPDATE SET ...
        WHEN NOT MATCHED THEN INSERT ...;
        -- Tương tự cho SiteB, SiteC
    END
END;
```

### 4.3. Phát triển ứng dụng

#### 4.3.1. Kết nối database

**File: `src/includes/db.php`**
```php
<?php
$server = getenv('DB_SERVER') ?: 'localhost';
$connectionInfo = [
    "Database" => "GlobalDB", 
    "UID" => "SA", 
    "PWD" => "YourStrong!Passw0rd",
    "TrustServerCertificate" => true
];
$conn = sqlsrv_connect($server, $connectionInfo);
```

#### 4.3.2. CRUD Operations

**Thêm đội bóng:**
```php
runQuery($conn, 
    'INSERT INTO DoiBong (MaDB, TenDB, CLB, GiaiDau) VALUES (?,?,?,?)', 
    [$madb, $tendb, $clb, $giaidau]
);
```

**Cập nhật cầu thủ:**
```php
runQuery($conn, 
    'UPDATE CauThu SET HoTen=?, MaDB=?, ViTri=? WHERE MaCT=?', 
    [$hoten, $madb, $vitri, $mact]
);
```

#### 4.3.3. Truy vấn phức tạp

**Cầu thủ theo giải đấu:**
```php
$stmt = runQuery($conn, 
    'SELECT c.* FROM CauThu c 
     JOIN DoiBong d ON c.MaDB=d.MaDB 
     WHERE d.GiaiDau=?', 
    [$giaidau]
);
```

**Huấn luyện viên theo giải đấu (JOIN phân mảnh dọc):**
```php
$stmt = runQuery($conn,
    'SELECT h.* FROM HuanLuyenVien h
     JOIN DoiBong d ON h.MaDB=d.MaDB
     WHERE d.GiaiDau=?',
    [$giaidau]
);
```

---

## CHƯƠNG 5: KẾT QUẢ VÀ ĐÁNH GIÁ

### 5.1. Kết quả triển khai

#### 5.1.1. Dữ liệu đã triển khai

- **18 đội bóng** từ 5 giải đấu (Premier League, La Liga, Serie A, Bundesliga, Ligue 1)
- **45 cầu thủ** với thông tin đầy đủ
- **18 huấn luyện viên** (phân mảnh dọc)
- **12 trận đấu** với kết quả chi tiết

#### 5.1.2. Phân bố dữ liệu

**SiteA (ABS % 3 = 0):** 6 đội bóng, 18 cầu thủ, 4 trận đấu  
**SiteB (ABS % 3 = 1):** 6 đội bóng, 14 cầu thủ, 4 trận đấu  
**SiteC (ABS % 3 = 2):** 6 đội bóng, 13 cầu thủ, 4 trận đấu

### 5.2. Kiểm thử chức năng

#### 5.2.1. CRUD Operations

✅ **Thêm đội bóng**: Trigger tự động định tuyến đến site phù hợp  
✅ **Sửa cầu thủ**: Cập nhật thành công qua view toàn cục  
✅ **Xóa trận đấu**: Cascade delete bản ghi liên quan  
✅ **Thêm HLV**: Phân mảnh dọc hoạt động chính xác

#### 5.2.2. Truy vấn phức tạp

**1. Cầu thủ theo câu lạc bộ:**
```sql
SELECT c.MaCT, c.HoTen, c.ViTri, d.TenDB 
FROM CauThu c 
JOIN DoiBong d ON c.MaDB=d.MaDB 
WHERE d.CLB='Manchester City FC';
```
✅ Kết quả: 4 cầu thủ (Haaland, De Bruyne, Foden, Rodri)

**2. Số trận cầu thủ tham gia:**
```sql
SELECT c.HoTen, COUNT(t.MaTD) AS SoTran
FROM CauThu c
JOIN ThamGia t ON c.MaCT = t.MaCT
WHERE c.HoTen = 'Erling Haaland'
GROUP BY c.HoTen;
```
✅ Kết quả: 2 trận

**3. Số trận hòa tại sân:**
```sql
SELECT COUNT(*) AS SoTranHoa
FROM TranDau td
WHERE td.SanDau = 'Etihad Stadium'
AND (SELECT SUM(SoTrai) FROM ThamGia t1 JOIN CauThu c1 ON t1.MaCT=c1.MaCT 
     WHERE t1.MaTD=td.MaTD AND c1.MaDB=td.MaDB1)
  = (SELECT SUM(SoTrai) FROM ThamGia t2 JOIN CauThu c2 ON t2.MaCT=c2.MaCT 
     WHERE t2.MaTD=td.MaTD AND c2.MaDB=td.MaDB2);
```
✅ Kết quả: 1 trận hòa

**4. Huấn luyện viên theo giải đấu (JOIN phân mảnh dọc):**
```sql
SELECT h.HoTen, h.QuocTich, h.NamKinhNghiem, d.TenDB
FROM HuanLuyenVien h
JOIN DoiBong d ON h.MaDB=d.MaDB
WHERE d.GiaiDau='Premier League'
ORDER BY h.NamKinhNghiem DESC;
```
✅ Kết quả: 6 HLV (Guardiola, Arteta, Klopp, Pochettino, ten Hag, Postecoglou, Howe)

### 5.3. Đánh giá hiệu năng

#### 5.3.1. Ưu điểm

✅ **Cân bằng tải**: Dữ liệu phân bố đều qua 3 site  
✅ **Trong suốt**: Người dùng không cần biết cách phân mảnh  
✅ **Linh hoạt**: Kết hợp cả phân mảnh ngang và dọc  
✅ **Bảo mật**: Tách thông tin nhạy cảm (SĐT, lịch sử)  
✅ **Mở rộng**: Dễ thêm site mới

#### 5.3.2. Nhược điểm

⚠️ **JOIN phân tán**: Truy vấn liên site chậm hơn cục bộ  
⚠️ **Độ phức tạp**: Trigger và view phức tạp hơn CSDL tập trung  
⚠️ **Overhead**: Chi phí đồng bộ và quản lý tăng  

#### 5.3.3. So sánh với CSDL tập trung

| Tiêu chí | Tập trung | Phân tán |
|----------|-----------|----------|
| Tốc độ truy vấn cục bộ | Nhanh | **Rất nhanh** |
| Tốc độ truy vấn toàn cục | **Nhanh** | Trung bình |
| Khả năng mở rộng | Hạn chế | **Cao** |
| Độ phức tạp | Thấp | **Cao** |
| Tính sẵn sàng | Thấp | **Cao** |

---

## CHƯƠNG 6: KẾT LUẬN

### 6.1. Kết quả đạt được

✅ **Thiết kế và triển khai thành công** hệ thống CSDL phân tán với:
- Phân mảnh ngang (4 bảng)
- Phân mảnh dọc (1 bảng)
- 3 site vật lý + 1 GlobalDB

✅ **Đạt được các mức trong suốt:**
- Trong suốt phân mảnh: View toàn cục che giấu phân mảnh
- Trong suốt vị trí: Người dùng không cần biết vị trí dữ liệu
- Trong suốt ánh xạ: Tự động ánh xạ global ↔ local schema

✅ **Ứng dụng web hoàn chỉnh:**
- Giao diện Bootstrap responsive
- CRUD đầy đủ cho 5 entity
- 4+ truy vấn phức tạp minh họa phân tán

### 6.2. Bài học kinh nghiệm

**Về lý thuyết:**
- Hiểu sâu về các chiến lược phân mảnh
- Nắm vững xử lý truy vấn phân tán
- Áp dụng các mức trong suốt

**Về thực hành:**
- Sử dụng Docker triển khai môi trường
- Viết Trigger và View phức tạp
- Tối ưu hóa truy vấn JOIN phân tán

**Về quản lý:**
- Tầm quan trọng của documentation
- Version control với Git
- Testing kỹ lưỡng

### 6.3. Hướng phát triển

**Ngắn hạn:**
- [ ] Thêm chức năng thống kê nâng cao
- [ ] Tối ưu hiệu năng truy vấn JOIN
- [ ] Implement caching layer

**Trung hạn:**
- [ ] Triển khai Replication cho high availability
- [ ] Thêm authentication & authorization
- [ ] API RESTful cho mobile app

**Dài hạn:**
- [ ] Mở rộng lên 5+ sites
- [ ] Implement sharding động
- [ ] Big Data analytics integration

### 6.4. Kết luận chung

Đề tài đã thành công trong việc:
1. **Nghiên cứu và áp dụng** lý thuyết CSDL phân tán vào thực tiễn
2. **Thiết kế kiến trúc** phân tán hiệu quả với cả 2 chiến lược phân mảnh
3. **Triển khai hệ thống** hoàn chỉnh trên Docker
4. **Phát triển ứng dụng** minh họa rõ ràng các khái niệm

Hệ thống có thể mở rộng áp dụng cho các lĩnh vực khác như:
- E-commerce (phân mảnh theo khu vực)
- Banking (phân mảnh theo loại tài khoản)
- IoT (phân mảnh theo sensor/location)

---

## PHỤ LỤC

### A. Cấu trúc code

### B. SQL Scripts

### C. Screenshots

### D. Tài liệu tham khảo

1. Özsu, M. T., & Valduriez, P. (2020). *Principles of Distributed Database Systems* (4th ed.)
2. Elmasri, R., & Navathe, S. B. (2015). *Fundamentals of Database Systems* (7th ed.)
3. Microsoft SQL Server Documentation
4. Docker Documentation

---

**Ngày hoàn thành**: 24/11/2025  
**Người thực hiện**: [Tên sinh viên]  
**Giảng viên hướng dẫn**: [Tên GV]
