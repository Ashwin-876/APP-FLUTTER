import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';
import 'providers/inventory_provider.dart';
import 'providers/recipe_provider.dart';

import 'screens/get_started_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/onboarding/family_name_screen.dart';
import 'screens/onboarding/dietary_preferences_screen.dart';
import 'screens/onboarding/allergen_profile_screen.dart';
import 'screens/onboarding/notifications_screen.dart';
import 'screens/scan_receipt_screen.dart';
import 'screens/analytics_dashboard_screen.dart';
import 'screens/recipe_suggestions_screen.dart';
import 'screens/digital_pantry_screen.dart';
import 'screens/more_menu_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/add_item_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/receipt_review_screen.dart'; // Added ReceiptReviewScreen
import 'screens/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: const FreshNovaApp(),
    ),
  );
}

class FreshNovaApp extends StatelessWidget {
  const FreshNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreshNova',
      debugShowCheckedModeBanner: false,
      themeMode: context.watch<UserProvider>().preferences.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F8F7), // background-light
        primaryColor: const Color(0xFF21C45D), // primary
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF21C45D),
          secondary: Color(0xFFFB923C),
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF122017), // background-dark
        primaryColor: const Color(0xFF21C45D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF21C45D),
          secondary: Color(0xFFFB923C),
          surface: Color(0xFF1E293B), // slate-800 approximation
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/get_started',
      routes: {
        '/get_started': (context) => const GetStartedScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/onboarding/family_name': (context) => const FamilyNameScreen(),
        '/onboarding/dietary': (context) => const DietaryPreferencesScreen(),
        '/onboarding/allergens': (context) => const AllergenProfileScreen(),
        '/onboarding/notifications': (context) => const NotificationsScreen(),
        '/dashboard': (context) => const MainScreen(),
        '/scan': (context) => const ScanReceiptScreen(),
        '/scan_receipt': (context) => const ScanReceiptScreen(),
        '/receipt': (context) => const ScanReceiptScreen(),
        '/analytics': (context) => const AnalyticsDashboardScreen(),
        '/recipes': (context) => const RecipeSuggestionsScreen(),
        '/recipe_detail': (context) => const RecipeDetailScreen(),
        '/receipt_review': (context) => const ReceiptReviewScreen(), // Added route
        '/pantry': (context) => const DigitalPantryScreen(),
        '/inventory': (context) => const DigitalPantryScreen(),
        '/add-item': (context) => const AddItemScreen(),
        '/more_menu': (context) => const MoreMenuScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
