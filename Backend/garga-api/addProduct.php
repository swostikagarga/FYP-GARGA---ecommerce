<?php
include './helpers/db.php';
include './helpers/imageUpload.php';
try {

    if (isset(
        $_POST['productName'],
        $_POST['description'],
        $_POST['price'],
        $_POST['category'],
        $_POST['merchantId'],
        $_FILES['images'],
        $_POST['colors'],
        $_POST['sizes'],
        //stock
        $_POST['stock'],

    )) {

        $productName = mysqli_real_escape_string($con, $_POST['productName']);
        $description = mysqli_real_escape_string($con, $_POST['description']);
        $price = $_POST['price'];
        $category = $_POST['category'];
        $merchantId = $_POST['merchantId'];
        $images = $_FILES['images'];
        $colors = $_POST['colors'];
        $sizes = $_POST['sizes'];
        $stock = $_POST['stock'];

        $actualPaths = getImagePaths($images);

        $sql = "INSERT INTO products (product_title, description, price,
        stock,
        colors,sizes, category_id, merchant_id) VALUES ('$productName', '$description', '$price',
        '$stock',
         '$colors', '$sizes', '$category',  '$merchantId')";
        $result = mysqli_query($con, $sql);


        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "Something went wrong, please try again",
            ));
            die();
        }

        $product_id = mysqli_insert_id($con);

        foreach ($actualPaths as $actualPath) {
            $sql = "INSERT INTO product_images (product_id, image_url) VALUES ('$product_id', '$actualPath')";
            $result = mysqli_query($con, $sql);

            if (!$result) {
                echo json_encode(array(
                    "success" => false,
                    "message" => "Something went wrong, please try again",
                ));
                die();
            }
        }


        echo json_encode(array(
            "success" => true,
            "message" => "Product added successfully",
        ));
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "productName, description, price, category,  merchantId, images , colors, and sizes are required",
        ));
        die();
    }
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
