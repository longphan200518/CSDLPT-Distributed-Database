<?php
$pageTitle='Trang chủ';
include __DIR__.'/includes/header.php';
?>
<div class="hero mb-4">
  <h1>Quản lý CSDL Phân Tán</h1>
  <p class="mb-0">Hệ thống phân mảnh dữ liệu với 3 site vật lý, truy vấn thống nhất qua view toàn cục</p>
</div>

<div class="mb-4">
  <h3 class="mb-3">Quản lý dữ liệu ngang</h3>
  <div class="row g-3">
    <div class="col-md-3">
      <a href="crud/doibong.php" class="nav-card">
        <div class="nav-card-icon">⚽</div>
        <h5>Đội bóng</h5>
        <p>Quản lý thông tin đội</p>
      </a>
    </div>
    <div class="col-md-3">
      <a href="crud/cauthu.php" class="nav-card">
        <div class="nav-card-icon">👤</div>
        <h5>Cầu thủ</h5>
        <p>Danh sách cầu thủ</p>
      </a>
    </div>
    <div class="col-md-3">
      <a href="crud/trandau.php" class="nav-card">
        <div class="nav-card-icon">🏟️</div>
        <h5>Trận đấu</h5>
        <p>Lịch thi đấu</p>
      </a>
    </div>
    <div class="col-md-3">
      <a href="crud/thamgia.php" class="nav-card">
        <div class="nav-card-icon">🤝</div>
        <h5>Tham gia</h5>
        <p>Cầu thủ tham gia</p>
      </a>
    </div>
  </div>
</div>

<div class="mb-4">
  <h3 class="mb-3">Quản lý dữ liệu dọc</h3>
  <div class="row">
    <div class="col-md-6">
      <a href="crud/huanluyenvien.php" class="nav-card nav-card-vertical">
        <div class="nav-card-icon">👔</div>
        <h5>Huấn luyện viên</h5>
        <p>Phân mảnh theo cột: Thông tin cơ bản, Bổ sung, Lịch sử</p>
      </a>
    </div>
  </div>
</div>

<div class="mb-4">
  <h3 class="mb-3">Truy vấn</h3>
  <div class="row g-3">
    <div class="col-md-4">
      <a href="queries/clb_cauthu.php" class="nav-card nav-card-query">
        <div class="nav-card-icon">🔍</div>
        <h5>Cầu thủ theo CLB</h5>
      </a>
    </div>
    <div class="col-md-4">
      <a href="queries/so_tran_cauthu.php" class="nav-card nav-card-query">
        <div class="nav-card-icon">📈</div>
        <h5>Số trận cầu thủ</h5>
      </a>
    </div>
    <div class="col-md-4">
      <a href="queries/so_tran_hoa.php" class="nav-card nav-card-query">
        <div class="nav-card-icon">⚖️</div>
        <h5>Số trận hòa</h5>
      </a>
    </div>
  </div>
</div>
<?php include __DIR__.'/includes/footer.php'; ?>