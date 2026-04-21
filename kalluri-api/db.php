<?php
// 🔥 ALLOW CORS (important for Flutter)
header("Access-Control-Allow-Origin: *");

// 🔥 DATABASE CONFIG
$host = "localhost";
$user = "root";
$password = "";
$database = "kalluri";

// 🔥 CREATE CONNECTION
$conn = new mysqli($host, $user, $password, $database);

// ❌ CHECK CONNECTION
if ($conn->connect_error) {
    die(json_encode([
        "error" => "Database connection failed",
        "details" => $conn->connect_error
    ]));
}
?>