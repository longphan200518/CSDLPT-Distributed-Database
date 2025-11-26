<?php
$pageTitle='Trang chủ';
include __DIR__.'/includes/header.php';
?>
<div class="hero mb-4">
  <h1>Quản lý CSDL Phân Tán</h1>
  <p class="mb-0">CRUD và truy vấn hợp nhất qua view toàn cục. Dữ liệu tự động phân phối theo quy tắc phân mảnh ngang (mod) và dọc (theo cột).</p>
</div>
<main class="mb-4" aria-label="Nội dung chính">
  <div class="section-grid">
    <div class="card">
      <div class="card-header">CRUD (Phân mảnh ngang)</div>
      <div class="card-body">
        <div class="list-group list-group-flush">
          <a class="list-group-item list-group-item-action" href="crud/doibong.php">Đội bóng</a>
          <a class="list-group-item list-group-item-action" href="crud/cauthu.php">Cầu thủ</a>
          <a class="list-group-item list-group-item-action" href="crud/trandau.php">Trận đấu</a>
          <a class="list-group-item list-group-item-action" href="crud/thamgia.php">Tham gia</a>
        </div>
      </div>
    </div>
    <div class="card">
      <div class="card-header">CRUD (Phân mảnh dọc)</div>
      <div class="card-body">
        <div class="list-group list-group-flush">
          <a class="list-group-item list-group-item-action" href="crud/huanluyenvien.php"><strong>Huấn luyện viên</strong><small class="muted">SiteA + SiteB (+ SiteC lịch sử tuỳ chọn)</small></a>
        </div>
      </div>
    </div>
    <div class="card">
      <div class="card-header">Truy vấn tổng hợp</div>
      <div class="card-body">
        <div class="list-group list-group-flush">
          <a class="list-group-item list-group-item-action" href="queries/clb_cauthu.php">Cầu thủ theo CLB</a>
          <a class="list-group-item list-group-item-action" href="queries/so_tran_cauthu.php">Số trận cầu thủ</a>
          <a class="list-group-item list-group-item-action" href="queries/so_tran_hoa.php">Số trận hòa</a>
        </div>
      </div>
    </div>
  </div>
</main>
<?php include __DIR__.'/includes/footer.php'; ?>