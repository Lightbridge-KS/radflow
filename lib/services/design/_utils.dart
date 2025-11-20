import 'package:intl/intl.dart';

/// Converts empty strings to "-"
String dashIfBlank(String value) {
  return value.trim().isEmpty ? '-' : value;
}

/// Converts boolean values to "Yes" or "-"
String boolYesDash(bool value) {
  return value ? 'Yes' : '-';
}

/// Gets the current date in dd/MM/yyyy format
String getCurrentDate() {
  final now = DateTime.now();
  final formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(now);
}