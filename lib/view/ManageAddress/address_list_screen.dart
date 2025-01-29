import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/view/ManageAddress/edit_address_screen.dart';
import 'package:towanto/viewModel/Address_ViewModels/remove_Address_view_model.dart';

import '../../model/Address_Models/get_Address_list_model.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/Address_ViewModels/get_Address_list_view_model.dart';
import 'add_address_screen.dart';

class AddressManager extends StatefulWidget {
  AddressManager({Key? key}) : super(key: key);

  @override
  State<AddressManager> createState() => _AddressManagerState();
}

class _AddressManagerState extends State<AddressManager> {


  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<GetAddressViewModel>(context,listen: false);
      provider.getAddressList(context);
    });

    // TODO: implement initState
    super.initState();
  }
  // Sample data - in real app, this would come from a data source

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        backgroundColor: AppColors.brightBlue,
        title: Text("Manage Address", style: TextStyle(
            fontSize: 20,
            color:  AppColors.black,
            fontWeight: FontWeight.bold,
            fontFamily: MyFonts.LexendDeca_Bold
        ),),

        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: AppColors.black,size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<GetAddressViewModel>(
        builder: (BuildContext context, GetAddressViewModel value, Widget? child) {
          if(value.loading){
            return Center(child: Utils.loadingIndicator(context));
          }
          else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: value.addresses.length+1, // +1 for the add button
                    itemBuilder: (context, index) {
                      // If it's the last item, return the add button
                      if (index == value.addresses.length) {
                        return _addNewAddressButton();
                      }
                      // Otherwise return address card
                      return Padding(
                        key: ValueKey(value.addresses[index].id), // Assign a unique key for each item
                        padding: const EdgeInsets.only(bottom: 16),
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
                                const SizedBox(height: 16),

                                // Action Buttons
                                const Divider(),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditAddressScreen(
                                                addressData: {
                                                  'name': value.addresses[index].name,
                                                  'company_name': "",
                                                  'email': value.addresses[index].email,
                                                  'street': value.addresses[index].street,
                                                  'country': value.addresses[index].country,
                                                  'state': value.addresses[index].state,
                                                  'city': value.addresses[index].city,
                                                  'phone': value.addresses[index].phone,
                                                  'vat': "",
                                                  'zipcode': value.addresses[index].zip,
                                                  'addressId':value.addresses[index].id,
                                                  'type':value.addresses[index].type
                                                },
                                                from: "Manage Address",
                                              ),
                                            ),
                                          );
                                   },
                                        icon: const Icon(Icons.edit_outlined, size: 20),
                                        label: const Text(
                                          'Edit',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.lightBlue,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: MyFonts.Lexenddeca_regular,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Consumer<RemoveAddressViewModel>(
                                      builder: (BuildContext context, RemoveAddressViewModel value2, Widget? child) {

                                        // Check if the addresses list has items before accessing the index
                                        if (value.addresses.isEmpty) {
                                          return Container(
                                            child:   Flexible(
                                              child: Text(
                                                "        ",
                                                style: TextStyle(
                                                  color: AppColors.red,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: MyFonts.LexendDeca_Bold,
                                                ),
                                                overflow: TextOverflow.ellipsis, // Ensures text does not overflow
                                              ),
                                            ),
                                          ); // Return an empty container or a placeholder
                                        }

                                        return Expanded(
                                          child: value2.isLoading(value.addresses[index].id.toString())
                                              ? Row(
                                            children: [
                                              Utils.loadingIndicator(context, size: 16),
                                              const SizedBox(width: 12),
                                              Flexible(
                                                child: Text(
                                                  "Removing...",
                                                  style: TextStyle(
                                                    color: AppColors.red,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: MyFonts.LexendDeca_Bold,
                                                  ),
                                                  overflow: TextOverflow.ellipsis, // Ensures text does not overflow
                                                ),
                                              ),
                                            ],
                                          )
                                              : TextButton.icon(
                                            onPressed: () async {
                                              await value2.removeAddressItem(context, value.addresses[index].id.toString());
                                              // final provider = Provider.of<GetAddressViewModel>(context, listen: false);
                                              // await provider.getupdateAddressList(context);
                                            },
                                            icon: Icon(Icons.delete_outline, size: 20),
                                            label: Text(
                                              'Remove',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors.red,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: MyFonts.Lexenddeca_regular,
                                              ),
                                            ),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: _addNewAddressButton(),
                // ),
              ],
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
                fontFamily: MyFonts.LexendDeca_Bold
            ),
          ),
        ],
      ),
    );
  }
}
