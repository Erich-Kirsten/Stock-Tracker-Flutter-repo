import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationData {
  final String country;
  final double latitude;
  final double longitude;

  LocationData({
    required this.country,
    required this.latitude,
    required this.longitude,
  });
}

class LocationHelper {
  static Future<LocationData> getLocationData() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 检查服务是否开启
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationData(country: 'Location Disabled', latitude: 0.0, longitude: 0.0);
    }

    // 检查权限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationData(country: 'Permission Denied', latitude: 0.0, longitude: 0.0);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationData(country: 'Permission Denied Forever', latitude: 0.0, longitude: 0.0);
    }

    // 获取当前位置
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 获取国家名
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String country = placemarks.isNotEmpty
        ? (placemarks[0].country ?? 'Unknown Country')
        : 'Country not found';

    return LocationData(
      country: country,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
