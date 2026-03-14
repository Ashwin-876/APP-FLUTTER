import 'package:flutter/material.dart';
import '../models/pantry_item.dart';

class InventoryProvider with ChangeNotifier {
  final List<PantryItem> _items = [];
  final List<PantryItem> _wastedItems = [];
  final List<PantryItem> _consumedItems = [];

  List<PantryItem> get items => _items;
  List<PantryItem> get wastedItems => _wastedItems;
  List<PantryItem> get consumedItems => _consumedItems;

  // Mock initial data
  InventoryProvider() {
    _items.addAll([
      PantryItem(
        name: 'Fresh Spinach',
        category: 'Vegetables',
        quantity: 250,
        unit: 'g',
        expiryDate: DateTime.now().add(const Duration(days: 1)),
        imageUrl:
            'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500&q=80',
      ),
      PantryItem(
        name: 'Organic Milk',
        category: 'Dairy',
        quantity: 1.5,
        unit: 'L',
        expiryDate: DateTime.now().add(const Duration(days: 4)),
        imageUrl:
            'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500&q=80',
      ),
      PantryItem(
        name: 'Bananas',
        category: 'Fruits',
        quantity: 6,
        unit: 'units',
        expiryDate: DateTime.now().add(const Duration(days: 6)),
        imageUrl:
            'https://images.unsplash.com/photo-1571501715201-9c17f7c65c27?w=500&q=80',
      ),
      PantryItem(
        name: 'Ribeye Steak',
        category: 'Meat',
        quantity: 500,
        unit: 'g',
        expiryDate: DateTime.now().add(const Duration(days: 12)),
        imageUrl:
            'https://images.unsplash.com/photo-1603048297172-c92544798d5e?w=500&q=80',
      ),
    ]);

    // Mock historical data
    _wastedItems.addAll([
      PantryItem(
        name: 'Avocado',
        category: 'Fruits',
        quantity: 2,
        unit: 'units',
        expiryDate: DateTime.now().subtract(const Duration(days: 5)),
        imageUrl: '',
      ),
      PantryItem(
        name: 'Yogurt',
        category: 'Dairy',
        quantity: 1,
        unit: 'tub',
        expiryDate: DateTime.now().subtract(const Duration(days: 12)),
        imageUrl: '',
      ),
    ]);

    _consumedItems.addAll([
      PantryItem(
        name: 'Eggs',
        category: 'Dairy',
        quantity: 12,
        unit: 'units',
        expiryDate: DateTime.now().add(const Duration(days: 2)),
        imageUrl: '',
      ),
      PantryItem(
        name: 'Chicken Breast',
        category: 'Meat',
        quantity: 1,
        unit: 'kg',
        expiryDate: DateTime.now().add(const Duration(days: 5)),
        imageUrl: '',
      ),
      PantryItem(
        name: 'Pasta',
        category: 'Pantry',
        quantity: 500,
        unit: 'g',
        expiryDate: DateTime.now().add(const Duration(days: 180)),
        imageUrl: '',
      ),
    ]);
  }

  void addItem(PantryItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void markAsConsumed(String id) {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex != -1) {
      _consumedItems.add(_items[itemIndex]);
      _items.removeAt(itemIndex);
      notifyListeners();
    }
  }

  void markAsWasted(String id) {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex != -1) {
      _wastedItems.add(_items[itemIndex]);
      _items.removeAt(itemIndex);
      notifyListeners();
    }
  }
}
