import 'package:flutter/material.dart';
import 'package:walmart/core/constants/colors.dart';
import 'package:walmart/core/utils/logger.dart';
import 'package:walmart/core/routes/app_routes.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  double walletBalance = 1250.00; // initial wallet balance

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
              // ✅ Mobile Wallet Section
              Text(
                'Mobile Wallet',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black87,
                ),
              ),
              const SizedBox(height: 12.0),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Wallet Balance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black87,
                        ),
                      ),
                      Text(
                        '₹${walletBalance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _showAddMoneyDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Add Money"),
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
                  _buildServiceCard(context, Icons.wifi, 'NFC', () {
                    logger.d('NFC tapped');
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.nfcPayment); // Navigate to NFC page
                  }),
                  // QR Payment Scanner
                  _buildServiceCard(
                    context,
                    Icons.qr_code_scanner,
                    'Scan QR to Pay',
                    () async {
                      logger.d('QR Scanner tapped');
                      final deducted =
                          await Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.qrScanner)
                              as double?;

                      if (deducted != null && deducted > 0) {
                        setState(() {
                          walletBalance -= deducted;
                          if (walletBalance < 0) walletBalance = 0;
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32.0),

              // AI Services Section
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
                    Icons.phone_outlined,
                    'AI Voice Call',
                    () {
                      logger.d('AI Voice Call tapped');
                      Navigator.of(context).pushNamed(AppRoutes.aiVoiceCall);
                    },
                  ),
                  _buildServiceCard(
                    context,
                    Icons.message_outlined,
                    'AI Chat',
                    () {
                      logger.d('AI Chat tapped');
                      Navigator.of(context).pushNamed(AppRoutes.aiChat);
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
                    Icons.search_outlined,
                    'Product Search',
                    () {
                      logger.d('Circle Search tapped');
                      Navigator.pushNamed(context, AppRoutes.circlesearch);
                    },
                  ),
                  _buildServiceCard(
                    context,
                    Icons.camera_alt_outlined,
                    'Photo Center',
                    () {
                      logger.d('Photo Center tapped');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32.0),

              // Other Payment Methods
              Text(
                'Other Payment Methods',
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
                  _buildServiceCard(context, Icons.wifi, 'NFC', () {
                    logger.d('NFC tapped');
                    Navigator.of(context).pushNamed(AppRoutes.nfcPayment);
                  }),
                  _buildServiceCard(
                    context,
                    Icons.credit_card,
                    'Credit / Debit Card',
                    () {
                      logger.d('Credit Card tapped');
                    },
                  ),
                  _buildServiceCard(
                    context,
                    Icons.money,
                    'Cash On Delivery',
                    () {
                      logger.d('COD tapped');
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

  // Add Money Dialog
  void _showAddMoneyDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Money to Wallet"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Enter amount"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                setState(() {
                  walletBalance += amount;
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // Service Card Widget
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
