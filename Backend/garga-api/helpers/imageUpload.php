<?php

function getImagePaths($images)
{
    $actualPaths = [];
    $uploadDir = __DIR__ . '/../images/'; // Adjust this path accordingly

    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    foreach ($images['name'] as $key => $image) {
        $imageName = $images['name'][$key];
        $imageTmpName = $images['tmp_name'][$key];
        $imageSize = $images['size'][$key];
        $imageError = $images['error'][$key];
        $imageType = $images['type'][$key];

        $imageExt = explode('.', $imageName);
        $imageActualExt = strtolower(end($imageExt));

        $allowed = array('jpg', 'jpeg', 'png', 'webp', 'heic');


        if (in_array($imageActualExt, $allowed)) {
            if ($imageError === 0) {
                if ($imageSize < 10 * 1024 * 1024) {
                    $imageNameNew = uniqid('', true) . "." . $imageActualExt;
                    $imageDestination = $uploadDir . $imageNameNew;
                    $actualPath = "/images/" . $imageNameNew;
                    $actualPaths[] = $actualPath;
                    if (move_uploaded_file($imageTmpName, $imageDestination)) {
                        continue;
                    } else {
                        echo json_encode(array(
                            "success" => false,
                            "message" => "Failed to move uploaded file.",
                        ));
                        die();
                    }
                } else {
                    echo json_encode(array(
                        "success" => false,
                        "message" => "Your file is too big! Please upload an image less than 10MB",
                    ));
                    die();
                }
            } else {
                echo json_encode(array(
                    "success" => false,
                    "message" => "There was an error uploading your file!",
                ));
                die();
            }
        } else {
            echo json_encode(array(
                "success" => false,
                "message" => "You cannot upload files of this type!",
            ));
            die();
        }
    }
    return $actualPaths;
}
