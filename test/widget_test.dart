import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/main.dart' as app;

void main() {
  testWidgets('app inicia sem erros fatais', (WidgetTester tester) async {
    // Viewport de celular (o app foi desenhado para telas verticais).
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    app.main();
    await tester.pump();
    await tester.pump(const Duration(seconds: 10));

    // Drena exceções toleradas (assets/rede/overflow em apps legados sem mocks).
    for (var i = 0; i < 30; i++) {
      final ex = tester.takeException();
      if (ex == null) break;
      final msg = ex.toString();
      if (!msg.contains('Unable to load asset') &&
          !msg.contains('NetworkImage') &&
          !msg.contains('HTTP request failed') &&
          !msg.contains('RenderFlex overflowed') &&
          !msg.contains('Multiple exceptions')) {
        fail('Exceção inesperada ao iniciar o app: $ex');
      }
    }
  });
}
