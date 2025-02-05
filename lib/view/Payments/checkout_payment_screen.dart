import 'package:flutter/material.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';


class CheckoutPaymentScreen extends StatefulWidget {

  const CheckoutPaymentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutPaymentScreen> createState() => CheckoutPaymentScreenState();
}

class CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;


  void clearPaymentSelection() {
    setState(() {
      selectedPaymentMethod = null; // Reset selection
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    clearPaymentSelection();
    super.initState();
  }
  static String? selectedPaymentMethod;

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
                        fontFamily: MyFonts.font_Bold,
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
      onTap: () => setState(()  {
        selectedPaymentMethod = title;
        if (title == 'Online Payment') {
          print("hewvckhgde"+title.toString());
           saveSelectedPaymentMethod(title);
         /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OnlinePaymentScreen()),
          );*/
        }
        else{
          saveSelectedPaymentMethod(title);

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
                      fontFamily: MyFonts.font_Bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                      fontFamily: MyFonts.font_regular,
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

  Future<void> saveSelectedPaymentMethod(String title) async {
    await PreferencesHelper.saveString("selectedPaymentMethod",title);
  }
}