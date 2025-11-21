<?php
require_once '../includes/db.php';
$pageTitle='Cầu thủ theo CLB';
$result = [];$search='';$searchType='league';
if ($_SERVER['REQUEST_METHOD']==='POST') {
  $search = $_POST['search'];
  $searchType = $_POST['searchType'];
  if($searchType === 'league') {
    $stmt = runQuery($conn, 'SELECT c.MaCT, c.HoTen, c.ViTri, d.TenDB FROM CauThu c JOIN DoiBong d ON c.MaDB=d.MaDB WHERE d.GiaiDau=? ORDER BY d.TenDB', [$search]);
  } else {
    $stmt = runQuery($conn, 'SELECT c.MaCT, c.HoTen, c.ViTri, d.TenDB FROM CauThu c JOIN DoiBong d ON c.MaDB=d.MaDB WHERE d.CLB=? ORDER BY c.HoTen', [$search]);
  }
  while($r=sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {$result[]=$r;}
}
include '../includes/header.php';
?>
<div class="mb-4">
  <h2 class="fw-semibold mb-3">Truy vấn: Cầu thủ theo giải đấu hoặc CLB</h2>
  <div class="row g-4">
    <div class="col-lg-4">
      <div class="card">
        <div class="card-header">Tìm kiếm cầu thủ</div>
        <div class="card-body">
          <form method="post">
            <div class="mb-3">
              <label class="form-label">Loại tìm kiếm</label>
              <select name="searchType" class="form-select mb-2">
                <option value="league" <?=$searchType==='league'?'selected':''?>>Theo giải đấu</option>
                <option value="club" <?=$searchType==='club'?'selected':''?>>Theo câu lạc bộ</option>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label">Tên giải đấu / CLB</label>
              <input name="search" class="form-control" value="<?=htmlspecialchars($search)?>" placeholder="Premier League hoặc Arsenal FC" required>
              <div class="form-text"><strong>Giải:</strong> Premier League, La Liga, Serie A, Bundesliga, Ligue 1<br><strong>CLB:</strong> Manchester City FC, Arsenal FC...</div>
            </div>
            <button class="btn btn-primary">Tra cứu</button>
          </form>
        </div>
      </div>
    </div>
    <div class="col-lg-8">
      <div class="card h-100">
        <div class="card-header">Kết quả</div>
        <div class="card-body">
          <?php if($result): ?>
            <table class="table table-sm table-hover">
              <thead><tr><th>Mã CT</th><th>Họ tên</th><th>Vị trí</th><th>Đội bóng</th></tr></thead>
              <tbody>
              <?php foreach($result as $r):?>
                <tr><td><?=$r['MaCT']?></td><td><?=htmlspecialchars($r['HoTen'])?></td><td><?=htmlspecialchars($r['ViTri'])?></td><td><?=htmlspecialchars($r['TenDB'])?></td></tr>
              <?php endforeach; ?>
              </tbody>
            </table>
            <div class="text-muted">Tổng: <?=count($result)?> cầu thủ</div>
          <?php elseif($search): ?>
            <div class="alert alert-warning">Không tìm thấy cầu thủ nào.</div>
          <?php else: ?>
            <div class="text-muted">Chọn loại tìm kiếm và nhập tên để tra cứu.</div>
          <?php endif; ?>
        </div>
      </div>
    </div>
  </div>
</div>
<?php include '../includes/footer.php'; ?>