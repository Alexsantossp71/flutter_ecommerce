import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/providers/catalog_provider.dart';
import 'package:flutter_ecommerce/data/demo_product_repository.dart';

void main() {
  group('CatalogProvider', () {
    late CatalogProvider catalog;

    setUp(() async {
      catalog = CatalogProvider(DemoProductRepository());
      await catalog.load();
    });

    test('carrega produtos do repositorio demo', () {
      expect(catalog.products, isNotEmpty);
      expect(catalog.loading, isFalse);
    });

    test('categorias incluem Todas', () {
      expect(catalog.categories, contains('Todas'));
      expect(catalog.categories.length, greaterThan(1));
    });

    test('categoria inicial é Todas', () {
      expect(catalog.selectedCategory, 'Todas');
    });

    test('setCategory muda a seleção', () {
      catalog.setCategory('Moda');
      expect(catalog.selectedCategory, 'Moda');
    });

    test('filtered retorna todos quando Todas', () {
      expect(catalog.filtered.length, catalog.products.length);
    });

    test('filtered filtra por categoria', () {
      catalog.setCategory('Moda');
      expect(catalog.filtered, isNotEmpty);
      for (final p in catalog.filtered) {
        expect(p.category, 'Moda');
      }
    });

    test('filtered filtra por busca textual', () {
      catalog.setQuery('Camiseta');
      expect(catalog.filtered, isNotEmpty);
      for (final p in catalog.filtered) {
        expect(
          p.name.toLowerCase().contains('camiseta') ||
          p.description.toLowerCase().contains('camiseta'),
          isTrue,
        );
      }
    });

    test('filtered combina categoria e busca', () {
      catalog.setCategory('Moda');
      catalog.setQuery('Mar');
      expect(catalog.filtered, isNotEmpty);
      for (final p in catalog.filtered) {
        expect(p.category, 'Moda');
        expect(
          p.name.toLowerCase().contains('mar') ||
          p.description.toLowerCase().contains('mar'),
          isTrue,
        );
      }
    });

    test('filtered retorna vazio quando busca não encontra nada', () {
      catalog.setQuery('xyzprodutoquenaoexiste');
      expect(catalog.filtered, isEmpty);
    });

    test('setQuery limpa filtro ao voltar para vazio', () {
      catalog.setQuery('Camiseta');
      expect(catalog.filtered.length, lessThan(catalog.products.length));
      catalog.setQuery('');
      expect(catalog.filtered.length, catalog.products.length);
    });

    test('products é unmodifiable', () {
      expect(() => (catalog.products as List).add(const Product(
        id: 'x', name: 'x', description: 'x', price: 1, category: 'x', imageAsset: 'x',
      )), throwsA(anything));
    });
  });
}
