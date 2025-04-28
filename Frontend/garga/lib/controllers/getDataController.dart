// ignore_for_file: file_names

import 'dart:convert';
import 'package:garga/components/button.dart';
import 'package:garga/components/color_size_selector.dart';
import 'package:garga/constant.dart';
import 'package:garga/controllers/addProductController.dart';
import 'package:garga/main.dart';
import 'package:garga/models/allUsersResponse.dart';
import 'package:garga/models/cart.dart';
import 'package:garga/models/category.dart';
import 'package:garga/models/orders.dart';
import 'package:garga/models/products.dart';
import 'package:garga/models/promo_code.dart';
import 'package:garga/models/stats.dart';
import 'package:garga/models/users.dart';
import 'package:flutter/material.dart';
import 'package:garga/pages/common/ordersPage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:khalti_flutter/khalti_flutter.dart';
//materil as M
import 'package:flutter/material.dart' as m;

class GetDataController extends GetxController {
  CategoriesResponse? categoriesResponse;
  ProductResponse? productResponse;
  OrderResponse? orderResponse;
  UserResponse? userResponse;
  StatsResponse? statsResponse;
  AllUsersResponse? allUsersResponse;
  List<String> favouriteProducts = [];
  PromoCodes? promoCodesResponse;
  var discountPercentage = 0.0;
  var deliveryCharge = 100;

  List<CartItem> cart = [];
  String? paymentMethod;

  @override
  onInit() {
    super.onInit();
    getInitialData();
    // prefs.remove("cart");
    initializeLocals();
  }

  void getInitialData() {
    getCategories();
    getProduct();
    getAllUsers();
    getOrders();
    getMyDetails();
    getStats();
    getPromoCodes();
  }

  TextEditingController promoCodeController = TextEditingController();

  void applyPromoCode() {
    final code = promoCodeController.text.trim();
    final promoCode = promoCodesResponse?.promoCodes
        ?.firstWhereOrNull((promo) => promo.promoCode == code);
    if (promoCode != null) {
      if (promoCode.isActive == true) {
        discountPercentage = double.parse(promoCode.percentage ?? "0");
        Get.showSnackbar(const GetSnackBar(
          message: "Promo code applied successfully",
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ));
      } else {
        Get.showSnackbar(const GetSnackBar(
          message: "Promo code is not active",
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      Get.showSnackbar(const GetSnackBar(
        message: "Invalid promo code",
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    }
    update();
  }

  void initializeLocals() {
    var cartString = prefs.getString("cart");
    if (cartString != null) {
      var cartList = jsonDecode(cartString) as List<dynamic>;
      cart = cartList
          .map(
            (e) => CartItem(
              product: Product.fromJson(e['product']),
              quantity: e['quantity'],
              size: SizeType.fromJson(e['size']),
              color: ColorType.fromJson(e['color']),
            ),
          )
          .toList();
    }

    var favouriteString = prefs.getString("favourite");
    if (favouriteString != null) {
      favouriteProducts = jsonDecode(favouriteString).cast<String>();
    }

    update();
  }

  void addFavouriteProduct(String productId) {
    favouriteProducts.add(productId);
    update();

    Get.showSnackbar(const GetSnackBar(
      message: "Product added to favourite",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
    ));

    updateFavouriteLocal();
  }

  void removeFavouriteProduct(String productId) {
    favouriteProducts.remove(productId);
    update();
    Get.showSnackbar(const GetSnackBar(
      message: "Product removed from favourite",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
    ));

    updateFavouriteLocal();
  }

  Future<void> addToCart(
    Product product, {
    int quantity = 1,
    required String? availableSizes,
    required String? availableColors,
  }) async {
    var selectedColors = getDecodedList<dynamic>(availableColors)
        .map((e) => ColorType.fromJson(e))
        .toList();

    var selectedSizes = getDecodedList<dynamic>(availableSizes)
        .map((e) => SizeType.fromJson(e))
        .toList();

    // Show color and size selection dialog
    var colorAndSize = await Get.defaultDialog<ColorAndSizeType>(
      barrierDismissible: false,
      title: "Select Color and Size",
      contentPadding: const EdgeInsets.all(20),
      content: ColorSizeSelector(
        colors: selectedColors,
        sizes: selectedSizes,
        onConfirm: (selectedColor, selectedSize) {
          Get.back(
            result: ColorAndSizeType(
              color: selectedColor,
              size: selectedSize,
            ),
          );
        },
      ),
    );

    if (colorAndSize == null) {
      // Get.showSnackbar(const GetSnackBar(
      //   message: "C
      //   duration: Duration(seconds: 2),
      //   backgroundColor: Colors.red,
      //   snackPosition: SnackPosition.TOP,
      // ));
      return;
    }

    // Check if the product is already in the cart
    bool containsProduct =
        cart.any((cartItem) => cartItem.product.productId == product.productId);

    if (containsProduct) {
      Get.showSnackbar(const GetSnackBar(
        message: "Already in Cart",
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      ));
      return;
    }

    // Add the selected item to the cart
    cart.add(
      CartItem(
        product: product,
        quantity: quantity,
        size: colorAndSize.size,
        color: colorAndSize.color,
      ),
    );

    updateLocalCart();
    update();

    Get.showSnackbar(const GetSnackBar(
      message: "Added to cart!",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
    ));
  }

  void removeFromCart(Product product) {
    cart.removeWhere(
        (element) => element.product.productId == product.productId);
    updateLocalCart();
    update();
    Get.showSnackbar(const GetSnackBar(
      message: "Removed from cart!",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.TOP,
    ));
  }

  void increaseQuantity(Product product) {
    var quantity = cart
        .firstWhere((element) => element.product.productId == product.productId)
        .quantity;

    if (quantity > (int.parse(product.stock ?? "0") - 1)) {
      Get.showSnackbar(const GetSnackBar(
        message: "Not enough stock",
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      ));
      return;
    }

    if (quantity < 10) {
      cart
          .firstWhere(
              (element) => element.product.productId == product.productId)
          .quantity++;
      update();
      updateLocalCart();
    }
  }

  bool isFavorite(String productId) {
    return favouriteProducts.contains(productId);
  }

  void decreaseQuantity(Product product) {
    var quantity = cart
        .firstWhere((element) => element.product.productId == product.productId)
        .quantity;
    if (quantity > 1) {
      cart
          .firstWhere(
              (element) => element.product.productId == product.productId)
          .quantity--;
      update();
      updateLocalCart();
    }
  }

  void updateLocalCart() {
    prefs.setString(
      "cart",
      jsonEncode(
        cart
            .map(
              (e) => {
                "quantity": e.quantity,
                "product": e.product.toJson(),
                "size": e.size.toJson(),
                "color": e.color.toJson()
              },
            )
            .toList(),
      ),
    );
  }

  void updateFavouriteLocal() {
    prefs.setString("favourite", jsonEncode(favouriteProducts));
  }

  double getSubTotal() {
    double subTotal = 0;
    for (var item in cart) {
      subTotal += double.parse(item.product.price ?? '0') * item.quantity;
    }
    return subTotal.toDouble();
  }

  double getDeliveryCharge() {
    return deliveryCharge.toDouble();
  }

  double getDiscount() {
    double total = getSubTotal();
    double discountAmount = (discountPercentage / 100) * total;
    return discountAmount.toPrecision(2);
  }

  double getTotal() {
    double subTotal = getSubTotal();
    double discountAmount = getDiscount();
    double total = subTotal - discountAmount + getDeliveryCharge();

    return total.toPrecision(2);
  }

  void updateData() {
    update();
  }

  Future<void> createOrder() async {
    try {
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (cart.isEmpty) {
        Get.showSnackbar(const GetSnackBar(
          message: "Add some product to cart first!!",
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
        return;
      }

      if (!isLoggedIn) {
        Get.showSnackbar(const GetSnackBar(
          message: "Go to profile and login first",
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
        return;
      }

      bool doContinue = await Get.dialog(
        AlertDialog(
          title: const Text("Select Payment Method"),
          content: GetBuilder<GetDataController>(
            builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    tileColor: Colors.white,
                    onTap: () {
                      controller.paymentMethod = "khalti";
                      update();
                    },
                    title: const Row(
                      children: [
                        Text("Khalti"),
                        Spacer(),
                        m.Image(
                          image: AssetImage("assets/khalti.png"),
                          height: 50,
                        ),
                      ],
                    ),
                    leading: Radio(
                      value: "khalti",
                      groupValue: controller.paymentMethod,
                      onChanged: (value) {
                        controller.paymentMethod = value.toString();
                        controller.update(); // triggers UI rebuild
                      },
                    ),
                  ),
                  ListTile(
                    tileColor: Colors.white,
                    onTap: () {
                      controller.paymentMethod = "cod";
                      update();
                    },
                    title: const Text("Cash on Delivery"),
                    leading: Radio(
                      value: "cod",
                      groupValue: controller.paymentMethod,
                      onChanged: (value) {
                        controller.paymentMethod = value.toString();
                        controller.update(); // triggers UI rebuild
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Button(
                      label: "Continue",
                      onPressed: () => Get.back(result: true)),
                ],
              );
            },
          ),
        ),
      );

      if (!doContinue) {
        return;
      }

      var encodedCart = jsonEncode([
        ...cart.map((item) => {
              "product": item.product.toJson(),
              "quantity": item.quantity,
              "size": item.size.value,
              "color": colorToHex(item.color.value),
            })
      ]);

      var response = await http.post(
          Uri(
            // host:ipAddress+"/garga-api",
            /// handled.
            scheme: "http",
            host: ipAddress,
            path: "/garga-api/createOrder.php",
          ),
          body: {
            "userId": prefs.getString("userId"),
            "total": getTotal().toString(),
            "cart": encodedCart,
            "paymentMethod": paymentMethod,
          });

      var result = jsonDecode(response.body);
      if (result['success']) {
        if (paymentMethod == "cod") {
          Get.showSnackbar(GetSnackBar(
            message: result['message'],
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ));
          cart.clear();
          getOrders();
          update();

          Get.to(() => const OrdersPage());
        } else {
          makePayment(result['orderId'].toString());
        }
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

  Future<void> disableProduct(String productId) async {
    try {
      var response = await http.post(
          Uri(
            // host:ipAddress+"/garga-api",
            /// handled.
            scheme: "http",
            host: ipAddress,
            path: "/garga-api/disableRestoreProduct.php",
          ),
          body: {
            "productId": productId,
          });

      var result = jsonDecode(response.body);
      if (result['success']) {
        Get.close(1);

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

  void makePayment(String orderId) async {
    try {
      var config = PaymentConfig(
          amount: (getTotal() * 100).toInt(),
          productIdentity: orderId,
          productName: "Garga order:$orderId");

      KhaltiScope.of(Get.context!).pay(
          preferences: const [PaymentPreference.khalti],
          config: config,
          onSuccess: (value) async {
            var response = await http.post(
                Uri(
                  // host:ipAddress+"/garga-api",
                  /// handled.
                  scheme: "http",
                  host: ipAddress,
                  path: "/garga-api/makePayment.php",
                ),
                body: {
                  "userId": prefs.getString("userId"),
                  "total": value.amount.toString(),
                  "orderId": orderId,
                  "otherDetails": value.toString(),
                });

            var result = jsonDecode(response.body);
            if (result['success']) {
              Get.showSnackbar(GetSnackBar(
                message: result['message'],
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.green,
              ));
              cart.clear();
              updateLocalCart();
              getOrders();
              update();
              Get.to(() => const OrdersPage());
            } else {
              Get.showSnackbar(GetSnackBar(
                message: result['message'],
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red,
              ));
            }
          },
          onFailure: (value) {
            Get.showSnackbar(GetSnackBar(
              message: value.message,
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
            ));
          });
    } catch (e) {
      Get.showSnackbar(const GetSnackBar(
        message: "Payment failed, try again later",
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> getProduct() async {
    try {
      var isMerchant = prefs.getString("role") == "merchant";
      var userId = prefs.getString("userId");
      var response = await http.post(
        Uri(
          scheme: "http",
          host: ipAddress,
          path: "/garga-api/getProducts.php",
        ),
        body: {
          "merchantId": isMerchant ? userId : "",
          "role": prefs.getString("role") ?? "user",
        },
      );

      var result = productResponseFromJson(response.body);

      if (result.success ?? false) {
        productResponse = result;
        update();
      } else {
        Get.showSnackbar(GetSnackBar(
          message: result.message,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getMyDetails() async {
    try {
      var response = await http.post(
          Uri(
            scheme: "http",
            host: ipAddress,
            path: "/garga-api/getMyDetails.php",
          ),
          body: {"userId": prefs.getString("userId")});

      var result = userResponseFromJson(response.body);

      if (result.success ?? false) {
        userResponse = result;

        if (userResponse?.user?.isDeleted == "1") {
          var role = userResponse?.user?.role;
          Get.showSnackbar(GetSnackBar(
            message: role == "merchant"
                ? "You can only login after approval from admin"
                : "Your account is deleted, contact admin",
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ));
          await prefs.clear();
          Get.offAll(() => const MyApp());
        } else {
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('role', userResponse?.user?.role ?? "");
          await prefs.setString("userId", userResponse?.user?.userId ?? "");
        }

        update();
      } else {
        Get.showSnackbar(GetSnackBar(
          message: result.message,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getStats() async {
    try {
      var response = await http.post(
        Uri(
          scheme: "http",
          host: ipAddress,
          path: "/garga-api/getStats.php",
        ),
        body: {
          "userId": prefs.getString("userId"),
          "role": prefs.getString("role")
        },
      );

      var result = statsResponseFromJson(response.body);

      if (result.success ?? false) {
        statsResponse = result;
        update();
      } else {
        Get.showSnackbar(GetSnackBar(
          message: result.message,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPromoCodes() async {
    try {
      var response = await http.post(
        Uri(
          scheme: "http",
          host: ipAddress,
          path: "/garga-api/getPromoCode.php",
        ),
        body: {
          "role": prefs.getString("role") ?? "user",
        },
      );

      var result = promoCodesFromJson(response.body);

      if (result.success ?? false) {
        promoCodesResponse = result;
        update();
      } else {
        Get.showSnackbar(GetSnackBar(
          message: result.message,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  void updateOrderStatus(String status, String orderId) async {
    try {
      var response = await http.post(
        Uri(
          scheme: "http",
          host: ipAddress,
          path: "/garga-api/updateOrderStatus.php",
        ),
        body: {
          "orderId": orderId,
          "status": status,
        },
      );

      print(response.body);

      var result = jsonDecode(response.body);

      if (result['success'] ?? false) {
        await getOrders();
        Get.showSnackbar(GetSnackBar(
          message: result['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ));

        update();
      } else {
        Get.showSnackbar(GetSnackBar(
          message: result.message,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  //add promo code
  Future<void> addPromoCode(
      String promoCode, String percentage, bool isActive) async {
    try {
      var response = await http.post(
        Uri(
          scheme: "http",
          host: ipAddress,
          path: "/garga-api/addPromoCode.php",
        ),
        body: {
          "promoCode": promoCode,
          "percentage": percentage,
          "is_active": isActive.toString(),
        },
      );
      var result = jsonDecode(response.body);
      if (result['success']) {
        Get.showSnackbar(GetSnackBar(
          message: result['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ));
        getPromoCodes();
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

  //update promo code
  Future<void> updatePromoCode(String promoCodeId, String promoCode,
      String percentage, bool isActive) async {
    try {
      var response = await http.post(
        Uri(
          scheme: "http",
          host: ipAddress,
          path: "/garga-api/updatePromoCode.php",
        ),
        body: {
          "promoCode": promoCode,
          "percentage": percentage,
          "is_active": isActive.toString(),
          "promoCodeId": promoCodeId,
        },
      );
      var result = jsonDecode(response.body);
      if (result['success']) {
        Get.showSnackbar(GetSnackBar(
          message: result['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ));
        getPromoCodes();
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

  Future<void> getCategories() async {
    try {
      var response = await http.post(
        Uri(
          scheme: "http",
          host: ipAddress,
          path: "/garga-api/getCategories.php",
        ),
      );

      var result = categoriesResponseFromJson(response.body);
      if (result.success ?? false) {
        categoriesResponse = result;
        update();
      } else {
        Get.showSnackbar(GetSnackBar(
          message: result.message,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getOrders() async {
    try {
      var response = await http.post(
          Uri(
            scheme: "http",
            host: ipAddress,
            path: "/garga-api/getOrders.php",
          ),
          body: {
            "userId": prefs.get("userId"),
            "role": prefs.get("role"),
          });

      var result = orderResponseFromJson(response.body);
      if (result.success ?? false) {
        orderResponse = result;
        update();
        getProduct();
      } else {
        Get.showSnackbar(GetSnackBar(
          message: result.message,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllUsers() async {
    try {
      var response = await http.get(
        Uri(
          scheme: "http",
          host: ipAddress,
          path: "/garga-api/getUsers.php",
        ),
      );

      var result = allUsersResponseFromJson(response.body);
      if (result.success ?? false) {
        allUsersResponse = result;
        update();
      } else {
        Get.showSnackbar(GetSnackBar(
          message: result.message,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
    }
  }
}
