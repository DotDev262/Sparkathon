import 'package:flutter/material.dart';
import 'package:walmart/features/cart/cart_page.dart';
import 'package:walmart/features/home/home_page.dart';
import 'package:walmart/features/deals/deals_page.dart'; // Assuming you have this
import 'package:walmart/features/services/service_page.dart'; // Assuming you have this
import 'package:walmart/features/account/account_page.dart'; // Assuming you have this
import 'package:walmart/features/cart/checkout_page.dart'; // Import the new checkout page
import 'package:walmart/features/ai_voice_call/ai_voice_call_page.dart';
import 'package:walmart/features/circle_search/CircleSearch.dart';
import 'package:walmart/features/ai_chat/ai_chat_page.dart';

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

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    cart: (context) => const CartPage(),
    deals: (context) => const DealsPage(), // Ensure you have a DealsPage
    services: (context) =>
        const ServicesPage(), // Ensure you have a ServicesPage
    account: (context) => const AccountPage(), // Ensure you have an AccountPage
    checkout: (context) => const CheckoutPage(), // Map the new route
    aiVoiceCall: (context) => const AIVoiceCallPage(),
    circlesearch: (context) => const CircleSearchPage(),
    aiChat: (context) => const AIChatPage(),
  };
}
