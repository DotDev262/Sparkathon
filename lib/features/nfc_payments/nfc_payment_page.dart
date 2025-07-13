import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCPaymentPage extends StatefulWidget {
  @override
  _NFCPaymentPageState createState() => _NFCPaymentPageState();
}

class _NFCPaymentPageState extends State<NFCPaymentPage> {
  String _nfcData = 'Waiting for NFC...';

  void _startNFCSession() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!isAvailable) {
      setState(() => _nfcData = 'NFC is not available on this device');
      return;
    }

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef == null) {
          setState(() => _nfcData = 'Tag is not NDEF formatted');
          return;
        }

        setState(() => _nfcData = 'Payment Completed using NFC\nTag ID: ${tag.data}');
        await NfcManager.instance.stopSession();
      },
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NFC Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_nfcData),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNFCSession,
              child: Text('Start NFC Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
