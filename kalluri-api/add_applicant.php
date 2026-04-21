<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

include 'db.php';

// 🔥 GET DATA
$data = json_decode(file_get_contents("php://input"));

if (!$data) {
    echo json_encode(["error" => "No data"]);
    exit;
}

// 🔥 VALUES
$name = $data->name;
$phone = $data->phone;
$email = $data->email;
$domain = $data->domain;

// 🔥 PREPARED STATEMENT (NO FAIL)
$stmt = $conn->prepare(
    "INSERT INTO applicants (name, phone, domain, email) VALUES (?, ?, ?, ?)"
);

if (!$stmt) {
    echo json_encode(["error" => $conn->error]);
    exit;
}

// 🔥 BIND VALUES
$stmt->bind_param("ssss", $name, $phone, $domain, $email);

// 🔥 EXECUTE
if ($stmt->execute()) {
    echo json_encode([
        "status" => "success",
        "id" => $stmt->insert_id
    ]);
} else {
    echo json_encode([
        "error" => $stmt->error
    ]);
}
?>