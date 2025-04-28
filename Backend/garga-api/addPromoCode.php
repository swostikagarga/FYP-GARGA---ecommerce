<?php
include './helpers/db.php';

try {


    if (isset(
        $_POST['promoCode'],
        $_POST['percentage'],
        $_POST['is_active'],
    )) {
        $promoCode = $_POST['promoCode'];
        $percentage = $_POST['percentage'];
        $is_active = $_POST['is_active'] == 'true' ? 1 : 0;

        //check if promo code already exists
        $sql = "select * from promo_codes where promo_code = '$promoCode'";
        $result = mysqli_query($con, $sql);

        if (mysqli_num_rows($result) > 0) {
            echo json_encode(array(
                "success" => false,
                "message" => "Promo code already exists",
            ));
            die();
        }

        //insert promo code
        $sql = "insert into promo_codes (promo_code, percentage, is_active) values ('$promoCode', '$percentage', '$is_active')";
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
            "message" => "Promo code added successfully",
        ));
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "Promo code, percentage and is_active are required",
        ));
        die();
    }
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
