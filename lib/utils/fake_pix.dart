import 'dart:convert';

/// Gera um payload PIX **fictício** no formato EMV/BR Code.
///
/// ⚠️ IMPORTANTE (segurança):
/// - A "chave" usada é `demo@modapraiasantos.com.br`, que NÃO existe
///   como chave PIX em nenhum banco → nenhum pagamento real é possível.
/// - O payload é visualmente idêntico a um PIX real (QR escaneável,
///   CRC16 calculado), mas qualquer tentativa de cobrança falha na
///   instituição. É 100% simulação.
class FakePix {
  /// Monta o payload EMV com o valor do pedido e um txid único.
  static String buildPayload({required double amount, required String txId}) {
    const key = 'demo@modapraiasantos.com.br';
    const merchantName = 'MODA PRAIA SANTOS';
    const merchantCity = 'SANTOS';

    final amountStr = amount.toStringAsFixed(2);

    final merchanAccount =
        _tlv('00', 'BR.GOV.BCB.PIX') + _tlv('01', key);
    final additionalData = _tlv('05', txId);

    var payload =
        _tlv('00', '01') + // Payload Format Indicator
        _tlv('26', merchanAccount) + // Merchant Account Information
        _tlv('52', '0000') + // Merchant Category Code
        _tlv('53', '986') + // Moeda: BRL
        _tlv('54', amountStr) + // Valor
        _tlv('58', 'BR') + // País
        _tlv('59', merchantName) + // Nome do recebedor
        _tlv('60', merchantCity) + // Cidade
        _tlv('62', additionalData); // Dados adicionais (txid)

    payload += '6304'; // campo CRC16
    return payload + _crc16(payload);
  }

  /// TLV: tag (2 dígitos) + tamanho (2 dígitos) + valor.
  static String _tlv(String tag, String value) {
    final len = value.length.toString().padLeft(2, '0');
    return '$tag$len$value';
  }

  /// CRC16-CCITT (polinômio 0x1021, init 0xFFFF) — padrão EMV.
  static String _crc16(String payload) {
    const poly = 0x1021;
    var crc = 0xFFFF;
    for (final byte in utf8.encode(payload)) {
      crc ^= byte << 8;
      for (var i = 0; i < 8; i++) {
        crc = (crc & 0x8000) != 0
            ? ((crc << 1) ^ poly) & 0xFFFF
            : (crc << 1) & 0xFFFF;
      }
    }
    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }
}
