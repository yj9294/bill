import 'package:intl/intl.dart';

abstract final class MoneyFormat {
  static final NumberFormat _compact = NumberFormat.currency(
    symbol: r'$ ',
    decimalDigits: 2,
  );

  static String amount(num value) => _compact.format(value);
}
