import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lumo_ai_travel_plan_app/screens/sub_screens/map_draw_route_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/map_api_services/google_map_service.dart';
import '../../api/map_models/nearby_detail_response.dart';
import '../../globals.dart' as globals;
import '../../widget/elevated_button_widget.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String placeId;

  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  State<StatefulWidget> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  NearbyDetailResult? placeDetail;
  bool isLoading = true;
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  Future<void> _fetchPlaceDetail() async {
    try {
      final apiKey = globals.mapApiKey;
      final mapService = GoogleMapService.create();
      final detailData = await mapService.fetchNearbyPlaceDetail(widget.placeId, apiKey);

      setState(() {
        placeDetail = detailData.result;
        isLoading = false;
      });
    } catch (e) {
      print('Get details fail: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onRoad() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapDrawRouteScreen(
          destination: LatLng(
          placeDetail!.geometry!.location.lat,
            placeDetail!.geometry!.location.lng
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // 取得景點明細資料
    _fetchPlaceDetail();

    // 啟動自動輪播，每3秒切換一次
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;
      if (placeDetail?.photos == null || placeDetail!.photos!.isEmpty) return;

      if (_currentPage < placeDetail!.photos!.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || placeDetail == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final photos = placeDetail?.photos ?? [];
    final openingHours = placeDetail?.opening_hours?.weekday_text ?? [];
    final website = placeDetail?.website;
    final phoneNumber = placeDetail?.formatted_phone_number;
    final rating = placeDetail?.rating;
    final reviews = placeDetail?.reviews ?? [];

    return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 照片自動輪播
                if (photos.isNotEmpty)
                  SizedBox(
                    height: 250,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        final photoUrl = getPhotoUrl(photos[index].photo_reference);
                        return Image.network(photoUrl, fit: BoxFit.cover,);
                      },
                    ),
                  ),

                // 基本資料區
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              placeDetail!.name,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8,),
                          if (rating != null)
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber,),
                                const SizedBox(width: 4,),
                                Text("$rating", style: const TextStyle(fontSize: 16),),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      Text(placeDetail!.formatted_address!, style: const TextStyle(fontSize: 16,)),
                      const SizedBox(height: 8,),
                      ElevatedButtonWidget(buttonName: "Plan a route", onPressedCallback: _onRoad,),
                      const SizedBox(height: 8,),
                      if (phoneNumber != null)
                        Row(
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(width: 4,),
                            GestureDetector(
                              onTap: () => _makePhoneCall(phoneNumber),
                              child: Text(phoneNumber, style: const TextStyle(color: Colors.blue),),
                            )
                          ],
                        ),
                      const SizedBox(height: 8,),
                      if (website != null)
                        Row(
                          children: [
                            const Icon(Icons.language),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _launchURL(website),
                              child: const Text('Official web', style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                const Divider(),

                // ✏️ 景點介紹
                if (placeDetail?.editorial_summary?.overview != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle('Attraction Introduction'),
                        const SizedBox(height: 8),
                        Text(placeDetail!.editorial_summary!.overview),
                      ],
                    ),
                  ),

                const Divider(),

                // 🕐 營業時間
                if (openingHours.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle('Open Time'),
                        const SizedBox(height: 8),
                        ...openingHours.map((day) => Text(day)),
                      ],
                    ),
                  ),

                const Divider(),

                // 🗣️ 使用者評論
                if (reviews.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle('User Reviews'),
                        const SizedBox(height: 8),
                        ...reviews.take(3).map((review) => reviewTile(review)),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          )
      )
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget reviewTile(Review review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (review.profile_photo_url != null)
            CircleAvatar(
              backgroundImage: NetworkImage(review.profile_photo_url!),
            )
          else
            const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.author_name ?? '匿名使用者', style: const TextStyle(fontWeight: FontWeight.bold)),
                if (review.text != null) Text(review.text!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getPhotoUrl(String photoReference) {
    String apiKey = globals.mapApiKey;
    return "https://maps.googleapis.com/maps/api/place/photo"
        "?maxwidth=800"
        "&photoreference=$photoReference"
        "&key=$apiKey";
  }

  Future<void> _launchURL(String url) async {
    try {
      // 自動把 http 換成 https
      if (url.startsWith('http://')) {
        url = url.replaceFirst('http://', 'https://');
      }
      final Uri uri = Uri.parse(url);
      final bool canLaunch = await canLaunchUrl(uri);
      debugPrint('canLaunchUrl result: $canLaunch');

      if (canLaunch) {
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        debugPrint('launchUrl success: $launched');
        if (!launched) {
          debugPrint('❗ launchUrl returned false, could not launch $url');
        }
      } else {
        debugPrint('❗ cannot launch url: $url');
      }
    } catch (e) {
      debugPrint('❗ Exception caught when trying to launch: $e');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
