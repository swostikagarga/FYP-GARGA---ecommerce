<?php
include './helpers/db.php';
include './helpers/imageUpload.php';

try {
    if (isset(
        $_POST['productId'],
        $_POST['productName'],
        $_POST['description'],
        $_POST['price'],
        $_POST['category'],
        $_POST['merchantId'],
        $_POST['colors'],
        $_POST['sizes'],
        $_POST['stock'],
    )) {
        $productId = $_POST['productId'];
        $productName = mysqli_real_escape_string($con, $_POST['productName']);
        $description = mysqli_real_escape_string($con, $_POST['description']);
        $price = $_POST['price'];
        $category = $_POST['category'];
        $merchantId = $_POST['merchantId'];
        $imageUrls = isset($_POST['imageUrls']) ? json_decode($_POST['imageUrls'], true) : [];
        $colors = $_POST['colors'];
        $sizes = $_POST['sizes'];
        $stock = $_POST['stock'];
        // Update product details
        $sql = "UPDATE products SET product_title = '$productName',
        colors = '$colors', sizes = '$sizes',
        stock = '$stock',
        description = '$description', price = '$price', category_id = '$category',  merchant_id = '$merchantId' WHERE product_id = '$productId'";
        $result = mysqli_query($con, $sql);

        if (!$result) {
            echo json_encode(array(
                "success" => false,
                "message" => "Something went wrong, please try again",
            ));
            die();
        }

        // Handle images
        if (isset($_FILES['images'])) {
            // Upload new images
            $newImagePaths = getImagePaths($_FILES['images']);
            // Merge new images in front of existing image URLs
            $imageUrls = array_merge($newImagePaths, $imageUrls);
        }

        // Update product images
        mysqli_query($con, "DELETE FROM product_images WHERE product_id = '$productId'");
        foreach ($imageUrls as $url) {
            mysqli_query($con, "INSERT INTO product_images (product_id, image_url) VALUES ('$productId', '$url')");
        }

        echo json_encode(array(
            "success" => true,
            "message" => "Product updated successfully",
        ));
    } else {
        echo json_encode(array(
            "success" => false,
            "message" => "productId, productName, description, price, category, and merchantID, colors, sizes are required",
        ));
        die();
    }
} catch (\Throwable $th) {
    echo json_encode(array(
        "success" => false,
        "message" => $th->getMessage(),
    ));
}
