import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pantry_item.dart';
import '../providers/inventory_provider.dart';
import 'main_screen.dart';

class ReceiptReviewScreen extends StatefulWidget {
  const ReceiptReviewScreen({super.key});

  @override
  State<ReceiptReviewScreen> createState() => _ReceiptReviewScreenState();
}

class _ReceiptReviewScreenState extends State<ReceiptReviewScreen> {
  // Mock data representing a parsed receipt
  final List<Map<String, dynamic>> _parsedItems = [
    {
      'item': PantryItem(
        name: 'Organic Honeycrisp Apples',
        category: 'Fruits',
        quantity: 5,
        unit: 'units',
        expiryDate: DateTime.now().add(const Duration(days: 14)),
        imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6faa6?w=500&q=80',
      ),
      'selected': true,
      'confidence': 98,
    },
    {
      'item': PantryItem(
        name: 'Oat Milk Original',
        category: 'Dairy',
        quantity: 1,
        unit: 'carton',
        expiryDate: DateTime.now().add(const Duration(days: 21)),
        imageUrl: 'https://images.unsplash.com/photo-1628178187806-da0be7918a22?w=500&q=80',
      ),
      'selected': true,
      'confidence': 95,
    },
    {
      'item': PantryItem(
        name: 'Baby Spinach',
        category: 'Vegetables',
        quantity: 1,
        unit: 'bag',
        expiryDate: DateTime.now().add(const Duration(days: 5)),
        imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500&q=80',
      ),
      'selected': true,
      'confidence': 92,
    },
    {
      'item': PantryItem(
        name: 'Whole Wheat Bread',
        category: 'Bakery',
        quantity: 1,
        unit: 'loaf',
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500&q=80',
      ),
      'selected': false, // Deselected by default as an example
      'confidence': 70, // Low confidence example
    },
  ];

  void _showEditItemDialog(int index) {
    final item = _parsedItems[index]['item'] as PantryItem;
    final nameController = TextEditingController(text: item.name);
    final quantityController = TextEditingController(text: item.quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final double? newQuantity = double.tryParse(quantityController.text);
                if (newQuantity != null && nameController.text.trim().isNotEmpty) {
                  setState(() {
                    _parsedItems[index]['item'] = PantryItem(
                      id: item.id,
                      name: nameController.text.trim(),
                      category: item.category,
                      quantity: newQuantity,
                      unit: item.unit,
                      expiryDate: item.expiryDate,
                      imageUrl: item.imageUrl,
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addItemToPantry() {
    final inventory = context.read<InventoryProvider>();
    int addedCount = 0;

    for (var parsedData in _parsedItems) {
      if (parsedData['selected'] == true) {
        inventory.addItem(parsedData['item'] as PantryItem);
        addedCount++;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully added $addedCount items to Pantry!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Pop the review screen, then switch the nav bar to the Pantry tab
    Navigator.popUntil(context, ModalRoute.withName('/dashboard'));
    MainScreen.switchTab(context, 1);
  }

  @override
  Widget build(BuildContext context) {
    int selectedCount = _parsedItems.where((i) => i['selected'] == true).length;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Review Scan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Theme.of(context).primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Found ${_parsedItems.length} Items',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Review and select items to add to your pantry',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // List of Items
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _parsedItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final data = _parsedItems[index];
                  final item = data['item'] as PantryItem;
                  final isSelected = data['selected'] as bool;
                  final confidence = data['confidence'] as int;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor.withOpacity(0.05)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.3)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: isSelected,
                            activeColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _parsedItems[index]['selected'] = value;
                              });
                            },
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 48,
                                  height: 48,
                                  color: Colors.grey.shade200,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 24,
                                    color: Colors.grey.shade400,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: isSelected ? null : TextDecoration.lineThrough,
                                color: isSelected ? null : Colors.grey.shade500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (confidence < 80)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Low Match',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '${item.quantity} ${item.unit} • Expires in ${item.daysUntilExpiry} days',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      trailing: isSelected ? IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        color: Colors.grey.shade400,
                        onPressed: () => _showEditItemDialog(index),
                      ) : null,
                    ),
                  );
                },
              ),
            ),

            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: selectedCount > 0 ? _addItemToPantry : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(
                  'Add $selectedCount Items to Pantry',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: selectedCount > 0 ? Colors.white : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
