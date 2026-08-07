import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/providers/cart_provider.dart';

Product _product(String id, double price) => Product(
      id: id,
      name: 'Produto $id',
      description: 'Descrição do produto $id',
      price: price,
      category: 'Moda',
      imageAsset: 'images/products/camiseta-mar.jpg',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('carrinho começa vazio', () async {
    final cart = CartProvider();
    await cart.init();

    expect(cart.isEmpty, isTrue);
    expect(cart.total, 0);
    expect(cart.totalItems, 0);
    expect(cart.items, isEmpty);
  });

  test('adicionar o mesmo produto incrementa a quantidade', () async {
    final cart = CartProvider();
    await cart.init();

    await cart.addProduct(_product('p1', 10));
    await cart.addProduct(_product('p1', 10));

    expect(cart.items.length, 1);
    expect(cart.totalItems, 2);
    expect(cart.total, 20);
  });

  test('produtos diferentes viram itens separados', () async {
    final cart = CartProvider();
    await cart.init();

    await cart.addProduct(_product('p1', 10));
    await cart.addProduct(_product('p2', 5.5));

    expect(cart.items.length, 2);
    expect(cart.totalItems, 2);
    expect(cart.total, 15.5);
  });

  test('increment e decrement controlam a quantidade', () async {
    final cart = CartProvider();
    await cart.init();
    await cart.addProduct(_product('p1', 10));

    await cart.increment('p1');
    expect(cart.totalItems, 2);

    await cart.decrement('p1');
    expect(cart.totalItems, 1);

    // decrementar abaixo de 1 remove o item
    await cart.decrement('p1');
    expect(cart.isEmpty, isTrue);
  });

  test('removeProduct tira o item do carrinho', () async {
    final cart = CartProvider();
    await cart.init();
    await cart.addProduct(_product('p1', 10));
    await cart.addProduct(_product('p2', 20));

    await cart.removeProduct('p1');

    expect(cart.items.length, 1);
    expect(cart.items.first.product.id, 'p2');
  });

  test('carrinho persiste e é restaurado entre instâncias', () async {
    final cart = CartProvider();
    await cart.init();
    await cart.addProduct(_product('p1', 10));
    await cart.addProduct(_product('p2', 5));
    await cart.increment('p1'); // p1 x2

    final restored = CartProvider();
    await restored.init();

    expect(restored.totalItems, 3);
    expect(restored.total, 25);
  });

  test('clear esvazia o carrinho e persiste', () async {
    final cart = CartProvider();
    await cart.init();
    await cart.addProduct(_product('p1', 10));

    await cart.clear();
    expect(cart.isEmpty, isTrue);

    final restored = CartProvider();
    await restored.init();
    expect(restored.isEmpty, isTrue);
  });
}
