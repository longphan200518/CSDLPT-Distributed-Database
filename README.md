# Đồ án CSDL Phân Tán – Quản lý Đội Bóng

## 1. Mô tả
Ứng dụng PHP mô phỏng hệ thống quản lý đội bóng, cầu thủ, trận đấu và tham gia, triển khai trên mô hình *toàn cục duy nhất* với SQL Server. Dữ liệu thật được phân mảnh ngang qua 3 database: `SiteA`, `SiteB`, `SiteC`. Ứng dụng chỉ thao tác trên các view toàn cục nằm trong `GlobalDB` và các trigger `INSTEAD OF` tự động định tuyến thao tác đến mảnh tương ứng.

## 2. Thành phần
- `docker/docker-compose.yml`: Khởi tạo dịch vụ `mssql` và `php`.
- `docker/Dockerfile`: Cài PHP + driver SQL Server.
- `sql/init-db.sql`: Tạo database site, bảng, dữ liệu mẫu, view và trigger.
- `src/`: Mã nguồn PHP (CRUD + truy vấn đặc biệt).

## 3. Chạy dự án
```powershell
cd docker
# Khởi chạy dịch vụ
docker compose up -d --build

# Sau khi SQL Server healthy, chạy script init (nếu db-init không tự chạy)
docker compose run --rm db-init
```
Truy cập ứng dụng: http://localhost:8080

## 4. Thông tin đăng nhập SQL Server
- Server: `mssql`
- User: `SA`
- Password: `YourStrong!Passw0rd`
- Global DB: `GlobalDB`

Đổi mật khẩu trong `docker-compose.yml` nếu cần.

## 5. Các bảng (Global View)
- DoiBong(MaDB, TenDB, CLB)
- CauThu(MaCT, HoTen, MaDB)
- TranDau(MaTD, MaDB1, MaDB2, TrongTai, SanDau)
- ThamGia(MaTD, MaCT, SoTrai)

## 6. Phân mảnh & Trong suốt
- Phân mảnh ngang theo phép băm khóa chính (`ABS(key) % 3`).
- View `UNION ALL` tạo ảo giác bảng duy nhất.
- Trigger `INSTEAD OF` xử lý INSERT/UPDATE/DELETE và định tuyến.

## 7. Truy vấn đặc biệt
1. Cầu thủ thuộc một câu lạc bộ
2. Số trận cầu thủ đã tham gia
3. Số trận hòa tại một sân đấu

## 8. Mở rộng
- Có thể thay hàm phân mảnh bằng logic theo CLB hoặc khu vực.
- Bổ sung kiểm tra toàn vẹn (foreign key liên-site) bằng trigger nâng cao.

## 9. Ghi chú
- Script dùng MERGE cho upsert an toàn khi chạy nhiều lần.
- Đơn giản hóa bảo mật và validation để minh họa yêu cầu học phần.

## 10. Troubleshooting
```powershell
# Xem logs SQL
docker logs mssql
# Thử kết nối thủ công
docker exec -it mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P YourStrong!Passw0rd -Q "SELECT name FROM sys.databases"
```
