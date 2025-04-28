<?php
include '../helpers/db.php';
try {

    if (isset(
        $_POST['user_id'],
        $_POST['currentPassword'],
        $_POST['newPassword']
    )) {
        $user_id = $_POST['user_id'];
        $currentPassword = $_POST['currentPassword'];
        $newPassword = $_POST['newPassword'];

        $sql = "select * from users where user_id = '$user_id'";
        $result = mysqli_query($con, $sql);
        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "An error occurred, please try again",
            ));
            die();
        }


        $user = mysqli_fetch_assoc($result);
        $hashed_password = $user['password'];
        $isCorrect = password_verify($currentPassword, $hashed_password);

        if (!$isCorrect) {
            echo json_encode(array(
                "success" => false,
                "message" => "Incorrect password!",
            ));
            die();
        }

        $newHashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);

        $sql = "UPDATE users SET password = ? WHERE user_id = ?";
        $stmt = mysqli_prepare($con, $sql);
        mysqli_stmt_bind_param($stmt, "si", $newHashedPassword, $user_id);
        $result = mysqli_stmt_execute($stmt);


        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "An error occurred, please try again",
            ));
            die();
        }

        echo json_encode(array(
            "success" => true,
            "message" => "Password changed successfully",
        ));
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "user_id, currentPassword and newPassword are required",
        ));
        die();
    }
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
