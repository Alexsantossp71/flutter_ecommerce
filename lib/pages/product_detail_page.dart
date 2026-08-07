import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/catalog_provider.dart';
import '../widgets/currency.dart';
import 'cart_page.dart';

/// Detalhe de um produto com botão de adicionar ao carrinho.
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final cart = context.read<CartProvider>();

    Product? product;
    for (final p in catalog.products) {
      if (p.id == productId) {
        product = p;
        break;
      }
    }
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Produto')),
        body: const Center(child: Text('Produto não encontrado')),
      );
    }

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Image.asset(product.imageAsset, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.toUpperCase(),
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  formatCurrency(product.price),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.description,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    cart.addProduct(product);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('${product.name} adicionado ao carrinho'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Adicionar ao carrinho'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  ),
                  child: const Text('Ver carrinho'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
