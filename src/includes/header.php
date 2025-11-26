<?php
if(!isset($pageTitle)) { $pageTitle = 'Hệ thống phân tán'; }
?>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title><?=htmlspecialchars($pageTitle)?> | Phân tán</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <link rel="stylesheet" href="/assets/style.css" />
</head>
<body>
<nav class="navbar navbar-expand-lg bg-white shadow-sm mb-3" aria-label="Thanh điều hướng chính">
  <div class="container-fluid">
    <a class="navbar-brand" href="/index.php" aria-label="Trang chủ">CSDL Phân Tán</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav" aria-controls="mainNav" aria-expanded="false" aria-label="Mở menu"><span class="navbar-toggler-icon"></span></button>
    <div class="collapse navbar-collapse" id="mainNav">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">CRUD</a>
          <ul class="dropdown-menu" aria-label="Quản lý dữ liệu">
            <li><h6 class="dropdown-header">Phân mảnh ngang</h6></li>
            <li><a class="dropdown-item" href="/crud/doibong.php">Đội bóng</a></li>
            <li><a class="dropdown-item" href="/crud/cauthu.php">Cầu thủ</a></li>
            <li><a class="dropdown-item" href="/crud/trandau.php">Trận đấu</a></li>
            <li><a class="dropdown-item" href="/crud/thamgia.php">Tham gia</a></li>
            <li><hr class="dropdown-divider" /></li>
            <li><h6 class="dropdown-header">Phân mảnh dọc</h6></li>
            <li><a class="dropdown-item" href="/crud/huanluyenvien.php">Huấn luyện viên</a></li>
          </ul>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Truy vấn</a>
          <ul class="dropdown-menu" aria-label="Các truy vấn tổng hợp">
            <li><a class="dropdown-item" href="/queries/clb_cauthu.php">Cầu thủ theo CLB</a></li>
            <li><a class="dropdown-item" href="/queries/so_tran_cauthu.php">Số trận cầu thủ</a></li>
            <li><a class="dropdown-item" href="/queries/so_tran_hoa.php">Số trận hòa</a></li>
          </ul>
        </li>
      </ul>
      <span class="small-muted" aria-hidden="true">Ngang · Dọc · Truy vấn</span>
    </div>
  </div>
</nav>
<div class="container">
