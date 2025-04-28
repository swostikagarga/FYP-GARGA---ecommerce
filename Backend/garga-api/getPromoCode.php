<?php
include './helpers/db.php';

try {

    if (
        !isset($_POST['role'])
    ) {
        echo json_encode(array(
            "success" => false,
            "message" => "Role is required",
        ));
        die();
    }


    // Get promo codes
    $sql = "SELECT * FROM promo_codes";

    $isUser = $_POST['role'] == 'user' ? true : false;

    if ($isUser) {
        $sql .= " WHERE is_active = 1 order by promo_code_id desc limit 1";
    }

    $result = mysqli_query($con, $sql);




    if (!$result) {
        echo json_encode(array(
            "success" => false,
            "message" => "An error occurred, please try again",
        ));
        die();
    }

    $promoCodes = mysqli_fetch_all($result, MYSQLI_ASSOC);

    // Convert is_active to boolean
    foreach ($promoCodes as &$promo) {
        if (isset($promo['is_active'])) {
            $promo['is_active'] = (bool)$promo['is_active'];
        }
    }




    echo json_encode(array(
        "success" => true,
        "promoCodes" => $promoCodes,
        "message" => "Promo codes fetched successfully",
    ));
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
