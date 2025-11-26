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
<div class="page-section">
  <div class="d-flex align-items-center justify-content-between mb-4">
    <h2 class="fw-bold mb-0">🔍 Cầu thủ theo giải đấu hoặc CLB</h2>
    <?php if($result): ?>
      <span class="badge bg-primary-subtle text-primary-emphasis px-3 py-2">
        <?=count($result)?> kết quả
      </span>
    <?php endif; ?>
  </div>
  <div class="row g-4">
    <div class="col-lg-4">
      <div class="card shadow-sm">
        <div class="card-header bg-primary bg-opacity-10">
          <strong>🔎 Tìm kiếm cầu thủ</strong>
        </div>
        <div class="card-body">
          <form method="post">
            <div class="mb-3">
              <label class="form-label">📋 Loại tìm kiếm</label>
              <select name="searchType" class="form-select mb-2">
                <option value="league" <?=$searchType==='league'?'selected':''?>>🏆 Theo giải đấu</option>
                <option value="club" <?=$searchType==='club'?'selected':''?>>🏢 Theo câu lạc bộ</option>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label">✏️ Tên giải đấu / CLB</label>
              <input name="search" class="form-control" value="<?=htmlspecialchars($search)?>" placeholder="Premier League hoặc Arsenal FC" required>
              <div class="form-text">
                <strong>Giải đấu:</strong> Premier League, La Liga, Serie A, Bundesliga, Ligue 1<br>
                <strong>CLB:</strong> Manchester City FC, Arsenal FC...
              </div>
            </div>
            <button class="btn btn-primary w-100">
              <strong>🔍 Tra cứu</strong>
            </button>
          </form>
        </div>
      </div>
    </div>
    <div class="col-lg-8">
      <div class="card h-100 shadow-sm">
        <div class="card-header">
          <strong>📊 Kết quả tìm kiếm</strong>
        </div>
        <div class="card-body p-0">
          <?php if($result): ?>
            <div class="table-responsive">
              <table class="table table-hover table-zebra align-middle mb-0">
                <thead>
                  <tr>
                    <th>Mã CT</th>
                    <th>Họ tên</th>
                    <th>Vị trí</th>
                    <th>Đội bóng</th>
                  </tr>
                </thead>
                <tbody>
                <?php foreach($result as $r):?>
                  <tr>
                    <td><strong><?=$r['MaCT']?></strong></td>
                    <td><?=htmlspecialchars($r['HoTen'])?></td>
                    <td><span class="badge bg-primary-subtle text-primary-emphasis"><?=htmlspecialchars($r['ViTri'])?></span></td>
                    <td><?=htmlspecialchars($r['TenDB'])?></td>
                  </tr>
                <?php endforeach; ?>
                </tbody>
              </table>
            </div>
            <div class="p-3 bg-light border-top">
              <strong class="text-muted">📈 Tổng số: <?=count($result)?> cầu thủ</strong>
            </div>
          <?php elseif($search): ?>
            <div class="p-4">
              <div class="alert alert-warning mb-0">
                <strong>⚠️ Không tìm thấy cầu thủ nào.</strong><br>
                <small>Vui lòng thử lại với từ khóa khác.</small>
              </div>
            </div>
          <?php else: ?>
            <div class="p-5 text-center text-muted">
              <div class="mb-3" style="font-size: 3rem;">🔍</div>
              <p class="mb-0"><strong>Chọn loại tìm kiếm và nhập tên để tra cứu.</strong></p>
            </div>
          <?php endif; ?>
        </div>
      </div>
    </div>
  </div>
</div>
<?php include '../includes/footer.php'; ?>