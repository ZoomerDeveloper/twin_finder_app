import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Сервис для работы с геолокацией
class GeolocationService {
  /// Проверяет разрешения на геолокацию
  static Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Получает текущую позицию пользователя
  static Future<Position?> getCurrentPosition() async {
    try {
      if (!await checkPermissions()) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Получает страну и город по координатам
  static Future<Map<String, String?>> getCountryAndCityFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return {
          'country': place.country,
          'city': place.locality ?? place.subLocality,
        };
      }
    } catch (e) {
      // Ошибка при получении адреса
    }

    return {'country': null, 'city': null};
  }

  /// Получает страну и город по текущей позиции
  static Future<Map<String, String?>> getCurrentCountryAndCity() async {
    Position? position = await getCurrentPosition();
    if (position == null) {
      return {'country': null, 'city': null};
    }

    return await getCountryAndCityFromCoordinates(
      position.latitude,
      position.longitude,
    );
  }
}
