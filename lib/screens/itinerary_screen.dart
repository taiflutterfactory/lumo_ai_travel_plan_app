import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../globals.dart' as globals;
import '../providers/itinerary_provider.dart';
import '../widget/bottom_navigation_bar_layout.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  final _locationController = TextEditingController();
  final _daysController = TextEditingController();
  final List<String> _selectedInterests = [];
  List<String> _interests = [];

  void _labelList() {
    final loc = S.of(context);
    _interests.add(loc.Food);
    _interests.add(loc.Culture);
    _interests.add(loc.Natural);
    _interests.add(loc.Family);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = S.of(context);

    _interests.clear();
    _interests = [
      loc.Food,
      loc.Culture,
      loc.Natural,
      loc.Family,
    ];
  }

  // 顯示 Planning Dialog
  void _showPlanningDialog(BuildContext context, ItineraryProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(S.of(context).SelectTripDeatils),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(labelText: S.of(context).Destination),
                    ),
                    TextField(
                      controller: _daysController,
                      decoration: InputDecoration(labelText: S.of(context).Days),
                    ),
                    const SizedBox(height: 8,),
                    Text('${S.of(context).Interesting}:'),
                    Wrap(
                      spacing: 10,
                      children: _interests.map((interest) {
                        final isSelected = _selectedInterests.contains(interest);

                        return FilterChip(
                          label: Text(interest),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedInterests.add(interest);
                              } else {
                                _selectedInterests.remove(interest);
                              }
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Colors.orange,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          showCheckmark: false,
                          elevation: 0,
                          selectedShadowColor: Colors.transparent,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(S.of(context).Cancel)
                ),
                ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () {
                    provider.generateItinerary(
                        location: _locationController.text,
                        days: _daysController.text,
                        interests: _selectedInterests,
                        apiKey: globals.chatGptApiKey
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).Generate),
                )
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItineraryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).Generate),),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  _showPlanningDialog(context, provider);
                },
                child: Text(S.of(context).Planning),
            ),
            const SizedBox(height: 16,),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator(),),
            if (provider.itineraryResult != null)
              Expanded(
                child: ListView.builder(
                  itemCount: provider.parsedDays.length,
                  itemBuilder: (context, index) {
                    final dayText = provider.parsedDays[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16,),
                        child: Text(
                          dayText,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
