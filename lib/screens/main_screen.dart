import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'digital_pantry_screen.dart';
import 'scan_receipt_screen.dart';
import 'recipe_suggestions_screen.dart';
import 'more_menu_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  /// Allows child screens to switch the active tab in the bottom navigation bar.
  static void switchTab(BuildContext context, int index) {
    final _MainScreenState? state = context
        .findAncestorStateOfType<_MainScreenState>();
    state?.switchTab(index);
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const DigitalPantryScreen(),
    const ScanReceiptScreen(),
    const RecipeSuggestionsScreen(),
    const MoreMenuScreen(),
  ];

  void switchTab(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody:
          true, // Allows the screens to render behind the floating nav bar
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: Container(
          // Key is crucial for AnimatedSwitcher to recognize different views
          key: ValueKey<int>(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
