import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/view/Home/product_details_screen.dart';
import 'package:towanto/viewModel/HomeViewModels/get_search_product_list_view_model.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/network/networkService/app_url.dart';
import '../../utils/resources/colors.dart';
import '../../model/HomeModels/search_product_model.dart';
import '../../utils/resources/fonts.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({Key? key}) : super(key: key);

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  void _handleSearch(String query, SearchProductViewModel viewModel) {
    setState(() {
      isSearching = query.isNotEmpty;
    });

    if (query.isNotEmpty) {
      // Debounce the API call to avoid too many requests
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_searchController.text == query) {
          viewModel.getproductsList(context, query);
        }
      });
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Search for products',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
              fontFamily: MyFonts.font_regular,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Type in the search bar to find products',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
              fontFamily: MyFonts.font_regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
              fontFamily: MyFonts.font_regular,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
              fontFamily: MyFonts.font_regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Products> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          color: AppColors.backgroundcolormenu,
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
                      categoryId: product.id.toString(),
                    ),
                  ));

              // Handle product tap
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          '${AppUrl.baseurlauth}web/image?model=product.product&id=${product.id}&field=image_1920' ??
                              '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Product Name
                  const SizedBox(height: 8),
                  SizedBox(
                    // height: 40,
                    child: Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: MyFonts.font_regular,
                      ),
                    ),
                  ),

                  // Price
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        (product.listPrice == null || product.listPrice == 0 || product.listPrice == 0.0)
                            ? 'Price Locked'
                            : '₹ ${product.listPrice}',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: MyFonts.font_regular,
                        ),
                      ),

                      ],
                  ),
                  SizedBox(height: 2,),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        // Determine if the star should be filled, half-filled, or empty
                        if (index < product.rating.floor()) {
                          return Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          );
                        } else if (index < product.rating && product.rating % 1 != 0) {
                          return Icon(
                            Icons.star_half,
                            color: Colors.amber,
                            size: 16,
                          );
                        } else {
                          return Icon(
                            Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }
                      }),
                      SizedBox(width: 8),
                      // Display the review count next to the stars
                      Flexible(
                        child: Text(
                          '(${product.ratingCount} reviews)',
                          style: TextStyle(
                            fontFamily: MyFonts.font_regular,
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )

                    ],
                  ),

                  // const SizedBox(height: 4),
                  // product.description != false && product.description != null
                  //     ? Text(
                  //         product.description.toString() ?? '',
                  //         maxLines: 2,
                  //         overflow: TextOverflow.ellipsis,
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           color: AppColors.grey,
                  //           fontWeight: FontWeight.normal,
                  //           fontFamily: MyFonts.font_regular,
                  //         ),
                  //       )
                  //     : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Search Products',
          style: TextStyle(
            fontFamily: MyFonts.font_regular,
            // color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        // backgroundColor: AppColors.brightBlue,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back,
              // color: AppColors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
      ),
      body: Consumer<SearchProductViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Search Bar
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   child: TextField(
              //     controller: _searchController,
              //     focusNode: _searchFocusNode,
              //     onChanged: (query) => _handleSearch(query, viewModel),
              //     decoration: InputDecoration(
              //       hintText: 'Search products...',
              //       hintStyle: TextStyle(
              //         fontSize: 14,
              //         color: AppColors.black,
              //         fontWeight: FontWeight.normal,
              //         fontFamily: MyFonts.Lexenddeca_regular,
              //       ),
              //       prefixIcon: const Icon(Icons.search, color: AppColors.grey),
              //       filled: true,
              //       fillColor: Colors.white,
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: BorderSide.none,
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: BorderSide(color: Colors.grey.shade300),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: BorderSide(color: Colors.blue.shade400),
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      onChanged: (query) => _handleSearch(query, viewModel),
                      decoration: InputDecoration(
                        hintText: '',
                        prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade400),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 48,
                      top: 0,
                      bottom: 0,
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, child) {
                          return value.text.isEmpty
                              ? Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Search',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: MyFonts.font_regular,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                DefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: MyFonts.font_regular,
                                  ),
                                  child: AnimatedTextKit(
                                    pause: const Duration(milliseconds: 1000),
                                    animatedTexts: [
                                      RotateAnimatedText(
                                        'seeds...',
                                        duration: const Duration(milliseconds: 1000),
                                      ),
                                      RotateAnimatedText(
                                        'pesticides...',
                                        duration: const Duration(milliseconds: 1000),
                                      ),
                                      RotateAnimatedText(
                                        'machinery...',
                                        duration: const Duration(milliseconds: 1000),
                                      ),
                                      RotateAnimatedText(
                                        'seasonal products...',
                                        duration: const Duration(milliseconds: 000),
                                      ),
                                      RotateAnimatedText(
                                        'brands...',
                                        duration: const Duration(milliseconds: 2000),
                                      ),
                                    ],
                                    repeatForever: true,
                                    isRepeatingAnimation: true,
                                  ),
                                ),
                              ],
                            ),
                          )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Content Area
              Expanded(
                child: viewModel.loading
                    ? Center(
                        child: Utils.loadingIndicator(
                            context), // Corrected this line
                      )
                    : !isSearching
                        ? _buildEmptyState()
                        : viewModel.products.isEmpty
                            ? _buildNoResultsFound()
                            : _buildProductGrid(viewModel.products),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
