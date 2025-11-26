<?php
require_once '../includes/db.php';
$pageTitle='Huấn luyện viên';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    if ($action === 'add') {
        runQuery($conn, 'INSERT INTO HuanLuyenVien (MaHLV, HoTen, QuocTich, MaDB, NamKinhNghiem, ThanhTich) VALUES (?,?,?,?,?,?)', [ 
            (int)$_POST['MaHLV'], 
            $_POST['HoTen'], 
            $_POST['QuocTich'], 
            (int)$_POST['MaDB'],
            isset($_POST['NamKinhNghiem']) && $_POST['NamKinhNghiem'] !== '' ? (int)$_POST['NamKinhNghiem'] : null,
            $_POST['ThanhTich'] ?? null
        ]);
    } elseif ($action === 'update') {
        runQuery($conn, 'UPDATE HuanLuyenVien SET HoTen=?, QuocTich=?, MaDB=?, NamKinhNghiem=?, ThanhTich=? WHERE MaHLV=?', [ 
            $_POST['HoTen'], 
            $_POST['QuocTich'], 
            (int)$_POST['MaDB'],
            isset($_POST['NamKinhNghiem']) && $_POST['NamKinhNghiem'] !== '' ? (int)$_POST['NamKinhNghiem'] : null,
            $_POST['ThanhTich'] ?? null,
            (int)$_POST['MaHLV'] 
        ]);
    } elseif ($action === 'delete') {
        runQuery($conn, 'DELETE FROM HuanLuyenVien WHERE MaHLV=?', [ (int)$_POST['MaHLV'] ]);
    }
}
$page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
$perPage = 15;
$offset = ($page - 1) * $perPage;

$stmtCount = runQuery($conn, 'SELECT COUNT(*) as total FROM HuanLuyenVien');
$totalRows = sqlsrv_fetch_array($stmtCount, SQLSRV_FETCH_ASSOC)['total'];
$totalPages = ceil($totalRows / $perPage);

$stmt = runQuery($conn, 'SELECT * FROM HuanLuyenVien ORDER BY MaHLV OFFSET ? ROWS FETCH NEXT ? ROWS ONLY', [$offset, $perPage]);
$rows = [];
while ($r = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) { $rows[] = $r; }
include '../includes/header.php';
?>
<div class="page-section">
  <div class="d-flex align-items-center justify-content-between mb-4">
    <h2 class="fw-bold mb-0">👔 Quản lý Huấn luyện viên</h2>
    <span class="badge bg-primary-subtle text-primary-emphasis px-3 py-2">
      <?=$totalRows?> huấn luyện viên | Trang <?=$page?>/<?=$totalPages?>
    </span>
  </div>
  <div class="alert alert-info mb-4">
    <strong>📊 Phân mảnh dọc:</strong> Dữ liệu được chia theo cột - Thông tin cơ bản (SiteA), Thông tin bổ sung (SiteB), Lịch sử sự nghiệp (SiteC). View toàn cục JOIN tự động.
  </div>
  <div class="row g-4">
    <div class="col-lg-5">
      <div class="card mb-3 shadow-sm">
        <div class="card-header bg-success bg-opacity-10">
          <strong>➕ Thêm / Cập nhật</strong>
        </div>
        <div class="card-body">
          <form method="post" class="form-inline-grid" id="formHLV" aria-label="Form thêm hoặc cập nhật huấn luyện viên">
            <div>
              <label class="form-label">🔢 Mã HLV</label>
              <input name="MaHLV" id="inputMaHLV" type="number" class="form-control" placeholder="Nhập mã HLV" required>
            </div>
            <div>
              <label class="form-label">📝 Họ tên</label>
              <input name="HoTen" id="inputHoTenHLV" class="form-control" placeholder="Nhập họ tên" required>
            </div>
            <div>
              <label class="form-label">🌍 Quốc tịch</label>
              <input name="QuocTich" id="inputQuocTich" class="form-control" placeholder="Nhập quốc tịch" required>
            </div>
            <div>
              <label class="form-label">⚽ Mã đội bóng</label>
              <input name="MaDB" id="inputMaDBHLV" type="number" class="form-control" placeholder="Nhập mã đội bóng" required>
            </div>
            <div>
              <label class="form-label">📅 Năm kinh nghiệm</label>
              <input name="NamKinhNghiem" id="inputNamKN" type="number" class="form-control" placeholder="Số năm kinh nghiệm">
            </div>
            <div>
              <label class="form-label">🏆 Thành tích</label>
              <textarea name="ThanhTich" id="inputThanhTich" class="form-control" placeholder="Nhập thành tích" rows="2"></textarea>
            </div>
            <div class="form-actions">
              <button name="action" value="add" class="btn btn-success btn-sm">
                <strong>➕ Thêm mới</strong>
              </button>
              <button name="action" value="update" class="btn btn-warning btn-sm">
                <strong>✏️ Cập nhật</strong>
              </button>
            </div>
          </form>
        </div>
      </div>
      <div class="card shadow-sm">
        <div class="card-header bg-danger bg-opacity-10">
          <strong>🗑️ Xóa</strong>
        </div>
        <div class="card-body">
          <form method="post" class="row g-2 align-items-end" aria-label="Form xóa huấn luyện viên">
            <div class="col-8">
              <label class="form-label">🔢 Mã HLV</label>
              <input name="MaHLV" type="number" class="form-control" placeholder="Nhập mã để xóa" required>
            </div>
            <div class="col-auto">
              <button name="action" value="delete" class="btn btn-danger btn-sm">
                <strong>🗑️ Xóa</strong>
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <div class="col-lg-7">
      <div class="card h-100 shadow-sm">
        <div class="card-header">
          <strong>📋 Danh sách huấn luyện viên</strong>
          <small class="text-muted ms-2">(JOIN: SiteA + SiteB + SiteC)</small>
        </div>
        <div class="card-body p-0">
          <div class="table-responsive" style="max-height:600px;">
            <table class="table table-hover table-zebra align-middle mb-0">
              <thead class="sticky-top">
                <tr>
                  <th>Mã</th>
                  <th>Họ tên</th>
                  <th>Quốc tịch</th>
                  <th>Đội</th>
                  <th>Năm KN</th>
                  <th>Thành tích</th>
                </tr>
              </thead>
              <tbody>
              <?php if(empty($rows)): ?>
                <tr>
                  <td colspan="6" class="text-center text-muted py-4">
                    <em>Chưa có dữ liệu. Hãy thêm huấn luyện viên mới!</em>
                  </td>
                </tr>
              <?php else: ?>
                <?php foreach($rows as $r):?>
                  <tr class="clickable-row" style="cursor:pointer" data-mahlv="<?=htmlspecialchars($r['MaHLV'])?>" data-hoten="<?=htmlspecialchars($r['HoTen'])?>" data-quoctich="<?=htmlspecialchars($r['QuocTich'])?>" data-madb="<?=htmlspecialchars($r['MaDB'])?>" data-namkn="<?=isset($r['NamKinhNghiem']) ? htmlspecialchars($r['NamKinhNghiem']) : ''?>" data-thanhtich="<?=isset($r['ThanhTich']) ? htmlspecialchars($r['ThanhTich']) : ''?>">
                    <td><strong><?=htmlspecialchars($r['MaHLV'])?></strong></td>
                    <td><?=htmlspecialchars($r['HoTen'])?></td>
                    <td><span class="badge bg-primary-subtle text-primary-emphasis"><?=htmlspecialchars($r['QuocTich'])?></span></td>
                    <td><?=htmlspecialchars($r['MaDB'])?></td>
                    <td><?=isset($r['NamKinhNghiem']) ? htmlspecialchars($r['NamKinhNghiem']) . ' năm' : 'N/A'?></td>
                    <td><small><?=isset($r['ThanhTich']) ? htmlspecialchars(substr($r['ThanhTich'],0,50)) . '...' : 'N/A'?></small></td>
                  </tr>
                <?php endforeach; ?>
              <?php endif; ?>
              </tbody>
            </table>
          </div>
        </div>
        <?php if($totalPages > 1): ?>
        <div class="card-footer">
          <nav aria-label="Phân trang">
            <ul class="pagination pagination-sm justify-content-center mb-0">
              <?php if($page > 1): ?>
                <li class="page-item"><a class="page-link" href="?page=1">Đầu</a></li>
                <li class="page-item"><a class="page-link" href="?page=<?=$page-1?>">Trước</a></li>
              <?php endif; ?>
              <?php for($i = max(1, $page-2); $i <= min($totalPages, $page+2); $i++): ?>
                <li class="page-item <?=$i==$page?'active':''?>"><a class="page-link" href="?page=<?=$i?>"><?=$i?></a></li>
              <?php endfor; ?>
              <?php if($page < $totalPages): ?>
                <li class="page-item"><a class="page-link" href="?page=<?=$page+1?>">Sau</a></li>
                <li class="page-item"><a class="page-link" href="?page=<?=$totalPages?>">Cuối</a></li>
              <?php endif; ?>
            </ul>
          </nav>
        </div>
        <?php endif; ?>
      </div>
    </div>
  </div>
  <div class="card mt-4 shadow-sm">
    <div class="card-header">
      <strong>📊 Cấu trúc phân mảnh dọc</strong>
    </div>
    <div class="card-body">
      <div class="row text-center g-3">
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
<script>
document.querySelectorAll('.clickable-row').forEach(row => {
  row.addEventListener('click', function() {
    document.getElementById('inputMaHLV').value = this.dataset.mahlv;
    document.getElementById('inputHoTenHLV').value = this.dataset.hoten;
    document.getElementById('inputQuocTich').value = this.dataset.quoctich;
    document.getElementById('inputMaDBHLV').value = this.dataset.madb;
    document.getElementById('inputNamKN').value = this.dataset.namkn || '';
    document.getElementById('inputThanhTich').value = this.dataset.thanhtich || '';
    document.getElementById('formHLV').scrollIntoView({behavior: 'smooth', block: 'nearest'});
  });
});
</script>
<?php include '../includes/footer.php'; ?>
