import 'package:flutter/material.dart';
import 'package:walmart/features/cart/cart_page.dart';
import 'package:walmart/features/home/home_page.dart';
import 'package:walmart/features/deals/deals_page.dart';
import 'package:walmart/features/services/service_page.dart';
import 'package:walmart/features/account/account_page.dart';
import 'package:walmart/features/cart/checkout_page.dart';
import 'package:walmart/features/ai_voice_call/ai_voice_call_page.dart';
import 'package:walmart/features/nfc_payments/nfc_payment_page.dart'; // ✅ 1. Import NFC page

class AppRoutes {
  static const String home = '/';
  static const String cart = '/cart';
  static const String deals = '/deals';
  static const String services = '/services';
  static const String account = '/account';
  static const String checkout = '/checkout';
  static const String aiVoiceCall = '/aiVoiceCall';
  static const String nfcPayment = '/nfcPayment'; // ✅ 2. Add route constant

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    cart: (context) => const CartPage(),
    deals: (context) => const DealsPage(),
    services: (context) => const ServicesPage(),
    account: (context) => const AccountPage(),
    checkout: (context) => const CheckoutPage(),
    aiVoiceCall: (context) => const AIVoiceCallPage(),
    nfcPayment: (context) => NFCPaymentPage(), // ✅ 3. Add to routes map
  };
}
