<?php
include '../helpers/db.php';
include '../helpers/imageUpload.php';
try {

    if (isset(
        $_POST['fullName'],
        $_POST['email'],
        $_POST['password'],
        $_POST['role']
    )) {
        $email = $_POST['email'];
        $fullName = $_POST['fullName'];
        $password = $_POST['password'];
        $role = $_POST['role'];
        $documentUrl = null;



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
        if ($count > 0) {
            echo json_encode(array(
                "success" => false,
                "message" => "Email already exists",
            ));
            die();
        }

        $hashed_password = password_hash($password, PASSWORD_DEFAULT);

        if (isset($_FILES['document'])) {
            if (isset($_FILES['document'])) {
                $images = $_FILES['document'];
                $actualPaths = getImagePaths($images);
                if (count($actualPaths) > 0) {
                    $documentUrl = $actualPaths[0];
                }
            }
        }


        if ($role == "merchant" && $documentUrl == null) {
            echo json_encode(array(
                "success" => false,
                "message" => "Document is required for merchant",
            ));
            die();
        }

        $sql;


        if ($documentUrl != null) {
            $sql = "insert into users (full_name, email, password,role, document_url, is_deleted) values ('$fullName', '$email', '$hashed_password', '$role', '$documentUrl', 1)";
        } else {
            $sql = "insert into users (full_name, email, password,role) values ('$fullName', '$email', '$hashed_password', '$role')";
        }
        $result = mysqli_query($con, $sql);

        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "An error occurred, please try again",
            ));
            die();
        }

        echo json_encode(array(
            "success" => true,
            "message" => $role == "merchant" ?
                "Request sent to admin for approval" :
                "User registered successfully",
        ));
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "fullName, email and password are required",
        ));
        die();
    }
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
