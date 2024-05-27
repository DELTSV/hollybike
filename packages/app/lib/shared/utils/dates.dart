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

String fromDateToDuration(DateTime date) {
  final now = DateTime.now();
  final difference = date.difference(now);

  if (difference.inDays > 365) {
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;
    return "Dans $years an${years > 1 ? "s" : ""} et $months mois";
  } else if (difference.inDays > 30) {
    final months = difference.inDays ~/ 30;
    final days = difference.inDays % 30;
    return "Dans $months mois et $days jour${days > 1 ? "s" : ""}";
  } else if (difference.inDays > 1) {
    return "Dans ${difference.inDays} jours";
  } else if (difference.inDays == 1) {
    return "Demain";
  } else if (difference.inHours > 1) {
    return "Dans ${difference.inHours} heures";
  } else if (difference.inHours == 1) {
    return "Dans une heure";
  } else if (difference.inMinutes > 1) {
    return "Dans ${difference.inMinutes} minutes";
  } else {
    return "Maintenant";
  }
}

bool checkSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
