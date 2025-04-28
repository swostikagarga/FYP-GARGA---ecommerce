<?php
include './helpers/db.php';



$sql = "SELECT * FROM users";
$result = mysqli_query($con, $sql);

if (!$result) {
    echo json_encode(array(
        "success" => false,
        "message" => "An error occurred, please try again",
    ));
    die();
}

$users = mysqli_fetch_all($result, MYSQLI_ASSOC);

echo json_encode(array(
    "success" => true,
    "users" => $users,
    "message" => "Users fetched successfully",
));
