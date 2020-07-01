import 'dart:convert';

import 'package:flutter/foundation.dart';
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

  String get dinersHeader{
    return getTranslatedValue('diners_header');
  }

  String get mealsHeader{
    return getTranslatedValue('meals_header');
  }

  String get summaryHeader{
    return getTranslatedValue('summary_header');
  }

  String get dinerNameHint{
    return getTranslatedValue('diner_name_hint');
  }

  String get saveParty{
    return getTranslatedValue('save_party');
  }

  String get requiredField{
    return getTranslatedValue('required_field');
  }

  String get nameExists{
    return getTranslatedValue('name_exists');
  }

  String get enterGroupName{
    return getTranslatedValue('enter_group_name');
  }

  String get savePartyRequirement{
    return getTranslatedValue('save_party_requirement');
  }

  String get editName{
    return getTranslatedValue('edit_name');
  }

  String get clearDiscount{
    return getTranslatedValue('clear_discount');
  }

  String get addDiscount{
    return getTranslatedValue('add_discount');
  }

  String get discount{
    return getTranslatedValue('discount');
  }

  String get fullPayment{
    return getTranslatedValue('full_payment');
  }

  String get deletConfirmation{
    return getTranslatedValue('delete_confirmation');
  }

  String get mealNameHint{
    return getTranslatedValue('meal_name_hint');
  }

  String get mealPriceHint{
    return getTranslatedValue('meal_price_hint');
  }

  String get numberRequirement{
    return getTranslatedValue('number_requirement');
  }

  String get splitEvenly{
    return getTranslatedValue('split_evenly');
  }

  String get meal{
    return getTranslatedValue('meal');
  }

  String get noEatersSelected{
    return getTranslatedValue('no_eaters_selected');
  }

  String get calculateMeal{
    return getTranslatedValue('calculate_meal');
  }

  String get tipPersentage{
    return getTranslatedValue('tip_percentage');
  }

  String get withTip{
    return getTranslatedValue('with_tip');
  }

  String get fullPayWithTip{
    return this.fullPayment + ' ' + this.withTip;
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