import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'core/routes/app_routes.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isAvailable = await NfcManager.instance.isAvailable();
  logger.d('NFC Available: $isAvailable');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walmart Companion App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
        ),
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.primaryBlue,
        ),
        fontFamily: 'Bogle',
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: AppColors.black87,
          ),
          bodyLarge: TextStyle(fontSize: 16.0, color: AppColors.black87),
          bodyMedium: TextStyle(fontSize: 14.0, color: AppColors.black87),
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes, // NFC should be added in AppRoutes
    );
  }
}
