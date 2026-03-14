import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.inventory_2_rounded,
    Icons.qr_code_scanner_rounded,
    Icons.restaurant_menu_rounded,
    Icons.menu_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    // We use the Scaffold's background color to create the "cutout" masking illusion
    final Color maskColor = Theme.of(context).scaffoldBackgroundColor;

    return Padding(
      // 1. Floating slightly elevated from the bottom
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate exact width for each item to perfectly align the indicator behind it
          final double itemWidth = constraints.maxWidth / _icons.length;

          return SizedBox(
            height: 94, // 70 (pill) + 24 (popout)
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 70,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111), // Dark pill shape
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                ),
                // 4. Liquid Indicator Circle ("Cutout" illusion)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  left: widget.currentIndex * itemWidth,
                  top:
                      2, // 24 (padding) - 22 (original offset) = 2
                  child: SizedBox(
                    width: itemWidth,
                    height: 60,
                    child: Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF111111,
                          ), // Match the pill color
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                maskColor, // The thick border perfectly masks the pill behind it!
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 2. Tabs & Icons Row
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      _icons.length,
                      (index) => _buildNavItem(index: index, icon: _icons[index]),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem({required int index, required IconData icon}) {
    final bool isActive = widget.currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          print('Bottom Nav: Clicked icon index $index');
          widget.onTap(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          height: 70,
          alignment: Alignment.center,
          // 3. "Pop-Out" Translation Animation
          transform: Matrix4.translationValues(0, isActive ? -24.0 : 0.0, 0),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            scale: isActive ? 1.0 : 0.8,
            child: Icon(
              icon,
              size: 28,
              color: isActive
                  ? const Color(0xFF22C55E) // Vibrant green for active
                  : const Color(0xFF888888), // Light grey for inactive
            ),
          ),
        ),
      ),
    );
  }
}
