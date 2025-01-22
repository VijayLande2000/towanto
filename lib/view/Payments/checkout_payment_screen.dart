import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/CartViewModels/cart_list_view_model.dart';
import 'order_confirmation_screen.dart';

class CheckoutPaymentScreen extends StatefulWidget {

  const CheckoutPaymentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {

  late Razorpay _razorpay;
  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _openCheckout() {
    var options = {
      'key': 'rzp_test_2lEuQlBezOWwMq', // Replace with your Test/Live API Key
      'amount': 50000, // Amount in smallest currency unit (e.g., 50000 = 500 INR)
      'name': 'Acme Corp.',
      'description': 'Test Payment',
      'prefill': {
        'contact': '1234567890',
        'email': 'test@example.com',
      },
      'theme': {'color': '#59A8EB'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    debugPrint('Payment Successful: ${response.paymentId}');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Payment Successful: ${response.paymentId}"),
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    debugPrint('Payment Failed: ${response.code} | ${response.message}');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Payment Failed: ${response.message}"),
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet options
    debugPrint('External Wallet: ${response.walletName}');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("External Wallet: ${response.walletName}"),
    ));
  }

  @override
  void dispose() {
    _razorpay.clear(); // Dispose Razorpay when not in use
    super.dispose();
  }

  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // _buildStepper(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: MyFonts.LexendDeca_Bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildPaymentOption(
                      'Online Payment',
                      Icons.payment,
                      'Pay securely using your credit/debit card',
                    ),
                    const SizedBox(height: 16),
                    _buildPaymentOption(
                      'Cash on Delivery',
                      Icons.local_shipping,
                      'Pay when you receive your order',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, String description) {
    bool isSelected = selectedPaymentMethod == title;

    return InkWell(
      onTap: () => setState(() {
        selectedPaymentMethod = title;
        if (title == 'Online Payment') {
          print("hewvckhgde"+title.toString());
          _openCheckout();
         /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OnlinePaymentScreen()),
          );*/
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderConfirmationScreen(),));
        }
      }),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.brightBlue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.brightBlue.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brightBlue.withOpacity(0.1) : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.brightBlue : AppColors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:AppColors.black,
                      fontFamily: MyFonts.LexendDeca_Bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                      fontFamily: MyFonts.Lexenddeca_regular,
                    ),
                  ),
                ],
              ),
            ),
            Radio(
              value: title,
              groupValue: selectedPaymentMethod,
              onChanged: (value) => setState(() => selectedPaymentMethod = value as String),
              activeColor: AppColors.brightBlue,
            ),
          ],
        ),
      ),
    );
  }
}