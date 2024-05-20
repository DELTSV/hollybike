import 'package:hollybike/shared/utils/strings.dart';
import 'package:intl/intl.dart';

String formatReadableDate(DateTime date) {
  final now = DateTime.now();

  if (date.year == now.year) {
    if (date.month == now.month && date.day == now.day) {
      return "Aujourd'hui à ${DateFormat.Hm().format(date)}";
    } else if (date.month == now.month && date.day == now.day + 1) {
      return "Demain à ${DateFormat.Hm().format(date)}";
    } else if (date.month == now.month && date.day == now.day - 1) {
      return "Hier à ${DateFormat.Hm().format(date)}";
    } else {
      return "le ${DateFormat.MMMMd().format(date)} à ${DateFormat.Hm().format(date)}";
    }
  } else {
    return "le ${DateFormat.yMMMMd().format(date)} à ${DateFormat.Hm().format(date)}";
  }
}

String getMonthWithDistantYear(DateTime date) {
  final currentYear = DateTime.now().year;

  if (date.year == currentYear) {
    return capitalize(DateFormat.MMM().format(date));
  } else {
    return capitalize("${DateFormat.MMM().format(date)} ${date.year}");
  }
}

String getMinimalDay(DateTime date) {
  return DateFormat.E().format(date);
}