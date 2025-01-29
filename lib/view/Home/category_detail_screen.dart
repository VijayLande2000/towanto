import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/common_widgets/Utils.dart';
import 'package:towanto/view/Home/product_details_screen.dart';
import 'package:towanto/viewModel/CartViewModels/cart_list_view_model.dart';

import '../../model/HomeModels/category_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/resources/colors.dart';
import '../../viewModel/CartViewModels/add_to_cart_viewModel.dart';
import '../../viewModel/HomeViewModels/categories_list_viewModel.dart';
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
  late final partnerId ;
  String? sessionId = ""; // Example session ID

  List<dynamic> idList = [];

  void addId(dynamic id) {
    idList.add(id);  // Adds a new id to the list
  }


  @override
  initState() {
    super.initState();
    print("CategoryDetailScreen init state");
    // Call the API when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchCategories();
      partnerId = await PreferencesHelper.getString("partnerId");
      _fetchCartItems();
    });
  }
  Future<void> _fetchCartItems() async {
    sessionId = await PreferencesHelper.getString("session_id");
    final cartListViewModel = Provider.of<CartListViewModel>(context, listen: false);
    cartListViewModel.cartListProductIdsViewModelApi(partnerId!, sessionId!, context);
  }

  Future<void> fetchCategories() async {
    // Obtain the instance of CategoriesListViewModel
    final categoriesListViewModel = Provider.of<CategoriesListViewModel>(
        context, listen: false);
    await categoriesListViewModel.categoriesListViewModelApi(
        widget.category.id.toString(), context);
  }

  String? selectedCategory;

  final List<String> categories = [

    'Playlists',
    'Podcasts',
    'Artists',
    'Downloaded',
  ];

  final Map<String, List<String>> subCategories = {
    'Playlists': ['Liked Songs', 'Recently Played', 'Your Episodes'],
    'Podcasts': ['Following', 'Downloaded Episodes', 'Popular'],
    'Artists': ['Following', 'Popular', 'Recommended'],
  };

  final Map<String, List<String>> subSubCategories = {
    'Liked Songs': ['Rock', 'Pop', 'Jazz'],
    'Following': ['New Releases', 'Live Shows'],
  };

  List<String> navigationStack = [];
  Widget _buildList(CategoriesListViewModel categoriesListViewModel, BuildContext context) {
    List<String> currentList = []; // Initialize the list to avoid null issues.

    if (navigationStack.isEmpty) {
      currentList = categories;
    } else if (navigationStack.length == 1) {
      currentList = subSubCategories[navigationStack.last] ?? [];
    } else {
      currentList = subSubCategories[navigationStack.last] ?? [];
    }

    return Consumer2<CategoriesListViewModel, CartListViewModel>(
      builder: (context, viewModel, cartListViewModel, child) {
        if (viewModel.loading || cartListViewModel.loading) {
          return Utils.loadingIndicator(context);
        } else if (viewModel.responseList?.products.isEmpty ?? true) {
          return Text('No data available');
        } else {
          return Container(
            color: Colors.black,
            child: Column(
              children: [
                if (navigationStack.isNotEmpty)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            navigationStack.removeLast();
                            if (navigationStack.isNotEmpty) {
                              selectedCategory = navigationStack.last;
                            } else {
                              selectedCategory = null;
                            }
                          });
                        },
                      ),
                      Text(
                        navigationStack.last,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: currentList
                        .map((category) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        label: Text(category),
                        onSelected: (_) {
                          List<String>? nextList;
                          if (navigationStack.isEmpty) {
                            nextList = categories;
                          } else if (navigationStack.length == 1) {
                            nextList = subSubCategories[category];
                          }

                          if (nextList?.isNotEmpty ?? false) {
                            setState(() {
                              selectedCategory = category;
                              navigationStack.add(category);
                            });
                          } else {
                            // Just print when reaching an end item
                            print('Selected end item: $category');
                            print('Full path: ${[...navigationStack, category].join(" > ")}');
                          }
                        },
                        backgroundColor: Colors.grey[800],
                        selectedColor: Colors.grey[700],
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor: AppColors.brightBlue, // Light blue
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
        child: Consumer2<CategoriesListViewModel,CartListViewModel>(
          builder: (context, viewModel,cartListViewModel, child) {
            if (viewModel.loading || cartListViewModel.loading) {
              return Utils.loadingIndicator(context);
            } else if (viewModel.responseList!.products.isEmpty) {
              return Text('No data available');
            } else {
              return Column(
                children: [
                  Container(
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildList(viewModel,context),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12.0,
                          crossAxisSpacing: 12.0,
                          childAspectRatio: 0.65, // Adjusted ratio for better fit
                        ),
                        itemCount: viewModel.responseList!.products.length,
                        itemBuilder: (context, index) {
                          final product = viewModel.responseList!.products[index];
                          bool alreadyAddedToCart = cartListViewModel.productIds.contains(product.id.toString());

                          print("product id = ${product.id.toString()}"); // Ensure id is a string
                          cartListViewModel.productIds.forEach((element) {
                            print("id = ${element.toString()}"); // Ensure each element in productIds is a string
                          });

                          print("alreadyAddedToCart = $alreadyAddedToCart");

                          print("dcxdc"+alreadyAddedToCart.toString());
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
                                    builder: (context) => ProductDetailsPage(categoryId: product.id.toString()),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product Image
                                    Expanded(
                                      flex: 4,
                                      child:Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Image.network(
                                            'https://towanto-ecommerce-mainbranch-16118324.dev.odoo.com/web/image?model=product.product&id=${product.id}&field=image_1920',
                                            // width: 48, // Adjust size as needed
                                            // height: 48, // Adjust size as needed
                                            fit: BoxFit.fitHeight,
                                            errorBuilder: (context, error, stackTrace) => Icon(
                                              Icons.error, // Fallback icon in case of an error
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
                                              color: index < 4 ? Colors.orange : Colors.grey.shade300,
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
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(
                                          '₹${product.baseUnitPrice}',
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
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Add to Cart Button
                                    const SizedBox(height: 8),
                                    Consumer<AddToCartViewModel>(
                                      builder: (context, cartViewModel, child) {
                                        bool isInCart = cartViewModel.isInCart(product.id!);
                                        bool isLoading = cartViewModel.isLoading(product.id!);
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 32,
                                          child: ElevatedButton(
                                            onPressed: isLoading ? null : () {
                                              if(!(isInCart||alreadyAddedToCart)){
                                                cartViewModel.toggleCartStatus(
                                                  partnerId,
                                                  product.id!,
                                                  1,
                                                  context,
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isInCart || alreadyAddedToCart ? Colors.grey[300] : const Color(0xFFFFD814),
                                              foregroundColor: Colors.black87,
                                              elevation: 0,
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: isLoading
                                                ?  SizedBox(
                                              width: 20,
                                              height: 20,
                                                child: CircularProgressIndicator(color: AppColors.brightBlue)
                                            )
                                                : Text(
                                              alreadyAddedToCart || isInCart ? 'Added to  Cart' : 'Add to Cart',
                                              style: const TextStyle(
                                                fontSize: 13,
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
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

