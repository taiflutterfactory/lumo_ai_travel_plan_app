import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/api/map_models/nearby_response.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class SearchBarWidget extends StatefulWidget {
  final List<NearbyResult> items;

  const SearchBarWidget({super.key, required this.items});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final SearchController _searchCountroller;
  List<NearbyResult> filtered = [];
  ModalRoute<dynamic>? _modalRoute;

  bool _isKeyboardVisible() {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  Future<bool> _handleWillPop() async {
    if (_isKeyboardVisible()) {
      FocusScope.of(context).unfocus();
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _searchCountroller = SearchController();
    filtered = widget.items;

    _searchCountroller.addListener(() {
      if (_searchCountroller.text.isEmpty) {
        setState(() {
          filtered = widget.items; // ✅ 如果文字被清空，回復顯示全部
        });
      }
    });

    // WidgetsBinding 保證 context 可用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _modalRoute = ModalRoute.of(context);
      _modalRoute?.addScopedWillPopCallback(_handleWillPop);
    });
  }

  @override
  void dispose() {
    _modalRoute?.removeScopedWillPopCallback(_handleWillPop);
    _searchCountroller.dispose(); // 釋放資源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      searchController: _searchCountroller,
      barHintText: '輸入地點...',
      barTrailing: [
        if (_searchCountroller.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchCountroller.clear();
                filtered = widget.items;

                // ✅ 重要：清空 Provider 內的 selectedPlaceName
                Provider.of<SearchBarProvider>(context, listen: false).updateSelectedPlace('');
              });
            },
          )
      ],
      onChanged: (value) {
        setState(() {
          filtered = widget.items
              .where((s) => s.name!.toLowerCase().contains(value.toLowerCase()))
              .toList();
        });
      },
      onSubmitted: (value) {
        FocusScope.of(context).unfocus();
        Provider.of<SearchBarProvider>(context, listen: false).updateSelectedPlace(value);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🎉 你選了：$value')),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) async {
        final query = controller.text;

        final results = query.isEmpty
            ? widget.items
            : widget.items
            .where((s) => s.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return results.map((item) {
          return ListTile(
            title: Text(item.name!),
            onTap: () {
              controller.closeView(item.name);
              Provider.of<SearchBarProvider>(context, listen: false).updateSelectedPlace(item.name);
              FocusScope.of(context).unfocus();
            },
          );
        });
      },
    );
  }
}