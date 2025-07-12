import 'package:flutter/material.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR to Pay'),
      ),
      body: Center(
        child: Text('QR Scanner Functionality Goes Here'),
      ),
    );
  }
}
