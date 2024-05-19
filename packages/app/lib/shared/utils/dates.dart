import 'package:intl/intl.dart';

String formatReadableDate(DateTime date) {
  // If the date is today, return "Aujourd'hui à HH:mm"
  // If the date is tomorrow, return "Demain à HH:mm"
  // If the date is yesterday, return "Hier à HH:mm"
  // If the date is in this year, return "le dd MMMM à HH:mm"
  // If the date is in another year, return "le dd MMMM yyyy à HH:mm"
  // The date format should be in French
  // Example: "Aujourd'hui à 14:30"
  // Example: "Demain à 10:00"
  // Example: "Hier à 18:00"
  // Example: "le 25 décembre à 08:00"
  // Example: "le 25 décembre 2022 à 08:00"
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