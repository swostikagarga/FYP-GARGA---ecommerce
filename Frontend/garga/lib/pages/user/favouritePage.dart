import 'package:flutter/material.dart';
import 'package:garga/components/cart_card.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:get/get.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Saved"),
        ),
        body: GetBuilder<GetDataController>(builder: (controller) {
          var favouriteProducts = controller.productResponse?.products
              ?.where((element) =>
                  controller.favouriteProducts.contains(element.productId))
              .toList();

          if (favouriteProducts == null || favouriteProducts.isEmpty) {
            return const Center(
              child: Text(
                "No Favourite Products!",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          return ListView.builder(
            itemCount: favouriteProducts.length,
            itemBuilder: (context, index) {
              var product = favouriteProducts[index];
              return CartCard(
                product: product,
                isFavourite: true,
              );
            },
          );
        }));
  }
}
