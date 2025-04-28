import 'package:garga/components/product_card.dart';
import 'package:garga/constant.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/main.dart';
import 'package:garga/models/category.dart';
import 'package:flutter/material.dart';
import 'package:garga/pages/admin/category_list.dart';
import 'package:garga/pages/common/login.dart';
import 'package:garga/pages/user/search_page.dart';
import 'package:get/get.dart';
import 'package:garga/utils/theme.dart';

class FirstPage extends StatefulWidget {
  final Function(int index) onGoToCart;
  const FirstPage({super.key, required this.onGoToCart});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var sortingOptions = [
    "Best Match",
    "Price: Low to High",
    "Price: High to Low",
  ];

  var selectedSorting = "Best Match";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetDataController>(builder: (controller) {
      var user = controller.userResponse?.user;
      var cart = controller.cart;
      var products = controller.productResponse?.products;

      //filter products based on selected sorting
      if (selectedSorting == "Price: Low to High") {
        products?.sort((a, b) => a.price!.compareTo(b.price!));
      } else if (selectedSorting == "Price: High to Low") {
        products?.sort((a, b) => b.price!.compareTo(a.price!));
      }
      //default sorting
      else {
        products?.sort((a, b) => b.productId!.compareTo(a.productId!));
      }

      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      return Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            centerTitle: false,
            title: !isLoggedIn
                ? GestureDetector(
                    onTap: () {
                      Get.offAll(
                        () => const LoginPage(),
                      );
                    },
                    child: const Text("Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        )),
                  )
                : Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.onGoToCart(4);
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          backgroundImage: user?.profileImage == null
                              ? null
                              : NetworkImage(
                                  getImageUrl(user!.profileImage),
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Hi, ${controller.userResponse?.user?.fullName ?? 'User'}",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
            actions: [
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  widget.onGoToCart(1);
                },
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade700,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (cart.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: -10,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Text(
                            cart.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '"Discover Deals, Embrace Savings."',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onTapOutside: (focusNode) {
                        FocusScope.of(context).unfocus();
                      },
                      onTap: () async {
                        await showSearch(
                          context: context,
                          delegate: SearchPage(),
                        );
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: "Search products",
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.blue.shade800,
                          size: 30,
                        ),
                        helperStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: textColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      onChanged: (value) async {
                        await showSearch(
                            context: context,
                            delegate: SearchPage(),
                            query: value);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "CATEGORY",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (controller
                                    .categoriesResponse?.categories?.length ??
                                0) +
                            1,
                        itemBuilder: (context, index) {
                          var category = index == 0
                              ? Category(categoryTitle: "All", categoryId: "0")
                              : controller
                                  .categoriesResponse?.categories?[index - 1];
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => CategoryList(
                                    category: category ?? Category()),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: index == 0
                                    ? primaryColor.shade700
                                    : Colors.white,
                                border: Border.all(
                                  color: primaryColor.shade700,
                                ),
                              ),
                              child: Text(
                                category?.categoryTitle ?? '',
                                style: TextStyle(
                                    color: index == 0
                                        ? Colors.white
                                        : const Color.fromARGB(255, 4, 0, 5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          controller.promoCodesResponse?.promoCodes?.length ??
                              0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var promoCode =
                            controller.promoCodesResponse?.promoCodes?[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            "Use code: ${promoCode?.promoCode} to get ${promoCode?.percentage}% off on your order!",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "FOR YOU",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              "Sort by: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            DropdownButton(
                              elevation: 0,
                              dropdownColor: Colors.white,
                              padding: const EdgeInsets.all(0),
                              value: selectedSorting,
                              items: [
                                ...sortingOptions.map(
                                  (String item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedSorting = value.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    //grid view
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.53,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: products?.length ??
                          0, // Use the length of the products list
                      itemBuilder: (context, index) {
                        var product = products?[index];
                        return ProductCard(product: product!);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
