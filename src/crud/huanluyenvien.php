<?php
require_once '../includes/db.php';
$pageTitle='Huấn luyện viên';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    if ($action === 'add') {
        runQuery($conn, 'INSERT INTO HuanLuyenVien (MaHLV, HoTen, QuocTich, MaDB, NgaySinh, SoDienThoai, NamKinhNghiem, ChucVuTruoc, ThanhTich) VALUES (?,?,?,?,?,?,?,?,?)', [ 
            (int)$_POST['MaHLV'], 
            $_POST['HoTen'], 
            $_POST['QuocTich'], 
            (int)$_POST['MaDB'], 
            $_POST['NgaySinh'], 
            $_POST['SoDienThoai'], 
            (int)$_POST['NamKinhNghiem'], 
            $_POST['ChucVuTruoc'], 
            $_POST['ThanhTich'] 
        ]);
    } elseif ($action === 'update') {
        runQuery($conn, 'UPDATE HuanLuyenVien SET HoTen=?, QuocTich=?, MaDB=?, NgaySinh=?, SoDienThoai=?, NamKinhNghiem=?, ChucVuTruoc=?, ThanhTich=? WHERE MaHLV=?', [ 
            $_POST['HoTen'], 
            $_POST['QuocTich'], 
            (int)$_POST['MaDB'], 
            $_POST['NgaySinh'], 
            $_POST['SoDienThoai'], 
            (int)$_POST['NamKinhNghiem'], 
            $_POST['ChucVuTruoc'], 
            $_POST['ThanhTich'], 
            (int)$_POST['MaHLV'] 
        ]);
    } elseif ($action === 'delete') {
        runQuery($conn, 'DELETE FROM HuanLuyenVien WHERE MaHLV=?', [ (int)$_POST['MaHLV'] ]);
    }
}
$stmt = runQuery($conn, 'SELECT * FROM HuanLuyenVien ORDER BY MaHLV');
$rows = [];
while ($r = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) { $rows[] = $r; }
include '../includes/header.php';
?>
<div class="mb-4">
  <h2 class="fw-semibold mb-3">Quản lý Huấn luyện viên <span class="badge badge-hash">Phân mảnh dọc</span></h2>
  <div class="alert alert-info">
    <strong>Phân mảnh dọc:</strong> Dữ liệu được chia theo cột - Thông tin cơ bản (SiteA), Thông tin bổ sung (SiteB), Lịch sử sự nghiệp (SiteC). View toàn cục JOIN tự động.
  </div>
  <div class="row g-4">
    <div class="col-lg-5">
      <div class="card mb-3">
        <div class="card-header">Thêm / Cập nhật</div>
        <div class="card-body">
          <form method="post">
            <div class="mb-2"><label class="form-label">Mã HLV</label><input name="MaHLV" type="number" class="form-control form-control-sm" required></div>
            <div class="mb-2"><label class="form-label">Họ tên</label><input name="HoTen" class="form-control form-control-sm" required></div>
            <div class="mb-2"><label class="form-label">Quốc tịch</label><input name="QuocTich" class="form-control form-control-sm" required></div>
            <div class="mb-2"><label class="form-label">Mã đội bóng</label><input name="MaDB" type="number" class="form-control form-control-sm" required></div>
            <div class="mb-2"><label class="form-label">Ngày sinh</label><input name="NgaySinh" type="date" class="form-control form-control-sm" required></div>
            <div class="mb-2"><label class="form-label">Số điện thoại</label><input name="SoDienThoai" class="form-control form-control-sm" required></div>
            <div class="mb-2"><label class="form-label">Năm kinh nghiệm</label><input name="NamKinhNghiem" type="number" class="form-control form-control-sm" required></div>
            <div class="mb-2"><label class="form-label">Chức vụ trước</label><input name="ChucVuTruoc" class="form-control form-control-sm" required></div>
            <div class="mb-3"><label class="form-label">Thành tích</label><textarea name="ThanhTich" class="form-control form-control-sm" rows="2" required></textarea></div>
            <div class="d-flex gap-2"><button name="action" value="add" class="btn btn-success btn-sm">Thêm</button><button name="action" value="update" class="btn btn-warning btn-sm">Cập nhật</button></div>
          </form>
        </div>
      </div>
      <div class="card">
        <div class="card-header">Xóa</div>
        <div class="card-body">
          <form method="post" class="row g-2 align-items-end">
            <div class="col-8"><label class="form-label">Mã HLV</label><input name="MaHLV" type="number" class="form-control form-control-sm" required></div>
            <div class="col-auto"><button name="action" value="delete" class="btn btn-danger btn-sm">Xóa</button></div>
          </form>
        </div>
      </div>
    </div>
    <div class="col-lg-7">
      <div class="card h-100">
        <div class="card-header">Danh sách <span class="small-muted">(JOIN: SiteA + SiteB + SiteC)</span></div>
        <div class="card-body" style="max-height:600px; overflow-y:auto;">
          <table class="table table-sm table-hover align-middle">
            <thead class="sticky-top"><tr><th>Mã</th><th>Họ tên</th><th>Quốc tịch</th><th>Đội</th><th>Năm KN</th><th>Thành tích</th></tr></thead>
            <tbody>
            <?php foreach($rows as $r):?>
              <tr>
                <td><?=htmlspecialchars($r['MaHLV'])?></td>
                <td><strong><?=htmlspecialchars($r['HoTen'])?></strong></td>
                <td><?=htmlspecialchars($r['QuocTich'])?></td>
                <td><?=htmlspecialchars($r['MaDB'])?></td>
                <td><?=htmlspecialchars($r['NamKinhNghiem'])?> năm</td>
                <td><small><?=htmlspecialchars(substr($r['ThanhTich'],0,50))?>...</small></td>
              </tr>
            <?php endforeach; ?>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
  <div class="card mt-3">
    <div class="card-header">Cấu trúc phân mảnh dọc</div>
    <div class="card-body">
      <div class="row text-center">
        <div class="col-md-4">
          <div class="p-3 bg-primary-subtle rounded">
            <strong>SiteA: HLV_Basic</strong><br>
            <small>MaHLV, HoTen, QuocTich</small>
          </div>
        </div>
        <div class="col-md-4">
          <div class="p-3 bg-success-subtle rounded">
            <strong>SiteB: HLV_Additional</strong><br>
            <small>MaHLV, MaDB, NgaySinh, SoDienThoai</small>
          </div>
        </div>
        <div class="col-md-4">
          <div class="p-3 bg-warning-subtle rounded">
            <strong>SiteC: HLV_History</strong><br>
            <small>MaHLV, NamKinhNghiem, ChucVuTruoc, ThanhTich</small>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<?php include '../includes/footer.php'; ?>
