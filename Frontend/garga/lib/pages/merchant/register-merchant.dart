import 'package:flutter/foundation.dart';
import 'package:garga/components/button.dart';

import 'package:flutter/material.dart';
import 'package:garga/controllers/register_controller.dart';
import 'package:get/get.dart';

class MerchantRegisterPage extends StatelessWidget {
  const MerchantRegisterPage({super.key});

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
                        "Become a Merchant",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Wrap(
                    children: [
                      Text(
                        "You will be able to login after your request is approved.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: "Business/Merchant Name",
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your business name';
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
                      } else if (GetUtils.isEmail(value!) == false) {
                        return 'Please enter a valid email address';
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
                  GetBuilder<RegisterController>(
                    builder: (controller) => FormField<Uint8List?>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        if (controller.imagePreview == null ||
                            controller.imagePreview!.isEmpty) {
                          return 'Please upload your business registration document';
                        }
                        return null;
                      },
                      initialValue: controller.imagePreview,
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Business Registration Document*",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: controller.imagePreview != null
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: IconButton(
                                            onPressed: () {
                                              controller.imagePreview = null;
                                              field.didChange(null);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        ClipRRect(
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.memory(
                                            controller.imagePreview!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    )
                                  : TextButton(
                                      onPressed: () async {
                                        await controller.pickImage();
                                        if (controller.imagePreview != null) {
                                          field.didChange(
                                              controller.imagePreview);
                                        }
                                      },
                                      child: const Icon(
                                        Icons.add_a_photo,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  field.errorText ?? "",
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Button(
                      label: "Submit Request",
                      onPressed: () async {
                        await controller.register("merchant");
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
