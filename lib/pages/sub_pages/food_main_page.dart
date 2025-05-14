import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/api/map_api_services/google_map_service.dart';
import 'package:lumo_ai_travel_plan_app/pages/sub_pages/attraction_deatail_page.dart';
import 'package:lumo_ai_travel_plan_app/widget/bottom_navigation_bar_widget.dart';
import 'package:lumo_ai_travel_plan_app/widget/search_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../api/map_models/nearby_response.dart';
import '../../app_state.dart';
import '../../globals.dart' as globals;

class FoodMainPage extends StatefulWidget {
  const FoodMainPage({super.key});

  @override
  State<FoodMainPage> createState() => _FoodMainPageState();
}

class _FoodMainPageState extends State<FoodMainPage> {
  List<NearbyResult> items = [];
  List<NearbyResult> displayedItems = [];

  final GoogleMapService _mapService = GoogleMapService.create();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFetchPlaces();
    });
  }

  // 取得使用者現在位置
  Future<void> _initFetchPlaces() async {
    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);

      // ⚡ 如果沒取得過，就先取定位
      if (locationProvider.latitude == null || locationProvider.longitude == null) {
        await locationProvider.getCurrentLocation();
      }

      double lat = locationProvider.latitude!;
      double lng = locationProvider.longitude!;
      String apiKey = globals.mapApiKey;

      final data = await _mapService.fetchNearbyFood(lat, lng, apiKey);

      setState(() {
        items = data.results;
      });
    } catch (e) {
      print("載入餐廳失敗: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('無法取得定位或餐廳資訊：$e')),
      );
    }
  }

  Future<void> _refreshLocationAndPlaces() async {
    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);

      // 重新取得定位
      await locationProvider.getCurrentLocation();

      double lat = locationProvider.latitude!;
      double lng = locationProvider.longitude!;
      String apiKey = globals.mapApiKey;

      final data = await _mapService.fetchNearbyFood(lat, lng, apiKey);

      setState(() {
        items = data.results; // 更新餐廳資料
      });

      // ✅ 順便清除搜尋條件
      Provider.of<SearchBarProvider>(context, listen: false).updateSelectedPlace('');
      FocusScope.of(context).unfocus(); // 收起鍵盤（如果有）

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ 已重新定位並更新附近餐廳')),
      );
    } catch (e) {
      print("重新定位失敗: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❗ 重新定位失敗：$e')),
      );
    }
  }

  void _updateDisplayedItems(String? selectedName) {
    setState(() {
      if (selectedName == null || selectedName.isEmpty) {
        displayedItems = items;
      } else {
        displayedItems = items.where((item) => item.name!.contains(selectedName)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlaceProvider = Provider.of<SearchBarProvider>(context);
    List<NearbyResult> currentDisplayedItems;

    if (selectedPlaceProvider.selectedPlaceName != null) {
      _updateDisplayedItems(selectedPlaceProvider.selectedPlaceName);
    } else {
      displayedItems = items;
    }

    return SafeArea(
      child: Scaffold(
        appBar: null,
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 20, left: 20),
                            width: 250,
                            height: 80,
                            alignment: Alignment.center,
                            child: SearchBarWidget(items: items),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20, left: 5),
                          width: 50,
                          height: 80,
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: _refreshLocationAndPlaces,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Expanded( // ⬅️ 把 ListView 包在 Expanded 裡
                      child: Consumer<SearchBarProvider>(
                        builder: (context, selectedPlaceProvider, child) {
                          if (selectedPlaceProvider.selectedPlaceName == null ||
                              selectedPlaceProvider.selectedPlaceName!
                                  .isEmpty) {
                            currentDisplayedItems = items;
                          } else {
                            currentDisplayedItems =
                                items.where((item) => item.name ==
                                    selectedPlaceProvider.selectedPlaceName)
                                    .toList();
                          }
                          return ListView.builder(
                            itemCount: currentDisplayedItems.length,
                            itemBuilder: (context, index) {
                              final item = currentDisplayedItems[index];
                              FocusScope.of(context).unfocus(); // ✅ 收鍵盤
                              return CustomListTile(result: item);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 客製ListTile
class CustomListTile extends StatelessWidget {
  final NearbyResult result;

  const CustomListTile({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: result.photos != null && result.photos!.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            getPhotoUrl(result.photos!.first.photoReference),
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        )
            : const Icon(Icons.location_on, size: 40, color: Colors.grey,),
        title: Text(result.name ?? "無名景點", style: const TextStyle(fontWeight: FontWeight.bold),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.vicinity != null) Text(result.vicinity!),
            if (result.rating != null)
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 4,),
                  Text(result.rating!.toString()),
                ],
              )
          ],
        ),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceDetailPage(placeId: result.place_id),
            ),
          );
        },
      ),
    );
  }

  String getPhotoUrl(String? photoReference) {
    String apiKey = globals.mapApiKey;
    return "https://maps.googleapis.com/maps/api/place/photo"
        "?maxwidth=400"
        "&photoreference=$photoReference"
        "&key=$apiKey";
  }
}