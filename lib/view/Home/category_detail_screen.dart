import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Categories')),
  //     body: Center(
  //       child: Consumer<CategoriesListViewModel>(
  //         builder: (context, viewModel, child) {
  //           if (viewModel.loading) {
  //             return CircularProgressIndicator();
  //           } else if (viewModel.responseList.isEmpty) {
  //             return Text('No data available');
  //           } else {
  //             return ListView.builder(
  //               itemCount: viewModel.responseList.length,
  //               itemBuilder: (context, index) {
  //                 final category = viewModel.responseList[index];
  //                 return ListTile(
  //                   title: Text(category.name + "    id: ${category.id.toString()}"),
  //                   subtitle: Text('Price: \$${category.baseUnitPrice.toString()}'),
  //                 );
  //               },
  //             );
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }

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
                return CircularProgressIndicator();
              } else if (viewModel.responseList.isEmpty) {
                return Text('No data available');
              } else {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      childAspectRatio: 0.65, // Adjusted ratio for better fit
                    ),
                    itemCount: viewModel.responseList.length,
                    itemBuilder: (context, index) {
                      final product = viewModel.responseList[index];
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
                                      '₹${(product.baseUnitPrice * 1.5).round()}',
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
                                    bool isInCart = cartViewModel.isInCart(product.id);
                                    bool isLoading = cartViewModel.isLoading(product.id);
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 32,
                                      child: ElevatedButton(
                                        onPressed: isLoading ? null : () {
                                          if(!(isInCart||alreadyAddedToCart)){
                                            cartViewModel.toggleCartStatus(
                                              partnerId,
                                              product.id,
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
                                            ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black87,
                                          ),
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
                );
              }
            },
          ),
        ),
      );
  }
}

