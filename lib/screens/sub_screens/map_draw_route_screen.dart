import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lumo_ai_travel_plan_app/widget/provider_widget.dart';
import 'package:provider/provider.dart';
import '../../globals.dart' as global;

class MapDrawRouteScreen extends StatefulWidget {
  final LatLng destination;

  const MapDrawRouteScreen({super.key, required this.destination});

  @override
  _MapDrawRouteScreenState createState() => _MapDrawRouteScreenState();
}

class _MapDrawRouteScreenState extends State<MapDrawRouteScreen> {
  GoogleMapController? mapController;
  Set<Polyline> _polylines = {};
  LatLng? startLocation;
  LatLng? get destination => widget.destination;
  double lat = 0.0;
  double lng = 0.0;

  Future<void> _getCurrentLocation() async {
    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);

      // 取得定位
      await locationProvider.getCurrentLocation();

      lat = locationProvider.latitude!;
      lng = locationProvider.longitude!;

      if (mounted) {
        setState(() {
          startLocation = LatLng(lat, lng);
        });
      }

      await _drawRoute(); // 畫出路線

    } catch (e) {
      print('取得定位失敗：$e');

      // 可以跳一個 Dialog 或 Toast 告訴使用者
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('錯誤'),
            content: Text('取得定位失敗，請檢查定位服務與權限。\n錯誤訊息：$e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('確定'),
              ),
            ],
          ),
        );
      }
    }
  }

  // 畫出路線
  Future<void> _drawRoute() async {
    if (startLocation == null || destination == null) {
      print("startLocation 或 destination 還沒準備好");
      return;
    }

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${startLocation!.latitude},${startLocation!.longitude}&'
        'destination=${destination!.latitude},${destination!.longitude}&'
        'mode=driving&key=${global.mapApiKey}';

    print("urlAAA: $url");

    final directions = await http.get(Uri.parse(url));

    if (directions.statusCode == 200) {
      final data = jsonDecode(directions.body);

      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final overviewPolyline = route['overview_polyline']['points'];

        // 把 overview_polyline 的 points 解碼成一串 LatLng
        final points = _decodePolyline(overviewPolyline);

        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            points: points,
            width: 5,
            color: Colors.blue,
          ));
        });
      } else {
        print("沒有找到路線");
      }
    } else {
      print("Directions API 錯誤： ${directions.statusCode}");
    }
  }

  // 解碼 overview_polyline points 字串成 LatLng List
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polylineCoordinates.add(
        LatLng(lat / 1E5, lng / 1E5),
      );
    }

    return polylineCoordinates;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('交通工具及路線規劃')),
      body: destination == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(destination!.latitude, destination!.longitude),
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polylines: _polylines,
      ),
    );
  }
}
