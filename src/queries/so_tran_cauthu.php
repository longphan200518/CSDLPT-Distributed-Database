<?php
require_once '../includes/db.php';
$pageTitle='Số trận tham gia';
$result = null; $hoten='';
if ($_SERVER['REQUEST_METHOD']==='POST') {
  $hoten = $_POST['HoTen'];
  $stmt = runQuery($conn, 'SELECT c.HoTen, COUNT(DISTINCT t.MaTD) AS SoTranThamGia FROM CauThu c JOIN ThamGia t ON c.MaCT = t.MaCT WHERE c.HoTen = ? GROUP BY c.HoTen', [$hoten]);
  $result = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
}
include '../includes/header.php';
?>
<div class="page-section">
  <div class="d-flex align-items-center justify-content-between mb-4">
    <h2 class="fw-bold mb-0">📈 Số trận cầu thủ đã tham gia</h2>
  </div>
  <div class="row g-4">
    <div class="col-lg-5">
      <div class="card shadow-sm">
        <div class="card-header bg-primary bg-opacity-10">
          <strong>🔎 Tìm kiếm</strong>
        </div>
        <div class="card-body">
          <form method="post">
            <div class="mb-3">
              <label class="form-label">👤 Họ tên cầu thủ</label>
              <input name="HoTen" class="form-control" value="<?=htmlspecialchars($hoten)?>" placeholder="Ví dụ: Erling Haaland" required>
            </div>
            <button class="btn btn-primary w-100">
              <strong>🔍 Tra cứu</strong>
            </button>
          </form>
        </div>
      </div>
    </div>
    <div class="col-lg-7">
      <div class="card h-100 shadow-sm">
        <div class="card-header">
          <strong>📊 Kết quả</strong>
        </div>
        <div class="card-body">
          <?php if($result): ?>
            <div class="alert alert-success">
              <h5 class="alert-heading">👤 <?=htmlspecialchars($result['HoTen'])?></h5>
              <hr>
              <p class="mb-0 fs-4">Đã tham gia: <strong><?=$result['SoTranThamGia']?></strong> trận đấu</p>
            </div>
          <?php elseif($hoten): ?>
            <div class="alert alert-warning">
              <strong>⚠️ Không tìm thấy cầu thủ</strong><br>
              <small>Không tìm thấy cầu thủ <strong><?=htmlspecialchars($hoten)?></strong> trong hệ thống.</small>
            </div>
          <?php else: ?>
            <div class="p-5 text-center text-muted">
              <div class="mb-3" style="font-size: 3rem;">🔍</div>
              <p class="mb-0"><strong>Nhập tên cầu thủ để xem số trận đã tham gia.</strong></p>
            </div>
          <?php endif; ?>
        </div>
      </div>
    </div>
  </div>
</div>
<?php include '../includes/footer.php'; ?>