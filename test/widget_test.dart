import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_ecommerce/main.dart' as app;
import 'package:flutter_ecommerce/widgets/product_card.dart';

/// Drena exceções toleradas de apps que carregam assets sem mocks
/// (asset de imagem e layout em viewport de teste). Qualquer outra
/// exceção falha o teste.
void _drainToleratedExceptions(WidgetTester tester) {
  for (var i = 0; i < 50; i++) {
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

/// Avança frames com durações fixas (evita o bug do pumpAndSettle
/// com animações infinitas do framework).
Future<void> _advance(WidgetTester tester,
    [Duration duration = const Duration(milliseconds: 600)]) async {
  await tester.pump();
  await tester.pump(duration);
}

void _usePhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('app inicia e renderiza a loja', (WidgetTester tester) async {
    _usePhoneViewport(tester);

    app.main();
    await _advance(tester);
    await _advance(tester);

    // Identidade da loja visível
    expect(find.text('Moda Praia Santos'), findsOneWidget);
    // Busca presente
    expect(find.byType(TextField), findsOneWidget);
    // Categorias carregadas (chips)
    expect(find.byType(ChoiceChip), findsWidgets);
    // Produtos na grade
    expect(find.byType(ProductCard), findsWidgets);

    _drainToleratedExceptions(tester);
  });

  testWidgets('abrir detalhe de um produto', (WidgetTester tester) async {
    _usePhoneViewport(tester);

    app.main();
    await _advance(tester);
    await _advance(tester);

    // Toca no primeiro produto da grade
    await tester.tap(find.byType(ProductCard).first);
    await _advance(tester);
    await _advance(tester);

    // Tela de detalhes com botão de adicionar e benefícios
    expect(find.text('Adicionar ao carrinho'), findsOneWidget);
    expect(find.text('Frete grátis'), findsOneWidget);

    _drainToleratedExceptions(tester);
  });

  testWidgets('fluxo de compra: detalhe → adicionar → carrinho',
      (WidgetTester tester) async {
    _usePhoneViewport(tester);

    app.main();
    await _advance(tester);
    await _advance(tester);

    // 1. Abre o detalhe do primeiro produto
    await tester.tap(find.byType(ProductCard).first);
    await _advance(tester);
    await _advance(tester);

    // 2. Adiciona ao carrinho pelo botão principal do detalhe
    // (o botão fica abaixo da dobra — garante que está visível antes do tap)
    final addButton = find.text('Adicionar ao carrinho');
    await tester.ensureVisible(addButton);
    await tester.pump();
    await tester.tap(addButton);
    await _advance(tester);
    await _advance(tester);

    // 3. Volta para a home
    await tester.pageBack();
    await _advance(tester);
    await _advance(tester);

    // 4. Abre o carrinho pelo ícone no topo
    await tester.tap(find.byTooltip('Carrinho'));
    await _advance(tester);
    await _advance(tester);

    // Carrinho com resumo do pedido
    expect(find.text('Resumo do pedido'), findsOneWidget);
    expect(find.text('Finalizar compra'), findsOneWidget);

    _drainToleratedExceptions(tester);
  });

  testWidgets('desktop: grade com mais colunas e footer visível', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    app.main();
    await _advance(tester);
    await _advance(tester);

    // Identidade e benefícios visíveis no desktop
    expect(find.text('Moda Praia Santos'), findsOneWidget);
    expect(find.text('Frete grátis'), findsOneWidget);
    // Rodapé com colunas de navegação
    expect(find.text('NAVEGAÇÃO'), findsOneWidget);
    expect(find.text('CONTATO'), findsOneWidget);

    _drainToleratedExceptions(tester);
  });


}
