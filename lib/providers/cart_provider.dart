import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

/// Estado global do carrinho de compras, com persistência local.
///
/// Salva o carrinho no [SharedPreferences] a cada alteração, então o
/// conteúdo sobrevive ao fechar o navegador ou o app.
class CartProvider extends ChangeNotifier {
  static const _storageKey = 'moda_praia_cart_v1';

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get total => _items.fold(0.0, (sum, item) => sum + item.total);

  bool get isEmpty => _items.isEmpty;

  /// Restaura o carrinho salvo (chamar uma vez ao iniciar o app).
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _items.clear();
      for (final entry in decoded) {
        final map = entry as Map<String, dynamic>;
        _items.add(CartItem(
          product: Product.fromJson(map['product'] as Map<String, dynamic>),
          quantity: (map['quantity'] as num).toInt(),
        ));
      }
      notifyListeners();
    } catch (_) {
      // dados corrompidos: começa com carrinho vazio
      _items.clear();
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode([
      for (final item in _items)
        {'product': item.product.toJson(), 'quantity': item.quantity},
    ]);
    await prefs.setString(_storageKey, data);
  }

  Future<void> addProduct(Product product, {int quantity = 1}) async {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
    await _persist();
  }

  Future<void> increment(String productId) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity += 1;
      notifyListeners();
      await _persist();
    }
  }

  Future<void> decrement(String productId) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;
    if (_items[index].quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index].quantity -= 1;
    }
    notifyListeners();
    await _persist();
  }

  Future<void> removeProduct(String productId) async {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
    await _persist();
  }

  Future<void> clear() async {
    _items.clear();
    notifyListeners();
    await _persist();
  }
}
