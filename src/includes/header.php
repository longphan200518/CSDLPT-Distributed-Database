<?php
if(!isset($pageTitle)) { $pageTitle = 'Hệ thống phân tán'; }

// Calculate base path relative to src/ directory
// If $basePath is not set, try to detect it automatically
if (!isset($basePath)) {
    $scriptName = $_SERVER['SCRIPT_NAME'] ?? '';
    // Check if we're in a subdirectory
    if (preg_match('#/(crud|queries)/#', $scriptName)) {
        $basePath = '../';
    } else {
        $basePath = '';
    }
}
?>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title><?=htmlspecialchars($pageTitle)?> | Phân tán</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <link rel="stylesheet" href="<?=$basePath?>assets/style.css?v=<?=time()?>" />
</head>
<body>
<nav class="navbar navbar-expand-lg bg-white shadow-sm mb-4" aria-label="Thanh điều hướng chính">
  <div class="container-fluid">
    <a class="navbar-brand" href="<?=$basePath?>index.php" aria-label="Trang chủ">
      <strong>🏆 CSDL Phân Tán</strong>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav" aria-controls="mainNav" aria-expanded="false" aria-label="Mở menu">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="mainNav">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            <strong>CRUD</strong>
          </a>
          <ul class="dropdown-menu" aria-label="Quản lý dữ liệu">
            <li><h6 class="dropdown-header">📊 Phân mảnh ngang</h6></li>
            <li><a class="dropdown-item" href="<?=$basePath?>crud/doibong.php">⚽ Đội bóng</a></li>
            <li><a class="dropdown-item" href="<?=$basePath?>crud/cauthu.php">👤 Cầu thủ</a></li>
            <li><a class="dropdown-item" href="<?=$basePath?>crud/trandau.php">🏟️ Trận đấu</a></li>
            <li><a class="dropdown-item" href="<?=$basePath?>crud/thamgia.php">🤝 Tham gia</a></li>
            <li><hr class="dropdown-divider" /></li>
            <li><h6 class="dropdown-header">📋 Phân mảnh dọc</h6></li>
            <li><a class="dropdown-item" href="<?=$basePath?>crud/huanluyenvien.php">👔 Huấn luyện viên</a></li>
          </ul>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            <strong>Truy vấn</strong>
          </a>
          <ul class="dropdown-menu" aria-label="Các truy vấn tổng hợp">
            <li><a class="dropdown-item" href="<?=$basePath?>queries/clb_cauthu.php">🔍 Cầu thủ theo CLB</a></li>
            <li><a class="dropdown-item" href="<?=$basePath?>queries/so_tran_cauthu.php">📈 Số trận cầu thủ</a></li>
            <li><a class="dropdown-item" href="<?=$basePath?>queries/so_tran_hoa.php">⚖️ Số trận hòa</a></li>
          </ul>
        </li>
      </ul>
      <div class="d-flex align-items-center">
        <span class="badge bg-primary-subtle text-primary-emphasis px-3 py-2">
          <small>Ngang · Dọc · Truy vấn</small>
        </span>
      </div>
    </div>
  </div>
</nav>
<div class="container-fluid px-4">
