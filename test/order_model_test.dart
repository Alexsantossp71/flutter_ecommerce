import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/models/order.dart';
import 'package:flutter_ecommerce/models/cart_item.dart';
import 'package:flutter_ecommerce/models/product.dart';

void main() {
  group('Order', () {
    late Product product;
    late CartItem cartItem;
    late Order order;

    setUp(() {
      product = const Product(
        id: 'camiseta-mar',
        name: 'Camiseta Básica Mar',
        description: 'Camiseta em algodão.',
        price: 59.90,
        category: 'Moda',
        imageAsset: 'images/products/camiseta-mar.jpg',
      );
      cartItem = CartItem(product: product, quantity: 2);
      order = Order(
        id: 'order-001',
        items: [cartItem],
        total: 119.80,
        customerName: 'João Silva',
        address: 'Rua da Praia, 123 - Santos/SP',
        paymentMethod: 'PIX',
        createdAt: DateTime(2026, 1, 15, 14, 30),
      );
    });

    test('cria Order com dados corretos', () {
      expect(order.id, 'order-001');
      expect(order.items.length, 1);
      expect(order.total, 119.80);
      expect(order.customerName, 'João Silva');
      expect(order.address, contains('Santos'));
      expect(order.paymentMethod, 'PIX');
      expect(order.createdAt.year, 2026);
    });

    test('CartItem calcula total corretamente', () {
      expect(cartItem.total, 59.90 * 2);
      expect(cartItem.quantity, 2);
    });

    test('CartItem quantidade default é 1', () {
      final item = CartItem(product: product);
      expect(item.quantity, 1);
      expect(item.total, 59.90);
    });

    test('CartItem total atualiza ao mudar quantidade', () {
      cartItem.quantity = 5;
      expect(cartItem.total, 59.90 * 5);
    });

    test('Order com multiplos itens', () {
      final product2 = const Product(
        id: 'bermuda-praia',
        name: 'Bermuda Praia',
        description: 'Bermuda leve.',
        price: 89.90,
        category: 'Praia',
        imageAsset: 'images/products/bermuda-praia.jpg',
      );
      final item2 = CartItem(product: product2, quantity: 1);
      final multiOrder = Order(
        id: 'order-002',
        items: [cartItem, item2],
        total: 119.80 + 89.90,
        customerName: 'Maria Santos',
        address: 'Av. Beira Mar, 456',
        paymentMethod: 'PIX',
        createdAt: DateTime.now(),
      );
      expect(multiOrder.items.length, 2);
      expect(multiOrder.total, 209.70);
    });
  });
}
