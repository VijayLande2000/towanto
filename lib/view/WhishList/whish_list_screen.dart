import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:towanto/viewModel/CartViewModels/add_to_cart_viewModel.dart';
import 'package:towanto/viewModel/WhishListViewModels/delete_whishList_viewModel.dart';
import 'package:towanto/viewModel/WhishListViewModels/whishList_list_view_model.dart';

import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/network/networkService/app_url.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';

// First, let's create a model class for our wishlist items
class WishlistItem {
  final String id;
  final String title;
  final String imageUrl;
  final double price;

  WishlistItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
  });
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String? partnerId = ""; // Example category ID
  String? sessionId = ""; // Example session ID

  // Method to call the API to fetch cart items
  Future<void> _fetchCartItems() async {
    partnerId = await PreferencesHelper.getString("partnerId");
    sessionId = await PreferencesHelper.getString("session_id");
    final cartListViewModel =
        Provider.of<WhishListViewModel>(context, listen: false);
    cartListViewModel.whishListViewModelApi(partnerId!, sessionId!, context);
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchCartItems();
    super.initState();
  }

  Map<String, bool> _loadingMap =
      {}; // Map to store the loading state for each item

  Future<void> _removeItem(String id) async {
    setState(() {
      _loadingMap[id] = true; // Set the loading state of this item to true
    });
    final deletewhishListitemViewModel =
        Provider.of<DeleteWhishlistItemViewModel>(context, listen: false);
    await deletewhishListitemViewModel.deleteWhishtlistViewModelApi(
        partnerId!, id, context, sessionId!);
    final whishListViewModel =
        Provider.of<WhishListViewModel>(context, listen: false);
    await whishListViewModel.updateWhishListViewModelApi(partnerId!, sessionId!,
        context); // _wishlistItems.removeWhere((item) => item.id == id);
    setState(() {
      _loadingMap[id] = false; // Reset loading state after operation
    });
  }

  Future<void> _addToCart(int productId) async {
    final addToCart = Provider.of<AddToCartViewModel>(context, listen: false);
    await addToCart.toggleCartStatus(partnerId!, productId, 1, context!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        title: Text(
          "Wishlist",
          style: TextStyle(
              fontSize: 20,
              // color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontFamily: MyFonts.font_regular),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, /*color: AppColors.black*/ size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<WhishListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading) {
            return Utils.loadingIndicator(context);
          }
          if (viewModel.whishListItemsList.isEmpty) {
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      "assets/lottie/empty_wishlist_new.json",
                    ),
                    Text(
                        "No items in your wishlist",
                        style: TextStyle(
                          color: AppColors.black,
                          fontFamily: MyFonts.font_regular,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        )
                    ),
                  ],

                ),
              ),
            );
          }
          // Get all products from the cart items
          final whishListItems = viewModel.whishListItemsList.toList();

          // Display all products
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: whishListItems.length,
                  itemBuilder: (context, index) {
                    final item = whishListItems[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Dismissible(
                          key: Key(item.productId.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red.shade100,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.red.shade700,
                              size: 28,
                            ),
                          ),
                          onDismissed: (_) => () {},
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center, // Changed to center
                                children: [
                                  // Product Image with fixed size and centered content
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*0.22,
                                      height: MediaQuery.of(context).size.height*0.1,
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                      ),
                                      child: Center( // Added Center widget
                                        child: Image.network(
                                          "${AppUrl.baseurlauth}web/image?model=product.product&id=${item.productId[0]}&field=image_1920",
                                          fit: BoxFit.contain, // Changed to contain for better centering
                                          width: 80, // Slightly smaller than container
                                          height: 80, // Slightly smaller than container
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Rest of the code remains the same...
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.productId.toString(),
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor * 14,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: MyFonts.font_regular,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '\$${item.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor * 12,
                                              color: AppColors.lightBlue,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: MyFonts.font_regular,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            DateFormat('yyyy-MM-dd').format(DateTime.parse(item.createDate.toString())),
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).textScaleFactor * 11,
                                              color: AppColors.grey,
                                              fontFamily: MyFonts.font_regular,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (_loadingMap[item.id.toString()] == true)
                                          const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.red,
                                            ),
                                          )
                                        else
                                          IconButton(
                                            onPressed: () => _removeItem(item.id.toString()),
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: AppColors.red,
                                              size: 24,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        const SizedBox(height: 4),
                                        Consumer<AddToCartViewModel>(
                                          builder: (context, viewModel, child) {
                                            bool isInCart = viewModel.isInCart(item.id);
                                            return SizedBox(
                                              width: 90,
                                              height: 32,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (isInCart || item.isInCart) {
                                                    Utils.flushBarErrorMessages("Already added in cart", context);
                                                  } else {
                                                    viewModel.toggleCartStatus(partnerId!, item.productId[0], 1, context);
                                                    _removeItem(item.id.toString());
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.brightBlue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                                ),
                                                child: viewModel.isLoading(item.id)
                                                    ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Adding",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: MediaQuery.of(context).textScaleFactor * 11,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const SizedBox(
                                                      height: 8,
                                                      width: 8,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                    : FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    isInCart || item.isInCart ? 'In Cart' : 'Add to Cart',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: MediaQuery.of(context).textScaleFactor * 11,
                                                      fontFamily: MyFonts.font_regular,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Memory-efficient way to handle large lists
class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WishlistScreen(),
    );
  }
}

class WishlistCard extends StatelessWidget {
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;

  const WishlistCard({
    Key? key,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.onAddToCart,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Dismissible(
          key: Key(productId),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red.shade100,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete_outline,
              color: Colors.red.shade700,
              size: 28,
            ),
          ),
          onDismissed: (_) => onRemove(),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
              ),
              // Product Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productId,
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: MyFonts.font_regular),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.lightBlue,
                            fontWeight: FontWeight.bold,
                            fontFamily: MyFonts.font_regular),
                      ),
                    ],
                  ),
                ),
              ),
              // Action Buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: onRemove,
                    icon: Icon(
                      Icons.delete_outline,
                      color: AppColors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
