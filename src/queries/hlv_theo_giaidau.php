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
<div class="mb-4">
  <h2 class="fw-semibold mb-3">Truy vấn: Huấn luyện viên theo giải đấu <span class="badge badge-hash">Phân mảnh dọc</span></h2>
  <div class="alert alert-info">
    <strong>Truy vấn phân tán:</strong> JOIN dữ liệu từ 3 site (HLV_Basic + HLV_Additional + HLV_History) và kết hợp với DoiBong (phân mảnh ngang).
  </div>
  <div class="row g-4">
    <div class="col-lg-4">
      <div class="card">
        <div class="card-header">Tìm kiếm theo giải đấu</div>
        <div class="card-body">
          <form method="post">
            <div class="mb-3">
              <label class="form-label">Tên giải đấu</label>
              <input name="search" class="form-control" value="<?=htmlspecialchars($search)?>" placeholder="Premier League" required>
              <div class="form-text"><strong>Giải:</strong> Premier League, La Liga, Serie A, Bundesliga, Ligue 1</div>
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
              <thead><tr><th>Mã HLV</th><th>Họ tên</th><th>Quốc tịch</th><th>Kinh nghiệm</th><th>Đội bóng</th></tr></thead>
              <tbody>
              <?php foreach($result as $r):?>
                <tr>
                  <td><?=$r['MaHLV']?></td>
                  <td><strong><?=htmlspecialchars($r['HoTen'])?></strong></td>
                  <td><?=htmlspecialchars($r['QuocTich'])?></td>
                  <td><?=$r['NamKinhNghiem']?> năm</td>
                  <td><?=htmlspecialchars($r['TenDB'])?></td>
                </tr>
              <?php endforeach; ?>
              </tbody>
            </table>
            <div class="text-muted">Tổng: <?=count($result)?> huấn luyện viên</div>
          <?php elseif($search): ?>
            <div class="alert alert-warning">Không tìm thấy huấn luyện viên nào.</div>
          <?php else: ?>
            <div class="text-muted">Nhập tên giải đấu để tra cứu.</div>
          <?php endif; ?>
        </div>
      </div>
    </div>
  </div>
</div>
<?php include '../includes/footer.php'; ?>
