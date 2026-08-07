import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/main.dart' as app;

void main() {
  testWidgets('app inicia sem erros fatais', (WidgetTester tester) async {
    app.main();
    await tester.pump();
    // Avança o tempo para expirar timers de splash/navegação (ex.: 5s).
    await tester.pump(const Duration(seconds: 10));
    // Drena exceções toleradas (assets/rede/overflow de apps legados sem mocks);
    // qualquer outra exceção falha o teste.
    for (var i = 0; i < 30; i++) {
      final ex = tester.takeException();
      if (ex == null) break;
      final msg = ex.toString();
      if (!msg.contains('Unable to load asset') &&
          !msg.contains('NetworkImage') &&
          !msg.contains('HTTP request failed') &&
          !msg.contains('RenderFlex overflowed')) {
        fail('Exceção inesperada ao iniciar o app: $ex');
      }
    }
  });
}
