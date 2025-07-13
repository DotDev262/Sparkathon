// lib/features/home/home_page.dart

import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'package:walmart/core/routes/app_routes.dart';
import 'package:walmart/core/utils/logger.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo/walmart_spark.png', // This should be your yellow Spark icon
              height: 32, // Height for a standalone logo in the AppBar
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: AppColors.white),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.cart);
              logger.i('Cart button pressed from AppBar');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section - Search Bar (remains similar)
            Container(
              color: AppColors.primaryBlue,
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.1,
                          ), // Use withOpacity for alpha
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: const TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: AppColors.grey),
                        hintText: 'Search for products, brands and more',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppColors.grey600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            const SizedBox(
              height: 16.0,
            ), // Space between blue section and first tile
            // --- Dynamic Tile Layout based on Walmart example ---

            // Example Large Banner Tile: "Hot July 4th savings"
            _buildPromoTile(
              context,
              imageUrl:
                  'https://tse3.mm.bing.net/th/id/OIP.s4PrSITYWvEkzVdbQcdReAHaEK?pid=Api', // Example 4th of July image
              title: 'Hot July 4th savings',
              description: 'Shop now',
              isLargeBanner: true,
              onTap: () {
                logger.d('Hot July 4th Savings tapped');
              },
            ),
            const SizedBox(height: 16.0),

            // Row of Two Smaller Tiles: "Hot new arrivals" and "Summer home trends"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildPromoTile(
                      context,
                      imageUrl:
                          'https://image.shutterstock.com/image-photo/colorful-collection-shirts-hanging-vibrant-260nw-2274479901.jpg', // Example New Arrivals Fashion image
                      title: 'Hot new arrivals',
                      description: 'Shop now',
                      onTap: () {
                        logger.d('Hot new arrivals tapped');
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildPromoTile(
                      context,
                      imageUrl:
                          'https://image.shutterstock.com/image-photo/modern-apartment-living-room-elegant-260nw-2259160537.jpg', // Example Summer Home Trends image
                      title: 'Summer home trends',
                      description: 'From \$6',
                      onTap: () {
                        logger.d('Summer home trends tapped');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Another Large Promotional Tile/Banner: "Classroom supplies for teachers"
            _buildPromoTile(
              context,
              imageUrl:
                  'https://i5.walmartimages.com/dfw/4ff9c6c9-5ebe/k2-_c0dfdaaa-17c2-481f-b892-7216ce4f49d7.v1.jpg?odnHeight=340&odnWidth=604&odnBg=FFFFFF', // Example Classroom Supplies image
              title: 'Classroom supplies for teachers',
              description: 'Shop now',
              isLargeBanner: true,
              onTap: () {
                logger.d('Classroom supplies tapped');
              },
            ),
            const SizedBox(height: 16.0),

            // Another Row of Two Tiles: "Hot, new beauty" and "Up to 45% off Flash Deals"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildPromoTile(
                      context,
                      imageUrl:
                          'https://media.istockphoto.com/id/1408439145/photo/autumn-skincare-and-autumn-makeup-concept-with-beauty-products-on-table.webp?s=2048x2048&w=is&k=20&c=OanHc1MH-y256GLbPXt2y3PI7GCsTtpvGm_qFbMA8_4=', // Example Beauty Products image
                      title: 'Hot, new beauty',
                      description: 'From \$10',
                      onTap: () {
                        logger.d('Hot new beauty tapped');
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildPromoTile(
                      context,
                      imageUrl:
                          'https://i5.walmartimages.com/dfw/4ff9c6c9-bdb2/k2-_686040ac-3f70-41ca-bf1d-a7513247a626.v1.jpg', // Example Flash Deals image
                      title: 'Up to 45% off',
                      description: 'Flash Deals',
                      onTap: () {
                        logger.d('Flash Deals tapped');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Walmart+ Tile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildPromoTile(
                context,
                imageUrl:
                    'https://tse2.mm.bing.net/th/id/OIP.jlBnBgmkjAxexJVjM25KzwHaEF?r=0&pid=Api', // Example Walmart+ offer image
                title: 'Get 50% off a year of Walmart+',
                description: 'Join Walmart+',
                onTap: () {
                  logger.d('Walmart+ tapped');
                },
              ),
            ),
            const SizedBox(height: 20.0),

            // Local Store Information Section (retained as a useful section)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Local Store Information',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildStoreInfoTile(
                    context,
                    icon: Icons.store,
                    title: 'My Store: 123 Main St',
                    subtitle: 'Open until 10 PM',
                    onTap: () {
                      logger.d('Store info tapped');
                    },
                  ),
                  const SizedBox(height: 12.0),
                  _buildStoreInfoTile(
                    context,
                    icon: Icons.delivery_dining,
                    title: 'Pickup & Delivery',
                    subtitle: null,
                    onTap: () {
                      logger.d('Pickup & Delivery tapped');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      // --- FLOATING ACTION BUTTON ADDED HERE ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AI Chat page using its named route
          Navigator.of(context).pushNamed(AppRoutes.aiChat);
          logger.d('AI Chat FAB tapped'); // Add a log for the FAB
        },
        backgroundColor: AppColors.primaryBlue, // Walmart blue
        foregroundColor: AppColors.white, // White icon
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            30.0,
          ), // Makes it a circular button
        ),
        child: const Icon(Icons.chat_bubble_outline), // Chat icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Places it bottom right, floating

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.grey600,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // Home (already on home)
          } else if (index == 1) {
            // Deals
            Navigator.pushNamed(context, AppRoutes.deals);
          } else if (index == 2) {
            // Services
            Navigator.pushNamed(context, AppRoutes.services);
          } else if (index == 3) {
            // Account
            Navigator.pushNamed(context, AppRoutes.account);
          }
          logger.d('Bottom navigation item $index tapped');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Deals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Services',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  // --- NEW Flexible Promotional Tile Widget ---
  // This widget creates a Card with an image, title, and description,
  // adaptable for various promotional content.
  Widget _buildPromoTile(
    BuildContext context, {
    required String imageUrl,
    required String title,
    String? description,
    bool isLargeBanner =
        false, // True for full-width banners, false for smaller tiles
    required VoidCallback onTap,
  }) {
    return Card(
      // Apply horizontal margin only for large banners, others will get padding from their parent Row
      margin: isLargeBanner
          ? const EdgeInsets.symmetric(horizontal: 16.0)
          : EdgeInsets.zero,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              child: Image.network(
                imageUrl,
                height: isLargeBanner
                    ? 150
                    : 120, // Adjust height based on banner type
                width: double
                    .infinity, // Image takes full width of its parent card
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  logger.e('Error loading promo tile image: $error');
                  return Container(
                    height: isLargeBanner ? 150 : 120,
                    color: AppColors.grey300,
                    child: const Center(child: Icon(Icons.broken_image)),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(
                12.0,
              ), // Consistent padding for text content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isLargeBanner
                          ? 18.0
                          : 16.0, // Larger font for banners
                      color: AppColors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 4.0),
                    // Re-purposing description for "Shop now" or "Join Walmart+" style links
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: AppColors
                            .grey600, // Default for general description
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  // If the description explicitly indicates a call to action like "Shop now"
                  // or "Join Walmart+", we can style it to look like a link.
                  if (description != null &&
                      (description.toLowerCase().contains('shop now') ||
                          description.toLowerCase().contains('join walmart+')))
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        description,
                        style: const TextStyle(
                          color: AppColors
                              .primaryBlue, // Make the "Shop now" text blue
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration
                              .underline, // Add underline for link feel
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets (Only _buildStoreInfoTile is retained) ---

  Widget _buildStoreInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue, size: 30),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16.0,
                color: AppColors.grey600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
