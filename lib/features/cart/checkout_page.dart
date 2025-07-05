import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'package:walmart/core/utils/logger.dart';

enum PaymentMethod {
  creditCard,
  upiId,
  upiApp,
  // Add more payment methods as needed
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Declare variables to hold the passed cart data
  Map<String, int> _receivedCartItems = {};
  Map<String, Map<String, dynamic>> _receivedProductData = {};

  // State for payment method selection
  PaymentMethod? _selectedPaymentMethod =
      PaymentMethod.creditCard; // Default selection
  final TextEditingController _upiIdController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve arguments when the dependencies change (e.g., when the route is pushed)
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _receivedCartItems = args['cartItems'] as Map<String, int>? ?? {};
      _receivedProductData =
          args['productData'] as Map<String, Map<String, dynamic>>? ?? {};
      logger.d('Received cartItems: $_receivedCartItems');
      logger.d('Received productData: $_receivedProductData');
    } else {
      logger.w('No arguments received for CheckoutPage.');
      // Handle the case where no arguments are passed, e.g., show an error or default to empty.
    }
  }

  @override
  void dispose() {
    _upiIdController.dispose();
    super.dispose();
  }

  // Calculate subtotal based on received data
  double get _subtotal {
    double total = 0.0;
    _receivedCartItems.forEach((productName, quantity) {
      if (_receivedProductData.containsKey(productName)) {
        total += _receivedProductData[productName]!['price'] * quantity;
      }
    });
    return total;
  }

  final double _shippingFee = 7.99; // Example fixed shipping fee
  double get _tax => _subtotal * 0.07; // Example 7% tax

  double get _total => _subtotal + _shippingFee + _tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ), // For back button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Order Summary Section ---
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black87,
              ),
            ),
            const SizedBox(height: 12.0),
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: _receivedCartItems.entries.map((entry) {
                    final productName = entry.key;
                    final quantity = entry.value;
                    final productInfo = _receivedProductData[productName];

                    if (productInfo == null) {
                      logger.w(
                        'Product info not found for: $productName in checkout.',
                      );
                      return const SizedBox.shrink(); // Hide if data is missing
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Image.network(
                              productInfo['imageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                logger.e(
                                  'Error loading checkout item image: $error',
                                );
                                return Container(
                                  width: 50,
                                  height: 50,
                                  color: AppColors.grey300,
                                  child: const Center(
                                    child: Icon(Icons.broken_image),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Qty: $quantity',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: AppColors.grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${(productInfo['price'] * quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPriceRow('Subtotal', _subtotal),
                    _buildPriceRow('Shipping', _shippingFee),
                    _buildPriceRow('Tax', _tax),
                    const Divider(),
                    _buildPriceRow('Total', _total, isTotal: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // --- Shipping Address Section ---
            Text(
              'Shipping Address',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black87,
              ),
            ),
            const SizedBox(height: 12.0),
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextField('Full Name', 'John Doe'),
                    const SizedBox(height: 12.0),
                    _buildTextField('Address Line 1', '123 Main St'),
                    const SizedBox(height: 12.0),
                    _buildTextField('Address Line 2 (Optional)', 'Apt 4B'),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('City', 'Anytown')),
                        const SizedBox(width: 12.0),
                        Expanded(child: _buildTextField('State', 'CA')),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    _buildTextField(
                      'Zip Code',
                      '90210',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // --- Payment Method Section ---
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black87,
              ),
            ),
            const SizedBox(height: 12.0),
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  RadioListTile<PaymentMethod>(
                    title: const Text('Credit Card (Visa ending in 1234)'),
                    value: PaymentMethod.creditCard,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                        logger.d('Payment method selected: Credit Card');
                      });
                    },
                    activeColor: AppColors.primaryBlue,
                    controlAffinity: ListTileControlAffinity
                        .trailing, // Checkbox on the right
                    secondary: const Icon(
                      Icons.credit_card,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const Divider(height: 0),
                  RadioListTile<PaymentMethod>(
                    title: const Text('UPI via UPI ID'),
                    value: PaymentMethod.upiId,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                        logger.d('Payment method selected: UPI via UPI ID');
                      });
                    },
                    activeColor: AppColors.primaryBlue,
                    controlAffinity: ListTileControlAffinity.trailing,
                    secondary: const Icon(
                      Icons.qr_code,
                      color: AppColors.primaryBlue,
                    ), // Example icon
                  ),
                  if (_selectedPaymentMethod == PaymentMethod.upiId)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                      child: _buildTextField(
                        'Enter UPI ID',
                        'e.g., yourname@bank',
                        controller: _upiIdController,
                      ),
                    ),
                  const Divider(height: 0),
                  RadioListTile<PaymentMethod>(
                    title: const Text('Pay via UPI App'),
                    value: PaymentMethod.upiApp,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (PaymentMethod? value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                        logger.d('Payment method selected: UPI App');
                      });
                    },
                    activeColor: AppColors.primaryBlue,
                    controlAffinity: ListTileControlAffinity.trailing,
                    secondary: const Icon(
                      Icons.payment,
                      color: AppColors.primaryBlue,
                    ), // Example icon
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),

            // --- Place Order Button ---
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String paymentStatusMessage = '';
                  switch (_selectedPaymentMethod) {
                    case PaymentMethod.creditCard:
                      logger.i('Placing order with Credit Card');
                      paymentStatusMessage =
                          'Processing Credit Card Payment...';
                      break;
                    case PaymentMethod.upiId:
                      final upiId = _upiIdController.text.trim();
                      if (upiId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your UPI ID'),
                          ),
                        );
                        return; // Stop execution if UPI ID is empty
                      }
                      logger.i('Placing order with UPI ID: $upiId');
                      paymentStatusMessage =
                          'Initiating UPI payment to $upiId...';
                      break;
                    case PaymentMethod.upiApp:
                      logger.i('Placing order with UPI App');
                      paymentStatusMessage = 'Opening UPI app for payment...';
                      break;
                    default:
                      logger.w('No payment method selected.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a payment method.'),
                        ),
                      );
                      return; // Stop execution if no method is selected
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(paymentStatusMessage)));

                  // Simulate order placement success after a short delay
                  Future.delayed(const Duration(seconds: 2), () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order Placed Successfully!'),
                      ),
                    );
                    // Optional: Navigate back to home or an order confirmation page
                    // Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ), // Make button full width
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24.0), // Padding at the bottom
          ],
        ),
      ),
    );
  }

  // Helper widget to build price rows (Subtotal, Shipping, Tax, Total)
  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18.0 : 16.0,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.black : AppColors.black87,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18.0 : 16.0,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.black : AppColors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to build text input fields
  Widget _buildTextField(
    String label,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller, // Added controller
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        labelStyle: const TextStyle(color: AppColors.grey600),
        hintStyle: const TextStyle(color: AppColors.grey),
      ),
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.black87),
    );
  }
}
