// lib/screens/checkout_address_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/view/ManageAddress/add_address_screen.dart';
import 'package:towanto/view/ManageAddress/edit_address_screen.dart';
import 'package:towanto/view/Payments/select_address_screen.dart';
import 'package:towanto/viewModel/CartViewModels/cart_list_view_model.dart';

import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/Address_ViewModels/get_Address_list_view_model.dart';

class CheckoutAddressScreen extends StatefulWidget {
  const CheckoutAddressScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutAddressScreen> createState() => _CheckoutAddressScreenState();
}

class _CheckoutAddressScreenState extends State<CheckoutAddressScreen> {
  @override
  void initState() {
    billingAddress.clear();
    shippingAddress.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<GetAddressViewModel>(context, listen: false);
      await provider.getAddressList(context);
      if (provider.addresses.isNotEmpty) {
        setState(() {
          billingAddress = {
            'title': 'Billing Address',
            'city': provider.addresses[0].city ?? '',
            'street': provider.addresses[0].street ?? '',
            'state': provider.addresses[0].state ?? '',
            'country': provider.addresses[0].country ?? '',
            'zipcode': provider.addresses[0].zip ?? '',
            'phone': provider.addresses[0].phone?.toString() ?? '',
            'addressId': provider.addresses[0].id?.toString() ?? '',
            'name': provider.addresses[0].name?.toString() ?? '',
            'email': provider.addresses[0].email?.toString() ?? '',
          };
          shippingAddress = {
            'title': 'Shipping Address',
            'city': provider.addresses[0].city ?? '',
            'street': provider.addresses[0].street ?? '',
            'state': provider.addresses[0].state ?? '',
            'country': provider.addresses[0].country ?? '',
            'zipcode': provider.addresses[0].zip ?? '',
            'phone': provider.addresses[0].phone?.toString() ?? '',
            'addressId': provider.addresses[0].id?.toString() ?? '',
            'name': provider.addresses[0].name?.toString() ?? '',
            'email': provider.addresses[0].email?.toString() ?? '',
          };
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }

  int currentStep = 1;

 static Map<String, dynamic> billingAddress = {};

  static Map<String, dynamic> shippingAddress = {};

  void navigateToStep(int step) {
    setState(() {
      currentStep = step;
    });
  }

  void updateAddress(String type, Map<String, dynamic> newAddress) {
    setState(() {
      if (type == 'Billing Address') {
        billingAddress = {...billingAddress, ...newAddress};
      } else {
        shippingAddress = {...shippingAddress, ...newAddress};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      body: Consumer<GetAddressViewModel>(builder:
          (BuildContext context, GetAddressViewModel value, Widget? child) {
        if (value.loading) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.brightBlue,
          ));
        } else {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // buildStepper(),
                          // const SizedBox(height: 24),
                          AddressCard(
                            title: 'Billing Address',
                            icon: Icons.credit_card,
                            borderColor: Colors.green,
                            address:
                                "${billingAddress['street']}, ${billingAddress['city']}, ${billingAddress['state']}, ${billingAddress['country']}, ${billingAddress['zipcode']}",
                            contact: billingAddress['phone'].toString(),
                            email: billingAddress['email'].toString(),
                            onEdit: () => _handleEdit(context, billingAddress),
                            onChangeAddress: () => ({
                              _handleChangeAddress(context, billingAddress, 'Billing Address',)
                            }) /* _handleChangeAddress(
                                context, billingAddress, 'Billing Address')*/
                            ,
                          ),
                          const SizedBox(height: 16),
                          AddressCard(
                            title: 'Shipping Address',
                            icon: Icons.local_shipping,
                            borderColor: Colors.blue,
                            address:
                                "${shippingAddress['street']}, ${shippingAddress['city']}, ${shippingAddress['state']}, ${shippingAddress['country']}, ${shippingAddress['zipcode']}",
                            contact: shippingAddress['phone'].toString(),
                            email: shippingAddress['email'].toString(),
                            onEdit: () => _handleEdit(context, shippingAddress),
                            // Fix the syntax here
                            onChangeAddress: () => _handleChangeAddress(
                                context, shippingAddress, 'Shipping Address'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 16),
                // buildBottomSection(),
              ],
            ),
          );
        }
      }),
    );
  }

  Future<void> _handleEdit(
      BuildContext context, Map<String, dynamic> address) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditAddressScreen(addressData: address, from: "checkoutScreen")),
    );
    if (result != null) {
      updateAddress(address['title'], result);
    }
  }

// Update the _handleChangeAddress function to properly handle the address update:
  Future<void> _handleChangeAddress(BuildContext context,
      Map<String, dynamic> currentAddress, String type) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SelectAddressScreen(currentAddress: currentAddress,type: type),
      ),
    );
    print(("ewcd" + result.toString()));

    if (result != null && result is Map<String, dynamic>) {
      // Create a properly formatted address map with all required fields
      final addressLines = result['address']?.toString().split('\n') ?? [];

      final formattedAddress = {
        'title': type,
        'street': addressLines.isNotEmpty ? addressLines[0].trim() : '',
        'state': addressLines.length > 1 && addressLines[1].contains(',')
            ? addressLines[1].split(',')[1].trim()
            : '',
        'country': addressLines.length > 2 && addressLines[2].contains(',')
            ? addressLines[2].split(',')[0].trim()
            : '',
        'zipcode': addressLines.length > 2
            ? RegExp(r'\b\d{6}\b').firstMatch(addressLines[2])?.group(0) ?? ''
            : '',
        'phone': result['contact'] ?? '',
        'addressId': result['addressId'] ?? '',
        'name': result['name'] ?? '',
        'email': result['email'] ?? '',
      };

      print("dgyfwvg" + formattedAddress.toString());
      // Update the state using the existing updateAddress method
      updateAddress(type, formattedAddress);
    }
  }

  Widget buildStepper() {
    return Row(
      children: [
        _buildStepperItem('Address', 1),
        _buildStepperLine(currentStep > 1),
        _buildStepperItem('Payment', 2),
        _buildStepperLine(currentStep > 2),
        _buildStepperItem('Review', 3),
      ],
    );
  }

  Widget _buildStepperItem(String label, int step) {
    bool isActive = currentStep >= step;
    return Expanded(
      child: GestureDetector(
        onTap: () => navigateToStep(step),
        child: Column(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: isActive ? AppColors.brightBlue : AppColors.grey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  step.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      color: isActive
                          ? AppColors.whiteColor
                          : AppColors.tabtxt_color,
                      fontWeight: FontWeight.bold,
                      fontFamily: MyFonts.LexendDeca_Bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                  fontSize: 14,
                  color:
                      isActive ? AppColors.brightBlue : AppColors.tabtxt_color,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontFamily: MyFonts.LexendDeca_Bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? AppColors.brightBlue : AppColors.grey,
      ),
    );
  }

  Widget buildBottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Amount to be paid',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    fontFamily: MyFonts.Lexenddeca_regular),
              ),
              const SizedBox(height: 4),
              Consumer<CartListViewModel>(
                builder: (context, viewModel, child) {
                  return Text(
                    '₹ ${viewModel.totalAmount.toStringAsFixed(2)}', // Formats the amount to two decimal places
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: MyFonts.LexendDeca_Bold,
                    ),
                  );
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => navigateToStep(currentStep + 1),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColors.brightBlue,
              shadowColor: Colors.green.withOpacity(0.3),
              elevation: 5,
            ),
            child: const Text(
              'Proceed',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: MyFonts.LexendDeca_Bold),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color borderColor;
  final String address;
  final String contact;
  final String email;
  final VoidCallback onEdit;
  final VoidCallback onChangeAddress;

  const AddressCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.borderColor,
    required this.address,
    required this.contact,
    required this.onEdit,
    required this.onChangeAddress,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: MyFonts.LexendDeca_SemiBold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    address,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: MyFonts.Lexenddeca_regular),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Contact: ',
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: MyFonts.Lexenddeca_regular),
                      ),
                      Text(
                        ' $contact',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                            fontFamily: MyFonts.Lexenddeca_regular),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Email: ',
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: MyFonts.Lexenddeca_regular),
                      ),
                      Expanded(
                        child: Text(
                          '$email',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                            fontFamily: MyFonts.Lexenddeca_regular,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              color: AppColors.backgroundcolormenu,
              icon: Icon(Icons.more_vert, color: AppColors.black),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit();
                    break;
                  case 'change':
                    onChangeAddress();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 18,
                        color: AppColors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Edit',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: MyFonts.LexendDeca_Bold),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'change',
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppColors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Change Address',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: MyFonts.LexendDeca_Bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
