<?php
$pageTitle='Trang chủ';
include __DIR__.'/includes/header.php';
?>
<div class="hero mb-4">
  <h1 class="display-6 mb-2">Hệ thống quản lý CSDL Phân Tán</h1>
  <p class="mb-0">Thao tác CRUD & truy vấn trên view toàn cục, dữ liệu tự động định tuyến tới các site vật lý.</p>
</div>
<div class="row g-4">
  <div class="col-md-6">
    <div class="card h-100">
      <div class="card-header fw-semibold">CRUD</div>
      <div class="card-body">
        <div class="list-group list-group-flush">
          <a class="list-group-item list-group-item-action" href="crud/doibong.php">Đội bóng</a>
          <a class="list-group-item list-group-item-action" href="crud/cauthu.php">Cầu thủ</a>
          <a class="list-group-item list-group-item-action" href="crud/trandau.php">Trận đấu</a>
          <a class="list-group-item list-group-item-action" href="crud/thamgia.php">Tham gia</a>
        </div>
      </div>
    </div>
  </div>
  <div class="col-md-6">
    <div class="card h-100">
      <div class="card-header fw-semibold">Truy vấn toàn cục</div>
      <div class="card-body">
        <div class="list-group list-group-flush">
          <a class="list-group-item list-group-item-action" href="queries/clb_cauthu.php">Cầu thủ theo CLB</a>
          <a class="list-group-item list-group-item-action" href="queries/so_tran_cauthu.php">Số trận cầu thủ tham gia</a>
          <a class="list-group-item list-group-item-action" href="queries/so_tran_hoa.php">Số trận hòa tại sân đấu</a>
        </div>
      </div>
    </div>
  </div>
</div>
<?php include __DIR__.'/includes/footer.php'; ?>