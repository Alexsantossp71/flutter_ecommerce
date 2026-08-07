import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/currency.dart';
import 'order_success_page.dart';

/// Checkout simulado: dados do cliente + forma de pagamento.
/// No desktop (>=900px): formulário à esquerda e resumo do pedido à direita.
///
/// No modo demo o pedido não é enviado a nenhum servidor — a tela de
/// sucesso simula a confirmação. A estrutura está pronta para integrar
/// um backend (Firebase/API) na Fase 2.
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  String _paymentMethod = 'Cartão';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _confirm(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final cart = context.read<CartProvider>();
    final items = cart.items
        .map((item) => CartItem(product: item.product, quantity: item.quantity))
        .toList();

    final order = Order(
      id: 'MP-${DateTime.now().millisecondsSinceEpoch % 100000}',
      items: items,
      total: cart.total,
      customerName: _nameController.text.trim(),
      address:
          '${_addressController.text.trim()}, ${_cityController.text.trim()}',
      paymentMethod: _paymentMethod,
      createdAt: DateTime.now(),
    );

    cart.clear();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => OrderSuccessPage(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final theme = Theme.of(context);

    final form = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Dados do cliente',
            style:
                theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nome completo',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Informe seu nome'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Telefone / WhatsApp',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Informe seu telefone'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Endereço (rua e número)',
              prefixIcon: Icon(Icons.home_outlined),
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Informe seu endereço'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: 'Cidade / UF',
              prefixIcon: Icon(Icons.location_city_outlined),
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Informe sua cidade'
                : null,
          ),
          const SizedBox(height: 24),
          Text(
            'Forma de pagamento',
            style:
                theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Cartão de crédito'),
                  subtitle: const Text('Simulação — nenhuma cobrança'),
                  value: 'Cartão',
                  groupValue: _paymentMethod,
                  onChanged: (value) => setState(() => _paymentMethod = value!),
                ),
                RadioListTile<String>(
                  title: const Text('Pix'),
                  subtitle: const Text('Simulação — nenhuma cobrança'),
                  value: 'Pix',
                  groupValue: _paymentMethod,
                  onChanged: (value) => setState(() => _paymentMethod = value!),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final summary = _OrderSummary(
      totalItems: cart.totalItems,
      total: cart.total,
      onConfirm: () => _confirm(context),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.sea,
        foregroundColor: Colors.white,
        title: const Text('Finalizar compra'),
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Seu carrinho está vazio'))
          : LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 640),
                              child: form,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 380, child: summary),
                    ],
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [form, const SizedBox(height: 16), summary],
                );
              },
            ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.totalItems,
    required this.total,
    required this.onConfirm,
  });

  final int totalItems;
  final double total;
  final VoidCallback onConfirm;

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
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.sea,
                    fontWeight: FontWeight.w700,
                  ),
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
              onPressed: onConfirm,
              child: const Text('Confirmar pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
