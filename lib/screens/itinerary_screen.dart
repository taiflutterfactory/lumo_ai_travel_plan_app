import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  final List<String> _interests = ['Food', 'Culture', 'Natural', 'Family'];
  final List<String> _selectedInterests = [];

  // 顯示 Planning Dialog
  void _showPlanningDialog(BuildContext context, ItineraryProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Trip Deatils'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Destination'),
                ),
                TextField(
                  controller: _daysController,
                  decoration: const InputDecoration(labelText: 'Days'),
                ),
                const SizedBox(height: 8,),
                const Text('Interesting:'),
                Wrap(
                  spacing: 10,
                  children: _interests.map((interest) {
                    return FilterChip(
                      label: Text(interest),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedInterests.add(interest);
                          } else {
                            _selectedInterests.remove(interest);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  context.pop;
                },
                child: const Text('Cancel')
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
                child: const Text('Generate'),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItineraryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Travel Plan'),),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  _showPlanningDialog(context, provider);
                },
                child: const Text('Planning'),
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
