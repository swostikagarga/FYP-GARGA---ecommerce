import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:garga/constant.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/models/products.dart';
import 'package:garga/utils/theme.dart';
import 'package:get/get.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetDataController>(builder: (controller) {
      var isFavourite = controller.isFavorite(product.productId!);
      return Scaffold(
        appBar: AppBar(
          title: Text(product.productTitle ?? ""),
        ),
        bottomNavigationBar: SafeArea(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    controller.favouriteProducts.contains(product.productId)
                        ? controller.removeFavouriteProduct(product.productId!)
                        : controller.addFavouriteProduct(product.productId!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_outline,
                    color: primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.addToCart(product,
                          availableColors: product.colors,
                          availableSizes: product.sizes);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Add to Cart"),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              CarouselSlider.builder(
                itemCount: product.images?.length ?? 0,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      getImageUrl(product.images![index]),
                      fit: BoxFit.cover,
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 200,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productTitle ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            product.categoryTitle ?? "",
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          image: product.profileImage == null
                              ? null
                              : DecorationImage(
                                  image: NetworkImage(
                                      getImageUrl(product.profileImage)),
                                  fit: BoxFit.cover,
                                ),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // Display the category name

                      SizedBox(
                        width: 300,
                        child: Text(
                          "Sold by: ${product.merchantName ?? ""}",
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Price: Rs.${product.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      product.description ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
