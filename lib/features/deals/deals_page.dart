// lib/features/deals/deals_page.dart

import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'package:walmart/core/utils/logger.dart';

class DealsPage extends StatelessWidget {
  const DealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.white, // White app bar as per image
        elevation: 0.5, // Subtle shadow for app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.of(
              context,
            ).pop(); // Go back to the previous screen (Home)
          },
        ),
        title: Text(
          'Deals',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar for Deals
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors
                      .grey300, // Lighter grey for search bar background
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: AppColors.grey),
                    hintText: 'Search', // Shorter hint text for deals search
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // Horizontal Filter/Category Buttons (Action Chips)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      context,
                      'All',
                      true,
                    ), // 'All' is selected by default
                    const SizedBox(width: 8.0),
                    _buildFilterChip(context, 'Rollbacks', false),
                    const SizedBox(width: 8.0),
                    _buildFilterChip(context, 'Clearance', false),
                    const SizedBox(width: 8.0),
                    _buildFilterChip(context, 'Special Buys', false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Main Promotional Banner (Tech Deals)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  onTap: () {
                    logger.d('Tech Deals banner tapped');
                  },
                  borderRadius: BorderRadius.circular(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        child: Image.network(
                          'https://via.placeholder.com/400x200/4CAF50/FFFFFF?text=Tech+Deals', // Placeholder image
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 200,
                                color: AppColors.grey300,
                                child: const Center(
                                  child: Icon(Icons.broken_image),
                                ),
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tech Deals',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black87,
                                  ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Limited time offers on electronics',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.black87),
                            ),
                            Text(
                              'Up to 50% off!',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors
                                        .primaryBlue, // Highlight sales text
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Featured Deals Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Featured Deals',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 180, // Height for horizontal scrollable cards
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildFeaturedDealCard(
                    context,
                    'Kitchen Essentials',
                    'https://via.placeholder.com/150/F8DE7E/000000?text=Kitchen',
                  ),
                  const SizedBox(width: 12.0),
                  _buildFeaturedDealCard(
                    context,
                    'Fashion Finds',
                    'https://via.placeholder.com/150/B0E0E6/000000?text=Fashion',
                  ),
                  const SizedBox(width: 12.0),
                  _buildFeaturedDealCard(
                    context,
                    'Toy Clearance',
                    'https://via.placeholder.com/150/FFC0CB/000000?text=Toys',
                  ),
                  const SizedBox(width: 12.0),
                  _buildFeaturedDealCard(
                    context,
                    'Gaming Gear',
                    'https://via.placeholder.com/150/A52A2A/FFFFFF?text=Gaming',
                  ),
                  const SizedBox(width: 12.0),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // Rollbacks Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Rollbacks',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.8, // Adjust aspect ratio for product cards
                children: [
                  _buildProductDealCard(
                    context,
                    'Smart TV',
                    'https://via.placeholder.com/150/1E90FF/FFFFFF?text=Smart+TV',
                    '\$299.00',
                    '\$399.00',
                  ),
                  _buildProductDealCard(
                    context,
                    'Wireless Headphones',
                    'https://via.placeholder.com/150/FFD700/000000?text=Headphones',
                    '\$49.99',
                    '\$79.99',
                  ),
                  _buildProductDealCard(
                    context,
                    'Gaming Console',
                    'https://via.placeholder.com/150/8A2BE2/FFFFFF?text=Gaming+Console',
                    '\$199.00',
                    '\$249.00',
                  ),
                  _buildProductDealCard(
                    context,
                    'Robot Vacuum',
                    'https://via.placeholder.com/150/ADFF2F/000000?text=Vacuum',
                    '\$149.00',
                    '\$199.00',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // Clearance Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Clearance',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.8,
                children: [
                  _buildProductDealCard(
                    context,
                    'Coffee Maker',
                    'https://via.placeholder.com/150/CD5C5C/FFFFFF?text=Coffee+Maker',
                    '\$25.00',
                    '\$40.00',
                  ),
                  _buildProductDealCard(
                    context,
                    'Blender',
                    'https://via.placeholder.com/150/DDA0DD/FFFFFF?text=Blender',
                    '\$15.00',
                    '\$30.00',
                  ),
                  _buildProductDealCard(
                    context,
                    'Toaster Oven',
                    'https://via.placeholder.com/150/F4A460/000000?text=Toaster',
                    '\$20.00',
                    '\$35.00',
                  ),
                  _buildProductDealCard(
                    context,
                    'Hand Mixer',
                    'https://via.placeholder.com/150/98FB98/000000?text=Mixer',
                    '\$10.00',
                    '\$20.00',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
      // We assume the bottom navigation bar is handled by a parent widget or common scaffold.
      // If this page is a direct tab in a persistent bottom nav bar, it won't have its own.
    );
  }

  // --- Helper Widgets for Deals Page ---

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.white : AppColors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      backgroundColor: isSelected ? AppColors.primaryBlue : AppColors.grey300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: isSelected ? AppColors.primaryBlue : AppColors.grey600,
          width: 0.5,
        ),
      ),
      onPressed: () {
        logger.d('$label filter tapped');
        // TODO: Implement filter logic (e.g., using a Provider or StatefulWidget)
      },
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    );
  }

  Widget _buildFeaturedDealCard(
    BuildContext context,
    String title,
    String imageUrl,
  ) {
    return SizedBox(
      width: 140, // Fixed width for horizontal featured cards
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: InkWell(
          onTap: () {
            logger.d('$title featured deal tapped');
          },
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8.0),
                ),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 100,
                    color: AppColors.grey300,
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDealCard(
    BuildContext context,
    String title,
    String imageUrl,
    String currentPrice,
    String originalPrice,
  ) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
          logger.d('$title product deal tapped');
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8.0),
              ),
              child: Image.network(
                imageUrl,
                height: 120, // Height for product images
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: AppColors.grey300,
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    currentPrice,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColors.darkBlue, // Highlight current price
                    ),
                  ),
                  Text(
                    originalPrice,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: AppColors.grey600,
                      decoration: TextDecoration
                          .lineThrough, // Strikethrough for original price
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
}
