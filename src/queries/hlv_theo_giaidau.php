<?php
require_once '../includes/db.php';
$pageTitle='Huấn luyện viên theo giải đấu';
$result = [];$search='';
if ($_SERVER['REQUEST_METHOD']==='POST') {
  $search = $_POST['search'];
  $stmt = runQuery($conn, 'SELECT h.MaHLV, h.HoTen, h.QuocTich, h.NamKinhNghiem, d.TenDB, d.GiaiDau FROM HuanLuyenVien h JOIN DoiBong d ON h.MaDB=d.MaDB WHERE d.GiaiDau=? ORDER BY h.NamKinhNghiem DESC', [$search]);
  while($r=sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {$result[]=$r;}
}
include '../includes/header.php';
?>
<div class="page-section">
  <div class="d-flex align-items-center justify-content-between mb-4">
    <h2 class="fw-bold mb-0">👔 Huấn luyện viên theo giải đấu</h2>
    <?php if($result): ?>
      <span class="badge bg-primary-subtle text-primary-emphasis px-3 py-2">
        <?=count($result)?> kết quả
      </span>
    <?php endif; ?>
  </div>
  <div class="alert alert-info mb-4">
    <strong>📊 Truy vấn phân tán:</strong> JOIN dữ liệu từ 3 site (HLV_Basic + HLV_Additional + HLV_History) và kết hợp với DoiBong (phân mảnh ngang).
  </div>
  <div class="row g-4">
    <div class="col-lg-4">
      <div class="card shadow-sm">
        <div class="card-header bg-primary bg-opacity-10">
          <strong>🔎 Tìm kiếm</strong>
        </div>
        <div class="card-body">
          <form method="post">
            <div class="mb-3">
              <label class="form-label">🏆 Tên giải đấu</label>
              <input name="search" class="form-control" value="<?=htmlspecialchars($search)?>" placeholder="Premier League" required>
              <div class="form-text"><strong>Giải:</strong> Premier League, La Liga, Serie A, Bundesliga, Ligue 1</div>
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
          <strong>📊 Kết quả</strong>
        </div>
        <div class="card-body p-0">
          <?php if($result): ?>
            <div class="table-responsive">
              <table class="table table-hover table-zebra align-middle mb-0">
                <thead>
                  <tr>
                    <th>Mã HLV</th>
                    <th>Họ tên</th>
                    <th>Quốc tịch</th>
                    <th>Kinh nghiệm</th>
                    <th>Đội bóng</th>
                  </tr>
                </thead>
                <tbody>
                <?php foreach($result as $r):?>
                  <tr>
                    <td><strong><?=$r['MaHLV']?></strong></td>
                    <td><?=htmlspecialchars($r['HoTen'])?></td>
                    <td><span class="badge bg-primary-subtle text-primary-emphasis"><?=htmlspecialchars($r['QuocTich'])?></span></td>
                    <td><?=$r['NamKinhNghiem']?> năm</td>
                    <td><?=htmlspecialchars($r['TenDB'])?></td>
                  </tr>
                <?php endforeach; ?>
                </tbody>
              </table>
            </div>
            <div class="p-3 bg-light border-top">
              <strong class="text-muted">📈 Tổng số: <?=count($result)?> huấn luyện viên</strong>
            </div>
          <?php elseif($search): ?>
            <div class="p-4">
              <div class="alert alert-warning mb-0">
                <strong>⚠️ Không tìm thấy huấn luyện viên nào.</strong><br>
                <small>Vui lòng thử lại với từ khóa khác.</small>
              </div>
            </div>
          <?php else: ?>
            <div class="p-5 text-center text-muted">
              <div class="mb-3" style="font-size: 3rem;">🔍</div>
              <p class="mb-0"><strong>Nhập tên giải đấu để tra cứu.</strong></p>
            </div>
          <?php endif; ?>
        </div>
      </div>
    </div>
  </div>
</div>
<?php include '../includes/footer.php'; ?>
