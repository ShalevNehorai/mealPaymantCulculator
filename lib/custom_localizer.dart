import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomLocalization {
  final Locale locale;

  CustomLocalization(this.locale);

  static CustomLocalization of(BuildContext context) {
    return Localizations.of<CustomLocalization>(context, CustomLocalization);
  }

  static const LocalizationsDelegate<CustomLocalization> delegate = _CustomLocalizationDeleget();

  Map<String, String> _localizedValues;

  Future load() async{
    String jsonStringValues = await rootBundle.loadString('languages/${this.locale.languageCode}.json');
    Map<String, dynamic> mappedValues = json.decode(jsonStringValues);
    _localizedValues = mappedValues.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslatedValue(String key){
    if(!_localizedValues.containsKey(key)){
      throw Exception("json file '${this.locale.languageCode}.json' not contains the key '$key'");
    }
    return _localizedValues[key];
  }

  String get diners{
    return getTranslatedValue('diners');
  }
}

class _CustomLocalizationDeleget extends LocalizationsDelegate<CustomLocalization>{
  const _CustomLocalizationDeleget();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'he'].contains(locale.languageCode);
  }

  @override
  Future<CustomLocalization> load(Locale locale) async{
    CustomLocalization demoLocalization = CustomLocalization(locale);
    await demoLocalization.load();
    return demoLocalization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<CustomLocalization> old) {
    return false;
  }
}