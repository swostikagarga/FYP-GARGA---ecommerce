import 'package:garga/constant.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/main.dart';
import 'package:garga/pages/common/change_password.dart';
import 'package:garga/pages/common/editProfile.dart';
import 'package:garga/pages/common/login.dart';
import 'package:flutter/material.dart';
import 'package:garga/pages/common/ordersPage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: GetBuilder<GetDataController>(
        builder: (controller) {
          var user = controller.userResponse?.user;
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user?.profileImage == null
                      ? null
                      : NetworkImage(getImageUrl(user?.profileImage ?? "")),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  user?.fullName ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.email ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  user?.role?.toUpperCase() ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const EditProfilePage(), arguments: user);
                  },
                  child: const Text("Update"),
                ),
                Text(
                  "Joined on: ${DateFormat.yMMMMd().format(user?.createdAt ?? DateTime.now())}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text("My Orders"),
                  trailing: const Icon(Icons.shopping_bag),
                  onTap: () => Get.to(() => const OrdersPage()),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text("Change Password"),
                  trailing: const Icon(Icons.lock),
                  onTap: () => Get.to(() => ChangePasswordPage(
                      userId: user?.userId.toString() ?? "")),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text("Logout"),
                  trailing: const Icon(Icons.logout),
                  onTap: () => Get.defaultDialog(
                    title: "Logout",
                    middleText: "Are you sure you want to logout?",
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await prefs.clear();
                          Get.offAll(() => const LoginPage());
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
