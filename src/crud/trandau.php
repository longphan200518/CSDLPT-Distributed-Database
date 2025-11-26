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
$stmt = runQuery($conn, 'SELECT td.MaTD, td.MaDB1, d1.TenDB AS TenDB1, d1.CLB AS CLB1, d1.GiaiDau AS GiaiDau1, td.MaDB2, d2.TenDB AS TenDB2, d2.CLB AS CLB2, d2.GiaiDau AS GiaiDau2, td.TrongTai, td.SanDau FROM TranDau td JOIN DoiBong d1 ON td.MaDB1=d1.MaDB JOIN DoiBong d2 ON td.MaDB2=d2.MaDB ORDER BY td.MaTD');
$rows=[]; while($r=sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)){$rows[]=$r;}
include '../includes/header.php';
?>
<div class="page-section">
  <h2 class="fw-semibold mb-3">Quản lý Trận đấu</h2>
  <div class="row g-4">
    <div class="col-lg-6">
      <div class="card mb-3">
        <div class="card-header">Thêm / Cập nhật</div>
        <div class="card-body">
          <form method="post" class="form-inline-grid" aria-label="Form thêm hoặc cập nhật trận đấu">
            <div><label class="form-label">Mã TD</label><input name="MaTD" type="number" class="form-control" required></div>
            <div><label class="form-label">Mã ĐB 1</label><input name="MaDB1" type="number" class="form-control" required></div>
            <div><label class="form-label">Mã ĐB 2</label><input name="MaDB2" type="number" class="form-control" required></div>
            <div><label class="form-label">Trọng tài</label><input name="TrongTai" class="form-control" required></div>
            <div><label class="form-label">Sân đấu</label><input name="SanDau" class="form-control" required></div>
            <div class="form-actions"><button name="action" value="add" class="btn btn-success btn-sm">Thêm</button><button name="action" value="update" class="btn btn-warning btn-sm">Cập nhật</button></div>
          </form>
        </div>
      </div>
      <div class="card">
        <div class="card-header">Xóa</div>
        <div class="card-body">
          <form method="post" class="row g-2 align-items-end" aria-label="Form xóa trận đấu">
            <div class="col-8"><label class="form-label">Mã TD</label><input name="MaTD" type="number" class="form-control" required></div>
            <div class="col-auto"><button name="action" value="delete" class="btn btn-danger btn-sm">Xóa</button></div>
          </form>
        </div>
      </div>
    </div>
    <div class="col-lg-6">
      <div class="card h-100">
        <div class="card-header">Danh sách</div>
        <div class="card-body">
          <div class="table-responsive">
          <table class="table table-sm table-hover table-zebra align-middle" aria-label="Danh sách trận đấu">
            <thead><tr><th>Mã TD</th><th>Đội 1</th><th>Đội 2</th><th>Trọng tài</th><th>Sân đấu</th></tr></thead>
            <tbody>
            <?php foreach($rows as $r):?>
              <tr>
                <td><?=$r['MaTD']?></td>
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
            </tbody>
          </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<?php include '../includes/footer.php'; ?>