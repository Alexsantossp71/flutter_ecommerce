import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../widgets/currency.dart';
import 'order_success_page.dart';

/// Checkout simulado: dados do cliente + forma de pagamento.
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

    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar compra')),
      body: cart.isEmpty
          ? const Center(child: Text('Seu carrinho está vazio'))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Dados do cliente',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
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
                  Text('Forma de pagamento',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Cartão de crédito'),
                          subtitle: const Text('Simulação — nenhuma cobrança'),
                          value: 'Cartão',
                          groupValue: _paymentMethod,
                          onChanged: (value) =>
                              setState(() => _paymentMethod = value!),
                        ),
                        RadioListTile<String>(
                          title: const Text('Pix'),
                          subtitle: const Text('Simulação — nenhuma cobrança'),
                          value: 'Pix',
                          groupValue: _paymentMethod,
                          onChanged: (value) =>
                              setState(() => _paymentMethod = value!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                              style: theme.textTheme.titleMedium),
                          Text(
                            formatCurrency(cart.total),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _confirm(context),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Confirmar pedido'),
                  ),
                ],
              ),
            ),
    );
  }
}
