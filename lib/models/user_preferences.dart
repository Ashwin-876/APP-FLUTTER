import 'package:flutter/material.dart';

class UserPreferences {
  String familyName;
  List<String> dietaryPreferences;
  List<String> allergens;
  bool notificationsEnabled;
  String language;
  String measurementUnit;
  ThemeMode themeMode;

  UserPreferences({
    this.familyName = '',
    List<String>? dietaryPreferences,
    List<String>? allergens,
    this.notificationsEnabled = true,
    this.language = 'English (US)',
    this.measurementUnit = 'Metric (kg, grams)',
    this.themeMode = ThemeMode.system,
  })  : dietaryPreferences = dietaryPreferences ?? [],
        allergens = allergens ?? [];
}
