<?php
$server = getenv('DB_SERVER') ?: 'localhost';
$username = getenv('DB_USER') ?: 'SA';
$password = getenv('DB_PASSWORD') ?: 'YourStrong!Passw0rd';
$globalDb = getenv('GLOBAL_DB') ?: 'GlobalDB';

$connectionInfo = [
    "Database" => $globalDb, 
    "UID" => $username, 
    "PWD" => $password, 
    "CharacterSet" => "UTF-8",
    "TrustServerCertificate" => true,
    "Encrypt" => false
];
$conn = sqlsrv_connect($server, $connectionInfo);
if (!$conn) {
    die(print_r(sqlsrv_errors(), true));
}

function runQuery($conn, $sql, $params = []) {
    $stmt = sqlsrv_query($conn, $sql, $params);
    if ($stmt === false) {
        die(print_r(sqlsrv_errors(), true));
    }
    return $stmt;
}
?>