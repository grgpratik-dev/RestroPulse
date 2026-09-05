final class Country {
  const Country({
    required this.code,
    required this.name,
    required this.flag,
    required this.currencyCodes,
    this.defaultCurrencyCode,
  });

  final String code;
  final String name;
  final String flag;
  final String? defaultCurrencyCode;
  final List<String> currencyCodes;
}
