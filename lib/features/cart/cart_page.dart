// lib/features/cart/cart_page.dart

import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'package:walmart/core/utils/logger.dart';
import 'package:walmart/core/routes/app_routes.dart'; // Import AppRoutes

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Placeholder for cart items (using a Map for simplicity to simulate quantity)
  final Map<String, int> _cartItems = {
    'Smart TV': 1,
    'Wireless Headphones': 2,
    'Robot Vacuum': 1,
  };

  // Placeholder product data (in a real app, this would come from a product model)
  final Map<String, Map<String, dynamic>> _productData = {
    'Smart TV': {
      'price': 299.00,
      'imageUrl': 'https://via.placeholder.com/80/1E90FF/FFFFFF?text=TV',
    },
    'Wireless Headphones': {
      'price': 49.99,
      'imageUrl': 'https://via.placeholder.com/80/FFD700/000000?text=HP',
    },
    'Robot Vacuum': {
      'price': 149.00,
      'imageUrl': 'https://via.placeholder.com/80/ADFF2F/000000?text=Vacuum',
    },
    'Coffee Maker': {
      'price': 25.00,
      'imageUrl': 'https://via.placeholder.com/80/CD5C5C/FFFFFF?text=Coffee',
    },
  };

  double get _subtotal {
    double total = 0.0;
    _cartItems.forEach((productName, quantity) {
      if (_productData.containsKey(productName)) {
        total += _productData[productName]!['price'] * quantity;
      }
    });
    return total;
  }

  // Simple placeholder for taxes and shipping
  double get _taxes => _subtotal * 0.07; // 7% tax
  double get _shipping =>
      _subtotal > 100 ? 0.00 : 7.99; // Free shipping over $100

  double get _total => _subtotal + _taxes + _shipping;

  void _updateQuantity(String productName, int change) {
    setState(() {
      int currentQuantity = _cartItems[productName] ?? 0;
      int newQuantity = currentQuantity + change;

      if (newQuantity <= 0) {
        _cartItems.remove(productName);
        logger.i('$productName removed from cart.');
      } else {
        _cartItems[productName] = newQuantity;
        logger.i('$productName quantity updated to $newQuantity.');
      }
    });
  }

  void _removeItem(String productName) {
    setState(() {
      _cartItems.remove(productName);
      logger.i('$productName removed from cart.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        title: Text(
          'Cart (${_cartItems.keys.length})', // Display item count in title
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      ); // Go back to home
                      logger.d('Navigating to home from empty cart.');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Start Shopping',
                      style: TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final productName = _cartItems.keys.elementAt(index);
                      final quantity = _cartItems[productName]!;
                      final productInfo = _productData[productName];

                      if (productInfo == null) {
                        logger.w('Product info not found for: $productName');
                        return const SizedBox.shrink(); // Hide if data is missing
                      }

                      return _buildCartItemCard(
                        context,
                        productName: productName,
                        price: productInfo['price'],
                        quantity: quantity,
                        imageUrl: productInfo['imageUrl'],
                        onIncrease: () => _updateQuantity(productName, 1),
                        onDecrease: () => _updateQuantity(productName, -1),
                        onRemove: () => _removeItem(productName),
                      );
                    },
                  ),
                ),
                // Order Summary and Checkout Button
                _buildOrderSummary(context),
              ],
            ),
    );
  }

  Widget _buildCartItemCard(
    BuildContext context, {
    required String productName,
    required double price,
    required int quantity,
    required String imageUrl,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
    required VoidCallback onRemove,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  logger.e('Error loading cart item image: $error');
                  return Container(
                    width: 80,
                    height: 80,
                    color: AppColors.grey300,
                    child: const Center(child: Icon(Icons.broken_image)),
                  );
                },
              ),
            ),
            const SizedBox(width: 12.0),
            // Product Details and Quantity
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      _buildQuantityButton(Icons.remove, onDecrease),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          '$quantity',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.black87,
                              ),
                        ),
                      ),
                      _buildQuantityButton(Icons.add, onIncrease),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.grey600,
                        ),
                        onPressed: onRemove,
                        tooltip: 'Remove item',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey300,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon, size: 20, color: AppColors.black87),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.grey300, width: 1.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow('Taxes', '\$${_taxes.toStringAsFixed(2)}'),
          _buildSummaryRow(
            'Shipping',
            _shipping == 0.0 ? 'Free' : '\$${_shipping.toStringAsFixed(2)}',
          ),
          const Divider(height: 24.0, thickness: 1.0),
          _buildSummaryRow(
            'Total',
            '\$${_total.toStringAsFixed(2)}',
            isTotal: true,
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                logger.i(
                  'Proceed to Checkout tapped. Total: \$${_total.toStringAsFixed(2)}',
                );
                // Navigate to CheckoutPage and pass cart data
                Navigator.pushNamed(
                  context,
                  AppRoutes.checkout,
                  arguments: {
                    'cartItems': _cartItems,
                    'productData': _productData,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Proceed to Checkout',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black87,
                  )
                : Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.black87),
          ),
          Text(
            value,
            style: isTotal
                ? Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  )
                : Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.black87),
          ),
        ],
      ),
    );
  }
}
