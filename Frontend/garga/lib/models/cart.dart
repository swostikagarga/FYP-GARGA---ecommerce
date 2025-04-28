import 'package:garga/controllers/addProductController.dart';
import 'package:garga/models/products.dart';

class CartItem {
  final Product product;
  int quantity;
  SizeType size;
  ColorType color;

  CartItem(
      {required this.product,
      required this.quantity,
      required this.size,
      required this.color});
}
