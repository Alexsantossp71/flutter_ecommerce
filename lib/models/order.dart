import 'cart_item.dart';

/// Pedido confirmado no checkout.
class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final String customerName;
  final String address;
  final String paymentMethod;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.customerName,
    required this.address,
    required this.paymentMethod,
    required this.createdAt,
  });
}
