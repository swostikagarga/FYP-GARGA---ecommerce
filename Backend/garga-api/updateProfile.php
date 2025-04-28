<?php
include './helpers/db.php';
include './helpers/imageUpload.php';


try {

    if (isset(
        $_POST['fullName'],
        $_POST['userId']
    )) {


        $fullName = $_POST['fullName'];
        $gender = null;
        $address = null;
        $phone_number = null;
        $profile_image = null;
        $userId = $_POST['userId'];

        if (isset($_POST['gender'])) {
            $gender = $_POST['gender'];
        }

        if (isset($_POST['address'])) {
            $address = $_POST['address'];
        }

        if (isset($_POST['phone_number'])) {
            $phone_number = $_POST['phone_number'];
        }

        if (isset($_POST['profile_image'])) {
            $profile_image = $_POST['profile_image'];
        }

        if (isset($_FILES['profile_image'])) {
            $images = $_FILES['profile_image'];
            $actualPaths = getImagePaths($images);
            if (count($actualPaths) > 0) {
                $profile_image = $actualPaths[0];
            }
        }



        $sql = "UPDATE users SET
        full_name = ?,
        gender = ?,
        address = ?,
        phone_number = ?,
        profile_image = ?
    WHERE user_id = ?";

        $stmt = mysqli_prepare($con, $sql);
        mysqli_stmt_bind_param($stmt, "sssssi", $fullName, $gender, $address, $phone_number, $profile_image, $userId);
        $result = mysqli_stmt_execute($stmt);

        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "An error occurred, please try again",
            ));
            die();
        }



        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "An error occurred, please try again",
            ));
            die();
        }

        echo json_encode(array(
            "success" => true,
            "message" => "User updated successfully",
        ));
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "fullName, userId are required",
        ));
        die();
    }
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
