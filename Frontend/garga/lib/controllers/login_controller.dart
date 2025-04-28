import 'dart:convert';

import 'package:garga/constant.dart';
import 'package:garga/models/users.dart';
import 'package:garga/pages/admin/admin_homepage.dart';
import 'package:garga/pages/user/home.dart';
import 'package:flutter/material.dart';
import 'package:garga/pages/merchant/merchant_homepage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var loginFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (loginFormKey.currentState?.validate() ?? false) {
      try {
        final prefs = await SharedPreferences.getInstance();
        var response = await http.post(
            Uri(
              // host:ipAddress+"/garga-api",
              /// handled.
              scheme: "http",
              host: ipAddress,
              path: "/garga-api/auth/login.php",
            ),
            body: {
              "email": emailController.text,
              "password": passwordController.text,
            });

        var result = jsonDecode(response.body);
        if (result['success']) {
          User user = User.fromJson(result['user']);
          if (user.isDeleted == "1") {
            var role = result['role'];
            Get.showSnackbar(GetSnackBar(
              message: role == "merchant"
                  ? "You can only login after approval from admin"
                  : "Your account is deleted, contact admin",
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red,
            ));
            return;
          }

          emailController.clear();
          passwordController.clear();
          Get.showSnackbar(GetSnackBar(
            message: result['message'],
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ));

          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('role', result['role']);
          await prefs.setString("userId", result['userId']);
          if (result['role'] == "admin") {
            Get.offAll(() => const AdminHomePage());
          } else if (result['role'] == "merchant") {
            Get.offAll(() => const MerchantHomePage());
          } else {
            Get.offAll(() => const HomePage());
          }
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
