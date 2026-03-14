import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanReceiptScreen extends StatefulWidget {
  const ScanReceiptScreen({super.key});

  @override
  State<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends State<ScanReceiptScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _cameraController = MobileScannerController();
  late AnimationController _lineController;
  late Animation<double> _lineAnimation;

  bool _torchOn = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _lineController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      setState(() => _isProcessing = true);
      _cameraController.stop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Barcode detected: ${barcodes.first.rawValue ?? "Processing..."}'),
          backgroundColor: Theme.of(context).primaryColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        Navigator.pushNamed(context, '/receipt_review').then((_) {
          // Resume camera when returning from review
          setState(() => _isProcessing = false);
          _cameraController.start();
        });
      });
    }
  }

  void _captureManually() {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    _cameraController.stop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Processing receipt...'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      Navigator.pushNamed(context, '/receipt_review').then((_) {
        _cameraController.start();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
            icon: Icon(
              _torchOn ? Icons.flash_on : Icons.flash_off,
              color: _torchOn ? Colors.yellow : Colors.white70,
            ),
            tooltip: 'Toggle Flash',
            onPressed: () {
              setState(() => _torchOn = !_torchOn);
              _cameraController.toggleTorch();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Camera View
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Real Camera Feed
                  MobileScanner(
                    controller: _cameraController,
                    onDetect: _onDetect,
                    errorBuilder: (context, error, child) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 64,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Camera access required.\nPlease allow camera permissions in your browser.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () => _cameraController.start(),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Dark overlay outside scan frame
                  _buildOverlay(context),

                  // Scan Frame with corners
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.78,
                      height: MediaQuery.of(context).size.height * 0.42,
                      child: Stack(
                        children: [
                          // Border frame
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor.withOpacity(0.4),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          // Corners
                          Positioned(top: 0, left: 0, child: _buildCorner(top: true, left: true)),
                          Positioned(top: 0, right: 0, child: _buildCorner(top: true, left: false)),
                          Positioned(bottom: 0, left: 0, child: _buildCorner(top: false, left: true)),
                          Positioned(bottom: 0, right: 0, child: _buildCorner(top: false, left: false)),

                          // Animated scan line
                          AnimatedBuilder(
                            animation: _lineAnimation,
                            builder: (context, child) {
                              final h = MediaQuery.of(context).size.height * 0.42;
                              return Positioned(
                                top: _lineAnimation.value * (h - 4),
                                left: 12,
                                right: 12,
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
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Hint label
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.55,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _isProcessing
                              ? 'Processing...'
                              : 'Point camera at your receipt or barcode',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Controls
            Container(
              color: const Color(0xFF0D2137),
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Switch Camera
                  _buildControlButton(
                    icon: Icons.flip_camera_ios_outlined,
                    label: 'FLIP',
                    onTap: () => _cameraController.switchCamera(),
                  ),

                  // Main capture button
                  GestureDetector(
                    onTap: _isProcessing ? null : _captureManually,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isProcessing
                            ? Colors.grey.shade700
                            : Theme.of(context).primaryColor,
                        boxShadow: _isProcessing
                            ? []
                            : [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 4,
                                ),
                              ],
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 3),
                      ),
                      child: _isProcessing
                          ? const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.document_scanner, color: Colors.white, size: 36),
                    ),
                  ),

                  // Gallery
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final double frameW = MediaQuery.of(context).size.width * 0.78;
    final double frameH = MediaQuery.of(context).size.height * 0.42;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.55), BlendMode.srcOut),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),
          Center(
            child: Container(
              width: frameW,
              height: frameH,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
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
          top: top ? BorderSide(color: Theme.of(context).primaryColor, width: 3) : BorderSide.none,
          bottom: !top ? BorderSide(color: Theme.of(context).primaryColor, width: 3) : BorderSide.none,
          left: left ? BorderSide(color: Theme.of(context).primaryColor, width: 3) : BorderSide.none,
          right: !left ? BorderSide(color: Theme.of(context).primaryColor, width: 3) : BorderSide.none,
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
