import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/api/map_api_services/google_map_service.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/attraction_deatail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/map_models/nearby_response.dart';
import '../../generated/l10n.dart';
import '../../globals.dart' as globals;
import '../../providers/location_provider.dart';

class FavoriteAttractionMainScreen extends StatefulWidget {
  const FavoriteAttractionMainScreen({super.key});

  @override
  State<FavoriteAttractionMainScreen> createState() => _FavoriteAttractionMainScreenState();
}

class _FavoriteAttractionMainScreenState extends State<FavoriteAttractionMainScreen> {
  List<NearbyResult> items = [];
  List<NearbyResult> displayedItems = [];
  late SharedPreferences prefs;
  Set<String> favoritePlaceIds = {}; // 用來儲存收藏的景點ID

  final GoogleMapService _mapService = GoogleMapService.create();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFetchPlaces();
      _loadFavorites(); // 載入收藏
    });
  }

  // 載入收藏
  Future<void> _loadFavorites() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritePlaceIds = prefs.getStringList('favorites')?.toSet() ?? {};
    });
  }

  // 儲存收藏
  Future<void> _saveFavorites() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favoritePlaceIds.toList());
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
      if (!mounted) return;
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
              Text(
                S.of(context).PopularPlaces,
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
                          return favoritePlaceIds.contains(item.place_id)
                              && rating >= 4.0
                              && userRatingsTotal > 30;
                        }).toList();

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: currentDisplayedItems.length,
                          itemBuilder: (context, index) {
                            final item = currentDisplayedItems[index];
                            return PopularPlacesListTile(
                              result: item,
                              isFavorite: favoritePlaceIds.contains(item.place_id),
                              onFavoriteTapped: () {
                                if (favoritePlaceIds.contains(item.place_id)) {
                                  favoritePlaceIds.remove(item.place_id);
                                } else {
                                  favoritePlaceIds.add(item.place_id);
                                }
                                _saveFavorites();
                              },
                            );
                          },
                        );
                      }
                    ),
                  ),
                ],
              ),
              Text(
                S.of(context).FavoritePlaces,
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
                      return favoritePlaceIds.contains(item.place_id)
                      && rating >= 3.0 && rating < 4.0;
                    }).toList();

                    return ListView.builder(
                      itemCount: currentDisplayedItems.length,
                      itemBuilder: (context, index) {
                        final item = currentDisplayedItems[index];
                        return FavoritePlacesListTile(
                          result: item,
                          isFavorite: favoritePlaceIds.contains(item.place_id),
                          onFavoriteTapped: () {
                            if (favoritePlaceIds.contains(item.place_id)) {
                              favoritePlaceIds.remove(item.place_id);
                            } else {
                              favoritePlaceIds.add(item.place_id);
                            }
                            _saveFavorites();
                          },
                        );
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

class PopularPlacesListTile extends StatefulWidget {
  final NearbyResult result;
  final bool isFavorite;
  final VoidCallback onFavoriteTapped;

  const PopularPlacesListTile({
    super.key,
    required this.result,
    required this.isFavorite,
    required this.onFavoriteTapped,
  });

  @override
  State<PopularPlacesListTile> createState() => _PopularPlacesListTileState();
}

class _PopularPlacesListTileState extends State<PopularPlacesListTile> {
  late bool _isFavorite;
  bool _isSaving = false; // 防連點flag

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  Future<void> _handleFavoriteTapped() async {
    if (_isSaving) return; // 防止重複點擊
    setState(() {
      _isSaving = true;
      _isFavorite = !_isFavorite; // 先切換UI
    });

    widget.onFavoriteTapped(); // 執行外部保存

    // 模擬儲存延遲
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isSaving = false;
    });
  }

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
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: PlaceDetailScreen(
                placeId: widget.result.place_id,
              ),
            );
          },
        );
      },
      child: Stack(
        children: [
          Container(
            width: 160,
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
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: widget.result.photos != null && widget.result.photos!.isNotEmpty
                      ? Image.network(
                    getPhotoUrl(widget.result.photos!.first.photoReference),
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    width: double.infinity,
                    height: 120,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.location_on, size: 40, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.result.name ?? "${S.of(context).NoNamePlace}!",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (widget.result.rating != null)
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(widget.result.rating!.toString()),
                          ],
                        ),
                      if (widget.result.vicinity != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            widget.result.vicinity!,
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

          // ⭐ AnimatedSwitcher + Positioned
          Positioned(
            right: 12,
            top: 12,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _handleFavoriteTapped,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  _isFavorite ? Icons.star : Icons.star_border,
                  key: ValueKey<bool>(_isFavorite), // 必須設 key 才能觸發動畫
                  color: Colors.amber,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
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
class FavoritePlacesListTile extends StatefulWidget {
  final NearbyResult result;
  final bool isFavorite;
  final VoidCallback onFavoriteTapped;

  const FavoritePlacesListTile({
    super.key,
    required this.result,
    required this.isFavorite,
    required this.onFavoriteTapped,
  });

  @override
  State<FavoritePlacesListTile> createState() => _FavoritePlacesListTileState();
}

class _FavoritePlacesListTileState extends State<FavoritePlacesListTile> {
  late bool _isFavorite;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  Future<void> _handleFavoriteTapped() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
      _isFavorite = !_isFavorite; // UI 先更新
    });

    widget.onFavoriteTapped(); // 呼叫外部儲存

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: widget.result.photos != null && widget.result.photos!.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            getPhotoUrl(widget.result.photos!.first.photoReference),
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        )
            : const Icon(Icons.location_on, size: 40, color: Colors.grey),
        title: Text(
          widget.result.name ?? "${S.of(context).NoNamePlace}!",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.result.vicinity != null) Text(widget.result.vicinity!),
            if (widget.result.rating != null)
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(widget.result.rating!.toString()),
                ],
              )
          ],
        ),
        trailing: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: IconButton(
            key: ValueKey<bool>(_isFavorite),
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
            onPressed: _handleFavoriteTapped,
          ),
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
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: PlaceDetailScreen(
                  placeId: widget.result.place_id,
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



