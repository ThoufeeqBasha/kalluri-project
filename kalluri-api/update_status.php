<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include 'db.php';

$data = json_decode(file_get_contents("php://input"));

$id = $data->id;
$status = $data->status;

$sql = "UPDATE applicants SET status='$status' WHERE id=$id";

if ($conn->query($sql)) {
    echo json_encode(["status" => "updated"]);
} else {
    echo json_encode(["error" => $conn->error]);
}
?>