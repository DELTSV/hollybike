/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
bool isValidSignupLink(String? link) {
  if (link == null || link.isEmpty) return false;

  final regex = RegExp(
    r'^https://hollybike.fr/invite\?host=.*&role=.*&association=.*&invitation=.*&verify=.*$',
  );
  return regex.hasMatch(link);
}
