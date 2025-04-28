import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:garga/constant.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/models/users.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  User? user;

  TextEditingController nameController = TextEditingController();
  String? gender;
  var addressController = TextEditingController();
  var phoneNumberController = TextEditingController();
  String? profileImage;

  var registerFormKey = GlobalKey<FormState>();

  XFile? image;
  Uint8List? imagePreview;

  List<String> genderList = ["male", "female", "other"];

  void initUser(User user) {
    this.user = user;
    nameController.text = user.fullName ?? "";
    gender = user.gender;
    addressController.text = user.address ?? "";
    phoneNumberController.text = user.phoneNumber ?? "";
    profileImage = user.profileImage;
    update();
  }

  void pickImage() async {
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

  Future<void> updateProfile() async {
    if (registerFormKey.currentState?.validate() ?? false) {
      try {
        var request = http.MultipartRequest(
            "POST",
            Uri(
              scheme: "http",
              host: ipAddress,
              path: "/garga-api/updateProfile.php",
            ));
        if (image != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'profile_image[]',
              imagePreview!,
              filename: image!.name,
            ),
          );
        }
        request.fields.addAll({
          "fullName": nameController.text,
        });

        if (gender != null) {
          request.fields["gender"] = gender!;
        }

        if (addressController.text.isNotEmpty) {
          request.fields["address"] = addressController.text;
        }

        if (phoneNumberController.text.isNotEmpty) {
          request.fields["phone_number"] = phoneNumberController.text;
        }

        request.fields["userId"] = user?.userId ?? "";
        request.fields['profile_image'] = user?.profileImage ?? "";

        var response = await request.send();

        var result = jsonDecode(await response.stream.bytesToString());

        if (result['success']) {
          Get.close(1);
          Get.showSnackbar(GetSnackBar(
            message: result['message'],
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ));
          Get.find<GetDataController>()
              .getMyDetails()
              .onError((error, stackTrace) {});
        } else {
          Get.showSnackbar(GetSnackBar(
            message: result['message'],
            duration: const Duration(seconds: 10),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
