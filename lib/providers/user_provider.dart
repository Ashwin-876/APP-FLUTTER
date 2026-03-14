import 'package:flutter/material.dart';
import '../models/user_preferences.dart';

class UserProvider with ChangeNotifier {
  final UserPreferences _preferences = UserPreferences();

  UserPreferences get preferences => _preferences;

  void updateFamilyName(String name) {
    _preferences.familyName = name;
    notifyListeners();
  }

  void toggleDietaryPreference(String pref) {
    if (_preferences.dietaryPreferences.contains(pref)) {
      _preferences.dietaryPreferences.remove(pref);
    } else {
      _preferences.dietaryPreferences.add(pref);
    }
    notifyListeners();
  }

  void toggleAllergen(String allergen) {
    if (_preferences.allergens.contains(allergen)) {
      _preferences.allergens.remove(allergen);
    } else {
      _preferences.allergens.add(allergen);
    }
    notifyListeners();
  }

  void setNotifications(bool enabled) {
    _preferences.notificationsEnabled = enabled;
    notifyListeners();
  }

  void updateLanguage(String language) {
    _preferences.language = language;
    notifyListeners();
  }

  void updateMeasurementUnit(String unit) {
    _preferences.measurementUnit = unit;
    notifyListeners();
  }

  void updateThemeMode(ThemeMode mode) {
    _preferences.themeMode = mode;
    notifyListeners();
  }
}
