<?php
include './helpers/db.php';
try {

    if (isset($_POST['productId'])) {
        $productId = $_POST['productId'];
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "productId is required",
        ));
        die();
    }


    $sql = "select * from products where product_id = '$productId'";

    $result = mysqli_query($con, $sql);

    if (!$result) {
        echo json_encode(array(
            "success" => false,
            "message" => "An error occurred, please try again",
        ));
        die();
    }

    $product = mysqli_fetch_assoc($result);


    $isdisabled = $product['is_disabled'] == 1 ? 0 : 1;

    $sql = "update products set is_disabled = '$isdisabled' where product_id = '$productId'";
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
        "message" => $isdisabled == 1 ? "product disabled successfully" : "product restored successfully",
    ));
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
