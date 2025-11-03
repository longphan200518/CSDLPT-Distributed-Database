# ========================================
# Script tự động khởi tạo database trong Docker
# ========================================

Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   HỆ THỐNG QUẢN LÝ ĐỘI BÓNG - DOCKER SETUP              ║" -ForegroundColor Cyan
Write-Host "║   Tự động khởi tạo SQL Server trong Docker               ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra Docker đã cài chưa
Write-Host "[1/5] Kiểm tra Docker..." -ForegroundColor Yellow
$dockerVersion = docker --version 2>$null
if (-not $dockerVersion) {
    Write-Host "❌ Docker chưa được cài đặt!" -ForegroundColor Red
    Write-Host "Vui lòng cài Docker Desktop từ: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ Docker đã cài: $dockerVersion" -ForegroundColor Green
Write-Host ""

# Khởi động SQL Server container
Write-Host "[2/5] Khởi động SQL Server container..." -ForegroundColor Yellow
docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Không thể khởi động container!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Container đã được khởi động" -ForegroundColor Green
Write-Host ""

# Đợi SQL Server sẵn sàng
Write-Host "[3/5] Đợi SQL Server khởi động hoàn tất (30 giây)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30
Write-Host "✓ SQL Server đã sẵn sàng" -ForegroundColor Green
Write-Host ""

# Copy scripts vào container
Write-Host "[4/5] Copy SQL scripts vào container..." -ForegroundColor Yellow
$scripts = @(
    "01_CreateDatabases.sql",
    "02_CreateTables.sql",
    "03_CreateViews.sql",
    "04_CreateTriggers.sql",
    "05_SampleData.sql",
    "06_StoredProcedures.sql"
)

foreach ($script in $scripts) {
    $sourcePath = "Database\$script"
    if (Test-Path $sourcePath) {
        docker cp $sourcePath sqlserver-doibong:/tmp/
        Write-Host "  ✓ Copied $script" -ForegroundColor Gray
    } else {
        Write-Host "  ⚠ File not found: $sourcePath" -ForegroundColor Yellow
    }
}
Write-Host "✓ Tất cả scripts đã được copy" -ForegroundColor Green
Write-Host ""

# Chạy các scripts
Write-Host "[5/5] Chạy SQL scripts..." -ForegroundColor Yellow
$password = "YourStrong@Passw0rd"

foreach ($script in $scripts) {
    Write-Host "  → Đang chạy $script..." -ForegroundColor Cyan
    
    $result = docker exec sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
        -S localhost -U sa -P $password `
        -i "/tmp/$script" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Hoàn thành $script" -ForegroundColor Green
    } else {
        Write-Host "  ❌ Lỗi khi chạy $script" -ForegroundColor Red
        Write-Host $result -ForegroundColor Red
    }
}
Write-Host ""

# Kiểm tra kết quả
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║               KIỂM TRA DỮ LIỆU                           ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Host "Kiểm tra số lượng dữ liệu..." -ForegroundColor Yellow

$checkQuery = @"
USE GlobalDB;
SELECT 'DoiBong' as [Table], COUNT(*) as [Count] FROM vw_DoiBong 
UNION ALL 
SELECT 'CauThu', COUNT(*) FROM vw_CauThu
UNION ALL
SELECT 'TranDau', COUNT(*) FROM vw_TranDau;
"@

$result = docker exec sqlserver-doibong /opt/mssql-tools/bin/sqlcmd `
    -S localhost -U sa -P $password `
    -Q $checkQuery

Write-Host $result -ForegroundColor White
Write-Host ""

# Kết luận
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║           ✅ HOÀN TẤT KHỞI TẠO DATABASE                  ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Thông tin kết nối:" -ForegroundColor Cyan
Write-Host "  Server:   localhost,1433" -ForegroundColor White
Write-Host "  Username: sa" -ForegroundColor White
Write-Host "  Password: YourStrong@Passw0rd" -ForegroundColor White
Write-Host "  Database: GlobalDB" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Bước tiếp theo:" -ForegroundColor Cyan
Write-Host "  cd Application\QuanLyDoiBong" -ForegroundColor Yellow
Write-Host "  dotnet run" -ForegroundColor Yellow
Write-Host ""
Write-Host "📖 Xem hướng dẫn chi tiết tại: DOCKER_SETUP.md" -ForegroundColor Cyan
Write-Host ""

# Lưu thông tin container
Write-Host "ℹ️  Các lệnh Docker hữu ích:" -ForegroundColor Cyan
Write-Host "  Xem logs:        docker logs sqlserver-doibong" -ForegroundColor Gray
Write-Host "  Dừng container:  docker-compose down" -ForegroundColor Gray
Write-Host "  Khởi động lại:   docker-compose restart" -ForegroundColor Gray
Write-Host ""
