<?php
include './helpers/db.php';
try {

    if (!isset($_POST['orderId'], $_POST['status'])) {
        echo json_encode(array(
            "success" => false,
            "message" => "Please provide orderId and status",
        ));
        die();
    }


    $sql = "UPDATE orders
            SET delivery_status = '" . $_POST['status'] . "'
            WHERE order_id = '" . $_POST['orderId'] . "'";

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
        "message" => "Order status updated successfully",
    ));
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
