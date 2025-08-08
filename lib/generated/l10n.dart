// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Select Language`
  String get SelectLanguage {
    return Intl.message(
      'Select Language',
      name: 'SelectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get Confirm {
    return Intl.message(
      'Confirm',
      name: 'Confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Generate`
  String get Generate {
    return Intl.message(
      'Generate',
      name: 'Generate',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message(
      'Home',
      name: 'Home',
      desc: '',
      args: [],
    );
  }

  /// `Itinerary`
  String get Itinerary {
    return Intl.message(
      'Itinerary',
      name: 'Itinerary',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get Favorite {
    return Intl.message(
      'Favorite',
      name: 'Favorite',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `Attraction`
  String get Attraction {
    return Intl.message(
      'Attraction',
      name: 'Attraction',
      desc: '',
      args: [],
    );
  }

  /// `Bites`
  String get Bites {
    return Intl.message(
      'Bites',
      name: 'Bites',
      desc: '',
      args: [],
    );
  }

  /// `Popular places`
  String get PopularPlaces {
    return Intl.message(
      'Popular places',
      name: 'PopularPlaces',
      desc: '',
      args: [],
    );
  }

  /// `Favorite places`
  String get FavoritePlaces {
    return Intl.message(
      'Favorite places',
      name: 'FavoritePlaces',
      desc: '',
      args: [],
    );
  }

  /// `Popular restaurant`
  String get PopularRestaurant {
    return Intl.message(
      'Popular restaurant',
      name: 'PopularRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `Favorite restaurant`
  String get FavoriteRestaurant {
    return Intl.message(
      'Favorite restaurant',
      name: 'FavoriteRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `Travel Plan`
  String get TravelPlan {
    return Intl.message(
      'Travel Plan',
      name: 'TravelPlan',
      desc: '',
      args: [],
    );
  }

  /// `Planning`
  String get Planning {
    return Intl.message(
      'Planning',
      name: 'Planning',
      desc: '',
      args: [],
    );
  }

  /// `No name place`
  String get NoNamePlace {
    return Intl.message(
      'No name place',
      name: 'NoNamePlace',
      desc: '',
      args: [],
    );
  }

  /// `No name restaurant`
  String get NoNameRestaurant {
    return Intl.message(
      'No name restaurant',
      name: 'NoNameRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `Trip Deatils`
  String get SelectTripDeatils {
    return Intl.message(
      'Trip Deatils',
      name: 'SelectTripDeatils',
      desc: '',
      args: [],
    );
  }

  /// `Interesting`
  String get Interesting {
    return Intl.message(
      'Interesting',
      name: 'Interesting',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get Destination {
    return Intl.message(
      'Destination',
      name: 'Destination',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get Days {
    return Intl.message(
      'Days',
      name: 'Days',
      desc: '',
      args: [],
    );
  }

  /// `Food`
  String get Food {
    return Intl.message(
      'Food',
      name: 'Food',
      desc: '',
      args: [],
    );
  }

  /// `Culture`
  String get Culture {
    return Intl.message(
      'Culture',
      name: 'Culture',
      desc: '',
      args: [],
    );
  }

  /// `Natural`
  String get Natural {
    return Intl.message(
      'Natural',
      name: 'Natural',
      desc: '',
      args: [],
    );
  }

  /// `Family`
  String get Family {
    return Intl.message(
      'Family',
      name: 'Family',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
