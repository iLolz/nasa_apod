import 'package:intl/intl.dart';

class Formatters {
  static String toYMD(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';

  static String toDateString(DateTime date) {
    final formater = DateFormat('dd/MM/yyyy');

    return formater.format(date);
  }
}
