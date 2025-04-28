import 'package:flutter/material.dart';
import 'package:garga/components/product_card.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:get/get.dart';

class SearchPage extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GetBuilder<GetDataController>(builder: (controller) {
      var products = controller.productResponse?.products;

      if (products == null || products.isEmpty) {
        return const Center(
          child: Text("No products found!"),
        );
      }

      var suggestionList = query.isEmpty
          ? products
          : products
              .where((element) =>
                  element.productTitle!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  element.description!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  element.categoryTitle!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  element.price!.toString().contains(query))
              .toList();

      if (suggestionList.isEmpty) {
        return Center(
          child: Text(
            "No search results found! \nTry searching for $query",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
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
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          var product = suggestionList[index];
          return ProductCard(
            product: product,
          );
        },
      );
    });
  }
}
