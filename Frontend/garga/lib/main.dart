import 'package:garga/pages/merchant/merchant_homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:garga/pages/admin/admin_homepage.dart';
import 'package:garga/pages/user/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:garga/utils/theme.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String role = prefs.getString('role') ?? "user";

    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      child: KhaltiScope(
          publicKey: "test_public_key_5ee53829f5614430864cc41412c44cb6",
          builder: (context, navigatorKey) {
            return GetMaterialApp(
              navigatorKey: navigatorKey,
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('ne', 'NP'),
              ],
              localizationsDelegates: const [
                KhaltiLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              defaultTransition: Transition.cupertino,
              theme: ThemeData(
                fontFamily: GoogleFonts.poppins().fontFamily,
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.all(20),
                ),
                buttonTheme: ButtonThemeData(
                  buttonColor: primaryColor,
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                listTileTheme: const ListTileThemeData(
                  tileColor: Color(0xffE0E0E0),
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                ),
                useMaterial3: false,
                primarySwatch: primaryColor,
                scaffoldBackgroundColor: backgroundColor,
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  },
                ),
              ),
              home: role == "admin"
                  ? const AdminHomePage()
                  : role == "merchant"
                      ? const MerchantHomePage()
                      : const HomePage(),
            );
          }),
    );
  }
}
