import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/common_widgets/Utils.dart';
import 'package:towanto/view/Home/product_details_screen.dart';
import 'package:towanto/viewModel/CartViewModels/cart_list_view_model.dart';
import 'dart:developer' as developer;

import '../../model/HomeModels/category_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/CartViewModels/add_to_cart_viewModel.dart';
import '../../viewModel/HomeViewModels/categories_list_viewModel.dart';
import '../../viewModel/HomeViewModels/home_page_data_viewModel.dart';
import '../Cart/cart_screen.dart';
import 'home_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final CategoryItem category;

  const CategoryDetailScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late final partnerId;
  String? sessionId = ""; // Example session ID

  List<dynamic> idList = [];

  void addId(dynamic id) {
    idList.add(id); // Adds a new id to the list
  }

  @override
  initState() {
    super.initState();
    print("CategoryDetailScreen init state");
    print("CategoryDetailScreen init state"+widget.category.id.toString());

    // Call the API when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchCategories();
      partnerId = await PreferencesHelper.getString("partnerId");
      _fetchCartItems();
    });
  }



  Future<void> _fetchCartItems() async {
    sessionId = await PreferencesHelper.getString("session_id");
    final cartListViewModel =
        Provider.of<CartListViewModel>(context, listen: false);
    cartListViewModel.cartListProductIdsViewModelApi(
        partnerId!, sessionId!, context);
  }

  Future<void> _fetchSubCartItems() async {
    sessionId = await PreferencesHelper.getString("session_id");
    final cartListViewModel =
        Provider.of<CartListViewModel>(context, listen: false);
    cartListViewModel.cartListSubProductIdsViewModelApi(
        partnerId!, sessionId!, context);
  }

  Future<void> fetchCategories() async {
    // Obtain the instance of CategoriesListViewModel
    final categoriesListViewModel =
        Provider.of<CategoriesListViewModel>(context, listen: false);
    await categoriesListViewModel.categoriesListViewModelApi(
        widget.category.id.toString(), context);
  }

  Future<void> fetchSubCategories(dynamic categoryId) async {
    // Obtain the instance of CategoriesListViewModel
    final categoriesListViewModel =
        Provider.of<CategoriesListViewModel>(context, listen: false);

    print("fnvklnf"+widget.category.id.toString());
    print("fnvklnf"+categoryId.toString());
    if(widget.category.id.toString()!=categoryId.toString()){
      await categoriesListViewModel.subCategoriesListViewModelApi(categoryId.toString(), context);
      await _fetchSubCartItems();
    }
  }

  List<String> navigationStack = [];

// Navigation Methods
  void _handleBack() {
    setState(() {
      navigationStack.removeLast();
    });
  }

  Future<void> _handleCategorySelect(BuildContext context, String category) async {
    String? categoryId = _getCategoryId(context, category);
    if (categoryId == null) return;

    print('Selected Category: $category');
    print('Category ID: $categoryId');

    await fetchSubCategories(categoryId);

    if (_hasSubcategories(context, category)) {
      Map<String, dynamic>? subcategories = _getSubcategories(context, category);
      if (subcategories == null) return;

      if (subcategories.length == 1) {
        setState(() {
          navigationStack.add(category);
        });
        String nextCategory = subcategories.keys.first;
        await _handleCategorySelect(context, nextCategory);
      } else {
        setState(() {
          navigationStack.add(category);
        });
      }
    }
  }

// Helper Methods with null safety
  Map<String, dynamic>? _getSubcategories(BuildContext context, String category) {
    Map<String, dynamic>? current = _getCurrentCategories(context);
    if (current == null || !current.containsKey(category)) return null;

    final categoryData = current[category];
    if (categoryData == null || !categoryData.containsKey('subcategories')) return null;

    return categoryData['subcategories'] as Map<String, dynamic>;
  }

  Map<String, dynamic>? _getCurrentCategories(BuildContext context) {
    final viewModel = context.read<CategoriesListViewModel>();
    if (viewModel.categoryTree == null) return null;

    Map<String, dynamic>? current = viewModel.categoryTree;

    for (String category in navigationStack) {
      if (current == null ||
          !current.containsKey(category) ||
          current[category] == null ||
          !current[category].containsKey('subcategories')) {
        return null;
      }
      current = current[category]['subcategories'] as Map<String, dynamic>;
    }
    return current;
  }

  bool _hasSubcategories(BuildContext context, String category) {
    Map<String, dynamic>? current = _getCurrentCategories(context);
    if (current == null ||
        !current.containsKey(category) ||
        current[category] == null ||
        !current[category].containsKey('subcategories')) {
      return false;
    }

    final subcategories = current[category]['subcategories'];
    return subcategories != null && subcategories.isNotEmpty;
  }

  String? _getCategoryId(BuildContext context, String category) {
    Map<String, dynamic>? current = _getCurrentCategories(context);
    if (current == null ||
        !current.containsKey(category) ||
        current[category] == null ||
        !current[category].containsKey('id')) {
      return null;
    }
    return current[category]['id'] as String;
  }

  String _getDisplayName(String fullName) {
    List<String> parts = fullName.split('/');
    return parts.last.trim();
  }

// UI Building Methods
  Widget _buildBackButton() {
    print('Current Navigation Stack: $navigationStack'); // Debug print for stack
    print('Navigation Stack Length: ${navigationStack.length}'); // Debug print for length
    print('Is Navigation Stack Empty: ${navigationStack.isEmpty}'); // Debug print for empty check

    return navigationStack.isNotEmpty && navigationStack.length !=1 ?IconButton(
      icon: const Icon(Icons.close, color: Colors.black),
      padding: const EdgeInsets.only(left: 0),
      onPressed: navigationStack.isNotEmpty && navigationStack.length !=1 ? () {
        print('Back Button Pressed - Stack before: $navigationStack'); // Debug print before pop
        _handleBack();
        print('Back Button Pressed - Stack after: $navigationStack'); // Debug print after pop
      } : null,
    ):SizedBox.shrink();
  }

  Widget _buildBreadcrumb() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: navigationStack.asMap().entries.map((entry) {
          int idx = entry.key;
          String category = entry.value;
          return navigationStack.isNotEmpty && navigationStack.length !=1 ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getDisplayName(category),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (idx < navigationStack.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black54,
                    size: 16,
                  ),
                ),
            ],
          ):SizedBox.shrink();
        }).toList(),
      ),
    );
  }

  Widget _buildNavigationHeader() {
    final categories = _getCurrentCategories(context);
    if (navigationStack.isEmpty || categories == null || categories.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (navigationStack.isNotEmpty) _buildBackButton(),
          Expanded(child: _buildBreadcrumb()),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context) {
    if (context.watch<CategoriesListViewModel>().loading) {
      return Center(child: Utils.loadingIndicator(context));
    }

    final categories = _getCurrentCategories(context);
    if (categories == null || categories.isEmpty) {
      return SizedBox.shrink();
    }

    // Only show categories list if we have categories and navigation has started
    if (navigationStack.isEmpty && categories.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (categories.isNotEmpty) {
          _handleCategorySelect(context, categories.keys.first);
        } else {
          developer.log("No categories available to select.", name: "CategoryDetailScreen");
        }
      });
      return SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: categories.keys
                .map((category) => _buildCategoryChip(context, category))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String category) {
    final hasSubcategories = _hasSubcategories(context, category);
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        color: AppColors.brightBlue,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => _handleCategorySelect(context, category),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getDisplayName(category),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                if (hasSubcategories)
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.white54,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: TextStyle(
            fontSize: 20,
            fontFamily: MyFonts.LexendDeca_Bold,
            // color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back,
              // color: AppColors.black,
            ),
            onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeGrid()));
            },
          );
        }),
        // backgroundColor: AppColors.brightBlue, // Light blue
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart), // Cart Icon
            onPressed: () {
              // Navigate to Cart Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer2<CategoriesListViewModel, CartListViewModel>(
          builder: (context, viewModel, cartListViewModel, child) {
            if (viewModel.loading || cartListViewModel.loading) {
              return Utils.loadingIndicator(context);
            } else if (viewModel.responseList?.products?.isEmpty ?? true) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.asset(
                        "assets/lottie/empty_products.json",
                      ),
                      Text(
                          "No Products Available",
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: MyFonts.LexendDeca_Bold,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          )
                      ),
                    ],
                  ),
                ),
              );



            } else {
              // // Wait until data is available before showing categories
              // if (viewModel.responseList != null && viewModel.categoryTree.isNotEmpty) {
              //   categories = viewModel.categoryTree.keys.toList();
              //   categoryTree = viewModel.categoryTree;
              // }

              return Column(
                children: [
                  _buildNavigationHeader(),
                  _buildCategoriesList(context),
                  Consumer2<CategoriesListViewModel, CartListViewModel>(
                      builder: (context, viewModel, cartListViewModel, child) {
                    if (viewModel.subCategoryLoading || cartListViewModel.subCategoryLoading) {
                      return Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),
                          child: Utils.loadingIndicator(context));
                    } else if (viewModel.responseList!.products.isEmpty) {
                      return Text('No data available');
                    } else {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12.0,
                              crossAxisSpacing: 12.0,
                              childAspectRatio:
                                  0.65, // Adjusted ratio for better fit
                            ),
                            itemCount: viewModel.responseList!.products.length,
                            itemBuilder: (context, index) {
                              final product =
                                  viewModel.responseList!.products[index];
                              bool alreadyAddedToCart = cartListViewModel
                                  .productIds
                                  .contains(product.id.toString());

                              print(
                                  "product id = ${product.id.toString()}"); // Ensure id is a string
                              cartListViewModel.productIds.forEach((element) {
                                print(
                                    "id = ${element.toString()}"); // Ensure each element in productIds is a string
                              });

                              print("alreadyAddedToCart = $alreadyAddedToCart");

                              print("dcxdc" + alreadyAddedToCart.toString());
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
                                        builder: (context) =>
                                            ProductDetailsPage(
                                                categoryId:
                                                    product.id.toString()),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Product Image
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Center(
                                              child: Image.network(
                                                'https://towanto-ecommerce-mainbranch-16118324.dev.odoo.com/web/image?model=product.product&id=${product.id}&field=image_1920',
                                                // width: 48, // Adjust size as needed
                                                // height: 48, // Adjust size as needed
                                                fit: BoxFit.fitHeight,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Icon(
                                                  Icons
                                                      .error, // Fallback icon in case of an error
                                                  size: 48,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Product Details
                                        const SizedBox(height: 8),
                                        // Product Name
                                        SizedBox(
                                          height: 40, // Fixed height for title
                                          child: Text(
                                            product.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),

                                        // Rating
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Row(
                                              children: List.generate(
                                                5,
                                                (index) => Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color: index < 4
                                                      ? Colors.orange
                                                      : Colors.grey.shade300,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '46',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Price
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Text(
                                              '₹${product.lstPrice}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '₹${(product.baseUnitPrice! * 1.5).round()}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Add to Cart Button
                                        const SizedBox(height: 8),
                                        Consumer<AddToCartViewModel>(
                                          builder:
                                              (context, cartViewModel, child) {
                                            bool isInCart = cartViewModel.isInCart(product.id!);
                                            bool isLoading = cartViewModel
                                                .isLoading(product.id!);

                                            print("frvasdf"+isInCart.toString());
                                            print("frvadssdf"+alreadyAddedToCart.toString());
                                            return SizedBox(
                                              width: double.infinity,
                                              height: 32,
                                              child: ElevatedButton(
                                                onPressed: isLoading
                                                    ? null
                                                    : () async {
                                                        if (!(isInCart || alreadyAddedToCart)) {
                                                          cartViewModel
                                                              .toggleCartStatus(
                                                            partnerId,
                                                            product.id!,
                                                            1,
                                                            context,
                                                          );
                                                        }

                                                      },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: isInCart ||
                                                          alreadyAddedToCart
                                                      ? Colors.grey[300]
                                                      : const Color(0xFFFFD814),
                                                  foregroundColor:
                                                      Colors.black87,
                                                  elevation: 0,
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: isLoading
                                                    ? const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.black87,
                                                        ),
                                                      )
                                                    : Text(
                                                        alreadyAddedToCart ||
                                                                isInCart
                                                            ? 'Added to  Cart'
                                                            : 'Add to Cart',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                        ),
                      );
                    }
                  }),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
