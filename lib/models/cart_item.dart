import 'product.dart';

/// Item do carrinho: um produto + quantidade.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}
