import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  final Locale locale;

  AppLocalization(this.locale);

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  late Map<String, String> _sentences;
  late Map<String, dynamic> result;
  Future<bool> load() async {
    var jsonData = {
      "en": {"title": "Hello World", "description": "This is a description"},
      "tr": {"title": "Merhaba Dünya", "description": "Bu bir açıklamadır"}
    };
    if (jsonData.containsKey(locale.languageCode)) {
      result = jsonData[locale.languageCode]!;
    } else {
      String data = await rootBundle
          .loadString('assets/translations/${locale.languageCode}.json');
      result = json.decode(data);
    }

    _sentences = <String, String>{};
    result.forEach((String key, dynamic value) {
      _sentences[key] = value.toString();
    });

    return true;
  }

  String? trans(String key) {
    return _sentences[key];
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['tr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localizations = AppLocalization(locale);
    await localizations.load();

    if (kDebugMode) {
      print("Load ${locale.languageCode}");
    }

    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}

extension AppLocalizationExtension on BuildContext {
  AppLocalization get appLocalization {
    return AppLocalization.of(this)!;
  }
}

extension Translate on BuildContext {
  String translate(String key) {
    return AppLocalization.of(this)!.trans(key) ?? "";
  }
}
