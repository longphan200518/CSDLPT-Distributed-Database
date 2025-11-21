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
<div class="mb-4">
  <h2 class="fw-semibold mb-3">Truy vấn: Số trận cầu thủ đã tham gia</h2>
  <div class="row g-4">
    <div class="col-lg-5">
      <div class="card">
        <div class="card-header">Nhập tên cầu thủ</div>
        <div class="card-body">
          <form method="post">
            <div class="mb-3">
              <label class="form-label">Họ tên</label>
              <input name="HoTen" class="form-control" value="<?=htmlspecialchars($hoten)?>" placeholder="Ví dụ: Erling Haaland" required>
            </div>
            <button class="btn btn-primary">Tra cứu</button>
          </form>
        </div>
      </div>
    </div>
    <div class="col-lg-7">
      <div class="card h-100">
        <div class="card-header">Kết quả</div>
        <div class="card-body">
          <?php if($result): ?>
            <div class="alert alert-success">
              <h5 class="alert-heading"><?=htmlspecialchars($result['HoTen'])?></h5>
              <hr>
              <p class="mb-0 fs-4">Đã tham gia: <strong><?=$result['SoTranThamGia']?></strong> trận đấu</p>
            </div>
          <?php elseif($hoten): ?>
            <div class="alert alert-warning">Không tìm thấy cầu thủ <strong><?=htmlspecialchars($hoten)?></strong> trong hệ thống.</div>
          <?php else: ?>
            <div class="text-muted">Nhập tên cầu thủ để xem số trận đã tham gia.</div>
          <?php endif; ?>
        </div>
      </div>
    </div>
  </div>
</div>
<?php include '../includes/footer.php'; ?>