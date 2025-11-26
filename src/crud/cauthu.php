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
$stmt = runQuery($conn, 'SELECT * FROM CauThu ORDER BY MaCT');
$rows = [];
while ($r = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) { $rows[] = $r; }
include '../includes/header.php';
?>
<div class="page-section">
  <h2 class="fw-semibold mb-3">Quản lý Cầu thủ</h2>
  <div class="row g-4">
    <div class="col-lg-5">
      <div class="card mb-3">
        <div class="card-header">Thêm / Cập nhật</div>
        <div class="card-body">
          <form method="post" class="form-inline-grid" aria-label="Form thêm hoặc cập nhật cầu thủ">
            <div><label class="form-label">Mã CT</label><input name="MaCT" type="number" class="form-control" required></div>
            <div><label class="form-label">Họ tên</label><input name="HoTen" class="form-control" required></div>
            <div><label class="form-label">Mã đội bóng</label><input name="MaDB" type="number" class="form-control" required></div>
            <div class="form-actions"><button name="action" value="add" class="btn btn-success btn-sm">Thêm</button><button name="action" value="update" class="btn btn-warning btn-sm">Cập nhật</button></div>
          </form>
        </div>
      </div>
      <div class="card">
        <div class="card-header">Xóa</div>
        <div class="card-body">
          <form method="post" class="row g-2 align-items-end" aria-label="Form xóa cầu thủ">
            <div class="col-8"><label class="form-label">Mã CT</label><input name="MaCT" type="number" class="form-control" required></div>
            <div class="col-auto"><button name="action" value="delete" class="btn btn-danger btn-sm">Xóa</button></div>
          </form>
        </div>
      </div>
    </div>
    <div class="col-lg-7">
      <div class="card h-100">
        <div class="card-header">Danh sách</div>
        <div class="card-body">
          <div class="table-responsive">
          <table class="table table-sm table-hover table-zebra align-middle" aria-label="Danh sách cầu thủ">
            <thead><tr><th>Mã</th><th>Họ tên</th><th>Đội bóng</th></tr></thead>
            <tbody>
            <?php foreach($rows as $r):?>
              <tr><td><?=htmlspecialchars($r['MaCT'])?></td><td><?=htmlspecialchars($r['HoTen'])?></td><td><?=htmlspecialchars($r['MaDB'])?></td></tr>
            <?php endforeach; ?>
            </tbody>
          </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<?php include '../includes/footer.php'; ?>