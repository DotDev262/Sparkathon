// lib/main.dart

import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walmart Companion App',
      debugShowCheckedModeBanner: false, // Set to false for production
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue, // Your primary Walmart blue
        appBarTheme: const AppBarTheme(
          backgroundColor:
              AppColors.primaryBlue, // Use darkBlue for AppBar background
          foregroundColor: AppColors.white, // White text/icons on AppBar
        ),
        scaffoldBackgroundColor:
            AppColors.white, // Default background for most screens
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.primaryBlue, // Accent color
        ),
        fontFamily: 'Bogle', // You can set a custom font here
        // Define text themes if you want consistent typography
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: AppColors.black87,
          ),
          bodyLarge: TextStyle(fontSize: 16.0, color: AppColors.black87),
          bodyMedium: TextStyle(fontSize: 14.0, color: AppColors.black87),
        ),
        useMaterial3: true, // Opt-in to Material 3 design
      ),
      initialRoute: AppRoutes.home, // Set the initial route
      routes: AppRoutes.routes, // Define your routes
    );
  }
}
