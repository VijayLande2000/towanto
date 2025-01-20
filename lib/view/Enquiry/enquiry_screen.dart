import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/resources/fonts.dart';
import 'package:towanto/utils/resources/colors.dart';
import 'package:towanto/utils/common_widgets/Utils.dart';
import '../../viewModel/EnquireyViewModel/enquirey_view_model.dart';
import '../Auth/login_screen.dart';

class EnquiryScreen extends StatelessWidget {
  const EnquiryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EnquiryViewModel(),
      child: const EnquiryScreenContent(),
    );
  }
}

class EnquiryScreenContent extends StatelessWidget {
  const EnquiryScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EnquiryViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.brightBlue,
        title: Text("Enquiry", style: TextStyle(
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Please send your Requirements to any products.we'll do our best to get back to you as soon as possible.",
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: MyFonts.LexendDeca_Bold,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Enquiry Form
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
                  Utils.createButton(
                    text: "Submit",
                    onClick: () => provider.submitEnquiry(context),
                  ),
                ],
              ),
            ),
          ),
          if (provider.loading) Utils.loadingIndicator(context,),
        ],
      ),
    );
  }
}
