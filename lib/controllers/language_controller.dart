// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final String _langeuageCodeKey = "LanguageCode";
  GetStorage storage = GetStorage();
  Rx<Locale> _currentLocale = const Locale('ar').obs;
  Locale get currentLocale => _currentLocale.value;
  @override
  void onInit() {
    _currentLocale.value = savedLocale();
    super.onInit();
  }

  Locale savedLocale() {
    String? langCode = storage.read(_langeuageCodeKey);
    if (langCode != null) {
      return Locale(langCode);
    }
    return Get.deviceLocale ?? const Locale('ar');
  }

  void changeLanguage(String newLanguageCode) {
    Get.updateLocale(Locale(newLanguageCode));
    _currentLocale.value = Locale(newLanguageCode);
    storage.write(_langeuageCodeKey, newLanguageCode);
  }
}
