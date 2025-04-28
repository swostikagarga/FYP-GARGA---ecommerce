import 'dart:convert';
import 'dart:typed_data';

import 'package:garga/constant.dart';
import 'package:flutter/material.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:get/get.dart';
import 'package:garga/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddProductController extends GetxController {
  var productNameController = TextEditingController();
  var productPriceController = TextEditingController();
  var descriptionController = TextEditingController();
  var stockController = TextEditingController();

  String? selectedCategory;

  List<SizeType> selectedSizes = [];
  List<ColorType> selectedColors = [];

  List<XFile> images = [];
  List<Uint8List> imagePreviews = [];
  List<String> imageUrls = [];

  var formKey = GlobalKey<FormState>();

  String? imageError;

  void pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      var image = await picker.pickImage(source: ImageSource.gallery);
      images.add(image!);
      imagePreviews.add(await image.readAsBytes());
      update();
    } catch (e) {
      Get.showSnackbar(const GetSnackBar(
        message: "Filed to pick image",
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    }
  }

  void addOrUpdateProduct(
      {bool isUpdate = false,
      String? productId,
      List<String>? imageUrls}) async {
    if (images.isEmpty && (imageUrls == null || imageUrls.isEmpty)) {
      imageError = "Image is required";
      update();
      return;
    }

    if ((formKey.currentState?.validate() ?? false)) {
      try {
        var request = http.MultipartRequest(
            "POST",
            Uri(
              scheme: "http",
              host: ipAddress,
              path: isUpdate
                  ? "/garga-api/updateProduct.php"
                  : "/garga-api/addProduct.php",
            ));

        request.fields.addAll({
          "productName": productNameController.text,
          "price": productPriceController.text,
          "description": descriptionController.text,
          "category": selectedCategory ?? "",
          "sizes": jsonEncode(selectedSizes),
          "colors": jsonEncode(selectedColors.map((e) => e.toJson()).toList()),
          "merchantId": prefs.getString("userId") ?? "",
          "stock": stockController.text,
        });

        if (isUpdate && productId != null) {
          request.fields["productId"] = productId;
        }

        if (imageUrls != null && imageUrls.isNotEmpty) {
          request.fields["imageUrls"] = jsonEncode(imageUrls);
        }

        if (images.isNotEmpty) {
          for (var i = 0; i < images.length; i++) {
            request.files.add(
              await http.MultipartFile.fromPath("images[]", images[i].path,
                  filename: images[i].name),
            );
          }
        }
        var streamResponse = await request.send();
        var response = await http.Response.fromStream(streamResponse);

        var result = jsonDecode(response.body);
        if (result['success']) {
          productNameController.clear();
          productPriceController.clear();
          descriptionController.clear();
          selectedCategory = null;

          selectedSizes.clear();
          selectedColors.clear();

          images.clear();
          imagePreviews.clear();
          Get.showSnackbar(GetSnackBar(
            message: result['message'],
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ));
          update();
          Get.close(1);
          Get.find<GetDataController>().getProduct();
        } else {
          Get.showSnackbar(GetSnackBar(
            message: result['message'],
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print(e);
      }
    }
  }
}

String colorToHex(Color color, {bool includeAlpha = false}) {
  int r = (color.r * 255).round(); // Convert double to int (0-255)
  int g = (color.g * 255).round();
  int b = (color.b * 255).round();
  int a = (color.a * 255).round();

  String rHex = r.toRadixString(16).padLeft(2, '0').toUpperCase();
  String gHex = g.toRadixString(16).padLeft(2, '0').toUpperCase();
  String bHex = b.toRadixString(16).padLeft(2, '0').toUpperCase();
  String aHex = a.toRadixString(16).padLeft(2, '0').toUpperCase();

  return includeAlpha ? '#$aHex$rHex$gHex$bHex' : '#$rHex$gHex$bHex';
}

Color hexToColor(String code) {
  code = code.replaceAll("#", ""); // Remove '#' if present

  if (code.length == 6) {
    // If format is RRGGBB, assume full opacity (alpha = FF)
    code = "FF$code";
  } else if (code.length != 8) {
    throw ArgumentError("Invalid hex color format: $code");
  }

  return Color(int.parse(code, radix: 16));
}

class SizeType {
  final String label;
  final String value;

  SizeType({required this.label, required this.value});

  //object from json
  factory SizeType.fromJson(Map<String, dynamic> json) {
    return SizeType(label: json['label'], value: json['value']);
  }

  //convert object to json
  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
      };
}

List<SizeType> availableSizes = [
  SizeType(label: "Free Size", value: "Free Size"),
  SizeType(label: "XS (Extra Small)", value: "XS"),
  SizeType(label: "S (Small)", value: "S"),
  SizeType(label: "M (Medium)", value: "M"),
  SizeType(label: "L (Large)", value: "L"),
  SizeType(label: "XL (Extra Large)", value: "XL"),
  SizeType(label: "XXL (Double Extra Large)", value: "XXL"),
];

class ColorType {
  final String label;
  final Color value;

  ColorType({required this.label, required this.value});

  //object from json
  factory ColorType.fromJson(Map<String, dynamic> json) {
    return ColorType(label: json['label'], value: hexToColor(json['value']));
  }

  //convert object to json
  Map<String, dynamic> toJson() => {
        'label': label,
        'value': colorToHex(value),
      };
}

String getColorLabel(String hexCode) {
  for (var colorType in availableColors) {
    if (colorToHex(colorType.value) == hexCode) {
      return colorType.label;
    }
  }
  return "Unknown Color";
}

List<ColorType> availableColors = [
  ColorType(label: "Red", value: Colors.red), // #F44336
  ColorType(label: "Green", value: Colors.green), // #4CAF50
  ColorType(label: "Blue", value: Colors.blue), // #2196F3
  ColorType(label: "Black", value: Colors.black), // #000000
  ColorType(label: "White", value: Colors.white), // #FFFFFF
  ColorType(label: "Yellow", value: Colors.yellow), // #FFEB3B
  ColorType(label: "Pink", value: Colors.pink), // #E91E63
  ColorType(label: "Purple", value: Colors.purple), // #9C27B0
  ColorType(label: "Orange", value: Colors.orange), // #FF9800
  ColorType(label: "Brown", value: Colors.brown), // #795548
  ColorType(label: "Gray", value: Colors.grey), // #9E9E9E
  ColorType(label: "Cyan", value: Colors.cyan), // #00BCD4
  ColorType(label: "Magenta", value: Colors.pinkAccent), // #FF4081
  ColorType(label: "Lime", value: Colors.lime), // #CDDC39
  ColorType(label: "Teal", value: Colors.teal), // #009688
  ColorType(label: "Indigo", value: Colors.indigo), // #3F51B5
  ColorType(label: "Amber", value: Colors.amber), // #FFC107
  ColorType(label: "Coral", value: Colors.deepOrange), // #FF5722
  ColorType(label: "Olive", value: Colors.greenAccent), // #B2FF59
  ColorType(label: "Navy", value: Colors.blueAccent), // #448AFF
  ColorType(label: "Slate", value: Colors.blueGrey), // #607D8B
  ColorType(label: "Maroon", value: Colors.brown), // #795548
  ColorType(label: "Khaki", value: Colors.yellowAccent), // #FFFF8D
  ColorType(label: "Lavender", value: Colors.purpleAccent), // #E040FB
  ColorType(label: "Salmon", value: Colors.pinkAccent), // #FF80AB
  ColorType(label: "Turquoise", value: Colors.tealAccent), // #64FFDA
  ColorType(label: "Peach", value: Colors.orangeAccent), // #FFAB40
  ColorType(label: "Mint", value: Colors.lightGreen), // #8BC34A
  ColorType(label: "Plum", value: Colors.deepPurple), // #673AB7
  ColorType(label: "Lavender Blush", value: Colors.pink.shade50), // #FCE4EC
  // ColorType(label: "Light Coral", value: Colors.lightBlueAccent), // #40C4FF
  // ColorType(
  //     label: "Light Goldenrod Yellow", value: Colors.yellow.shade50), // #FFFDE7
  // ColorType(label: "Light Gray", value: Colors.grey.shade300), // #E0E0E0
  // ColorType(label: "Light Pink", value: Colors.pink.shade100), // #F8BBD0
  // ColorType(label: "Light Salmon", value: Colors.orange.shade100), // #FFCCBC
  // ColorType(label: "Light Sea Green", value: Colors.teal.shade200), // #80CBC4
  // ColorType(
  //     label: "Light Sky Blue", value: Colors.lightBlue.shade100), // #B3E5FC
  // ColorType(
  //     label: "Light Slate Gray", value: Colors.blueGrey.shade200), // #B0BEC5
  // ColorType(label: "Light Steel Blue", value: Colors.blue.shade100), // #BBDEFB
  // ColorType(label: "Light Yellow", value: Colors.yellow.shade100), // #FFF9C4
  // ColorType(
  //     label: "Medium Aquamarine", value: Colors.lightGreen.shade200), // #A5D6A7
  // ColorType(label: "Medium Blue", value: Colors.blue.shade200), // #90CAF9
  // ColorType(label: "Medium Orchid", value: Colors.purple.shade200), // #CE93D8
  // ColorType(label: "Medium Sea Green", value: Colors.green.shade200), // #A5D6A7
  // ColorType(label: "Medium Slate Blue", value: Colors.blue.shade300), // #64B5F6
  // ColorType(label: "Medium Spring Green", value: Colors.greenAccent), // #69F0AE
  // ColorType(label: "Medium Turquoise", value: Colors.teal.shade300), // #4DB6AC
  // ColorType(label: "Medium Violet Red", value: Colors.pink.shade200), // #F48FB1
  // ColorType(label: "Midnight Blue", value: Colors.indigo.shade900), // #1A237E
  // ColorType(label: "Mint Cream", value: Colors.teal.shade50), // #E0F2F1
  // ColorType(label: "Misty Rose", value: Colors.pink.shade50), // #FCE4EC
  // ColorType(label: "Moccasin", value: Colors.orange.shade50), // #FFF3E0
  // ColorType(label: "Navajo White", value: Colors.brown.shade50), // #EFEBE9
  // ColorType(label: "Old Lace", value: Colors.yellow.shade50), // #FFFDE7
  // ColorType(label: "Olive Drab", value: Colors.green.shade300), // #81C784
  // ColorType(label: "Orange Red", value: Colors.redAccent), // #FF5252
  // ColorType(label: "Orchid", value: Colors.purple.shade300), // #BA68C8
  // ColorType(label: "Pale Goldenrod", value: Colors.yellow.shade200), // #FFF59D
  // ColorType(label: "Pale Green", value: Colors.green.shade100), // #C8E6C9
  // ColorType(label: "Pale Turquoise", value: Colors.teal.shade100), // #B2DFDB
  // ColorType(label: "Pale Violet Red", value: Colors.pink.shade300), // #F06292
  // ColorType(label: "Papaya Whip", value: Colors.orange.shade50), // #FFF3E0
  // ColorType(label: "Peach Puff", value: Colors.orange.shade200), // #FFAB91
  // ColorType(label: "Peru", value: Colors.brown.shade200), // #BCAAA4
  // ColorType(label: "Pink Lemonade", value: Colors.pink.shade200), // #F48FB1
  // ColorType(label: "Powder Blue", value: Colors.blue.shade50), // #E3F2FD
  // ColorType(label: "Rosy Brown", value: Colors.brown.shade100), // #D7CCC8
  // ColorType(label: "Royal Blue", value: Colors.blue.shade900), // #0D47A1
  // ColorType(label: "Saddle Brown", value: Colors.brown.shade800), // #4E342E
  // ColorType(label: "Sienna", value: Colors.brown.shade600), // #6D4C41
  // ColorType(label: "Sky Blue", value: Colors.blue.shade200), // #90CAF9
  // ColorType(label: "Snow", value: Colors.white), // #FFFFFF
  // ColorType(label: "Steel Blue", value: Colors.blue.shade600), // #1E88E5
];
