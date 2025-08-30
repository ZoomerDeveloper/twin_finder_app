import 'package:intl/intl.dart';

String formatDateToString(DateTime date) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(date);
}

String formatDateToReadable(String? inputDate) {
  if (inputDate == null || inputDate.isEmpty) {
    return '';
  }
  final DateTime parsedDate = DateTime.parse(inputDate);
  final DateFormat formatter = DateFormat('MMM d, yyyy', 'en_US');
  return formatter.format(parsedDate);
}

/// Проверяет, достиг ли пользователь минимального возраста (18 лет)
bool isMinimumAgeReached(DateTime birthDate) {
  final now = DateTime.now();
  final age = now.year - birthDate.year;

  // Проверяем, прошел ли день рождения в этом году
  if (now.month < birthDate.month ||
      (now.month == birthDate.month && now.day < birthDate.day)) {
    return age > 18;
  }

  return age >= 18;
}

/// Возвращает максимальную дату для выбора (18 лет назад)
DateTime getMaximumBirthDate() {
  final now = DateTime.now();
  return DateTime(now.year - 18, now.month, now.day);
}

/// Возвращает минимальную дату для выбора (100 лет назад)
DateTime getMinimumBirthDate() {
  final now = DateTime.now();
  return DateTime(now.year - 100, now.month, now.day);
}

/// Форматирует дату рождения в строку возраста (например: "24 years old")
String formatAgeFromBirthday(DateTime? birthday) {
  if (birthday == null) return '';
  
  final now = DateTime.now();
  int age = now.year - birthday.year;
  
  // Проверяем, прошел ли день рождения в этом году
  if (now.month < birthday.month || 
      (now.month == birthday.month && now.day < birthday.day)) {
    age--;
  }
  
  return '$age years old';
}
