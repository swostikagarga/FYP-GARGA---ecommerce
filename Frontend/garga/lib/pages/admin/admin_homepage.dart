import 'package:garga/controllers/getDataController.dart';
import 'package:garga/pages/admin/admin_users.dart';
import 'package:garga/pages/common/dashboard.dart';
import 'package:garga/pages/common/ordersPage.dart';
import 'package:garga/pages/common/products_list.dart';

import 'package:garga/pages/common/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:garga/utils/theme.dart';
import 'package:get/get.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  var screens = [
    const DashboardPage(),
    const ProductListPage(),
    const AdminUserPage(),
    const OrdersPage(),
    const ProfilePage(),
  ];
  var activePage = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetDataController>(
      init: GetDataController(),
      builder: (controller) => Scaffold(
          body: screens[activePage],
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              fixedColor: primaryColor,
              unselectedItemColor: Colors.blueGrey,
              currentIndex: activePage,
              onTap: (page) {
                setState(() {
                  activePage = page;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: "Products",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: "Users",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: "Orders",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ])),
    );
  }
}
