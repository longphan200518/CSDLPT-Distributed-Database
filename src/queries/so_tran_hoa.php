<?php
require_once '../includes/db.php';
$pageTitle='Số trận hòa';
$result = null; $s=$sum1=$sum2='';
if ($_SERVER['REQUEST_METHOD']==='POST') {
  $s = $_POST['SanDau'];
  $sql = "SELECT COUNT(*) AS SoTranHoa FROM TranDau td WHERE td.SanDau = ? AND ( (SELECT SUM(t1.SoTrai) FROM ThamGia t1 JOIN CauThu c1 ON t1.MaCT=c1.MaCT WHERE t1.MaTD=td.MaTD AND c1.MaDB=td.MaDB1) = (SELECT SUM(t2.SoTrai) FROM ThamGia t2 JOIN CauThu c2 ON t2.MaCT=c2.MaCT WHERE t2.MaTD=td.MaTD AND c2.MaDB=td.MaDB2) )";
  $stmt = runQuery($conn, $sql, [$s]);
  $result = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
}
include '../includes/header.php';
?>
<div class="page-section">
  <div class="d-flex align-items-center justify-content-between mb-4">
    <h2 class="fw-bold mb-0">⚖️ Số trận hòa tại sân đấu</h2>
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
              <label class="form-label">🏟️ Sân đấu</label>
              <input name="SanDau" class="form-control" value="<?=htmlspecialchars($s)?>" placeholder="Ví dụ: Old Trafford" required>
              <div class="form-text">Etihad Stadium, Anfield, Old Trafford, Camp Nou...</div>
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
          <?php if($result!==null && $s): ?>
            <div class="alert alert-info">
              <h5 class="alert-heading">🏟️ Sân: <?=htmlspecialchars($s)?></h5>
              <hr>
              <p class="mb-0 fs-4">Số trận hòa: <strong><?=$result['SoTranHoa']?></strong></p>
            </div>
          <?php elseif($s): ?>
            <div class="alert alert-warning">
              <strong>⚠️ Không tìm thấy dữ liệu</strong><br>
              <small>Không tìm thấy dữ liệu cho sân <strong><?=htmlspecialchars($s)?></strong>.</small>
            </div>
          <?php else: ?>
            <div class="p-5 text-center text-muted">
              <div class="mb-3" style="font-size: 3rem;">🔍</div>
              <p class="mb-0"><strong>Nhập tên sân đấu để xem số trận hòa đã diễn ra.</strong></p>
            </div>
          <?php endif; ?>
        </div>
      </div>
    </div>
  </div>
</div>
<?php include '../includes/footer.php'; ?>