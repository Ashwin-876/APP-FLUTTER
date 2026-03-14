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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for camera feel
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scan Receipt',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Viewfinder Area
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Simulated Camera Feed
                  Opacity(
                    opacity: 0.8,
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB0NTCDZJ1suJSeuOuApmTle5rhFmSa7XtrmTtr72h3Jy_G1qBGidON-_cCGJC46ElJpvonxgLVdZJzUiJaG-93DPq0D9VysjpD3A6faSTi053bkSlODoDMsUOpJ8ZgjF1hr37djEMzB3b4u_SOlxU0yf1NYoYvKIdVvkGhST7l1nLhOWY460nSKl4boIgWWoF7zOyJGTRK2esa-LfpqwfD7jpNiQmpB4RgxD_bwEmi_tT32ZHAJzeS3-4ahGAGZtj4l8J2cHwv88LD',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Overlay Mask Elements (Darkening outside the frame)
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Stack(
                        children: [
                          // Frame border
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.5),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),

                          // Corner indicators
                          Positioned(
                            top: 0,
                            left: 0,
                            child: _buildCorner(top: true, left: true),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: _buildCorner(top: true, left: false),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: _buildCorner(top: false, left: true),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: _buildCorner(top: false, left: false),
                          ),

                          // Animated Scanning Line
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Positioned(
                                top:
                                    _animation.value *
                                    (MediaQuery.of(context).size.height * 0.5 -
                                        4),
                                left: 0,
                                right: 0,
                                child: Opacity(
                                  opacity:
                                      (_animation.value < 0.05 ||
                                          _animation.value > 0.95)
                                      ? 0.0
                                      : 1.0,
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).primaryColor,
                                          blurRadius: 15,
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

                  // Helpful Tips Overlay
                  Positioned(
                    bottom: 24,
                    left: 32,
                    right: 32,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: const Text(
                        'Place receipt on a flat surface and ensure good lighting for best results.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Camera Controls
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Gallery Button
                  Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.image),
                          color: Theme.of(context).colorScheme.onSurface,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'GALLERY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  // Shutter Button
                  GestureDetector(
                    onTap: () {
                      // Simulate scanning delay and parsing
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Scanning receipt...'),
                          duration: Duration(seconds: 1),
                        ),
                      );

                      Future.delayed(const Duration(seconds: 1), () {
                        if (!context.mounted) return;
                        
                        Navigator.pushNamed(context, '/receipt_review');
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.2),
                          width: 4,
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ),

                  // Flash Button
                  Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.flash_on),
                          color: Theme.of(context).colorScheme.onSurface,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'FLASH',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({required bool top, required bool left}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? BorderSide(color: Theme.of(context).primaryColor, width: 4)
              : BorderSide.none,
          bottom: !top
              ? BorderSide(color: Theme.of(context).primaryColor, width: 4)
              : BorderSide.none,
          left: left
              ? BorderSide(color: Theme.of(context).primaryColor, width: 4)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: Theme.of(context).primaryColor, width: 4)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(16) : Radius.zero,
          topRight: top && !left ? const Radius.circular(16) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(16) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(16) : Radius.zero,
        ),
      ),
    );
  }
}
