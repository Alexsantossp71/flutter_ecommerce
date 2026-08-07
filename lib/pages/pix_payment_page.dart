import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../utils/fake_pix.dart';
import '../widgets/currency.dart';
import 'order_success_page.dart';

/// Pagamento via PIX **simulado**.
///
/// Mostra um QR Code fictício (chave demo que não existe em banco algum),
/// código copia-e-cola e um temporizador de confirmação. Após o tempo
/// (ou ao tocar "simular pagamento"), o pedido é confirmado e o carrinho
/// é limpo. Nenhuma cobrança real acontece.
class PixPaymentPage extends StatefulWidget {
  const PixPaymentPage({
    super.key,
    required this.customerName,
    required this.address,
    required this.items,
    required this.total,
  });

  final String customerName;
  final String address;
  final List<CartItem> items;
  final double total;

  @override
  State<PixPaymentPage> createState() => _PixPaymentPageState();
}

class _PixPaymentPageState extends State<PixPaymentPage> {
  static const _confirmSeconds = 15;

  late final String _orderId =
      'MP-${DateTime.now().millisecondsSinceEpoch % 100000}';
  late final String _payload =
      FakePix.buildPayload(amount: widget.total, txId: 'DEMO-$_orderId');

  Timer? _timer;
  int _secondsLeft = _confirmSeconds;
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        timer.cancel();
        _confirmPayment();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _confirmPayment() async {
    if (_confirmed || !mounted) return;
    setState(() => _confirmed = true);
    _timer?.cancel();

    final cart = context.read<CartProvider>();
    final order = Order(
      id: _orderId,
      items: widget.items,
      total: widget.total,
      customerName: widget.customerName,
      address: widget.address,
      paymentMethod: 'Pix',
      createdAt: DateTime.now(),
    );

    await cart.clear();

    if (!mounted) return;
    // pequena pausa para o usuário ver o "confirmado" antes de navegar
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => OrderSuccessPage(order: order)),
    );
  }

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: _payload));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Código PIX copiado (cópia fictícia de demonstração)'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.deep,
        foregroundColor: Colors.white,
        title: const Text('Pagamento via PIX'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // QR Code fictício
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Valor a pagar',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              formatCurrency(widget.total),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: AppTheme.sea,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppTheme.ink.withValues(alpha: 0.1),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: QrImageView(
                            data: _payload,
                            size: 190,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Escaneie o QR Code com o app do seu banco',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Código copia-e-cola
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pix copia e cola',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _payload,
                            style: const TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: _copyCode,
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text('Copiar código'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(44),
                            side: const BorderSide(color: AppTheme.sea),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Status da confirmação
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _confirmed
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF16A34A),
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Pagamento confirmado!',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: AppTheme.sea,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Aguardando confirmação do pagamento...',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Confirmação automática em $_secondsLeft s',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: _confirmPayment,
                                child: const Text(
                                  'Simular pagamento agora',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.sea,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Aviso de demonstração
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.gold.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFF92600A), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Ambiente de demonstração: este QR Code é fictício '
                          '(chave inexistente) e nenhuma cobrança real é '
                          'realizada. Não informe dados bancários.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6B4A00),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
