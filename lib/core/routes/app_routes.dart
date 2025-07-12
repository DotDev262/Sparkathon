import 'package:flutter/material.dart';
import 'package:walmart/features/cart/cart_page.dart';
import 'package:walmart/features/home/home_page.dart';
import 'package:walmart/features/deals/deals_page.dart';
import 'package:walmart/features/services/service_page.dart';
import 'package:walmart/features/account/account_page.dart';
import 'package:walmart/features/cart/checkout_page.dart';
import 'package:walmart/features/ai_voice_call/ai_voice_call_page.dart';
import 'package:walmart/features/nfc_payments/nfc_payment_page.dart'; // ✅ 1. Import NFC page
import 'package:walmart/features/circle_search/circle_search.dart';
import 'package:walmart/features/ai_chat/ai_chat_page.dart';
import 'package:walmart/features/qr_scanner/qr_scanner_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String cart = '/cart';
  static const String deals = '/deals';
  static const String services = '/services';
  static const String account = '/account';
  static const String checkout = '/checkout';
  static const String aiVoiceCall = '/aiVoiceCall';
  static const String circlesearch = '/Circlesearch';
  static const String aiChat = '/aiChat';
  static const String nfcPayment = '/nfcPayment';
  static const String qrScanner = '/qrScanner';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    cart: (context) => const CartPage(),
    deals: (context) => const DealsPage(),
    services: (context) => const ServicesPage(),
    account: (context) => const AccountPage(),
    checkout: (context) => const CheckoutPage(),
    aiVoiceCall: (context) => const AIVoiceCallPage(),
    nfcPayment: (context) => NFCPaymentPage(),
    circlesearch: (context) => const CircleSearchPage(),
    aiChat: (context) => const AIChatPage(),
    qrScanner: (context) => const QRScannerPage(),
  };
}
