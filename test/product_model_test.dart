import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/models/product.dart';

void main() {
  group('Product', () {
    const product = Product(
      id: 'camiseta-mar',
      name: 'Camiseta Básica Mar',
      description: 'Camiseta em algodão premium.',
      price: 59.90,
      category: 'Moda',
      imageAsset: 'images/products/camiseta-mar.jpg',
      isFeatured: true,
    );

    test('cria Product com dados corretos', () {
      expect(product.id, 'camiseta-mar');
      expect(product.name, 'Camiseta Básica Mar');
      expect(product.description, isNotEmpty);
      expect(product.price, 59.90);
      expect(product.category, 'Moda');
      expect(product.imageAsset, contains('camiseta-mar.jpg'));
      expect(product.isFeatured, isTrue);
    });

    test('isFeatured default é false', () {
      const p = Product(
        id: 'x',
        name: 'Test',
        description: 'd',
        price: 10,
        category: 'c',
        imageAsset: 'i',
      );
      expect(p.isFeatured, isFalse);
    });

    test('serializa para JSON', () {
      final json = product.toJson();
      expect(json['id'], 'camiseta-mar');
      expect(json['name'], 'Camiseta Básica Mar');
      expect(json['price'], 59.90);
      expect(json['category'], 'Moda');
      expect(json['isFeatured'], isTrue);
    });

    test('desserializa de JSON', () {
      final json = product.toJson();
      final restored = Product.fromJson(json);
      expect(restored.id, product.id);
      expect(restored.name, product.name);
      expect(restored.price, product.price);
      expect(restored.category, product.category);
      expect(restored.isFeatured, product.isFeatured);
    });

    test('round-trip preserva dados', () {
      final json = product.toJson();
      final restored = Product.fromJson(json);
      expect(restored.toJson(), json);
    });

    test('fromJson lida com isFeatured ausente (default false)', () {
      final json = {
        'id': 'x',
        'name': 'Test',
        'description': 'd',
        'price': 10.0,
        'category': 'c',
        'imageAsset': 'i',
      };
      final p = Product.fromJson(json);
      expect(p.isFeatured, isFalse);
    });

    test('fromJson lida com price int', () {
      final json = {
        'id': 'x',
        'name': 'T',
        'description': 'd',
        'price': 10,
        'category': 'c',
        'imageAsset': 'i',
      };
      final p = Product.fromJson(json);
      expect(p.price, 10.0);
      expect(p.price, isA<double>());
    });
  });
}
