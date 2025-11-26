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
$stmt = runQuery($conn, 'SELECT * FROM ThamGia ORDER BY MaTD, MaCT');
$rows=[]; while($r=sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)){$rows[]=$r;}
include '../includes/header.php';
?>
<div class="page-section">
  <h2 class="fw-semibold mb-3">Quản lý Tham gia</h2>
  <div class="row g-4">
    <div class="col-lg-5">
      <div class="card mb-3">
        <div class="card-header">Thêm / Cập nhật</div>
        <div class="card-body">
          <form method="post" class="form-inline-grid" aria-label="Form thêm hoặc cập nhật tham gia">
            <div><label class="form-label">Mã TD</label><input name="MaTD" type="number" class="form-control" required></div>
            <div><label class="form-label">Mã CT</label><input name="MaCT" type="number" class="form-control" required></div>
            <div><label class="form-label">Số trái</label><input name="SoTrai" type="number" class="form-control" required></div>
            <div class="form-actions"><button name="action" value="add" class="btn btn-success btn-sm">Thêm</button><button name="action" value="update" class="btn btn-warning btn-sm">Cập nhật</button></div>
          </form>
        </div>
      </div>
      <div class="card">
        <div class="card-header">Xóa</div>
        <div class="card-body">
          <form method="post" class="row g-2 align-items-end" aria-label="Form xóa tham gia">
            <div class="col-5"><label class="form-label">Mã TD</label><input name="MaTD" type="number" class="form-control" required></div>
            <div class="col-5"><label class="form-label">Mã CT</label><input name="MaCT" type="number" class="form-control" required></div>
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
          <table class="table table-sm table-hover table-zebra align-middle" aria-label="Danh sách tham gia">
            <thead><tr><th>Mã TD</th><th>Mã CT</th><th>Số trái</th></tr></thead>
            <tbody>
            <?php foreach($rows as $r):?>
              <tr><td><?=$r['MaTD']?></td><td><?=$r['MaCT']?></td><td><?=$r['SoTrai']?></td></tr>
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