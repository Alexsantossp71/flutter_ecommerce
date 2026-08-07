import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/main.dart' as app;

void main() {
  testWidgets('app inicia sem erros', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
