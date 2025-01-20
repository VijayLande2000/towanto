import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/Address_ViewModels/get_Address_list_view_model.dart';

class SelectAddressScreen extends StatefulWidget {
  final Map<String, dynamic> currentAddress;

  const SelectAddressScreen({Key? key, required this.currentAddress})
      : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  List<Map<String, dynamic>> _savedAddresses = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<GetAddressViewModel>(context, listen: false);
      await provider.getAddressList(context);
      if (provider.addresses.isNotEmpty) {
        setState(() {
          for (var address in provider.addresses) {
            _savedAddresses.add({
              'address': '${address.street}, ${address.city}\n${address.state}, ${address.country}\n${address.zip}',
              'contact': address.phone?.toString() ?? '',
              'name': address.name ?? '',
              'email': address.email ?? '',
              'addressId': address.id?.toString() ?? '',
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        backgroundColor: AppColors.brightBlue,
        title: Text(
          "Select Address",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontFamily: MyFonts.LexendDeca_Bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<GetAddressViewModel>(
        builder: (context, value, child) {
          if (value.loading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.brightBlue),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _savedAddresses.length,
              itemBuilder: (context, index) {
                final address = _savedAddresses[index];
                final addressText = address['address'] ?? '';
                final isSelected = addressText.split('\n')[0] ==
                    widget.currentAddress['street'];

                return  Card(

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
                              value.addresses[index].name.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color:  AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: MyFonts.LexendDeca_Bold
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
                                "${value.addresses[index].city.toString()+" "+value.addresses[index].street.toString()+" "+value.addresses[index].state.toString()+" "+value.addresses[index].country.toString()+" "+value.addresses[index].zip.toString()}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color:  AppColors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: MyFonts.LexendDeca_Bold
                                ),
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
                              value.addresses[index].phone.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color:  AppColors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: MyFonts.LexendDeca_Bold
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
