<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

include 'db.php';

// 🔥 GET DATA
$data = json_decode(file_get_contents("php://input"));

if (!$data) {
    echo json_encode(["error" => "No data received"]);
    exit;
}

// 🔥 VALUES
$id = $data->id ?? 0;
$name = $data->name ?? '';
$phone = $data->phone ?? '';
$email = $data->email ?? '';
$domain = $data->domain ?? '';
$status = $data->status ?? 'pending';

// ❌ VALIDATION
if ($id == 0 || $name == '' || $phone == '' || $email == '' || $domain == '') {
    echo json_encode(["error" => "Missing fields"]);
    exit;
}

// 🔥 UPDATE QUERY
$sql = "UPDATE applicants SET
name='$name',
phone='$phone',
email='$email',
domain='$domain',
status='$status'
WHERE id=$id";

// ❌ ERROR
if (!$conn->query($sql)) {
    echo json_encode([
        "error" => "Update failed",
        "details" => $conn->error
    ]);
    exit;
}

// ✅ SUCCESS
echo json_encode([
    "status" => "success",
    "message" => "Applicant updated successfully"
]);
?>