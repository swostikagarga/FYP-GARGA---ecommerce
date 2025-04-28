import 'package:garga/components/product_card.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:garga/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCategoryPage extends StatelessWidget {
  const AllCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var category = Get.arguments as Category;

    var dataController = Get.find<GetDataController>();

    var filteredProduct = dataController.productResponse?.products
            ?.where((element) => element.categoryId == category.categoryId)
            .toList() ??
        [];

    return Scaffold(
        appBar: AppBar(
          title: Text(category.categoryTitle ?? ""),
        ),
        body: ListView.builder(
          itemCount: filteredProduct.length,
          itemBuilder: (context, index) {
            return ProductCard(product: filteredProduct[index]);
          },
        ));
  }
}
