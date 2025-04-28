import 'package:flutter/material.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/main.dart';
import 'package:garga/pages/common/login.dart';
import 'package:garga/pages/user/cart_page.dart';
import 'package:garga/pages/user/favouritePage.dart';
import 'package:garga/pages/user/first_page.dart';
import 'package:garga/pages/common/profile_page.dart';
import 'package:garga/utils/theme.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var activePage = 0;

  @override
  Widget build(BuildContext context) {
    var screens = [
      FirstPage(onGoToCart: (index) {
        setState(() {
          activePage = index;
        });
      }),
      const CartPage(),
      Container(),
      const FavouritePage(),
      const ProfilePage(),
    ];

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    return GetBuilder<GetDataController>(
      init: GetDataController(),
      builder: (controller) => Scaffold(
        body: screens[activePage],
        bottomNavigationBar: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
                fixedColor: primaryColor,
                unselectedItemColor: Colors.blueGrey,
                currentIndex: activePage,
                onTap: (page) {
                  if (page == 4 && !isLoggedIn) {
                    Get.offAll(() => const LoginPage());
                    return;
                  }

                  if (page == 2) {
                    return;
                  }
                  setState(() {
                    activePage = page;
                  });
                },
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    label: "Cart",
                  ),
                  BottomNavigationBarItem(
                    icon: Container(width: 40), // Small spacer for the logo
                    label: "",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_outline),
                    label: "Saved",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
            Positioned(
              top: -20, // Adjusted height so it’s not too far out
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: GestureDetector(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/garga-white.png', // Replace with your logo path
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Text(
                      "GARGA",
                      style: TextStyle(
                        color: Color(0xFF9FA5C0),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
