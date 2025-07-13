import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  // Controller for the mobile scanner.
  // This allows you to control the camera (e.g., toggle torch, switch camera).
  final MobileScannerController cameraController = MobileScannerController(
    // Optional: Specify barcode formats if you only want to scan QR codes
    // formats: [BarcodeFormat.qrCode],
  );

  String? _scannedCode; // To store the scanned QR code data
  bool _isScanCompleted =
      false; // Flag to prevent multiple detections for the same code

  @override
  void dispose() {
    // It's crucial to dispose of the camera controller when the widget is removed
    cameraController.dispose();
    super.dispose();
  }

  // Helper to show a dialog with the scanned code
  void _showScannedCodeDialog(String code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("QR Code Scanned!"),
          content: Text("Scanned Data:\n$code"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // You can choose to pop the QRScannerPage with the result here:
                // Navigator.of(context).pop(code);
              },
            ),
            TextButton(
              child: const Text("Scan Again"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _restartScan(); // Restart the scanner for another QR code
              },
            ),
          ],
        );
      },
    );
  }

  // Helper to restart the scanner
  void _restartScan() {
    setState(() {
      _isScanCompleted = false;
      _scannedCode = null;
    });
    cameraController.start(); // Restart the camera feed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR to Pay')),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // The actual QR scanner widget
                MobileScanner(
                  controller: cameraController,
                  // The onDetect callback is triggered when a barcode is found.
                  onDetect: (capture) {
                    if (!_isScanCompleted) {
                      // Only process if scan is not yet completed
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        final Barcode barcode = barcodes.first;
                        final String? code =
                            barcode.rawValue; // The actual scanned data

                        if (code != null && code.isNotEmpty) {
                          setState(() {
                            _isScanCompleted = true; // Mark scan as completed
                            _scannedCode = code; // Store the scanned data
                          });
                          cameraController
                              .stop(); // Stop the camera feed to prevent continuous scanning

                          // Use the scanned code for payment or display
                          _showScannedCodeDialog(code);
                        }
                      }
                    }
                  },
                ),
                // Optional: Add a visual overlay to help the user align the QR code
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _scannedCode != null
                  ? 'Scanned QR Code:\n$_scannedCode'
                  : 'Point your camera at a QR code to scan.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (_isScanCompleted) // Show a button to restart scan if needed
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _restartScan,
                child: const Text('Scan Another QR Code'),
              ),
            ),
        ],
      ),
    );
  }
}
