<?php
include './helpers/db.php';
try {

    //role
    if (!isset($_POST['role'])) {
        echo json_encode(array(
            "success" => false,
            "message" => "Role is required",
        ));
        die();
    }
    $role = $_POST['role'];
    $isUser = $role == 'user' ? true : false;


    $merchantId = $_POST['merchantId'] ?? null;
    if ($merchantId) {
        $sql = "select products.*,profile_image,category_title,full_name as merchant_name from products join categories on products.category_id = categories.category_id join users
        on products.merchant_id = users.user_id where products.merchant_id = $merchantId";
    } else {

        $sql = "select products.*,profile_image,category_title,full_name as merchant_name from products join categories on products.category_id = categories.category_id join users on products.merchant_id = users.user_id";
    }

    if ($isUser) {
        $sql .= " where products.is_disabled =0 and products.stock > 0";
    }

    $result = mysqli_query($con, $sql);

    if (!$result) {
        echo json_encode(array(
            "success" => false,
            "message" => "An error occurred, please try again",
        ));
        die();
    }

    $products = mysqli_fetch_all($result, MYSQLI_ASSOC);




    foreach ($products as $key => $product) {
        $productId = $product['product_id'];
        $sql = "select image_url from product_images where product_id = $productId";
        $result = mysqli_query($con, $sql);
        $images = mysqli_fetch_all($result, MYSQLI_ASSOC);
        $images = array_map(function ($image) {
            return $image['image_url'];
        }, $images);
        $products[$key]['images'] = $images;
    }

    echo json_encode(array(
        "success" => true,
        "products" => $products,
        "message" => "Products fetched successfully",
    ));
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
