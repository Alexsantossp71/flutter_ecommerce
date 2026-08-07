import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/currency.dart';
import 'checkout_page.dart';

/// Carrinho de compras: lista de itens com controles de quantidade.
/// No desktop (>=900px) o resumo fica numa coluna fixa ao lado.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void _goToCheckout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CheckoutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final theme = Theme.of(context);

    final itemsList = cart.isEmpty
        ? _EmptyCart(theme: theme)
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cart.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          item.product.imageAsset,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              formatCurrency(item.product.price),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.sea,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      cart.decrement(item.product.id),
                                  icon: const Icon(Icons.remove_circle_outline),
                                  visualDensity: VisualDensity.compact,
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: theme.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      cart.increment(item.product.id),
                                  icon: const Icon(Icons.add_circle_outline),
                                  visualDensity: VisualDensity.compact,
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () =>
                                      cart.removeProduct(item.product.id),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                  tooltip: 'Remover',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.sea,
        foregroundColor: Colors.white,
        title: const Text('Carrinho'),
      ),
      body: cart.isEmpty
          ? itemsList
          : LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 900;
                final summary = _CartSummary(
                  totalItems: cart.totalItems,
                  total: cart.total,
                  onCheckout: () => _goToCheckout(context),
                );
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: itemsList),
                      SizedBox(width: 360, child: summary),
                    ],
                  );
                }
                return Column(
                  children: [
                    Expanded(child: itemsList),
                    summary,
                  ],
                );
              },
            ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.remove_shopping_cart_outlined,
            size: 56,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text('Seu carrinho está vazio',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Explore a loja e adicione produtos',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({
    required this.totalItems,
    required this.total,
    required this.onCheckout,
  });

  final int totalItems;
  final double total;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.ink.withValues(alpha: 0.06)),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Resumo do pedido',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Itens', style: theme.textTheme.bodyMedium),
                Text('$totalItems', style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Frete', style: theme.textTheme.bodyMedium),
                Text(
                  'Grátis',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: AppTheme.sea, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                Text(
                  formatCurrency(total),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.sea,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onCheckout,
              child: const Text('Finalizar compra'),
            ),
          ],
        ),
      ),
    );
  }
}
