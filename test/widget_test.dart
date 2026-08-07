import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_ecommerce/main.dart' as app;
import 'package:flutter_ecommerce/widgets/product_card.dart';

/// Drena exceções toleradas de apps que carregam assets sem mocks
/// (asset de imagem e layout em viewport de teste). Qualquer outra
/// exceção falha o teste.
void _drainToleratedExceptions(WidgetTester tester) {
  for (var i = 0; i < 30; i++) {
    final ex = tester.takeException();
    if (ex == null) break;
    final msg = ex.toString();
    if (!msg.contains('Unable to load asset') &&
        !msg.contains('NetworkImage') &&
        !msg.contains('HTTP request failed') &&
        !msg.contains('RenderFlex overflowed') &&
        !msg.contains('Multiple exceptions')) {
      fail('Exceção inesperada ao iniciar o app: $msg');
    }
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('app inicia e renderiza a loja', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    app.main();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Identidade da loja visível
    expect(find.text('Moda Praia Santos'), findsOneWidget);
    // Busca presente
    expect(find.byType(TextField), findsOneWidget);
    // Categorias carregadas (chips)
    expect(find.byType(ChoiceChip), findsWidgets);

    _drainToleratedExceptions(tester);
  });

  testWidgets('abrir detalhe de um produto', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    app.main();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Toca no primeiro produto da grade
    final firstCard = find.byType(ProductCard).first;
    await tester.tap(firstCard);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Tela de detalhes com botão de adicionar
    expect(find.text('Adicionar ao carrinho'), findsOneWidget);

    _drainToleratedExceptions(tester);
  });
}
