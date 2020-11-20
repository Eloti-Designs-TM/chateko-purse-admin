import 'package:intl/intl.dart';

final converter = NumberFormat("#,##0.00", "en_US");

convertNumberToCurrency(int value) {
  return converter.format(value);
}

final dateFormate = DateFormat('yyyy-MM-dd hh:mm');

convertTime(String date) {
  return dateFormate.parse(date);
}
