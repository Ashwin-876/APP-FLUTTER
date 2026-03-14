import 'package:uuid/uuid.dart';

class PantryItem {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final DateTime expiryDate;
  final String imageUrl;

  PantryItem({
    String? id,
    required this.name,
    required this.category,
    this.quantity = 1.0,
    this.unit = 'unit',
    required this.expiryDate,
    this.imageUrl = '',
  }) : id = id ?? const Uuid().v4();

  int get daysUntilExpiry {
    final now = DateTime.now();
    final difference = expiryDate.difference(
      DateTime(now.year, now.month, now.day),
    );
    return difference.inDays;
  }
}
