import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/common_widgets/Utils.dart';
import '../../utils/network/networkService/app_url.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/HomeViewModels/home_page_data_viewModel.dart';
import 'getBrandsList.dart';

class AllBrands extends StatefulWidget {
  const AllBrands({Key? key}) : super(key: key);

  @override
  State<AllBrands> createState() => _AllBrandsState();
}



class _AllBrandsState extends State<AllBrands> {


  Future<void> fetchAllBrands() async {
    // Obtain the instance of CategoriesListViewModel
    final homePageViewModel = Provider.of<HomePageDataViewModel>(context, listen: false);
    await homePageViewModel.getAllBrandsList(context);
  }

  @override
  void initState() {
    // Fetch data after the initial build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAllBrands();
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        title: const Text(
          'All Brands',
          style: TextStyle(
            // color: AppColors.appBarTitleTextColor,
            fontSize: 20,
            // fontWeight: FontWeight.w600,
            // fontFamily: MyFonts.font_regular,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 1,
      ),
      body: Consumer<HomePageDataViewModel>(
        builder: (context, homePageViewModel, child) {
          if (homePageViewModel.isLoading) {
            return Utils.loadingIndicator(context);
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  buildAllBrandsGrid(homePageViewModel, context),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildAllBrandsGrid(HomePageDataViewModel homePageDataViewModel, BuildContext context) {
    if (homePageDataViewModel.brandsList == null ||
        homePageDataViewModel.brandsList!.brands == null ||
        homePageDataViewModel.brandsList!.brands!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No brands available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontFamily: MyFonts.font_regular,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate dynamic grid properties
          final screenWidth = MediaQuery
              .of(context)
              .size
              .width;
          final crossAxisCount = screenWidth > 600 ? 3 : 2;
          final aspectRatio = screenWidth > 600 ? 0.9 : 0.85;

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: aspectRatio,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: homePageDataViewModel.brandsList!.brands!.length,
            itemBuilder: (context, index) {
              final brand = homePageDataViewModel.brandsList!.brands![index];

              return LayoutBuilder(
                builder: (context, cardConstraints) {
                  final cardWidth = cardConstraints.maxWidth;
                  final dynamicIconSize = cardWidth * 0.25;

                  return Card(
                    color: AppColors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BrandProductsList(brandName: brand.name,brandid: brand.id,),
                          ),
                        );
                        // Navigate to brand detail page if needed
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: EdgeInsets.all(cardWidth * 0.04),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: brand.imageUrl != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      '${brand.imageUrl}',
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error,
                                          stackTrace) =>
                                          Icon(
                                            Icons.camera,
                                            size: dynamicIconSize,
                                            color: Colors.grey.shade400,
                                          ),
                                    ),
                                  )
                                      : Icon(
                                    Icons.camera,
                                    size: dynamicIconSize,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  brand.name ?? 'Unknown Brand',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.appBarTitleTextColor,
                                    fontFamily: MyFonts.font_regular,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }}