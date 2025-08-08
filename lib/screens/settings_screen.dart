import 'package:flutter/material.dart';
import 'package:lumo_ai_travel_plan_app/widget/bottom_navigation_bar_layout.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../providers/locale_provider.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Locale? _selectedLocale;

  // 語系
  final Map<String, Locale> _localeMap = {
    'English': const Locale('en', 'US'),
    '繁體中文': const Locale('zh', 'TW'),
    '简体中文': const Locale('zh', 'CN'),
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在 _selectedLocale 還沒設定時，才從 Provider 拿一次當前語系
    if (_selectedLocale == null) {
      final current = Provider.of<LocaleProvider>(context, listen: false).locale;
      _selectedLocale = _localeMap.entries
        .firstWhere((e) => e.value == current,
          orElse: () => const MapEntry('English', Locale('en', 'US')))
        .value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              S.of(context).SelectLanguage,
              style: const TextStyle(fontSize: 18),
            ), // 「選擇語言」由 intl 管理
            const SizedBox(height: 12),
            DropdownButton<Locale>(
              value: _selectedLocale,
              isExpanded: true,
              items: _localeMap.entries.map((entry) {
                return DropdownMenuItem<Locale>(
                  value: entry.value,
                  child: Text(entry.key),
                );
              }).toList(),
              onChanged: (newLoc) {
                setState(() {
                  _selectedLocale = newLoc;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedLocale != null) {
                  Provider.of<LocaleProvider>(context, listen: false).setLocale(_selectedLocale!);
                }
              },
              child: Text(S.of(context).Confirm),
            )
          ],
        )
      ),
    );
  }


}
