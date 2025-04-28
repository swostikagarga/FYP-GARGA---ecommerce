import 'package:flutter/material.dart';
import 'package:garga/components/product_card.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/models/category.dart';
import 'package:get/get.dart';

class CategoryList extends StatelessWidget {
  final Category category;
  const CategoryList({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.categoryTitle ?? ''),
      ),
      body: GetBuilder<GetDataController>(builder: (controller) {
        var categoryProducts =
            controller.productResponse?.products?.where((element) {
          if (element.categoryId == category.categoryId) {
            return true;
          } else if (category.categoryId == "0") {
            return true;
          }
          return false;
        }).toList();

        if (categoryProducts == null || categoryProducts.isEmpty) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Text(
                "No products found in this category!",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.53,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categoryProducts.length,
          itemBuilder: (context, index) {
            var product = categoryProducts[index];
            return ProductCard(
              product: product,
            );
          },
        );
      }),
    );
  }
}
