import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/inventory_provider.dart';
import '../models/pantry_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.energy_savings_leaf,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'FreshNova',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: Colors.grey.shade600,
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 4, bottom: 4),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  width: 2,
                ),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuC8oV9vs2bJ9RoCrDXv0TnslCHDIfAboayOeD-KQsAxozwC46zqJiWtoi3iuJXfGtGDW4uj_59LOLRJ4qB_4qvVdlGF7ce_9aAISSYMD6QDnk9rzjYTleJWfWpoa2WnJPCN8FvGbGQTZIFDiq1cNbJMzefooUdi7FDfIfr2vHI-a3rXnXK5_crYe_43LqgsWmj7SEzAoTYVmFKMH4OpinfU6w8gmIP8qZLWGQrbPAvCG_-Ws5gREmGo_hJgpo6lKZfOnYtSJH91G66B',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Section
                const Text(
                  'Hello, Alex!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your pantry is looking fresh today.',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Quick Stats Cards
                Consumer<InventoryProvider>(
                  builder: (context, inventory, child) {
                    final expiringCount = inventory.items
                        .where((i) => i.daysUntilExpiry <= 2)
                        .length;
                    final totalCount = inventory.items.length;
                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.warning_amber_rounded,
                            value: expiringCount.toString(),
                            label: 'EXPIRING',
                            color: Colors.orange,
                            bgColor: Colors.orange.shade50,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.inventory_2_outlined,
                            value: totalCount.toString(),
                            label: 'TOTAL ITEMS',
                            color: Theme.of(context).primaryColor,
                            bgColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.delete_sweep_outlined,
                            value: '1.2kg',
                            label: 'WASTE',
                            color: Colors.blue,
                            bgColor: Colors.blue.shade50,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Quick Actions
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          print('Dashboard: Clicked Add Item');
                          Navigator.pushNamed(context, '/add-item');
                        },
                        child: _buildActionButton(
                          icon: Icons.add,
                          label: 'Add Item',
                          primary: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          print('Dashboard: Clicked Receipt');
                          Navigator.pushNamed(context, '/receipt');
                        },
                        child: _buildActionButton(
                          icon: Icons.document_scanner_outlined,
                          label: 'Receipt',
                          primary: false,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          print('Dashboard: Clicked Recipes');
                          Navigator.pushNamed(context, '/recipes');
                        },
                        child: _buildActionButton(
                          icon: Icons.restaurant_menu,
                          label: 'Recipes',
                          primary: false,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Expiring Soon Carousel
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Expiring Soon',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'View All',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 196,
                  child: Consumer<InventoryProvider>(
                    builder: (context, inventory, child) {
                      final items = List<PantryItem>.from(inventory.items)
                        ..sort((a, b) => a.daysUntilExpiry.compareTo(b.daysUntilExpiry));
                      
                      final expiringItems = items.where((item) => item.daysUntilExpiry <= 5).take(5).toList();

                      if (expiringItems.isEmpty) {
                        return Center(
                          child: Text(
                            'No items expiring soon!', 
                            style: TextStyle(color: Colors.grey.shade500)
                          )
                        );
                      }

                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: expiringItems.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final item = expiringItems[index];
                          final isExpiring = item.daysUntilExpiry <= 2;
                          final progress = (30 - item.daysUntilExpiry) / 30.0;
                          
                          return _buildExpiringCard(
                            title: item.name,
                            days: '${item.daysUntilExpiry} Days',
                            exp: 'Exp: ${DateFormat('MMM dd').format(item.expiryDate)}',
                            progress: progress.clamp(0.0, 1.0),
                            color: isExpiring ? Colors.red : Colors.orange,
                            imageUrl: item.imageUrl,
                            onTap: () {
                              Navigator.pushNamed(context, '/inventory');
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Recent Activity Feed
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _buildActivityItem(
                        icon: Icons.add_circle_outline,
                        color: Theme.of(context).primaryColor,
                        bgColor: Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.1),
                        action: 'Added ',
                        item: 'Organic Spinach',
                        time: 'Today, 10:24 AM',
                      ),
                      Divider(color: Colors.grey.shade100, height: 1),
                      _buildActivityItem(
                        icon: Icons.remove_circle_outline,
                        color: Colors.red,
                        bgColor: Colors.red.withOpacity(0.1),
                        action: 'Discarded ',
                        item: 'Greek Yogurt',
                        time: 'Yesterday, 06:15 PM • Expired',
                      ),
                      Divider(color: Colors.grey.shade100, height: 1),
                      _buildActivityItem(
                        icon: Icons.restaurant,
                        color: Colors.blue,
                        bgColor: Colors.blue.withOpacity(0.1),
                        action: 'Cooked ',
                        item: 'Pasta Primavera',
                        time: 'Oct 20, 08:30 PM',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool primary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primary
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: primary ? Colors.white : Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiringCard({
    required String title,
    required String days,
    required String exp,
    required double progress,
    required Color color,
    required String imageUrl,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 96,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      days,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 8),
                Text(
                  exp,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String action,
    required String item,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    children: [
                      TextSpan(text: action),
                      TextSpan(
                        text: item,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
