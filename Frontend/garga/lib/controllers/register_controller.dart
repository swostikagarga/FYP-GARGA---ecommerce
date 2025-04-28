import 'dart:convert';
import 'dart:typed_data';

import 'package:garga/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var registerFormKey = GlobalKey<FormState>();

  XFile? image;
  Uint8List? imagePreview;

  Future<void> register(String role) async {
    if (registerFormKey.currentState?.validate() ?? false) {
      try {
        var request = http.MultipartRequest(
            "POST",
            Uri(
              scheme: "http",
              host: ipAddress,
              path: "/garga-api/auth/register.php",
            ));

        request.fields['email'] = emailController.text;
        request.fields['password'] = passwordController.text;
        request.fields['fullName'] = nameController.text;
        request.fields['role'] = role;
        if (imagePreview != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'document[]',
              imagePreview!,
              filename: image?.name,
            ),
          );
        }
        var response = await request.send();
        var result = jsonDecode(await response.stream.bytesToString());
        if (result['success']) {
          Get.back();
          Get.showSnackbar(GetSnackBar(
            message: result['message'],
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ));
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

  Future<void> deleteUser(String userId) async {
    try {
      var response = await http.post(
          Uri(
            // host:ipAddress+"/garga-api",
            /// handled.
            scheme: "http",
            host: ipAddress,
            path: "/garga-api/deleteRestoreUser.php",
          ),
          body: {
            "userId": userId,
          });

      var result = jsonDecode(response.body);
      if (result['success']) {
        Get.back();
        Get.showSnackbar(GetSnackBar(
          message: result['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ));
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

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      var image = await picker.pickImage(source: ImageSource.gallery);
      this.image = image;
      imagePreview = await image!.readAsBytes();
      update();
    } catch (e) {
      Get.showSnackbar(const GetSnackBar(
        message: "Filed to pick image",
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    }
  }
}
