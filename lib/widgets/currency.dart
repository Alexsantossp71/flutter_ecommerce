/// Formata um valor em moeda brasileira (R$ 1.234,56) sem dependências.
String formatCurrency(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final integer = parts[0];
  final cents = parts[1];

  // separador de milhar
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final digit = integer[i];
    final remaining = integer.length - i;
    buffer.write(digit);
    if (remaining > 1 && (remaining - 1) % 3 == 0) {
      buffer.write('.');
    }
  }
  return 'R\$ ${buffer.toString()},$cents';
}
