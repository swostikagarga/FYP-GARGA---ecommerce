<?php
include '../helpers/db.php';
try {

    if (isset(
        $_POST['email'],
        $_POST['password']
    )) {
        $email = $_POST['email'];
        $password = $_POST['password'];

        $sql = "select * from users where email = '$email'";
        $result = mysqli_query($con, $sql);

        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "An error occurred, please try again",
            ));
            die();
        }
        $count = mysqli_num_rows($result);
        if ($count === 0) {
            echo json_encode(array(
                "success" => false,
                "message" => "User not found!",
            ));
            die();
        }

        $user = mysqli_fetch_assoc($result);

        $hashed_password = $user['password'];


        $isCorrect = password_verify($password, $hashed_password);

        if (!$isCorrect) {
            echo json_encode(array(
                "success" => false,
                "message" => "Incorrect password!",
            ));
            die();
        }

        echo json_encode(array(
            "success" => true,
            "message" => "User logged in successfully",
            "role" =>   $user['role'],
            "userId" => $user['user_id'],
            "user" => $user,
        ));
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "email and password are required",
        ));
        die();
    }
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
