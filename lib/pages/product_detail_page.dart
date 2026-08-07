import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/catalog_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/currency.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';

/// Detalhe do produto: imagem em destaque, preço, quantidade,
/// benefícios e sugestões da mesma categoria.
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final cart = context.read<CartProvider>();

    Product? found;
    for (final p in catalog.products) {
      if (p.id == widget.productId) {
        found = p;
        break;
      }
    }
    final product = found;
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Produto')),
        body: const Center(child: Text('Produto não encontrado')),
      );
    }

    final theme = Theme.of(context);
    final related = catalog.products
        .where((p) => p.id != product.id && p.category == product.category)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 320,
            backgroundColor: AppTheme.sea,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Hero(
                tag: 'product-${product.id}',
                child: Image.asset(product.imageAsset, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.name,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        formatCurrency(product.price),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppTheme.sea,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        product.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: AppTheme.ink.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // benefícios
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: const [
                          _BenefitChip(
                              icon: Icons.local_shipping_outlined,
                              label: 'Frete grátis'),
                          _BenefitChip(
                              icon: Icons.swap_horiz, label: 'Troca fácil'),
                          _BenefitChip(
                              icon: Icons.verified_user_outlined,
                              label: 'Compra segura'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // quantidade + total
                      Row(
                        children: [
                          _QuantitySelector(
                            value: _quantity,
                            onChanged: (value) =>
                                setState(() => _quantity = value),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Total: ${formatCurrency(product.price * _quantity)}',
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.sea,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            cart.addProduct(product, quantity: _quantity);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '$_quantity × ${product.name} no carrinho',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Adicionar ao carrinho'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            side: const BorderSide(color: AppTheme.sea),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CartPage(),
                            ),
                          ),
                          child: const Text(
                            'Ver carrinho',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // relacionados
          if (related.isNotEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Você também pode gostar',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 280,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: related.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 14),
                            itemBuilder: (context, index) {
                              final p = related[index];
                              return SizedBox(
                                width: 190,
                                child: ProductCard(
                                  product: p,
                                  onTap: () => Navigator.of(context)
                                      .pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailPage(
                                          productId: p.id),
                                    ),
                                  ),
                                  onAddToCart: () {
                                    cart.addProduct(p);
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${p.name} adicionado ao carrinho'),
                                          duration: const Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (MediaQuery.sizeOf(context).width >= 900)
            SliverToBoxAdapter(
              child: Container(
                color: AppTheme.deep,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: const Center(
                  child: Text(
                    'MODA PRAIA SANTOS • © 2026',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  const _BenefitChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.ink.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.sea),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.ink.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove, size: 18),
          ),
          Text(
            '$value',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon: const Icon(Icons.add, size: 18),
          ),
        ],
      ),
    );
  }
}
