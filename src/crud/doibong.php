<?php
require_once '../includes/db.php';
$pageTitle='Đội bóng';
// Handle create/update/delete
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    if ($action === 'add') {
        runQuery($conn, 'INSERT INTO DoiBong (MaDB, TenDB, CLB) VALUES (?,?,?)', [ (int)$_POST['MaDB'], $_POST['TenDB'], $_POST['CLB'] ]);
    } elseif ($action === 'update') {
        runQuery($conn, 'UPDATE DoiBong SET TenDB=?, CLB=? WHERE MaDB=?', [ $_POST['TenDB'], $_POST['CLB'], (int)$_POST['MaDB'] ]);
    } elseif ($action === 'delete') {
        runQuery($conn, 'DELETE FROM DoiBong WHERE MaDB=?', [ (int)$_POST['MaDB'] ]);
    }
}
$page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
$perPage = 15;
$offset = ($page - 1) * $perPage;

$stmtCount = runQuery($conn, 'SELECT COUNT(*) as total FROM DoiBong');
$totalRows = sqlsrv_fetch_array($stmtCount, SQLSRV_FETCH_ASSOC)['total'];
$totalPages = ceil($totalRows / $perPage);

$stmt = runQuery($conn, 'SELECT * FROM DoiBong ORDER BY MaDB OFFSET ? ROWS FETCH NEXT ? ROWS ONLY', [$offset, $perPage]);
$rows = [];
while ($r = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) { $rows[] = $r; }
include '../includes/header.php';
?>
<div class="page-section">
  <div class="d-flex align-items-center justify-content-between mb-4">
    <h2 class="fw-bold mb-0">⚽ Quản lý Đội bóng</h2>
    <span class="badge bg-primary-subtle text-primary-emphasis px-3 py-2">
      <?=$totalRows?> đội bóng | Trang <?=$page?>/<?=$totalPages?>
    </span>
  </div>
  <div class="row g-4">
    <div class="col-lg-5">
      <div class="card mb-3 shadow-sm">
        <div class="card-header bg-success bg-opacity-10">
          <strong>➕ Thêm / Cập nhật</strong>
        </div>
        <div class="card-body">
          <form method="post" class="form-inline-grid" id="formDoiBong" aria-label="Form thêm hoặc cập nhật đội bóng">
            <div>
              <label class="form-label">🔢 Mã đội bóng</label>
              <input name="MaDB" id="inputMaDB" type="number" class="form-control" placeholder="Nhập mã đội bóng" required>
            </div>
            <div>
              <label class="form-label">📝 Tên đội bóng</label>
              <input name="TenDB" id="inputTenDB" class="form-control" placeholder="Nhập tên đội bóng" required>
            </div>
            <div>
              <label class="form-label">🏢 CLB</label>
              <input name="CLB" id="inputCLB" class="form-control" placeholder="Nhập tên CLB" required>
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
          <form method="post" class="row g-2 align-items-end" aria-label="Form xóa đội bóng">
            <div class="col-8">
              <label class="form-label">🔢 Mã đội bóng</label>
              <input name="MaDB" type="number" class="form-control" placeholder="Nhập mã để xóa" required>
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
          <strong>📋 Danh sách đội bóng</strong>
        </div>
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-hover table-zebra align-middle mb-0" aria-label="Danh sách đội bóng">
              <thead>
                <tr>
                  <th>Mã</th>
                  <th>Tên đội bóng</th>
                  <th>CLB</th>
                </tr>
              </thead>
              <tbody>
              <?php if(empty($rows)): ?>
                <tr>
                  <td colspan="3" class="text-center text-muted py-4">
                    <em>Chưa có dữ liệu. Hãy thêm đội bóng mới!</em>
                  </td>
                </tr>
              <?php else: ?>
                <?php foreach($rows as $r): ?>
                  <tr class="clickable-row" style="cursor:pointer" data-madb="<?=htmlspecialchars($r['MaDB'])?>" data-tendb="<?=htmlspecialchars($r['TenDB'])?>" data-clb="<?=htmlspecialchars($r['CLB'])?>">
                    <td><strong><?=htmlspecialchars($r['MaDB'])?></strong></td>
                    <td><?=htmlspecialchars($r['TenDB'])?></td>
                    <td><span class="badge bg-primary-subtle text-primary-emphasis px-3 py-2"><?=htmlspecialchars($r['CLB'])?></span></td>
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
    document.getElementById('inputMaDB').value = this.dataset.madb;
    document.getElementById('inputTenDB').value = this.dataset.tendb;
    document.getElementById('inputCLB').value = this.dataset.clb;
    document.getElementById('formDoiBong').scrollIntoView({behavior: 'smooth', block: 'nearest'});
  });
});
</script>
<?php include '../includes/footer.php'; ?>