<?php
include './helpers/db.php';

try {
    if (!isset($_POST['userId'], $_POST['role'])) {
        echo json_encode(array(
            "success" => false,
            "message" => "Invalid request",
        ));
        die();
    }

    $role = $_POST['role'];
    $userId = $_POST['userId'];

    // Total Users
    $sql = "SELECT COUNT(*) AS total_users FROM users";
    $result = mysqli_query($con, $sql);
    if (!$result) {
        echo json_encode(array(
            "success" => false,
            "message" => "An error occurred, please try again",
        ));
        die();
    }
    $total_users = mysqli_fetch_assoc($result);

    // Total Products
    if ($role == 'admin') {
        $sql = "SELECT COUNT(*) AS total_products FROM products";
    } else {
        $sql = "SELECT COUNT(*) AS total_products FROM products WHERE merchant_id = '$userId'";
    }
    $result = mysqli_query($con, $sql);
    if (!$result) {
        echo json_encode(array(
            "success" => false,
            "message" => "An error occurred, please try again",
        ));
        die();
    }
    $total_products = mysqli_fetch_assoc($result);

    // Total Orders
    if ($role == 'admin') {
        $sql = "SELECT COUNT(*) AS total_orders FROM orders";
    } else {
        $sql = "SELECT COUNT(DISTINCT orders.order_id) AS total_orders
                FROM orders
                JOIN order_items ON orders.order_id = order_items.order_id
                JOIN products ON order_items.product_id = products.product_id
                WHERE products.merchant_id = '$userId'";
    }
    $result = mysqli_query($con, $sql);
    if (!$result) {
        echo json_encode(array(
            "success" => false,
            "message" => "An error occurred, please try again",
        ));
        die();
    }
    $total_orders = mysqli_fetch_assoc($result);

    // Monthly Income
    if ($role == 'merchant') {
        $sql = "SELECT SUM(order_items.product_price * order_items.quantity) AS total
                FROM order_items
                JOIN products ON order_items.product_id = products.product_id
                JOIN orders ON order_items.order_id = orders.order_id
                WHERE orders.status = 'paid'
                  AND products.merchant_id = '$userId'
                  AND MONTH(orders.order_date) = MONTH(CURRENT_DATE())
                  AND YEAR(orders.order_date) = YEAR(CURRENT_DATE())";
    } else {
        $sql = "SELECT SUM(order_items.product_price * order_items.quantity) AS total
                FROM order_items
                JOIN orders ON order_items.order_id = orders.order_id
                WHERE orders.status = 'paid'
                  AND MONTH(orders.order_date) = MONTH(CURRENT_DATE())
                  AND YEAR(orders.order_date) = YEAR(CURRENT_DATE())";
    }
    $result = mysqli_query($con, $sql);
    if (!$result) {
        echo json_encode(array(
            "success" => false,
            "message" => "An error occurred, please try again",
        ));
        die();
    }
    $monthlyIncome = mysqli_fetch_assoc($result);

    // Total Income
    if ($role == 'merchant') {
        $sql = "SELECT SUM(order_items.product_price * order_items.quantity) AS total
                FROM order_items
                JOIN products ON order_items.product_id = products.product_id
                JOIN orders ON order_items.order_id = orders.order_id
                WHERE orders.status = 'paid' AND products.merchant_id = '$userId'";
    } else {
        $sql = "SELECT SUM(order_items.product_price * order_items.quantity) AS total
                FROM order_items
                JOIN orders ON order_items.order_id = orders.order_id
                WHERE orders.status = 'paid'";
    }
    $result = mysqli_query($con, $sql);
    if (!$result) {
        echo json_encode(array(
            "success" => false,
            "message" => "An error occurred, please try again",
        ));
        die();
    }
    $totalIncome = mysqli_fetch_assoc($result);

    echo json_encode(array(
        "success" => true,
        "stats" => array(

            array(
                "title" => "Total Products",
                "value" => (int)($total_products['total_products'] ?? 0),
            ),
            array(
                "title" => "Total Orders",
                "value" => (int)($total_orders['total_orders'] ?? 0),
            ),
            array(
                "title" => "Monthly Income",
                "value" => "Rs. " . ($monthlyIncome['total'] ?? "0"),
            ),
            array(
                "title" => "Total Income",
                "value" => "Rs. " . ($totalIncome['total'] ?? "0"),
            ),
            array(
                "title" => "Total Users",
                "value" => (int)($total_users['total_users'] ?? 0),
            ),
        ),
        "message" => "Stats fetched successfully",
    ));
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
