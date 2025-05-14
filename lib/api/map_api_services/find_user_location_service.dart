import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class FindUserLocationService {
  /// 取得目前使用者位置
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('⚠️ 定位服務未啟用');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('⚠️ 定位權限被拒絕');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('⚠️ 定位權限被永久拒絕');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// 根據座標轉成地址資訊
  Future<String> getAddressFromPosition(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      return "${placemark.locality ?? ''}, ${placemark.country ?? ''}";
    } else {
      return "找不到地址";
    }
  }
}