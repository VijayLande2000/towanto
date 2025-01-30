import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/resources/fonts.dart';
import 'package:towanto/utils/resources/colors.dart';
import 'package:towanto/utils/common_widgets/Utils.dart';

import '../../utils/repositories/ProfileRepositories/logged_in_user_info_repository.dart';
import '../../utils/repositories/ProfileRepositories/update_account_repository.dart';
import '../../viewModel/profileViewModels/update_account_information_view_model.dart';
import '../Auth/login_screen.dart';
import 'de_activate_account_pop_up.dart';


class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountInfoViewModel(
      ),
      child: const AccountInfoScreenContent(),
    );
  }
}

class AccountInfoScreenContent extends StatefulWidget {
  const AccountInfoScreenContent({Key? key}) : super(key: key);

  @override
  State<AccountInfoScreenContent> createState() => _AccountInfoScreenContentState();
}

class _AccountInfoScreenContentState extends State<AccountInfoScreenContent> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;


  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AccountInfoViewModel>(context, listen: false).fetchAndAssignAccountInfo(context);
    });

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountInfoViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        title: Text(
          "Account Information",
          style: TextStyle(
            fontSize: 20,
            // color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontFamily: MyFonts.LexendDeca_Bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, /*color: AppColors.black*/ size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 20),

                  // Form Fields
                  ...provider.formFields.map(
                        (field) => Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: CustomTextField(
                        controller: field['controller'],
                        label: field['label'],
                        hint: field['hint'],
                        onChanged: (_) => provider.validateField(field['key']),
                        errorText: provider.errors[field['key']],
                        prefixIcon: field['icon'],
                      ),
                    ),
                  ),

                  // Country State City Picker
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 180,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.copyWith(
                            titleMedium: const TextStyle(
                              fontFamily: MyFonts.LexendDeca_Bold,
                              color: AppColors.cardcolor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        child: SelectState(

                          onCountryChanged: (country) {
                            setState(() => selectedCountry = country);
                          },
                          onStateChanged: (state) {
                            setState(() => selectedState = state);
                          },
                          onCityChanged: (city) {
                            setState(() => selectedCity = city);
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Utils.createButton(
                    text: "Update Account",
                    onClick: () => provider.submitAccountInfo(context, selectedCountry, selectedState, selectedCity),
                  ),
                  const SizedBox(height: 20,),
                  GradientButton(text: 'DeActivate account', onClick: () {
                    showLoginPopup(context);

                  },),
                ],
              ),
            ),
          ),

          if (provider.loading) Utils.loadingIndicator(context),
        ],
      ),
    );
  }
}
