import 'package:flutter/material.dart';

class ScanReceiptScreen extends StatefulWidget {
  const ScanReceiptScreen({super.key});

  @override
  State<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends State<ScanReceiptScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startScan() async {
    setState(() => _isScanning = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text('Scanning receipt...'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isScanning = false);
    Navigator.pushNamed(context, '/receipt_review');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scan Receipt',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white70),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('How to Scan'),
                  content: const Text(
                    '1. Place your receipt on a flat surface.\n'
                    '2. Tap the Scan button below.\n'
                    '3. Review the detected items.\n'
                    '4. Confirm and add them to your pantry.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Got It'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scanner Viewfinder
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF0A1628),
                          const Color(0xFF0D2137),
                          const Color(0xFF0A1628),
                        ],
                      ),
                    ),
                  ),

                  // Floating particles / dots
                  ...List.generate(8, (i) {
                    return Positioned(
                      top: (i * 80.0) % 400 + 20,
                      left: (i * 73.0) % 300 + 30,
                      child: Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),

                  // Scanner Frame
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.78,
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Stack(
                        children: [
                          // Darker inside frame
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),

                          // Receipt icon in center
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (ctx, child) {
                                    return Transform.scale(
                                      scale: 0.95 + (_animation.value * 0.05),
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    Icons.receipt_long,
                                    size: 80,
                                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _isScanning
                                      ? 'Analyzing...'
                                      : 'Position receipt here',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Frame border
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor.withOpacity(0.4),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),

                          // Corner indicators
                          Positioned(top: 0, left: 0, child: _buildCorner(top: true, left: true)),
                          Positioned(top: 0, right: 0, child: _buildCorner(top: true, left: false)),
                          Positioned(bottom: 0, left: 0, child: _buildCorner(top: false, left: true)),
                          Positioned(bottom: 0, right: 0, child: _buildCorner(top: false, left: false)),

                          // Animated scanning line
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              final h = MediaQuery.of(context).size.height * 0.45;
                              return Positioned(
                                top: _animation.value * (h - 4),
                                left: 0,
                                right: 0,
                                child: Opacity(
                                  opacity: _isScanning ? 1.0 : (_animation.value < 0.05 || _animation.value > 0.95 ? 0.0 : 0.6),
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Theme.of(context).primaryColor,
                                          Colors.transparent,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tips overlay at bottom of viewfinder
                  Positioned(
                    bottom: 20,
                    left: 32,
                    right: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.white.withOpacity(0.5), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'Good lighting improves accuracy',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Controls Panel
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D2137),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Gallery Button
                      _buildControlButton(
                        icon: Icons.photo_library_outlined,
                        label: 'GALLERY',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gallery upload coming soon'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),

                      // Main Shutter / Scan Button
                      GestureDetector(
                        onTap: _isScanning ? null : _startScan,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isScanning
                                ? Colors.grey.shade700
                                : Theme.of(context).primaryColor,
                            boxShadow: _isScanning
                                ? []
                                : [
                                    BoxShadow(
                                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 4,
                                    ),
                                  ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 3,
                            ),
                          ),
                          child: _isScanning
                              ? const Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.document_scanner,
                                  color: Colors.white,
                                  size: 36,
                                ),
                        ),
                      ),

                      // Flash / QR toggle Button
                      _buildControlButton(
                        icon: Icons.qr_code_scanner,
                        label: 'QR CODE',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('QR code scanning coming soon'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tap the button to scan your receipt',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
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

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(icon, color: Colors.white70, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({required bool top, required bool left}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? BorderSide(color: Theme.of(context).primaryColor, width: 3)
              : BorderSide.none,
          bottom: !top
              ? BorderSide(color: Theme.of(context).primaryColor, width: 3)
              : BorderSide.none,
          left: left
              ? BorderSide(color: Theme.of(context).primaryColor, width: 3)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: Theme.of(context).primaryColor, width: 3)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(12) : Radius.zero,
          topRight: top && !left ? const Radius.circular(12) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(12) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(12) : Radius.zero,
        ),
      ),
    );
  }
}
