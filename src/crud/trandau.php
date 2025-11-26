<?php
require_once '../includes/db.php';
$pageTitle='Trận đấu';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    if ($action === 'add') {
        runQuery($conn, 'INSERT INTO TranDau (MaTD, MaDB1, MaDB2, TrongTai, SanDau) VALUES (?,?,?,?,?)', [ (int)$_POST['MaTD'], (int)$_POST['MaDB1'], (int)$_POST['MaDB2'], $_POST['TrongTai'], $_POST['SanDau'] ]);
    } elseif ($action === 'update') {
        runQuery($conn, 'UPDATE TranDau SET MaDB1=?, MaDB2=?, TrongTai=?, SanDau=? WHERE MaTD=?', [ (int)$_POST['MaDB1'], (int)$_POST['MaDB2'], $_POST['TrongTai'], $_POST['SanDau'], (int)$_POST['MaTD'] ]);
    } elseif ($action === 'delete') {
        runQuery($conn, 'DELETE FROM TranDau WHERE MaTD=?', [ (int)$_POST['MaTD'] ]);
    }
}
$page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
$perPage = 15;
$offset = ($page - 1) * $perPage;

$stmtCount = runQuery($conn, 'SELECT COUNT(*) as total FROM TranDau');
$totalRows = sqlsrv_fetch_array($stmtCount, SQLSRV_FETCH_ASSOC)['total'];
$totalPages = ceil($totalRows / $perPage);

$stmt = runQuery($conn, 'SELECT td.MaTD, td.MaDB1, d1.TenDB AS TenDB1, d1.CLB AS CLB1, d1.GiaiDau AS GiaiDau1, td.MaDB2, d2.TenDB AS TenDB2, d2.CLB AS CLB2, d2.GiaiDau AS GiaiDau2, td.TrongTai, td.SanDau FROM TranDau td JOIN DoiBong d1 ON td.MaDB1=d1.MaDB JOIN DoiBong d2 ON td.MaDB2=d2.MaDB ORDER BY td.MaTD OFFSET ? ROWS FETCH NEXT ? ROWS ONLY', [$offset, $perPage]);
$rows=[]; while($r=sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)){$rows[]=$r;}
include '../includes/header.php';
?>
<div class="page-section">
  <div class="d-flex align-items-center justify-content-between mb-4">
    <h2 class="fw-bold mb-0">🏟️ Quản lý Trận đấu</h2>
    <span class="badge bg-primary-subtle text-primary-emphasis px-3 py-2">
      <?=$totalRows?> trận đấu | Trang <?=$page?>/<?=$totalPages?>
    </span>
  </div>
  <div class="row g-4">
    <div class="col-lg-6">
      <div class="card mb-3 shadow-sm">
        <div class="card-header bg-success bg-opacity-10">
          <strong>➕ Thêm / Cập nhật</strong>
        </div>
        <div class="card-body">
          <form method="post" class="form-inline-grid" id="formTranDau" aria-label="Form thêm hoặc cập nhật trận đấu">
            <div>
              <label class="form-label">🔢 Mã TD</label>
              <input name="MaTD" id="inputMaTD" type="number" class="form-control" placeholder="Nhập mã trận đấu" required>
            </div>
            <div>
              <label class="form-label">⚽ Mã ĐB 1</label>
              <input name="MaDB1" id="inputMaDB1" type="number" class="form-control" placeholder="Nhập mã đội 1" required>
            </div>
            <div>
              <label class="form-label">⚽ Mã ĐB 2</label>
              <input name="MaDB2" id="inputMaDB2" type="number" class="form-control" placeholder="Nhập mã đội 2" required>
            </div>
            <div>
              <label class="form-label">👔 Trọng tài</label>
              <input name="TrongTai" id="inputTrongTai" class="form-control" placeholder="Nhập tên trọng tài" required>
            </div>
            <div>
              <label class="form-label">🏟️ Sân đấu</label>
              <input name="SanDau" id="inputSanDau" class="form-control" placeholder="Nhập tên sân đấu" required>
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
          <form method="post" class="row g-2 align-items-end" aria-label="Form xóa trận đấu">
            <div class="col-8">
              <label class="form-label">🔢 Mã TD</label>
              <input name="MaTD" type="number" class="form-control" placeholder="Nhập mã để xóa" required>
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
    <div class="col-lg-6">
      <div class="card h-100 shadow-sm">
        <div class="card-header">
          <strong>📋 Danh sách trận đấu</strong>
        </div>
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-hover table-zebra align-middle mb-0" aria-label="Danh sách trận đấu">
              <thead>
                <tr>
                  <th>Mã TD</th>
                  <th>Đội 1</th>
                  <th>Đội 2</th>
                  <th>Trọng tài</th>
                  <th>Sân đấu</th>
                </tr>
              </thead>
              <tbody>
              <?php if(empty($rows)): ?>
                <tr>
                  <td colspan="5" class="text-center text-muted py-4">
                    <em>Chưa có dữ liệu. Hãy thêm trận đấu mới!</em>
                  </td>
                </tr>
              <?php else: ?>
                <?php foreach($rows as $r):?>
                  <tr class="clickable-row" style="cursor:pointer" data-matd="<?=$r['MaTD']?>" data-madb1="<?=$r['MaDB1']?>" data-madb2="<?=$r['MaDB2']?>" data-trongtai="<?=htmlspecialchars($r['TrongTai'])?>" data-sandau="<?=htmlspecialchars($r['SanDau'])?>">
                    <td><strong><?=$r['MaTD']?></strong></td>
                    <td>
                      <strong><?=htmlspecialchars($r['TenDB1'])?></strong><br>
                      <small class="text-muted">CLB: <?=htmlspecialchars($r['CLB1'])?> | Giải: <?=htmlspecialchars($r['GiaiDau1'])?></small>
                    </td>
                    <td>
                      <strong><?=htmlspecialchars($r['TenDB2'])?></strong><br>
                      <small class="text-muted">CLB: <?=htmlspecialchars($r['CLB2'])?> | Giải: <?=htmlspecialchars($r['GiaiDau2'])?></small>
                    </td>
                    <td><?=htmlspecialchars($r['TrongTai'])?></td>
                    <td><?=htmlspecialchars($r['SanDau'])?></td>
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
    document.getElementById('inputMaTD').value = this.dataset.matd;
    document.getElementById('inputMaDB1').value = this.dataset.madb1;
    document.getElementById('inputMaDB2').value = this.dataset.madb2;
    document.getElementById('inputTrongTai').value = this.dataset.trongtai;
    document.getElementById('inputSanDau').value = this.dataset.sandau;
    document.getElementById('formTranDau').scrollIntoView({behavior: 'smooth', block: 'nearest'});
  });
});
</script>
<?php include '../includes/footer.php'; ?>