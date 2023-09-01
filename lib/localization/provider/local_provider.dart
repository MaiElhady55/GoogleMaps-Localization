import 'package:flutter/material.dart';

class LocalProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void switchLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
