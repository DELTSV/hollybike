/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:hollybike/shared/utils/strings.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

String formatReadableDate(DateTime date) {
  final now = DateTime.now();

  if (date.year == now.year) {
    if (date.month == now.month && date.day == now.day) {
      return "aujourd'hui à ${DateFormat.Hm().format(date)}";
    } else if (date.month == now.month && date.day == now.day + 1) {
      return "demain à ${DateFormat.Hm().format(date)}";
    } else if (date.month == now.month && date.day == now.day - 1) {
      return "hier à ${DateFormat.Hm().format(date)}";
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
    return "Dans un jour";
  } else if (difference.inHours > 1) {
    return "Dans ${difference.inHours} heures";
  } else if (difference.inHours == 1) {
    return "Dans une heure";
  } else if (difference.inMinutes > 1) {
    return "Dans ${difference.inMinutes} minutes";
  } else if (difference.inMinutes == 1) {
    return "Dans une minute";
  } else if (difference.inSeconds <= 0) {
    return "Maintenant";
  } else {
    return "Dans ${difference.inSeconds} secondes";
  }
}

bool checkSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String? dateToJson(DateTime? dateTime) => dateTime == null
    ? null
    : DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dateTime);

String formatPastTime(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 365) {
    final years = difference.inDays ~/ 365;
    return "il y a $years an${years > 1 ? "s" : ""}";
  } else if (difference.inDays > 30) {
    final months = difference.inDays ~/ 30;
    return "il y a $months mois";
  } else if (difference.inDays > 7) {
    final weeks = difference.inDays ~/ 7;
    return "il y a $weeks semaine${weeks > 1 ? "s" : ""}";
  } else if (difference.inDays > 1) {
    return "il y a ${difference.inDays} jours";
  } else if (difference.inHours > 1) {
    return "il y a ${difference.inHours} heures";
  } else if (difference.inHours == 1) {
    return "il y a une heure";
  } else if (difference.inMinutes > 1) {
    return "il y a ${difference.inMinutes} minutes";
  } else if (difference.inMinutes == 1) {
    return "il y a une minute";
  } else {
    return "il y a quelques secondes";
  }
}

String formatTimeDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date).inDays;

  String formattedDate;

  if (difference == 0) {
    formattedDate = "aujourd'hui";
  } else if (difference == 1) {
    formattedDate = "hier";
  } else {
    formattedDate = "le ${DateFormat.yMMMMd('fr_FR').format(date)}";
  }

  final time = "${date.hour}h${date.minute.toString().padLeft(2, '0')}";

  return "$formattedDate à $time";
}