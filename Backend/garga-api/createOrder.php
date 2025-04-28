<?php
include './helpers/db.php';
try {

    if (isset(
        $_POST['userId'],
        $_POST['total'],
        $_POST['cart'],
        $_POST['paymentMethod'],
    )) {
        $userId = $_POST['userId'];
        $total = $_POST['total'];
        $cart = $_POST['cart'];
        $paymentMethod = $_POST['paymentMethod'];

        $sql = "insert into orders (user_id, total,status,payment_mode) values ('$userId', '$total','pending', '$paymentMethod')";
        $result = mysqli_query($con, $sql);

        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "An error occurred, please try again",
            ));
            die();
        }

        $orderId = mysqli_insert_id($con);


        $decodedCart = json_decode($cart);

        foreach ($decodedCart as $item) {
            $quantity = $item->quantity;
            $productId = $item->product->product_id;
            $price = $item->product->price;
            $color = $item->color;
            $size = $item->size;

            $sql = "insert into order_items (order_id, product_id, quantity, product_price, color, size) values ('$orderId', '$productId', '$quantity', '$price', '$color', '$size')";
            $result = mysqli_query($con, $sql);

            if ($_POST['paymentMethod'] == 'cod') {
                $sql = "update products set stock = stock - $quantity where product_id = '$productId'";
                $result = mysqli_query($con, $sql);
            }

            if (!$result) {
                echo json_encode(array(
                    "success" => false,
                    "message" => "Failed to insert order items",
                ));
                die();
            }
        }

        echo json_encode(array(
            "success" => true,
            "message" => "Order created successfully",
            "orderId" => $orderId
        ));
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "userId, total and cart are required",
        ));
        die();
    }
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
