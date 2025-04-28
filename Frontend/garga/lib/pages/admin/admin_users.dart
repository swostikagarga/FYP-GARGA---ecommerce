import 'package:flutter/material.dart';
import 'package:garga/constant.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/controllers/register_controller.dart';
import 'package:garga/models/allUsersResponse.dart';
import 'package:garga/utils/theme.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminUserPage extends StatelessWidget {
  const AdminUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context, builder: (context) => const AddUserPopup());
        },
        child: const Icon(Icons.add),
      ),
      body: const DefaultTabController(length: 3, child: UserTabBar()),
    );
  }
}

class UserTabBar extends StatelessWidget {
  const UserTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetDataController>(builder: (controller) {
      var userList = controller.allUsersResponse?.users;
      var adminList =
          userList?.where((element) => element.role == "admin").toList();
      var merchantList =
          userList?.where((element) => element.role == "merchant").toList();
      var usersList =
          userList?.where((element) => element.role == "user").toList();
      return Column(
        children: [
          const TabBar(
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            tabs: [
              Tab(
                text: "Admins",
              ),
              Tab(
                text: "Merchants",
              ),
              Tab(
                text: "Customers",
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                UserList(userType: UserType.admin, users: adminList),
                UserList(userType: UserType.merchant, users: merchantList),
                UserList(userType: UserType.user, users: usersList),
              ],
            ),
          ),
        ],
      );
    });
  }
}

enum UserType { admin, merchant, user }

class UserList extends StatelessWidget {
  final UserType userType;
  final List<User>? users;
  const UserList({super.key, required this.userType, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users == null || users!.isEmpty) {
      return const Center(
        child: Text(
          "No users found",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: users!.length,
      itemBuilder: (context, index) {
        return UserCard(user: users![index]);
      },
    );
  }
}

//user card

class UserCard extends StatelessWidget {
  final User user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    bool isDeleted = user.isDeleted == "1";
    bool isMerchant = user.role == "merchant";

    String title = isDeleted
        ? isMerchant
            ? "Approve Merchant"
            : "Restore User"
        : "Deactivate Account";
    String content = isDeleted
        ? "Are you sure you want to restore this user?"
        : "Are you sure you want to Deactivate this user?";

    //list tile
    return GetBuilder<RegisterController>(
      init: RegisterController(),
      builder: (controller) => ListTile(
        tileColor: Colors.transparent,
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 25,
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 40,
          ),
        ),
        title: Text(
            (user.fullName ?? "") +
                ((isMerchant)
                    ? isDeleted
                        ? " (Not Approved)"
                        : "(Approved)"
                    : ""),
            style: TextStyle(
              color: (isDeleted && isMerchant) ? Colors.red : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            )),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email ?? ""),
            Text(
              'Joined on ${DateFormat.yMMMd().format(user.createdAt!)}',
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      insetPadding: const EdgeInsets.all(20),
                      titlePadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      title: Text(title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text((isMerchant && isDeleted)
                                ? "Do you want to approve this merchant?"
                                : content),
                            if (isMerchant)
                              const SizedBox(
                                height: 10,
                              ),
                            Text(
                              isDeleted
                                  ? "Note: Review the merchant document before approving."
                                  : "Note: Merchant will not be able to login until approved.",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                            if (isMerchant)
                              const SizedBox(
                                height: 10,
                              ),
                            if (isMerchant)
                              Image.network(
                                getImageUrl(user.documentUrl ?? ""),
                                height: 500,
                                width: 500,
                                fit: BoxFit.cover,
                              ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await controller.deleteUser(user.userId ?? "");
                            Get.find<GetDataController>().getAllUsers();
                          },
                          child: Text(isDeleted
                              ? isMerchant
                                  ? "Approve"
                                  : "Restore"
                              : "Delete"),
                        ),
                      ],
                    ));
          },
          icon: isDeleted
              ? isMerchant
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.restore,
                      color: Colors.green,
                    )
              : const Icon(
                  Icons.no_accounts,
                  color: Colors.red,
                ),
        ),
        isThreeLine: true,
      ),
    );
  }
}

class AddUserPopup extends StatefulWidget {
  const AddUserPopup({super.key});

  @override
  State<AddUserPopup> createState() => _AddUserPopupState();
}

class _AddUserPopupState extends State<AddUserPopup> {
  String dropdownValue = 'admin';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetDataController>(
      builder: (controller) => AlertDialog(
        //width of the alert dialog

        contentPadding: const EdgeInsets.all(10),
        insetPadding: const EdgeInsets.all(20),
        title: const Text(
          "Add User",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: GetBuilder<RegisterController>(
            init: RegisterController(),
            builder: (controller) => SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: controller.registerFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: [
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
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        labelText: "Email Address",
                      ),
                      validator: (value) {
                        if ((value?.isEmpty ?? true) ||
                            !GetUtils.isEmail(value ?? "")) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controller.passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter initial password for the user';
                        } else if ((value?.length ?? 0) < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                    ),
                    DropdownButtonFormField(
                      items: const [
                        DropdownMenuItem(
                          value: "admin",
                          child: Text("Admin"),
                        ),
                        // DropdownMenuItem(
                        //   value: "merchant",
                        //   child: Text("Merchant"),
                        // ),
                        DropdownMenuItem(
                          value: "user",
                          child: Text("User"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value.toString();
                        });
                      },
                      value: dropdownValue,
                      decoration: const InputDecoration(
                        labelText: "Role",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await Get.find<RegisterController>().register(dropdownValue);
              controller.getAllUsers();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
