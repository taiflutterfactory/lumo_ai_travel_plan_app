import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/api/map_api_services/google_map_service.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/attraction_deatail_screen.dart';
import 'package:provider/provider.dart';

import '../../api/map_models/nearby_response.dart';
import '../../globals.dart' as globals;
import '../../widget/provider_widget.dart';

class AttractionMainScreen extends StatefulWidget {
  const AttractionMainScreen({super.key});

  @override
  State<AttractionMainScreen> createState() => _AttractionMainScreenState();
}

class _AttractionMainScreenState extends State<AttractionMainScreen> {
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

  Future<void> _initFetchPlaces() async {
    try {
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);

      if (locationProvider.latitude == null || locationProvider.longitude == null) {
        await locationProvider.getCurrentLocation();
      }

      double lat = locationProvider.latitude!;
      double lng = locationProvider.longitude!;
      String apiKey = globals.mapApiKey;

      final data = await _mapService.fetchNearbyPlace(lat, lng, apiKey);

      setState(() {
        items = data.results;
      });

      // ✅ 背景慢慢補 details
      _enrichPlacesWithDetails();

    } catch (e) {
      print("Loading fail: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Can\'t get the location：$e')),
      );
    }
  }

  Future<void> _enrichPlacesWithDetails() async {
    for (int i = 0; i < items.length; i++) {
      try {
        final detail = await _mapService.fetchNearbyPlaceDetail(items[i].place_id, globals.mapApiKey);
        setState(() {
          items[i].user_ratings_total = detail.result.user_ratings_total;
        });
              // 小小 delay 保護 API
        await Future.delayed(const Duration(milliseconds: 150));
      } catch (e) {
        print("Get details fail: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Popular places',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black12
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 260,
                    child: Builder(
                      builder: (context) {
                        final currentDisplayedItems = items.where((item) {
                          final rating = item.rating ?? 0;
                          final userRatingsTotal = item.user_ratings_total ?? 0;
                          return rating >= 4.0 && userRatingsTotal > 30;
                        }).toList();

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: currentDisplayedItems.length,
                          itemBuilder: (context, index) {
                            final item = currentDisplayedItems[index];
                            return PopularPlacesListTile(result: item);
                          },
                        );
                      }
                    ),
                  ),
                ],
              ),
              const Text(
                'Favorite places',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black12
                ),
              ),
              const SizedBox(height: 5,),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final currentDisplayedItems = items.where((item) {
                      final rating = item.rating ?? 0;
                      return rating >= 3.0 && rating < 4.0;
                    }).toList();

                    return ListView.builder(
                      itemCount: currentDisplayedItems.length,
                      itemBuilder: (context, index) {
                        final item = currentDisplayedItems[index];
                        return FavoritePlacesListTile(result: item);
                      },
                    );
                  }
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

class PopularPlacesListTile extends StatelessWidget {
  final NearbyResult result;

  const PopularPlacesListTile({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8, // 限制高度
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: PlaceDetailScreen(
                placeId: result.place_id,
              ),
            );
          },
        );
      },
      child: Container(
        width: 160, // 卡片寬度
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 上面放圖片
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: result.photos != null && result.photos!.isNotEmpty
                  ? Image.network(
                getPhotoUrl(result.photos!.first.photoReference),
                width: double.infinity,
                height: 120, // 圖片區域高度
                fit: BoxFit.cover,
              )
                  : Container(
                width: double.infinity,
                height: 120,
                color: Colors.grey.shade300,
                child: const Icon(Icons.location_on, size: 40, color: Colors.white),
              ),
            ),
            // 下方資訊
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name ?? "No name place!",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (result.rating != null)
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(result.rating!.toString()),
                      ],
                    ),
                  if (result.vicinity != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        result.vicinity!,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
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

// 客製ListTile
class FavoritePlacesListTile extends StatelessWidget {
  final NearbyResult result;

  const FavoritePlacesListTile({super.key, required this.result});

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
        title: Text(result.name ?? "No name place!", style: const TextStyle(fontWeight: FontWeight.bold),),
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
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8, // 限制高度
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: PlaceDetailScreen(
                  placeId: result.place_id,
                ),
              );
            },
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


