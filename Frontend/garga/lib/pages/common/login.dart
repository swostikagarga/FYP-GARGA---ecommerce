import 'package:garga/pages/merchant/register-merchant.dart';
import 'package:garga/pages/user/home.dart';
import 'package:get/get.dart';
import 'package:garga/components/button.dart';
import 'package:garga/components/logo.dart';
import 'package:garga/controllers/login_controller.dart';
import 'package:garga/pages/common/register.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LoginController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.offAll(() => const HomePage());
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const MyLogo(),
                  const Row(
                    children: [
                      Text(
                        "Login",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                  Button(label: "Login", onPressed: controller.login),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const RegisterPage());
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Get.to(() => const MerchantRegisterPage());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Become a merchant?",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
