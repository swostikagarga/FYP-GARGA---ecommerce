<?php
include './helpers/db.php';
try {

    if (isset($_POST['userId'])) {
        $userId = $_POST['userId'];
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "userId is required",
        ));
        die();
    }


    $sql = "select * from users where user_id = '$userId'";

    $result = mysqli_query($con, $sql);

    if (!$result) {
        echo json_encode(array(
            "success" => false,
            "message" => "An error occurred, please try again",
        ));
        die();
    }

    $user = mysqli_fetch_assoc($result);

    echo json_encode(array(
        "success" => true,
        "user" => $user,
        "message" => "User fetched successfully",
    ));
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
