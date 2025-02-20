import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/model/Address_Models/payment_address_model.dart';

import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/Address_ViewModels/get_Address_list_view_model.dart';
import '../ManageAddress/add_address_screen.dart';

class SelectAddressScreen extends StatefulWidget {
  final Map<String, dynamic> currentAddress;
  String type;

   SelectAddressScreen({Key? key, required this.currentAddress,required this.type})
      : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  List<PaymentAddressModel> _savedAddresses = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<GetAddressViewModel>(context, listen: false);
      await provider.getAddressList(context);
      if (provider.addresses.isNotEmpty) {
        setState(() {
          print("ewgyucd"+widget.type.toString());
            for (var address in provider.addresses) {
              if (widget.type == "Billing Address" && address.type == "billing") {
                _savedAddresses.add(PaymentAddressModel(
                  addressId: address.id!,
                  name: address.firmName,
                  proprietorName: address.proprietorName!,
                  email: address.email!,
                  phone: address.phone!,
                  street: address.street!,
                  city: address.city!,
                  zipcode: address.zipcode,
                  type: address.type!,
                  country: address.countryName?? "",
                  state: address.stateName?? "",
                  // vat: address.vat ?? "",
                ));
              }
              else if (widget.type == "Shipping Address" && address.type == "shipping")
                {
                  _savedAddresses.add(PaymentAddressModel(
                    addressId: address.id!,
                    name: address.firmName,
                    proprietorName: address.proprietorName!,
                    email: address.email!,
                    phone: address.phone!,
                    street: address.street!,
                    city: address.city!,
                    zipcode: address.zipcode,
                    type: address.type!,
                    country: address.countryName?? "",
                    state: address.stateName?? "",
                    // vat: address.vat ?? "",
                  ));
                }
          }
        });
      }
    });
  }

  String? selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        title: Text(
          "Select Address",
          style: TextStyle(
            fontSize: 20,
            // color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontFamily: MyFonts.font_regular,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<GetAddressViewModel>(
        builder: (context, value, child) {
          if (value.loading) {
            return Center(
              child: Utils.loadingIndicator(context),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _savedAddresses.length,
              itemBuilder: (context, index) {
                final address = _savedAddresses[index];
                return  InkWell(
                  onTap: () {
                    selectedAddress= value.addresses[index].id.toString();
                    Navigator.pop(context, address);
                  },
                  child: Card(
                    elevation: 2,
                    color: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Info
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 20, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                address.name.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color:  AppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: MyFonts.font_regular
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Address
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 20, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${address.city}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color:  AppColors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: MyFonts.font_regular
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Phone
                          Row(
                            children: [
                              const Icon(Icons.phone_outlined, size: 20, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                address.phone.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color:  AppColors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: MyFonts.font_regular
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.email_outlined, size: 20, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                address.email.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color:  AppColors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: MyFonts.font_regular
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                /*Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(addressText.isNotEmpty
                        ? addressText
                        : 'Address not available'),
                    subtitle: Text('Contact: ${address['contact'] ?? 'N/A'}'),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () => Navigator.pop(context, address),
                  ),
                );*/
              },
            );
          }
        },
      ),
    );
  }
  Widget _addNewAddressButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddressInfoScreen(),));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brightBlue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add, color:AppColors.whiteColor,),
          SizedBox(width: 8),
          Text(
            'ADD NEW ADDRESS',
            style: TextStyle(
                fontSize: 16,
                color:  AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontFamily: MyFonts.font_regular
            ),
          ),
        ],
      ),
    );
  }

}
