import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'onboarding/allergen_profile_screen.dart';
import 'onboarding/dietary_preferences_screen.dart';
import 'onboarding/family_name_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final familyName = userProvider.preferences.familyName;
    final displayName = familyName.isEmpty ? 'Awesome Family' : familyName;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FamilyNameScreen(
                      isFromSettings: true,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                color: Theme.of(context).colorScheme.surface,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.2),
                              width: 2,
                            ),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuAZf82RDGBel5PpY11vvo1I8Ayp7TIf1VYlC3KH4Fiy_jqnpQGkVUnW_7EJyzVJIwDNy-iQouiVp7XFN3f5dkd9qMJBCsKXnauWWsvflg1uz0y61134StU_uiELKARMYRqiXDJsvohLHqr6U0Gc9Pzl-useJC5B-CUfEf7ag0rueSOmLKTpFq1utdGl5aDR0vduNLDioX0qS5gVb09jWwRfJnBHWcmaVntxSvbDGCGvL4vVvOEEFYYFhg418LtTsNm-Ri2tG9il_RjA',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'alex.johnson@freshnova.com',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Premium Member',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade200),

            // Safety & Health
            _buildSectionHeader('SAFETY & HEALTH'),
            _buildSettingsItem(
              icon: Icons.grass_outlined,
              iconColor: Colors.green,
              iconBgColor: Colors.green.shade100,
              title: 'Dietary Preferences',
              subtitle: 'Vegetarian, Vegan, Gluten-Free, etc.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DietaryPreferencesScreen(
                      isFromSettings: true,
                    ),
                  ),
                );
              },
            ),
            _buildSettingsItem(
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.orange,
              iconBgColor: Colors.orange.shade100,
              title: 'Allergen Profile',
              subtitle: 'Manage food sensitivities and alerts',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllergenProfileScreen(
                      isFromSettings: true,
                    ),
                  ),
                );
              },
            ),
            Divider(height: 1, color: Colors.grey.shade200),

            // App Notifications
            _buildSectionHeader('APP NOTIFICATIONS'),
            _buildSettingsSwitchItem(
              icon: Icons.notifications_none,
              iconColor: Theme.of(context).primaryColor,
              iconBgColor: Theme.of(context).primaryColor.withOpacity(0.1),
              title: 'Push Notifications',
              subtitle: 'Order status and fresh arrivals',
              value: userProvider.preferences.notificationsEnabled,
              onChanged: (val) {
                userProvider.setNotifications(val);
              },
            ),
            _buildSettingsItem(
              icon: Icons.mail_outline,
              iconColor: Theme.of(context).primaryColor,
              iconBgColor: Theme.of(context).primaryColor.withOpacity(0.1),
              title: 'Email Preferences',
              subtitle: 'Newsletter and weekly reports',
              onTap: () {},
            ),
            Divider(height: 1, color: Colors.grey.shade200),

            // App Preferences
            _buildSectionHeader('APP PREFERENCES'),
            _buildSettingsItem(
              icon: Icons.language,
              iconColor: Colors.grey.shade600,
              iconBgColor: Colors.grey.shade100,
              title: 'Language',
              subtitle: userProvider.preferences.language,
              onTap: () => _showLanguagePicker(context, userProvider),
            ),
            _buildSettingsItem(
              icon: Icons.straighten,
              iconColor: Colors.grey.shade600,
              iconBgColor: Colors.grey.shade100,
              title: 'Measurement Units',
              subtitle: userProvider.preferences.measurementUnit,
              onTap: () => _showMeasurementPicker(context, userProvider),
            ),
            _buildSettingsItem(
              icon: Icons.dark_mode_outlined,
              iconColor: Colors.grey.shade600,
              iconBgColor: Colors.grey.shade100,
              title: 'Appearance',
              subtitle: _getThemeModeString(userProvider.preferences.themeMode),
              onTap: () => _showThemePicker(context, userProvider),
            ),
            Divider(height: 1, color: Colors.grey.shade200),

            // Support
            _buildSectionHeader('SUPPORT'),
            _buildSettingsItem(
              icon: Icons.help_outline,
              iconColor: Colors.grey.shade600,
              iconBgColor: Colors.grey.shade100,
              title: 'Help Center',
              // subtitle omitted deliberately
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.description_outlined,
              iconColor: Colors.grey.shade600,
              iconBgColor: Colors.grey.shade100,
              title: 'Terms of Service',
              // subtitle omitted deliberately
              onTap: () {},
            ),
            Divider(height: 1, color: Colors.grey.shade200),

            // Sign Out
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/get_started');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.red.shade600,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text(
                          'Sign Out',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'FreshNova App v2.4.0',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSwitchItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Theme.of(context).colorScheme.surface,
            activeTrackColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  String _getThemeModeString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System preference';
    }
  }

  void _showLanguagePicker(BuildContext context, UserProvider provider) {
    _showOptionsSheet(
      context: context,
      title: 'Language',
      options: ['English (US)', 'Spanish', 'French', 'German'],
      currentValue: provider.preferences.language,
      onSelected: (val) {
        provider.updateLanguage(val);
      },
    );
  }

  void _showMeasurementPicker(BuildContext context, UserProvider provider) {
    _showOptionsSheet(
      context: context,
      title: 'Measurement Units',
      options: ['Metric (kg, grams)', 'Imperial (lbs, oz)'],
      currentValue: provider.preferences.measurementUnit,
      onSelected: (val) {
        provider.updateMeasurementUnit(val);
      },
    );
  }

  void _showThemePicker(BuildContext context, UserProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Appearance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildThemeRadio(
                  context,
                  title: 'Light',
                  value: ThemeMode.light,
                  groupValue: provider.preferences.themeMode,
                  onChanged: (val) {
                    provider.updateThemeMode(val as ThemeMode);
                    Navigator.pop(context);
                  },
                ),
                _buildThemeRadio(
                  context,
                  title: 'Dark',
                  value: ThemeMode.dark,
                  groupValue: provider.preferences.themeMode,
                  onChanged: (val) {
                    provider.updateThemeMode(val as ThemeMode);
                    Navigator.pop(context);
                  },
                ),
                _buildThemeRadio(
                  context,
                  title: 'System preference',
                  value: ThemeMode.system,
                  groupValue: provider.preferences.themeMode,
                  onChanged: (val) {
                    provider.updateThemeMode(val as ThemeMode);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeRadio(
    BuildContext context, {
    required String title,
    required ThemeMode value,
    required ThemeMode groupValue,
    required Function(ThemeMode?) onChanged,
  }) {
    return RadioListTile<ThemeMode>(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      value: value,
      groupValue: groupValue,
      activeColor: Theme.of(context).primaryColor,
      onChanged: onChanged,
    );
  }

  void _showOptionsSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...options.map((option) {
                  return RadioListTile<String>(
                    title: Text(option, style: const TextStyle(fontWeight: FontWeight.w600)),
                    value: option,
                    groupValue: currentValue,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (val) {
                      onSelected(val!);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
