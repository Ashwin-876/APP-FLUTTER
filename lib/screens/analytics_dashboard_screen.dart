import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
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
          'Analytics',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Export Data',
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Exporting analytics data to CSV...'),
                  backgroundColor: Theme.of(context).primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
              
              // Simulate network delay then show success
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data exported successfully!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tabs
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTab('Overview', 0),
                  const SizedBox(width: 32),
                  _buildTab('Waste', 1),
                  const SizedBox(width: 32),
                  _buildTab('Savings', 2),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Consumer<InventoryProvider>(
                builder: (context, inventory, child) {
                  final totalItems = inventory.items.length;
                  final wastedItems = inventory.wastedItems;
                  final consumedItems = inventory.consumedItems;

                  final expiringCount = inventory.items
                      .where((i) => i.daysUntilExpiry <= 2)
                      .length;
                      
                  final mockWasteKg = (wastedItems.length * 1.5).toStringAsFixed(1);
                  final mockMonthlySpending = ((totalItems + wastedItems.length + consumedItems.length) * 4.5)
                      .toStringAsFixed(2);
                      
                  // Calculate rough value based on 3.20 per item
                  final mockWasteValue = (wastedItems.length * 3.2).toStringAsFixed(2);
                  final mockSavingsValue = (consumedItems.length * 4.5).toStringAsFixed(2);
                  
                  final wastePercentage = (totalItems + consumedItems.length) > 0
                      ? (wastedItems.length / (totalItems + consumedItems.length + wastedItems.length)) * 100
                      : 0.0;

                  return _buildTabContent(
                    inventory,
                    totalItems,
                    expiringCount,
                    mockWasteKg,
                    mockMonthlySpending,
                    mockWasteValue,
                    mockSavingsValue,
                    wastePercentage,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
    InventoryProvider inventory,
    int totalItems,
    int expiringCount,
    String mockWasteKg,
    String mockMonthlySpending,
    String mockWasteValue,
    String mockSavingsValue,
    double wastePercentage,
  ) {
    if (_selectedTabIndex == 1) {
      return _buildWasteView(inventory, mockWasteKg, mockWasteValue);
    } else if (_selectedTabIndex == 2) {
      return _buildSavingsView(inventory, mockSavingsValue);
    } else {
      return _buildOverviewView(
        inventory,
        mockWasteKg,
        mockMonthlySpending,
        mockWasteValue,
        wastePercentage,
      );
    }
  }

  Widget _buildOverviewView(
    InventoryProvider inventory,
    String mockWasteKg,
    String mockMonthlySpending,
    String mockWasteValue,
    double wastePercentage,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Waste Trends
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Waste Trends (Last 6 Months)',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$mockWasteKg kg',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.trending_down,
                                          color: Colors.red.shade600,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '15%',
                                          style: TextStyle(
                                            color: Colors.red.shade600,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Mini Bar Chart
                              SizedBox(
                                height: 120,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildChartBar('JAN', 0.4, false),
                                    _buildChartBar('FEB', 0.9, false),
                                    _buildChartBar('MAR', 0.65, true),
                                    _buildChartBar('APR', 0.55, false),
                                    _buildChartBar('MAY', 0.75, false),
                                    _buildChartBar('JUN', 0.45, false),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Key Metrics
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                title: 'Monthly Spending',
                                value: '\$$mockMonthlySpending',
                                trend: '+\$12 vs last mo',
                                icon: Icons.arrow_upward,
                                trendColor: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricCard(
                                title: 'Waste Value',
                                value: '\$$mockWasteValue',
                                trend:
                                    '${wastePercentage.toStringAsFixed(1)}% of budget',
                                icon: Icons.warning_amber_rounded,
                                trendColor: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Waste Reduction Goal
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Waste Reduction Goal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '75%',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              LinearProgressIndicator(
                                value: 0.75,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                                minHeight: 10,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'You\'re ${mockWasteKg}kg into your monthly waste limit of 10kg.',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
  }

  Widget _buildWasteView(InventoryProvider inventory, String mockWasteKg, String mockWasteValue) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Total Wasted Value',
                  value: '\$$mockWasteValue',
                  trend: 'This Month',
                  icon: Icons.trending_down,
                  trendColor: Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  title: 'Wasted Weight',
                  value: '${mockWasteKg}kg',
                  trend: '${inventory.wastedItems.length} items',
                  icon: Icons.scale_outlined,
                  trendColor: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Recently Wasted',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          if (inventory.wastedItems.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No wasted items! Great job!'),
              ),
            )
          else
            ...inventory.wastedItems.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Expired ${DateTime.now().difference(item.expiryDate).inDays} days ago',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '-\$3.20',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildSavingsView(InventoryProvider inventory, String mockSavingsValue) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Most Wasted Items',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade100),
                _buildWastedItem(
                  Icons.eco,
                  Colors.orange,
                  Colors.orange.shade100,
                  'Spinach',
                  '3 times this month',
                  '-\$12.40',
                ),
                Divider(height: 1, color: Colors.grey.shade100),
                _buildWastedItem(
                  Icons.egg,
                  Colors.blue,
                  Colors.blue.shade100,
                  'Whole Milk',
                  '2 times this month',
                  '-\$8.20',
                ),
                Divider(height: 1, color: Colors.grey.shade100),
                _buildWastedItem(
                  Icons.bakery_dining,
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.1),
                  'Bread',
                  '2 times this month',
                  '-\$4.50',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Savings Analysis Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.savings,
                          color: Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Total Savings',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Total Savings',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$$mockSavingsValue this month',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'By using ingredients before expiration, you\'ve saved enough this year to cover 2 weeks of groceries!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.analytics_outlined,
                    size: 100,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Recently Consumed',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          if (inventory.consumedItems.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('You haven\'t marked anything as consumed yet!'),
              ),
            )
          else
            ...inventory.consumedItems.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.check_circle_outline, color: Colors.green),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Saved \$4.50 from wasting',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildChartBar(String label, double heightFraction, bool isPrimary) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 36,
          height: 90 * heightFraction,
          decoration: BoxDecoration(
            color: isPrimary
                ? Theme.of(context).primaryColor
                : Colors.grey.shade100,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required IconData icon,
    required Color trendColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: trendColor, size: 14),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  color: trendColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWastedItem(
    IconData icon,
    Color iconColor,
    Color bgColor,
    String title,
    String subtitle,
    String amount,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
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
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ), // Assuming orange corresponds to secondary
        ],
      ),
    );
  }
}
