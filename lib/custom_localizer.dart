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

  String get dinersHeader => getTranslatedValue('diners_header');

  String get mealsHeader => getTranslatedValue('meals_header');

  String get summaryHeader => getTranslatedValue('summary_header');

  String get dinerNameHint => getTranslatedValue('diner_name_hint');

  String get saveParty => getTranslatedValue('save_party');

  String get requiredField => getTranslatedValue('required_field');

  String get nameExists => getTranslatedValue('name_exists');

  String get enterGroupName => getTranslatedValue('enter_group_name');

  String get savePartyRequirement => getTranslatedValue('save_party_requirement');

  String get editName => getTranslatedValue('edit_name');

  String get clearDiscount => getTranslatedValue('clear_discount');

  String get addDiscount => getTranslatedValue('add_discount');

  String get discount => getTranslatedValue('discount');

  String get fullPayment => getTranslatedValue('full_payment');

  String get deletConfirmation => getTranslatedValue('delete_confirmation');

  String get mealNameHint => getTranslatedValue('meal_name_hint');

  String get priceHint => getTranslatedValue('price_hint');

  String get numberRequirement => getTranslatedValue('number_requirement');

  String get splitEvenly => getTranslatedValue('split_evenly');

  String get noEatersSelected => getTranslatedValue('no_eaters_selected');

  String get calculateMeal => getTranslatedValue('calculate_meal');

  String get tipPersentage => getTranslatedValue('tip_percentage');

  String get withTip => getTranslatedValue('with_tip');

  String get fullPayWithTip => this.fullPayment + ' ' + this.withTip;

  String get addExtraHeader => getTranslatedValue('add_extra_header');

  String get extraNameHint => getTranslatedValue('extra_name_hint');

  String get add => getTranslatedValue('add');

  String get clearSelection => getTranslatedValue('clear_selection');

  String get noSavedGroupFound => getTranslatedValue('no_saved_group');

  String get deleteGroupDescription => getTranslatedValue('delete_group_description');

  String get discountTypeLabel => getTranslatedValue('discount_type');

  String get discountAmountType => getTranslatedValue('discount_amount_type');

  String get discountPesentType => getTranslatedValue('discount_persent_type');

  String get discountInputHint => getTranslatedValue('discount_input_hint');

  String get discountPersentRequirement => getTranslatedValue('discount_persent_requirement');

  String get editMealHeader => getTranslatedValue('edit_meal_header');

  String get mealDiscountHeader => getTranslatedValue('meal_discount_header');
  
  String get freeMeal => getTranslatedValue('free_meal');

  String get discountIncludeExtras => getTranslatedValue('discount_include_extra');

  String get chooseEaters => getTranslatedValue('choose_eaters');

  String get addExtra => getTranslatedValue('add_extra');

  String get edit => getTranslatedValue('edit');
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