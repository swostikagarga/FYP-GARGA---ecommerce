import 'package:flutter/material.dart';
import 'package:garga/components/button.dart';
import 'package:garga/constant.dart';
import 'package:garga/controllers/edit_profile_controller.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: GetBuilder<EditProfileController>(initState: (_) {
        Get.lazyPut<EditProfileController>(() => EditProfileController());
        var user = Get.arguments;
        if (user != null) {
          Get.find<EditProfileController>().initUser(user);
        }
      }, builder: (controller) {
        var user = controller.user;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: controller.registerFormKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: controller.imagePreview != null
                            ? MemoryImage(controller.imagePreview!)
                            : user?.profileImage == null
                                ? null
                                : NetworkImage(
                                    getImageUrl(user?.profileImage ?? "")),
                        backgroundColor: Colors.grey,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            controller.pickImage();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
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
                    controller: controller.addressController,
                    decoration: const InputDecoration(
                      labelText: "Address",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: controller.genderList
                        .map((value) => Row(
                              children: [
                                Radio(
                                  value: value,
                                  groupValue: controller.gender,
                                  onChanged: (v) {
                                    controller.gender = v;
                                    controller.update();
                                  },
                                ),
                                Text(GetUtils.capitalizeFirst(value) ?? ""),
                              ],
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Button(
                      label: "Update Profile",
                      onPressed: () {
                        controller.updateProfile();
                      }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
