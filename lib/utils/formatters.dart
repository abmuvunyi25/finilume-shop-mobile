import 'package:intl/intl.dart';

final rwF = NumberFormat.currency(
  locale: 'fr_RW',
  symbol: 'RWF',
  decimalDigits: 0,
);

String formatRWF(double amount) => rwF.format(amount);