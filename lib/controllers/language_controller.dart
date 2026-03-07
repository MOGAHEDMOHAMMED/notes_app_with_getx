import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final String _langeuageCodeKey = "LanguageCode";
  GetStorage storage = GetStorage();
  Locale savedLocale() {
    String? langCode = storage.read(_langeuageCodeKey);
    if (langCode != null) {
      return Locale(langCode);
    }
    return Get.deviceLocale ?? const Locale('ar');
  }
  void changeLanguage(String newLanguageCode) {
    Get.updateLocale(Locale(newLanguageCode));
    storage.write(_langeuageCodeKey, newLanguageCode);
  }
}
