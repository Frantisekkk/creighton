import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('E dd.MM').format(date);
}

String formatDay(DateTime date) {
  return DateFormat('E').format(date);
}

String formatDateWithoutDay(DateTime date) {
  return DateFormat('dd').format(date);
}
