<?php
// 🔥 CORS + JSON HEADERS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

// 🔥 INCLUDE DB
include 'db.php';

// 🔥 GET INPUT
$data = json_decode(file_get_contents("php://input"));

// ❌ CHECK DATA
if (!$data) {
    echo json_encode(["error" => "No data received"]);
    exit;
}

// 🔥 GET ID
$id = $data->id ?? 0;

// ❌ VALIDATION
if ($id == 0) {
    echo json_encode(["error" => "Invalid ID"]);
    exit;
}

// 🔥 DELETE QUERY
$sql = "DELETE FROM applicants WHERE id=$id";

// ❌ QUERY ERROR
if (!$conn->query($sql)) {
    echo json_encode([
        "error" => "Delete failed",
        "details" => $conn->error
    ]);
    exit;
}

// ✅ SUCCESS
echo json_encode([
    "status" => "success",
    "message" => "Applicant deleted successfully"
]);
?>