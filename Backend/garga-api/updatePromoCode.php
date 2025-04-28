<?php
include './helpers/db.php';

try {
    if (isset($_POST['promoCodeId'], $_POST['promoCode'], $_POST['percentage'], $_POST['is_active'])) {
        $promoCodeId = $_POST['promoCodeId'];
        $promoCode = $_POST['promoCode'];
        $percentage = $_POST['percentage'];
        $is_active = $_POST['is_active'] == 'true' ? 1 : 0;

        // Check if promo code with same name exists but with a different ID
        $sql = "SELECT * FROM promo_codes WHERE promo_code = '$promoCode' AND promo_code_id != '$promoCodeId'";
        $result = mysqli_query($con, $sql);

        if (mysqli_num_rows($result) > 0) {
            echo json_encode(array(
                "success" => false,
                "message" => "Another promo code with the same name already exists",
            ));
            die();
        }

        // Update the promo code
        $sql = "UPDATE promo_codes SET promo_code = '$promoCode', percentage = '$percentage', is_active = '$is_active' WHERE promo_code_id = '$promoCodeId'";
        $result = mysqli_query($con, $sql);

        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "An error occurred while updating the promo code",
            ));
            die();
        }

        echo json_encode(array(
            "success" => true,
            "message" => "Promo code updated successfully",
        ));
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "promoCodeId, promoCode, percentage, and is_active are required",
        ));
        die();
    }
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
