// lib/features/services/services_page.dart

import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'package:walmart/core/utils/logger.dart';
import 'package:walmart/core/routes/app_routes.dart'; // Import AppRoutes

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Services',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI Services Section (New Section for clarity)
              Text(
                'AI Services',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.5,
                children: [
                  _buildServiceCard(
                    context,
                    Icons.message_outlined, // Icon for chat
                    'AI Chat',
                    () {
                      logger.d('AI Chat tapped');
                    },
                  ),
                  _buildServiceCard(
                    context,
                    Icons.phone_outlined, // Icon for voice call
                    'AI Voice Call',
                    () {
                      logger.d('AI Voice Call tapped');
                      Navigator.of(context).pushNamed(
                        AppRoutes.aiVoiceCall,
                      ); // Navigate to AI Voice Call Page
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32.0),

              // In-Store Services Section
              Text(
                'In-Store Services',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.5,
                children: [
                  _buildServiceCard(
                    context,
                    Icons.camera_alt_outlined,
                    'Photo Center',
                    () {
                      logger.d('Photo Center tapped');
                    },
                  ),
                  _buildServiceCard(
                    context,
                    Icons.circle_outlined,
                    'Circle Search',
                    () {
                      logger.d('Circle Search tapped');
                      Navigator.pushNamed(context, AppRoutes.circlesearch);
                    },
                  ),
                  _buildServiceCard(context, Icons.wifi, 'NFC', () {
                    logger.d('NFC tapped');
                  }),
                ],
              ),
              const SizedBox(height: 32.0),

              // Online Services Section
              Text(
                'Online Services',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.5,
                children: [
                  _buildServiceCard(
                    context,
                    Icons.delivery_dining,
                    'Delivery',
                    () {
                      logger.d('Delivery tapped');
                    },
                  ),
                  _buildServiceCard(
                    context,
                    Icons.credit_card,
                    'Credit Card',
                    () {
                      logger.d('Credit Card tapped');
                    },
                  ),
                  _buildServiceCard(
                    context,
                    Icons.card_giftcard,
                    'Gift Cards',
                    () {
                      logger.d('Gift Cards tapped');
                    },
                  ),
                  _buildServiceCard(
                    context,
                    Icons.home_outlined,
                    'Home Services',
                    () {
                      logger.d('Home Services tapped');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widget for Service Cards (unchanged) ---
  Widget _buildServiceCard(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppColors.darkBlue),
              const SizedBox(height: 8.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
