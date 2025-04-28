<?php
include './helpers/db.php';
try {

    if (isset(
        $_POST['userId'],
        $_POST['total'],
        $_POST['orderId'],
        $_POST['otherDetails']
    )) {
        $userId = $_POST['userId'];
        $total = $_POST['total'];
        $orderId = $_POST['orderId'];
        $otherDetails = $_POST['otherDetails'];

        $sql = "insert into payments (user_id, order_id, amount, other_details) values ('$userId', '$orderId', '$total', '$otherDetails')";
        $result = mysqli_query($con, $sql);

        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "Failed to insert payment",
            ));
            die();
        }

        $sql = "update orders set status = 'paid' where order_id = '$orderId'";

        $result = mysqli_query($con, $sql);

        //get all order items for this order
        $sql = "select * from order_items where order_id = '$orderId'";
        $result = mysqli_query($con, $sql);
        $orderItems = mysqli_fetch_all($result, MYSQLI_ASSOC);

        //update stock for each order item

        foreach ($orderItems as $item) {
            $productId = $item['product_id'];
            $quantity = $item['quantity'];

            $sql = "update products set stock = stock - $quantity where product_id = '$productId'";
            $result = mysqli_query($con, $sql);

            if (!$result) {
                echo json_encode(array(
                    "success" => false,
                    "message" => "Failed to update stock",
                ));
                die();
            }
        }

        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "Failed to update order status",
            ));
            die();
        }

        echo json_encode(array(
            "success" => true,
            "message" => "Payment made successfully",
        ));
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "userId, total, orderId and otherDetails are required",
        ));
        die();
    }
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
