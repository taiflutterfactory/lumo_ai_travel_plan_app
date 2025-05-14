import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NaviGationBarProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

class SearchBarProvider extends ChangeNotifier {
  String? _selectedPlaceName;
  String? get selectedPlaceName => _selectedPlaceName;

  void updateSelectedPlace(String? newName) {
    _selectedPlaceName = newName;
    notifyListeners();
  }

  void clearSelectedPlace() {
    _selectedPlaceName = null;
    notifyListeners();
  }
}

class LocationProvider with ChangeNotifier {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 檢查定位服務是否開啟
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('定位服務未開啟');
    }

    // 檢查權限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('定位權限被拒絕');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('定位權限被永久拒絕');
    }

    // 取得目前位置
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = position.latitude;
    longitude = position.longitude;

    notifyListeners(); // 通知聽眾更新
  }
}
