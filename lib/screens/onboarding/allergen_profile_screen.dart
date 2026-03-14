import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class AllergenProfileScreen extends StatefulWidget {
  final bool isFromSettings;
  const AllergenProfileScreen({super.key, this.isFromSettings = false});

  @override
  State<AllergenProfileScreen> createState() => _AllergenProfileScreenState();
}

class _AllergenProfileScreenState extends State<AllergenProfileScreen> {
  final Map<String, Map<String, dynamic>> _allergens = {
    'Dairy': {'icon': Icons.opacity, 'checked': false},
    'Peanuts': {'icon': Icons.eco, 'checked': false},
    'Shellfish': {'icon': Icons.set_meal, 'checked': false},
    'Soy': {'icon': Icons.spa, 'checked': false},
    'Eggs': {'icon': Icons.egg, 'checked': false},
    'Tree Nuts': {'icon': Icons.psychology, 'checked': false},
    'Wheat': {'icon': Icons.grass, 'checked': false},
    'Fish': {'icon': Icons.phishing, 'checked': false},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Allergen Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Section (Hide if coming from settings)
            if (!widget.isFromSettings)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'STEP 3 OF 4',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          '75% Complete',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.75,
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  // Hero Text
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 36,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Any food allergies?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select any allergens we should know about to customize your FreshNova experience.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),

                  // Allergen Grid List
                  ..._allergens.keys.map((allergen) {
                    final data = _allergens[allergen]!;
                    final isChecked = data['checked'] as bool;
                    final icon = data['icon'] as IconData;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _allergens[allergen]!['checked'] = !isChecked;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: isChecked
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.5)
                                  : Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.1),
                              width: isChecked ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(icon, color: Theme.of(context).primaryColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  allergen,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: isChecked,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (val) {
                                    setState(() {
                                      _allergens[allergen]!['checked'] =
                                          val ?? false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You can always update these preferences later in your profile settings. We use this data to filter out ingredients in your recipe feed.',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Footer Action
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (!widget.isFromSettings)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/onboarding/notifications',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.3),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'SKIP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  if (!widget.isFromSettings) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        // Save logic
                        final userProvider = context.read<UserProvider>();
                        userProvider.preferences.allergens.clear();
                        _allergens.forEach((key, data) {
                          if (data['checked'] == true) {
                            userProvider.toggleAllergen(key);
                          }
                        });

                        if (widget.isFromSettings) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Allergen Profile updated successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          Navigator.pushNamed(
                            context,
                            '/onboarding/notifications',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        widget.isFromSettings ? 'SAVE CHANGES' : 'NEXT STEP',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
