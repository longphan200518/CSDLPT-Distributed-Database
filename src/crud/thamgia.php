<?php
require_once '../includes/db.php';
$pageTitle='Tham gia';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    if ($action === 'add') {
        runQuery($conn, 'INSERT INTO ThamGia (MaTD, MaCT, SoTrai) VALUES (?,?,?)', [ (int)$_POST['MaTD'], (int)$_POST['MaCT'], (int)$_POST['SoTrai'] ]);
    } elseif ($action === 'update') {
        runQuery($conn, 'UPDATE ThamGia SET SoTrai=? WHERE MaTD=? AND MaCT=?', [ (int)$_POST['SoTrai'], (int)$_POST['MaTD'], (int)$_POST['MaCT'] ]);
    } elseif ($action === 'delete') {
        runQuery($conn, 'DELETE FROM ThamGia WHERE MaTD=? AND MaCT=?', [ (int)$_POST['MaTD'], (int)$_POST['MaCT'] ]);
    }
}
$page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
$perPage = 15;
$offset = ($page - 1) * $perPage;

$stmtCount = runQuery($conn, 'SELECT COUNT(*) as total FROM ThamGia');
$totalRows = sqlsrv_fetch_array($stmtCount, SQLSRV_FETCH_ASSOC)['total'];
$totalPages = ceil($totalRows / $perPage);

$stmt = runQuery($conn, 'SELECT tg.MaTD, tg.MaCT, tg.SoTrai, c.HoTen, td.SanDau FROM ThamGia tg LEFT JOIN CauThu c ON tg.MaCT=c.MaCT LEFT JOIN TranDau td ON tg.MaTD=td.MaTD ORDER BY tg.MaTD, tg.MaCT OFFSET ? ROWS FETCH NEXT ? ROWS ONLY', [$offset, $perPage]);
$rows=[]; while($r=sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)){$rows[]=$r;}
include '../includes/header.php';
?>
<div class="page-section">
  <div class="d-flex align-items-center justify-content-between mb-4">
    <h2 class="fw-bold mb-0">🤝 Quản lý Tham gia</h2>
    <span class="badge bg-primary-subtle text-primary-emphasis px-3 py-2">
      <?=$totalRows?> bản ghi | Trang <?=$page?>/<?=$totalPages?>
    </span>
  </div>
  <div class="row g-4">
    <div class="col-lg-5">
      <div class="card mb-3 shadow-sm">
        <div class="card-header bg-success bg-opacity-10">
          <strong>➕ Thêm / Cập nhật</strong>
        </div>
        <div class="card-body">
          <form method="post" class="form-inline-grid" id="formThamGia" aria-label="Form thêm hoặc cập nhật tham gia">
            <div>
              <label class="form-label">🏟️ Mã TD</label>
              <input name="MaTD" id="inputMaTDTG" type="number" class="form-control" placeholder="Nhập mã trận đấu" required>
            </div>
            <div>
              <label class="form-label">👤 Mã CT</label>
              <input name="MaCT" id="inputMaCTTG" type="number" class="form-control" placeholder="Nhập mã cầu thủ" required>
            </div>
            <div>
              <label class="form-label">⚽ Số trái</label>
              <input name="SoTrai" id="inputSoTrai" type="number" class="form-control" placeholder="Nhập số trái" required>
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
          <form method="post" class="row g-2 align-items-end" aria-label="Form xóa tham gia">
            <div class="col-5">
              <label class="form-label">🏟️ Mã TD</label>
              <input name="MaTD" type="number" class="form-control" placeholder="Mã TD" required>
            </div>
            <div class="col-5">
              <label class="form-label">👤 Mã CT</label>
              <input name="MaCT" type="number" class="form-control" placeholder="Mã CT" required>
            </div>
            <div class="col-12">
              <button name="action" value="delete" class="btn btn-danger btn-sm w-100">
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
          <strong>📋 Danh sách tham gia</strong>
        </div>
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-hover table-zebra align-middle mb-0" aria-label="Danh sách tham gia">
              <thead>
                <tr>
                  <th>Trận đấu</th>
                  <th>Cầu thủ</th>
                  <th>Số trái</th>
                </tr>
              </thead>
              <tbody>
              <?php if(empty($rows)): ?>
                <tr>
                  <td colspan="3" class="text-center text-muted py-4">
                    <em>Chưa có dữ liệu. Hãy thêm bản ghi mới!</em>
                  </td>
                </tr>
              <?php else: ?>
                <?php foreach($rows as $r):?>
                  <tr class="clickable-row" style="cursor:pointer" data-matd="<?=$r['MaTD']?>" data-mact="<?=$r['MaCT']?>" data-sotrai="<?=$r['SoTrai']?>">
                    <td>
                      <strong><?=htmlspecialchars($r['SanDau'] ?? 'N/A')?></strong>
                      <br><small class="text-muted">Mã TD: <?=$r['MaTD']?></small>
                    </td>
                    <td>
                      <strong><?=htmlspecialchars($r['HoTen'] ?? 'N/A')?></strong>
                      <br><small class="text-muted">Mã CT: <?=$r['MaCT']?></small>
                    </td>
                    <td><span class="badge bg-success"><?=$r['SoTrai']?> bàn</span></td>
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
    document.getElementById('inputMaTDTG').value = this.dataset.matd;
    document.getElementById('inputMaCTTG').value = this.dataset.mact;
    document.getElementById('inputSoTrai').value = this.dataset.sotrai;
    document.getElementById('formThamGia').scrollIntoView({behavior: 'smooth', block: 'nearest'});
  });
});
</script>
<?php include '../includes/footer.php'; ?>