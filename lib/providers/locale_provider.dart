import 'package:flutter/cupertino.dart';

class LocaleProvider extends ChangeNotifier {
  late Locale _locale = const Locale('en', 'US'); // 預設語系

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;

    _locale = newLocale;
    notifyListeners();
  }
}
