<?php

include './helpers/db.php';

try {
    if (isset($_POST['userId'], $_POST['role'])) {
        $userId = $_POST['userId'];
        $role = $_POST['role'];

        // Fetch all orders normally for admin and merchant
        $sql = "SELECT users.email, users.full_name, orders.*
                FROM orders
                JOIN users ON orders.user_id = users.user_id
                ORDER BY orders.order_date DESC";

        // If the user is not admin or merchant, fetch only their orders
        if ($role !== 'admin' && $role !== 'merchant') {
            $sql = "SELECT users.email, users.full_name, orders.*
                    FROM orders
                    JOIN users ON orders.user_id = users.user_id
                    WHERE orders.user_id = '$userId'
                    ORDER BY orders.order_date DESC";
        }

        $result = mysqli_query($con, $sql);

        if (!$result) {
            echo json_encode(["success" => false, "message" => "An error occurred, please try again"]);
            die();
        }

        $orders = mysqli_fetch_all($result, MYSQLI_ASSOC);

        foreach ($orders as $key => $order) {
            $order_id = $order['order_id'];

            // Get all order items for this order
            $sql = "SELECT products.product_title, order_items.product_id,
                           products.merchant_id, products.price,
                           order_items.quantity, order_items.color, order_items.size
                    FROM order_items
                    JOIN products ON order_items.product_id = products.product_id
                    WHERE order_items.order_id = '$order_id'";

            $result = mysqli_query($con, $sql);
            $order_items = mysqli_fetch_all($result, MYSQLI_ASSOC);
            $orders[$key]['order_items'] = $order_items;

            // If the user is a merchant, calculate merchant-specific total and filter orders
            if ($role === 'merchant') {
                $merchant_items = array_filter($order_items, function ($item) use ($userId) {
                    return $item['merchant_id'] == $userId;
                });

                // If no matching merchant items, remove the order
                if (empty($merchant_items)) {
                    unset($orders[$key]);
                    continue;
                }

                // Calculate merchant-specific order amount
                $merchant_total = array_reduce($merchant_items, function ($sum, $item) {
                    return $sum + ($item['price'] * $item['quantity']);
                }, 0);


                $orders[$key]['total'] = "$merchant_total";
                $orders[$key]['order_items'] = array_values($merchant_items); // Re-index array
            }

            // Fetch images for each product
            foreach ($orders[$key]['order_items'] as $item_key => $item) {
                $product_id = $item['product_id'];
                $sql = "SELECT * FROM product_images WHERE product_id = '$product_id'";
                $result = mysqli_query($con, $sql);
                $images = mysqli_fetch_all($result, MYSQLI_ASSOC);
                $orders[$key]['order_items'][$item_key]['images'] = $images;
            }
        }

        // Re-index orders array after filtering (only for merchants)
        if ($role === 'merchant') {
            $orders = array_values($orders);
        }

        echo json_encode(["success" => true, "orders" => $orders, "message" => "Orders fetched successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "userId and role are required"]);
        die();
    }
} catch (\Throwable $th) {
    echo json_encode(["success" => false, "message" => $th->getMessage()]);
}
