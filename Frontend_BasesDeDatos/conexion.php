<?php
$host = "localhost";
$user = "root";
$pass = "root";
$db   = "flota_de_buses";
$port = 3306;

$conn = new mysqli($host, $user, $pass, $db,3306);

if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}
?>