import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/view/Home/product_details_screen.dart';

import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/network/networkService/app_url.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/CartViewModels/add_to_cart_viewModel.dart';
import '../../viewModel/HomeViewModels/GetBrandsByID_ViewModel.dart';
import '../../viewModel/HomeViewModels/filter_list_view_model.dart';
import '../../viewModel/HomeViewModels/home_page_data_viewModel.dart';
import '../Cart/cart_screen.dart';
import 'filter_bottom_sheet.dart';
import 'home_screen.dart';

class BrandProductsList extends StatefulWidget {
  final String? brandName; // Optional parameter
  final dynamic brandid; // Optional parameter


  const BrandProductsList({Key? key, this.brandName,this.brandid}) : super(key: key);

  @override
  State<BrandProductsList> createState() => _BrandProductsListState();
}

class _BrandProductsListState extends State<BrandProductsList> {
  String? partnerId;



  Future<void> fetchBrandProductsList() async {
    // Obtain the instance of GetBrandsByIDViewModel
    final getBrandsViewModel = Provider.of<GetBrandsByIDViewModel>(
        context, listen: false);
    await getBrandsViewModel.getBrandsbyIDViewModelApi(widget.brandid, context);
  }

  Future<void> fetchPartnerID() async {
    // Obtain the instance of GetBrandsByIDViewModel
    partnerId = await PreferencesHelper.getString("partnerId");
  }

  @override
  void initState() {
    super.initState();

    // Fetch data after the initial build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchPartnerID();
      fetchBrandProductsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        title: Text(
          widget.brandName ?? "Brand Products",
          style: TextStyle(
            fontSize: 20,
            fontFamily: MyFonts.font_regular,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Clear selections in ViewModel
              final filterViewModel =
              Provider.of<FilterListViewModel>(context, listen: false);
              filterViewModel.clearSelections();
              Navigator.pop(context); // Use pop instead of push to go back
            },
          );
        }),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),

        ],
      ),
      body: Consumer<GetBrandsByIDViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.getBrandsLoading) {
            return Center(child: Utils.loadingIndicator(context));
          } else if (viewModel.responseData == null) {
            return Center(child: Text("No products found"));
          } else {
            return buildProductGrid(context, viewModel, partnerId);
          }
        },
      ),
    );
  }

  Widget buildProductGrid(BuildContext context,
      GetBrandsByIDViewModel viewModel,
      String? partnerId) {
    // Don't use Expanded here as it's not inside a flex widget
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          childAspectRatio: 0.65,
        ),
        itemCount: viewModel.responseData?.products.length ?? 0,
        itemBuilder: (context, index) {
          final product = viewModel.responseData!.products[index];

          return Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(
                      categoryId: product.id?.toString() ?? "",
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: product.id != null
                              ? Image.network(
                            '${AppUrl.baseurlauth}web/image?model=product.product&id=${product.id}&field=image_1920',
                            fit: BoxFit.fitHeight,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(
                                  Icons.error,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                          )
                              : Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: MyFonts.font_regular,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    buildRatingRow(product.rating,
                        product.ratingCount),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            (product.price == null ||
                                product.price == 0 ||
                                product.price.toString().isEmpty)
                                ? 'Price Locked'
                                : '₹${product.price}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: MyFonts.font_regular,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    (product.price == null ||
                        product.price == 0 ||
                        product.price.toString().isEmpty)?SizedBox.shrink(): Consumer<AddToCartViewModel>(
                      builder: (context, cartViewModel, child) {
                        bool isInCart = product.id != null && cartViewModel.isInCart(product.id!);
                        bool isLoading = product.id != null && cartViewModel.isLoading(product.id!);

                        return SizedBox(
                          width: double.infinity,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: (isLoading || product.id == null)
                                ? null
                                : () async {
                              if (!isInCart) {
                                cartViewModel.toggleCartStatus(
                                  partnerId!,
                                  product.id!,
                                  // int.tryParse(product.minimumOrderQty.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1,
                                  1,
                                  context,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isInCart
                                  ? Colors.grey[300]
                                  : const Color(0xFFFFD814),
                              foregroundColor: Colors.black87,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.brightBlue,
                              ),
                            )
                                : Text(
                              isInCart
                                  ? 'Added to Cart'
                                  : 'Add to Cart',
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: MyFonts.font_regular,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildRatingRow(double ratingAvg, int ratingCount) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final reviewText = ratingCount <= 1 ? 'review)' : 'reviews)';

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Star rating (not flexible to preserve stars)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                if (index < ratingAvg.floor()) {
                  return const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 14,
                  );
                } else if (index < ratingAvg && ratingAvg % 1 != 0) {
                  return const Icon(
                    Icons.star_half,
                    color: Colors.amber,
                    size: 14,
                  );
                } else {
                  return const Icon(
                    Icons.star_border,
                    color: Colors.amber,
                    size: 14,
                  );
                }
              }),
            ),
            const SizedBox(width: 4),
            // Review count in a flexible container
            Flexible(
              child: Text(
                '($ratingCount $reviewText',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: MyFonts.font_regular,
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}