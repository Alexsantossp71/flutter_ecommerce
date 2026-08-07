import 'package:flutter/foundation.dart';

import '../data/product_repository.dart';
import '../models/product.dart';

/// Catálogo de produtos: carrega do [ProductRepository] e mantém
/// filtros de categoria e busca.
class CatalogProvider extends ChangeNotifier {
  CatalogProvider(this._repository);

  final ProductRepository _repository;

  List<Product> _allProducts = [];
  List<Product> get products => List.unmodifiable(_allProducts);

  String _selectedCategory = 'Todas';
  String get selectedCategory => _selectedCategory;

  String _query = '';
  String get query => _query;

  bool _loading = true;
  bool get loading => _loading;

  /// Produtos filtrados por categoria e busca.
  List<Product> get filtered {
    final term = _query.trim().toLowerCase();
    return _allProducts.where((product) {
      final matchesCategory =
          _selectedCategory == 'Todas' ||
          product.category == _selectedCategory;
      final matchesQuery =
          term.isEmpty ||
          product.name.toLowerCase().contains(term) ||
          product.description.toLowerCase().contains(term);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  /// Categorias disponíveis (começando com "Todas").
  List<String> get categories =>
      ['Todas', ...{for (final product in _allProducts) product.category}];

  Future<void> load() async {
    _allProducts = await _repository.getProducts();
    _loading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setQuery(String query) {
    _query = query;
    notifyListeners();
  }
}
