import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ecommerce/widgets/currency.dart';

void main() {
  group('formatCurrency', () {
    test('formata valor simples', () {
      expect(formatCurrency(10.0), 'R\$ 10,00');
    });

    test('formata valor com centavos', () {
      expect(formatCurrency(59.90), 'R\$ 59,90');
    });

    test('formata valor zero', () {
      expect(formatCurrency(0.0), 'R\$ 0,00');
    });

    test('formata valor com milhar', () {
      expect(formatCurrency(1234.56), 'R\$ 1.234,56');
    });

    test('formata valor grande com milhares', () {
      expect(formatCurrency(10500.99), 'R\$ 10.500,99');
    });

    test('formata centavos zero', () {
      expect(formatCurrency(49.0), 'R\$ 49,00');
    });

    test('formata centavos arredondados', () {
      expect(formatCurrency(10.999), 'R\$ 11,00');
    });

    test('começa com R\\$ sempre', () {
      expect(formatCurrency(1.5), startsWith('R\$ '));
    });

    test('tem virgula antes dos centavos', () {
      final formatted = formatCurrency(99.99);
      expect(formatted, contains(','));
      expect(formatted.endsWith('99'), isTrue);
    });
  });
}
