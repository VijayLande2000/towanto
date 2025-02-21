import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/common_widgets/Utils.dart';
import 'package:towanto/view/Home/product_details_screen.dart';
import 'package:towanto/viewModel/CartViewModels/cart_list_view_model.dart';
import 'package:towanto/viewModel/HomeViewModels/filter_list_view_model.dart';
import 'dart:developer' as developer;

import '../../model/HomeModels/category_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/network/networkService/app_url.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/CartViewModels/add_to_cart_viewModel.dart';
import '../../viewModel/HomeViewModels/categories_list_viewModel.dart';
import '../../viewModel/HomeViewModels/home_page_data_viewModel.dart';
import '../Cart/cart_screen.dart';
import 'filter_bottom_sheet.dart';
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
    print("CategoryDetailScreen init state" + widget.category.id.toString());

    // Call the API when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchCategories();
      partnerId = await PreferencesHelper.getString("partnerId");
      // _fetchCartItems();
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
    final filterlistApiViewModel =
        Provider.of<FilterListViewModel>(context, listen: false);
    await filterlistApiViewModel.getFilterList(context);
  }

  Future<void> fetchSubCategories(dynamic categoryId) async {
    // Obtain the instance of CategoriesListViewModel
    final categoriesListViewModel =
        Provider.of<CategoriesListViewModel>(context, listen: false);

    print("fnvklnf" + widget.category.id.toString());
    print("fnvklnf" + categoryId.toString());
    if (widget.category.id.toString() != categoryId.toString()) {
      await categoriesListViewModel.subCategoriesListViewModelApi(
          categoryId.toString(), context);
      // await _fetchSubCartItems();
    }
  }

  Future<void> fetchInitialSubCategories(dynamic categoryId) async {
    // Obtain the instance of CategoriesListViewModel
    final categoriesListViewModel =
        Provider.of<CategoriesListViewModel>(context, listen: false);
    print("fnvklnf" + widget.category.id.toString());
    print("fnvklnf" + categoryId.toString());
    await categoriesListViewModel.subCategoriesListViewModelApi(
        categoryId.toString(), context);
    // await _fetchSubCartItems();
  }

  String? selectedCategoryId;
  List<String> navigationStack = [];

// Add these variables to your state
  List<CategorySelection> selectedCategoryHistory = [];

  List<NavigationLevelSelection> levelSelections = [];

  Future<void> _handleCategorySelect(
      BuildContext context, String category) async {
    print("--- Starting Category Selection ---");

    // Fetch the category ID, handling the possibility of a null return
    String? categoryId = _getCategoryId(context, category);
    if (categoryId == null || categoryId.isEmpty) {
      print("No category ID found for: $category");
      return; // Exit if the category ID is null or empty
    }

    // Get current navigation level
    String currentLevel =
        navigationStack.isEmpty ? "root" : navigationStack.last;

    // Check if state changes are necessary before calling setState
    bool isCategoryChanged = selectedCategoryId != categoryId;

    if (isCategoryChanged) {
      setState(() {
        selectedCategoryId = categoryId;

        // Update or add selection for the current level
        int existingIndex = levelSelections
            .indexWhere((selection) => selection.level == currentLevel);
        if (existingIndex != -1) {
          levelSelections[existingIndex] =
              NavigationLevelSelection(currentLevel, category, categoryId);
        } else {
          levelSelections.add(
              NavigationLevelSelection(currentLevel, category, categoryId));
        }
      });
    }

    // Avoid duplicate API calls by checking if the category is already being processed
    if (_isCategoryLoading(categoryId)) {
      print("Category is already being loaded: $categoryId");
      return;
    }

    try {
      // Mark category as loading
      _markCategoryAsLoading(categoryId);

      // Fetch subcategories
      if (isCategoryChanged) {
        await fetchSubCategories(categoryId);
        print("Successfully fetched subcategories");
      }
    } catch (e) {
      print("Error fetching subcategories: $e");
    } finally {
      // Mark category as loaded
      _markCategoryAsLoaded(categoryId);
    }

    // Check for subcategories
    if (_hasSubcategories(context, category)) {
      Map<String, dynamic>? subcategories =
          _getSubcategories(context, category);
      if (subcategories == null) {
        print("No subcategories found");
        return;
      }

      if (!navigationStack.contains(category)) {
        setState(() {
          navigationStack.add(category);
        });
      }

      // Handle single subcategory case without redundant calls
      if (subcategories.length == 1) {
        String? nextCategoryId =
            _getCategoryId(context, subcategories.keys.first);

        // Ensure no repeated calls for the same subcategory
        if (nextCategoryId != null && !_isCategoryLoading(nextCategoryId)) {
          await _handleCategorySelect(context, subcategories.keys.first);
        }
      }
    }
  }

// Helper methods to manage loading state
  final Set<String> _loadingCategories = {};

  bool _isCategoryLoading(String categoryId) {
    return _loadingCategories.contains(categoryId);
  }

  void _markCategoryAsLoading(String categoryId) {
    _loadingCategories.add(categoryId);
  }

  void _markCategoryAsLoaded(String categoryId) {
    _loadingCategories.remove(categoryId);
  }

  void _handleBack() async {
    print("--- Starting Back Navigation ---");

    if (navigationStack.isEmpty) {
      print("Navigation stack is empty - cannot go back");
      return;
    }

    // Remove current level selection
    String currentLevel = navigationStack.last;
    levelSelections.removeWhere((selection) => selection.level == currentLevel);

    setState(() {
      navigationStack.removeLast();

      // If we're going back to root, clear all selections
      if (navigationStack.length == 1) {
        levelSelections.clear();
        selectedCategoryId = null;

        // Make API call with widget.category.id
        try {
          final categoryId = widget.category.id.toString();
          fetchInitialSubCategories(
              categoryId); // Assuming this is your API call method
          print("Making root level API call with category ID: $categoryId");
        } catch (e) {
          print("Error making root level API call: $e");
        }
      } else {
        // Restore previous level's selection if not at root
        String previousLevel = navigationStack.last;
        NavigationLevelSelection? previousSelection = levelSelections
            .firstWhere((selection) => selection.level == previousLevel,
                orElse: () => NavigationLevelSelection("", "", ""));

        if (previousSelection.level.isNotEmpty) {
          selectedCategoryId = previousSelection.selectedId;
        } else {
          selectedCategoryId = null;
        }

        // Fetch subcategories for previous selection if it exists
        if (selectedCategoryId != null) {
          try {
            fetchSubCategories(selectedCategoryId!);
          } catch (e) {
            print("Error fetching subcategories: $e");
          }
        }
      }
    });
  }

  Widget _buildCategoryChip(BuildContext context, String category) {
    final hasSubcategories = _hasSubcategories(context, category);
    final categoryId = _getCategoryId(context, category);

    // Get current navigation level
    String currentLevel =
        navigationStack.isEmpty ? "root" : navigationStack.last;

    // Check if this category is selected in current level
    bool isSelected = levelSelections.any((selection) =>
        selection.level == currentLevel &&
        selection.selectedCategory == category);

    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        color: isSelected ? Color(0xFFFFD814) : AppColors.brightBlue,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => _handleCategorySelect(context, category),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getDisplayName(category),
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontFamily: MyFonts.font_regular,
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
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

// Helper Methods with null safety
  Map<String, dynamic>? _getSubcategories(
      BuildContext context, String category) {
    Map<String, dynamic>? current = _getCurrentCategories(context);
    if (current == null || !current.containsKey(category)) return null;

    final categoryData = current[category];
    if (categoryData == null || !categoryData.containsKey('subcategories'))
      return null;

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
    print(
        'Current Navigation Stack: $navigationStack'); // Debug print for stack
    print(
        'Navigation Stack Length: ${navigationStack.length}'); // Debug print for length
    print(
        'Is Navigation Stack Empty: ${navigationStack.isEmpty}'); // Debug print for empty check

    return navigationStack.isNotEmpty && navigationStack.length != 1
        ? IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            padding: const EdgeInsets.only(left: 0),
            onPressed: navigationStack.isNotEmpty && navigationStack.length != 1
                ? () {
                    print(
                        'Back Button Pressed - Stack before: $navigationStack'); // Debug print before pop
                    _handleBack();
                    print(
                        'Back Button Pressed - Stack after: $navigationStack'); // Debug print after pop
                  }
                : null,
          )
        : SizedBox.shrink();
  }

  Widget _buildBreadcrumb() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: navigationStack.asMap().entries.map((entry) {
          int idx = entry.key;
          String category = entry.value;
          return navigationStack.isNotEmpty && navigationStack.length != 1
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getDisplayName(category),
                      style: const TextStyle(
                        color: AppColors.black,
                        fontFamily: MyFonts.font_Medium,
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
                )
              : SizedBox.shrink();
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
          developer.log("No categories available to select.",
              name: "CategoryDetailScreen");
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

  Future<void> loadFilterProducts() async {
    final CategoryListViewModel =
    Provider.of<CategoriesListViewModel>(context, listen: false);
    final body =
      {
        "params":
        {
          "brand": ["Shiva agro Seeds Pvt ltd"],
          // "category":["Seeds / Vegetables Seeds / Carrot" , "Seeds / Vegetables Seeds / Kakri"],
          // "min_price":100,
          // "max_price":150,
          "variety":"PBW-154"
        }

    };

    if (levelSelections.isNotEmpty) {
      print("Last Selected Product ID: ${levelSelections.last.selectedId}");
      await CategoryListViewModel.filterCategoriesListViewModelApi(body, context);
    } else {
      print("No Product Selected.");
      print("Category Id " + widget.category.id.toString());
      await CategoryListViewModel.filterCategoriesListViewModelApi(body, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final filterViewModel =
            Provider.of<FilterListViewModel>(context, listen: false);
        filterViewModel.clearSelections(); // Clear selections
        return true; // Allow popping the screen
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        appBar: AppBar(
          title: Text(
            widget.category.name,
            style: TextStyle(
              fontSize: 20,
              fontFamily: MyFonts.font_regular,
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
                // Clear selections in ViewModel as well
                final filterViewModel =
                    Provider.of<FilterListViewModel>(context, listen: false);
                filterViewModel.clearSelections();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeGrid()));
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
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () async {
                // await context.read<FilterListViewModel>().getFilterList(context);

                final result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => FilterBottomSheet(),
                );
                if (result != null) {
                  print('Applied filters: $result');
                  loadFilterProducts();
                }
              },
            )
          ],
        ),
        body: Consumer<CategoriesListViewModel>(
          builder: (context, categoriesViewModel, child) {
            if (categoriesViewModel.loading) {
              return Utils.loadingIndicator(context);
            }

            return Column(
              children: [
                _buildNavigationHeader(),
                _buildCategoriesList(context),
                Builder(
                  builder: (context) {
                    if (categoriesViewModel.subCategoryLoading) {
                      return Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.3),
                        child: Utils.loadingIndicator(context),
                      );
                    }

                    if (categoriesViewModel.responseList?.products?.isEmpty ??
                        true) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
                          crossAxisAlignment: CrossAxisAlignment.center, // Centers content horizontally
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                              child: LottieBuilder.asset("assets/lottie/empty_products.json"),
                            ),
                            const SizedBox(height: 16), // Adds some spacing between animation and text
                            Text(
                              "No Products Available",
                              style: TextStyle(
                                color: AppColors.black,
                                fontFamily: MyFonts.font_regular,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12.0,
                            crossAxisSpacing: 12.0,
                            childAspectRatio: 0.65,
                          ),
                          itemCount:
                              categoriesViewModel.responseList!.products.length,
                          itemBuilder: (context, index) {
                            final product = categoriesViewModel
                                .responseList!.products[index];
                            bool alreadyAddedToCart = false;

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
                                        categoryId: product.id.toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                              '${AppUrl.baseurlauth}web/image?model=product.product&id=${product.id}&field=image_1920',
                                              fit: BoxFit.fitHeight,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Icon(
                                                Icons.error,
                                                size: 48,
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: MyFonts.font_regular,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      buildRatingRow(product.ratingAvg,
                                          product.ratingCount),
                                      const SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              (product.lstPrice == null ||
                                                  product.lstPrice == 0 ||
                                                  product.lstPrice == 0.0 ||
                                                  product.lstPrice.toString().isEmpty)
                                                  ? 'Price Locked'
                                                  : '₹${product.lstPrice}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: MyFonts.font_regular,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          )

                                          // if (product.lstPrice != null && product.lstPrice! > 0 && product.baseUnitPrice != null && product.baseUnitPrice! > 0) ...[
                                          //   const SizedBox(width: 4),
                                          //   Text(
                                          //     '₹${(product.baseUnitPrice! * 1.5).round()}',
                                          //     style: TextStyle(
                                          //       fontSize: 12,
                                          //       color: Colors.grey.shade600,
                                          //       decoration: TextDecoration.lineThrough,
                                          //     ),
                                          //   ),
                                          // ]
                                        ],
                                      ),

                                      const SizedBox(height: 8),
                                      // Replace the ValueListenableBuilder section with:
                                      Consumer<AddToCartViewModel>(
                                        builder:
                                            (context, cartViewModel, child) {
                                          bool isInCart = cartViewModel
                                              .isInCart(product.id!);
                                          bool isLoading = cartViewModel
                                              .isLoading(product.id!);

                                          return SizedBox(
                                            width: double.infinity,
                                            height: 32,
                                            child: ElevatedButton(
                                              onPressed: isLoading
                                                  ? null
                                                  : () async {
                                                      if (!(isInCart ||
                                                          alreadyAddedToCart)) {
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
                                                foregroundColor: Colors.black87,
                                                elevation: 0,
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: isLoading
                                                  ? const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: AppColors
                                                            .brightBlue,
                                                      ),
                                                    )
                                                  : Text(
                                                      alreadyAddedToCart ||
                                                              isInCart
                                                          ? 'Added to Cart'
                                                          : 'Add to Cart',
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontFamily: MyFonts
                                                            .font_regular,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                            ),
                                          );
                                        },
                                      )
                                      // ValueListenableBuilder<AddToCartViewModel>(
                                      //   valueListenable: context.read<AddToCartViewModel>(),
                                      //   builder: (context, cartViewModel, child) {
                                      //     bool isInCart = cartViewModel.isInCart(product.id!);
                                      //     bool isLoading = cartViewModel.isLoading(product.id!);
                                      //
                                      //     return SizedBox(
                                      //       width: double.infinity,
                                      //       height: 32,
                                      //       child: ElevatedButton(
                                      //         onPressed: isLoading
                                      //             ? null
                                      //             : () async {
                                      //           if (!(isInCart || alreadyAddedToCart)) {
                                      //             cartViewModel.toggleCartStatus(
                                      //               partnerId,
                                      //               product.id!,
                                      //               1,
                                      //               context,
                                      //             );
                                      //           }
                                      //         },
                                      //         style: ElevatedButton.styleFrom(
                                      //           backgroundColor:
                                      //           isInCart || alreadyAddedToCart ? Colors.grey[300] : const Color(0xFFFFD814),
                                      //           foregroundColor: Colors.black87,
                                      //           elevation: 0,
                                      //           padding: EdgeInsets.zero,
                                      //           shape: RoundedRectangleBorder(
                                      //             borderRadius: BorderRadius.circular(20),
                                      //           ),
                                      //         ),
                                      //         child: isLoading
                                      //             ? const SizedBox(
                                      //           width: 20,
                                      //           height: 20,
                                      //           child: CircularProgressIndicator(
                                      //             strokeWidth: 2,
                                      //             color: AppColors.brightBlue,
                                      //           ),
                                      //         )
                                      //             : Text(
                                      //           alreadyAddedToCart || isInCart ? 'Added to Cart' : 'Add to Cart',
                                      //           style: const TextStyle(
                                      //             fontSize: 13,
                                      //             fontWeight: FontWeight.w500,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
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

class CategorySelection {
  final String category;
  final String id;

  CategorySelection(this.category, this.id);
}

class NavigationLevelSelection {
  final String level;
  final String selectedCategory;
  final String selectedId;

  NavigationLevelSelection(this.level, this.selectedCategory, this.selectedId);
}
