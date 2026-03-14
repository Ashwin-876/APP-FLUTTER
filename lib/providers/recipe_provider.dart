import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'inventory_provider.dart';

class RecipeProvider with ChangeNotifier {
  String _searchQuery = '';
  List<String> _selectedFilters = [];

  String get searchQuery => _searchQuery;
  List<String> get selectedFilters => _selectedFilters;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFilter(String filter) {
    if (_selectedFilters.contains(filter)) {
      _selectedFilters.remove(filter);
    } else {
      _selectedFilters.add(filter);
    }
    notifyListeners();
  }

  final List<Recipe> _allRecipes = [
    Recipe(
      id: '1',
      title: 'Honey Glazed Salmon with Summer Quinoa',
      prepTimeMinutes: 25,
      imageUrl:
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=500&q=80',
      tags: ['High-protein', 'Gluten-free'],
      requiredIngredients: ['Salmon', 'Quinoa', 'Honey', 'Lemon', 'Spinach'],
      instructions: [
        'Preheat the oven to 400°F (200°C).',
        'Cook the quinoa according to package instructions.',
        'Mix honey, lemon juice, salt, and pepper to create the glaze.',
        'Place salmon fillets on a baking sheet and brush with the honey glaze.',
        'Bake for 12-15 minutes or until salmon is cooked through.',
        'Serve salmon over a bed of quinoa and fresh spinach.'
      ],
    ),
    Recipe(
      id: '2',
      title: 'Rainbow Mediterranean Buddha Bowl',
      prepTimeMinutes: 15,
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&q=80',
      tags: ['Vegan', 'Gluten-free'],
      requiredIngredients: [
        'Quinoa',
        'Chickpeas',
        'Cucumber',
        'Tomatoes',
        'Spinach',
        'Hummus',
      ],
      instructions: [
        'Cook the quinoa according to package instructions.',
        'Drain and rinse chickpeas, then season with olive oil, salt, and cumin.',
        'Dice cucumbers and tomatoes.',
        'Arrange quinoa, chickpeas, cucumber, tomatoes, and spinach in a bowl.',
        'Top with a generous scoop of hummus and serve.'
      ],
    ),
    Recipe(
      id: '3',
      title: 'Avocado Toast with Poached Egg',
      prepTimeMinutes: 10,
      imageUrl:
          'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=500&q=80',
      tags: ['Vegetarian', 'High-protein'],
      requiredIngredients: ['Bread', 'Avocado', 'Egg', 'Lemon'],
      instructions: [
        'Toast the bread until golden brown.',
        'Mash avocado with a squeeze of lemon juice, salt, and black pepper.',
        'Bring a pot of water to a gentle simmer and poach the egg for 3 minutes.',
        'Spread the mashed avocado on the toast and top with the poached egg.',
        'Serve immediately with a pinch of red pepper flakes if desired.'
      ],
    ),
    Recipe(
      id: '4',
      title: 'Keto Garlic Butter Steak Bites',
      prepTimeMinutes: 20,
      imageUrl:
          'https://images.unsplash.com/photo-1558030006-450675393462?w=500&q=80',
      tags: ['Keto', 'High-protein', 'Gluten-free'],
      requiredIngredients: ['Steak', 'Butter', 'Garlic', 'Parsley'],
      instructions: [
        'Cut steak into bite-sized cubes and season generously with salt and pepper.',
        'Heat a large skillet over high heat with a tablespoon of oil.',
        'Sear the steak bites for 2-3 minutes until browned on all sides.',
        'Reduce heat to medium, add butter and minced garlic to the skillet.',
        'Toss the steak in the garlic butter for another minute, then garnish with parsley and serve.'
      ],
    ),
  ];

  List<Recipe> get recipes {
    return _allRecipes.where((recipe) {
      // Filter by search query
      final matchesQuery = recipe.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.requiredIngredients.any((ingredient) => ingredient.toLowerCase().contains(_searchQuery.toLowerCase()));

      // Filter by selected tags
      final matchesTags = _selectedFilters.isEmpty ||
          _selectedFilters.every((filter) => recipe.tags.contains(filter));

      return matchesQuery && matchesTags;
    }).toList();
  }

  Recipe? getRecipeById(String id) {
    try {
      return _allRecipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  // Mock match generation logic
  double calculateMatchPercentage(Recipe recipe, InventoryProvider inventory) {
    if (recipe.requiredIngredients.isEmpty) return 100.0;

    int matchCount = 0;
    final pantryNames = inventory.items
        .map((e) => e.name.toLowerCase())
        .toList();

    for (String requiredItem in recipe.requiredIngredients) {
      if (pantryNames.any(
        (pantryItem) => pantryItem.contains(requiredItem.toLowerCase()),
      )) {
        matchCount++;
      }
    }

    return (matchCount / recipe.requiredIngredients.length) * 100;
  }
}
