// lib/features/account/account_page.dart

import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'package:walmart/core/utils/logger.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.white, // White app bar
        elevation: 0.5, // Subtle shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        title: Text(
          'Account',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Header
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        AppColors.grey300, // Placeholder background
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150/F08080/FFFFFF?text=SC', // Example profile image
                    ),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Fallback if image fails to load
                      logger.e('Error loading profile image: $exception');
                    },
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sophia Carter',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.black87,
                            ),
                      ),
                      Text(
                        'Member since 2021',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(), // Separator
            // Orders Section
            _buildSectionHeader(context, 'Orders'),
            _buildOrderTile(
              context,
              orderId: 'Order #1234567890',
              status: 'Delivered',
              imageUrl:
                  'https://via.placeholder.com/60/9ACD32/000000?text=Product', // Example product image
              onTap: () {
                logger.d('Order 1 tapped');
              },
            ),
            _buildOrderTile(
              context,
              orderId: 'Order #9876543210',
              status: 'Shipped',
              imageUrl:
                  'https://via.placeholder.com/60/6A5ACD/FFFFFF?text=Product', // Example product image
              onTap: () {
                logger.d('Order 2 tapped');
              },
            ),
            _buildAccountOptionTile(
              context,
              title: 'View all orders',
              onTap: () {
                logger.d('View all orders tapped');
              },
              showIcon: false, // Don't show leading icon for this
            ),
            const Divider(),

            // Account Details Section
            _buildSectionHeader(context, 'Account Details'),
            _buildAccountOptionTile(
              context,
              title: 'Personal Information',
              onTap: () {
                logger.d('Personal Information tapped');
              },
            ),
            _buildAccountOptionTile(
              context,
              title: 'Payment Methods',
              onTap: () {
                logger.d('Payment Methods tapped');
              },
            ),
            _buildAccountOptionTile(
              context,
              title: 'Addresses',
              onTap: () {
                logger.d('Addresses tapped');
              },
            ),
            const Divider(),

            // Settings Section
            _buildSectionHeader(context, 'Settings'),
            _buildAccountOptionTile(
              context,
              title: 'Notifications',
              onTap: () {
                logger.d('Notifications tapped');
              },
            ),
            _buildAccountOptionTile(
              context,
              title: 'Communication Preferences',
              onTap: () {
                logger.d('Communication Preferences tapped');
              },
            ),
            _buildAccountOptionTile(
              context,
              title: 'App Behavior',
              onTap: () {
                logger.d('App Behavior tapped');
              },
            ),
            const Divider(),

            // Help & Support Section
            _buildSectionHeader(context, 'Help & Support'),
            _buildAccountOptionTile(
              context,
              title: 'Contact Support',
              onTap: () {
                logger.d('Contact Support tapped');
              },
            ),
            _buildAccountOptionTile(
              context,
              title: 'FAQs',
              onTap: () {
                logger.d('FAQs tapped');
              },
            ),
            const SizedBox(height: 20.0), // Padding at bottom
          ],
        ),
      ),
      // Assuming bottom navigation bar is handled by a parent widget
    );
  }

  // --- Helper Widgets for Account Page ---

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.black, // Darker text for section headers
        ),
      ),
    );
  }

  Widget _buildOrderTile(
    BuildContext context, {
    required String orderId,
    required String status,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 60,
            height: 60,
            color: AppColors.grey300,
            child: const Center(child: Icon(Icons.broken_image, size: 30)),
          ),
        ),
      ),
      title: Text(
        orderId,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.black87,
        ),
      ),
      subtitle: Text(
        status,
        style: TextStyle(
          color: (status == 'Delivered') ? AppColors.green : AppColors.orange,
          fontSize: 13.0,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16.0,
        color: AppColors.grey600,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
    );
  }

  Widget _buildAccountOptionTile(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    bool showIcon = true, // Default to true, false for "View all orders"
  }) {
    return ListTile(
      leading: showIcon
          ? const Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: Colors.transparent,
            )
          : null, // Invisible icon for alignment
      title: Text(
        title,
        style: const TextStyle(fontSize: 16.0, color: AppColors.black87),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16.0,
        color: AppColors.grey600,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.only(
        left: showIcon ? 16.0 : 32.0,
        right: 16.0,
      ), // Adjust padding based on icon presence
      minLeadingWidth: showIcon
          ? 20.0
          : 0.0, // Control space for leading widget
    );
  }
}
