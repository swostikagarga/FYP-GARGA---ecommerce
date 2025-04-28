import 'package:garga/components/button.dart';

import 'package:garga/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(RegisterController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: controller.registerFormKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Row(
                    children: [
                      Text(
                        "Sign Up",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "as a User",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your password';
                      } else if ((value?.length ?? 0) < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Button(
                      label: "Sign Up",
                      onPressed: () {
                        controller.register("user");
                      }),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
