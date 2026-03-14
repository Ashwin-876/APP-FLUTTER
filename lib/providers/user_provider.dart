import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences.dart';

class UserProvider with ChangeNotifier {
  final UserPreferences _preferences = UserPreferences();

  UserPreferences get preferences => _preferences;

  UserProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _preferences.familyName = prefs.getString('familyName') ?? '';
    _preferences.allergens =
        prefs.getStringList('allergens') ?? [];
    _preferences.dietaryPreferences =
        prefs.getStringList('dietaryPreferences') ?? [];
    _preferences.notificationsEnabled =
        prefs.getBool('notificationsEnabled') ?? true;
    _preferences.language = prefs.getString('language') ?? 'English';
    _preferences.measurementUnit =
        prefs.getString('measurementUnit') ?? 'Metric';
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    _preferences.themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('familyName', _preferences.familyName);
    await prefs.setStringList(
        'allergens', _preferences.allergens.toList());
    await prefs.setStringList(
        'dietaryPreferences', _preferences.dietaryPreferences.toList());
    await prefs.setBool(
        'notificationsEnabled', _preferences.notificationsEnabled);
    await prefs.setString('language', _preferences.language);
    await prefs.setString('measurementUnit', _preferences.measurementUnit);
    await prefs.setInt('themeMode', _preferences.themeMode.index);
  }

  void updateFamilyName(String name) {
    _preferences.familyName = name;
    _savePreferences();
    notifyListeners();
  }

  void toggleDietaryPreference(String pref) {
    if (_preferences.dietaryPreferences.contains(pref)) {
      _preferences.dietaryPreferences.remove(pref);
    } else {
      _preferences.dietaryPreferences.add(pref);
    }
    _savePreferences();
    notifyListeners();
  }

  void toggleAllergen(String allergen) {
    if (_preferences.allergens.contains(allergen)) {
      _preferences.allergens.remove(allergen);
    } else {
      _preferences.allergens.add(allergen);
    }
    _savePreferences();
    notifyListeners();
  }

  void setNotifications(bool enabled) {
    _preferences.notificationsEnabled = enabled;
    _savePreferences();
    notifyListeners();
  }

  void updateLanguage(String language) {
    _preferences.language = language;
    _savePreferences();
    notifyListeners();
  }

  void updateMeasurementUnit(String unit) {
    _preferences.measurementUnit = unit;
    _savePreferences();
    notifyListeners();
  }

  void updateThemeMode(ThemeMode mode) {
    _preferences.themeMode = mode;
    _savePreferences();
    notifyListeners();
  }
}
