<?php
require_once '../includes/db.php';
$pageTitle='Cầu thủ';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    if ($action === 'add') {
        runQuery($conn, 'INSERT INTO CauThu (MaCT, HoTen, MaDB) VALUES (?,?,?)', [ (int)$_POST['MaCT'], $_POST['HoTen'], (int)$_POST['MaDB'] ]);
    } elseif ($action === 'update') {
        runQuery($conn, 'UPDATE CauThu SET HoTen=?, MaDB=? WHERE MaCT=?', [ $_POST['HoTen'], (int)$_POST['MaDB'], (int)$_POST['MaCT'] ]);
    } elseif ($action === 'delete') {
        runQuery($conn, 'DELETE FROM CauThu WHERE MaCT=?', [ (int)$_POST['MaCT'] ]);
    }
}
$page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
$perPage = 15;
$offset = ($page - 1) * $perPage;

$stmtCount = runQuery($conn, 'SELECT COUNT(*) as total FROM CauThu');
$totalRows = sqlsrv_fetch_array($stmtCount, SQLSRV_FETCH_ASSOC)['total'];
$totalPages = ceil($totalRows / $perPage);

$stmt = runQuery($conn, 'SELECT c.MaCT, c.HoTen, c.MaDB, d.TenDB, d.CLB FROM CauThu c LEFT JOIN DoiBong d ON c.MaDB=d.MaDB ORDER BY c.MaCT OFFSET ? ROWS FETCH NEXT ? ROWS ONLY', [$offset, $perPage]);
$rows = [];
while ($r = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) { $rows[] = $r; }
include '../includes/header.php';
?>
<div class="page-section">
  <div class="d-flex align-items-center justify-content-between mb-4">
    <h2 class="fw-bold mb-0">👤 Quản lý Cầu thủ</h2>
    <span class="badge bg-primary-subtle text-primary-emphasis px-3 py-2">
      <?=$totalRows?> cầu thủ | Trang <?=$page?>/<?=$totalPages?>
    </span>
  </div>
  <div class="row g-4">
    <div class="col-lg-5">
      <div class="card mb-3 shadow-sm">
        <div class="card-header bg-success bg-opacity-10">
          <strong>➕ Thêm / Cập nhật</strong>
        </div>
        <div class="card-body">
          <form method="post" class="form-inline-grid" id="formCauThu" aria-label="Form thêm hoặc cập nhật cầu thủ">
            <div>
              <label class="form-label">🔢 Mã cầu thủ</label>
              <input name="MaCT" id="inputMaCT" type="number" class="form-control" placeholder="Nhập mã cầu thủ" required>
            </div>
            <div>
              <label class="form-label">📝 Họ tên</label>
              <input name="HoTen" id="inputHoTen" class="form-control" placeholder="Nhập họ tên" required>
            </div>
            <div>
              <label class="form-label">⚽ Mã đội bóng</label>
              <input name="MaDB" id="inputMaDBCT" type="number" class="form-control" placeholder="Nhập mã đội bóng" required>
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
          <form method="post" class="row g-2 align-items-end" aria-label="Form xóa cầu thủ">
            <div class="col-8">
              <label class="form-label">🔢 Mã cầu thủ</label>
              <input name="MaCT" type="number" class="form-control" placeholder="Nhập mã để xóa" required>
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
          <strong>📋 Danh sách cầu thủ</strong>
        </div>
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-hover table-zebra align-middle mb-0" aria-label="Danh sách cầu thủ">
              <thead>
                <tr>
                  <th>Mã CT</th>
                  <th>Họ tên</th>
                  <th>Đội bóng</th>
                  <th>CLB</th>
                </tr>
              </thead>
              <tbody>
              <?php if(empty($rows)): ?>
                <tr>
                  <td colspan="4" class="text-center text-muted py-4">
                    <em>Chưa có dữ liệu. Hãy thêm cầu thủ mới!</em>
                  </td>
                </tr>
              <?php else: ?>
                <?php foreach($rows as $r):?>
                  <tr class="clickable-row" style="cursor:pointer" data-mact="<?=htmlspecialchars($r['MaCT'])?>" data-hoten="<?=htmlspecialchars($r['HoTen'])?>" data-madb="<?=htmlspecialchars($r['MaDB'])?>">
                    <td><span class="badge bg-secondary"><?=htmlspecialchars($r['MaCT'])?></span></td>
                    <td><strong><?=htmlspecialchars($r['HoTen'])?></strong></td>
                    <td><?=htmlspecialchars($r['TenDB'] ?? 'N/A')?> <small class="text-muted">(#<?=$r['MaDB']?>)</small></td>
                    <td><span class="badge bg-primary-subtle text-primary-emphasis"><?=htmlspecialchars($r['CLB'] ?? 'N/A')?></span></td>
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
</div>
<script>
document.querySelectorAll('.clickable-row').forEach(row => {
  row.addEventListener('click', function() {
    document.getElementById('inputMaCT').value = this.dataset.mact;
    document.getElementById('inputHoTen').value = this.dataset.hoten;
    document.getElementById('inputMaDBCT').value = this.dataset.madb;
    document.getElementById('formCauThu').scrollIntoView({behavior: 'smooth', block: 'nearest'});
  });
});
</script>
<?php include '../includes/footer.php'; ?>