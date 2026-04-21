<?php
// 🔥 HEADERS
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// 🔥 DB
include 'db.php';

// 🔥 QUERY
$sql = "SELECT * FROM applicants ORDER BY id DESC";
$result = $conn->query($sql);

// ❌ ERROR
if (!$result) {
    echo json_encode([
        "error" => "Fetch failed",
        "details" => $conn->error
    ]);
    exit;
}

// 🔥 DATA
$data = [];

while ($row = $result->fetch_assoc()) {
    $data[] = [
        "id" => $row["id"],
        "name" => $row["name"],
        "phone" => $row["phone"],
        "email" => $row["email"], // ✅ ADDED
        "domain" => $row["domain"],
        "status" => $row["status"]
    ];
}

// ✅ RESPONSE
echo json_encode($data);
?>