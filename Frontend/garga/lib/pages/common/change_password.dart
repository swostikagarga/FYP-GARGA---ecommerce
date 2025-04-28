import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:garga/constant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  final String userId;
  const ChangePasswordPage({super.key, required this.userId});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> changePassword() async {
      if (changePasswordFormKey.currentState?.validate() ?? false) {
        try {
          var response = await http.post(
              Uri(
                // host:ipAddress+"/garga-api",
                /// handled.
                scheme: "http",
                host: ipAddress,
                path: "/garga-api/auth/changePassword.php",
              ),
              body: {
                "currentPassword": oldPasswordController.text,
                "newPassword": newPasswordController.text,
                "user_id": widget.userId,
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
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: changePasswordFormKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                TextFormField(
                  controller: oldPasswordController,
                  decoration: const InputDecoration(
                    labelText: "Old Password",
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    } else if ((value?.length ?? 0) < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    } else if ((value?.length ?? 0) < 6) {
                      return 'Password must be at least 6 characters';
                    } else if (value == oldPasswordController.text) {
                      return 'New password must be different from old password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    } else if ((value?.length ?? 0) < 6) {
                      return 'Password must be at least 6 characters';
                    } else if (value != newPasswordController.text) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    changePassword();
                  },
                  child: const Text("Change Password"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
