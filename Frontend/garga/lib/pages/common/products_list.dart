import 'package:flutter/material.dart';
import 'package:garga/constant.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/models/products.dart';
import 'package:garga/pages/user/product_detail.dart';
import 'package:get/get.dart';
import 'package:garga/pages/merchant/addProduct.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: GetBuilder<GetDataController>(builder: (controller) {
        var products = controller.productResponse?.products ?? [];

        if (products.isEmpty) {
          return const Center(
            child: Text("No Products Found"),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 12,
          ),
          itemCount: products.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var product = products[index];

            return ProductCard(product: product);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddProductPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    bool isDisabled = product.isDisabled == "1" ? true : false;
    return GetBuilder<GetDataController>(
      builder: (controller) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 120,
            maxHeight: 150,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  getImageUrl(product.images?.first ?? ""),
                  width: 120,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * 0.5,
                      child: Text(
                        product.productTitle ?? "",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Price: Rs.${product.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.remove_red_eye,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            Get.to(
                              () => ProductDetail(
                                product: product,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Get.to(() => AddProductPage(product: product));
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            !isDisabled ? Icons.check_circle : Icons.cancel,
                            color: !isDisabled ? Colors.green : Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(isDisabled
                                      ? "Enable Product"
                                      : "Disable Product"),
                                  content: Text(isDisabled
                                      ? "Are you sure you want to enable this product?"
                                      : "Are you sure you want to disable this product?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await controller.disableProduct(
                                          product.productId ?? "",
                                        );
                                        await controller.getProduct();
                                      },
                                      child: Text(
                                        isDisabled ? "Enable" : "Disable",
                                        style: TextStyle(
                                          color: isDisabled
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
