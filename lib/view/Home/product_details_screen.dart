import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/view/Cart/cart_screen.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/CartViewModels/add_to_cart_viewModel.dart';
import '../../viewModel/CartViewModels/cart_list_view_model.dart';
import '../../viewModel/CartViewModels/updateCart_viewModel.dart';
import '../../viewModel/HomeViewModels/home_page_data_viewModel.dart';
import '../../viewModel/HomeViewModels/product_details_viewModel.dart';
import '../../viewModel/WhishListViewModels/add_to_whishList_viewModel.dart';

class ProductDetailsPage extends StatefulWidget {
  final String categoryId; // Pass the categoryId through constructor

  ProductDetailsPage({required this.categoryId});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late final partnerId;
  late final sessionId;

  @override
  void initState() {
    super.initState();
    // Call the API to fetch product details
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      partnerId = await PreferencesHelper.getString("partnerId");
      final viewModel = Provider.of<ProductdetailsViewModel>(context, listen: false);
      viewModel.getProductDetailsViewModelApi(widget.categoryId, context);
      final addToWhishListViewModel =
          Provider.of<AddToWhishListViewModel>(context, listen: false);
      addToWhishListViewModel.setWhishListStatus(false);
    });
  }

  int quantity = 1; // Initialize the quantity to 1
  bool isInWishlist = false;

  Future<void> _fetchCartItems() async {
    partnerId = await PreferencesHelper.getString("partnerId");
    sessionId = await PreferencesHelper.getString("session_id");
    final cartListViewModel =
        Provider.of<CartListViewModel>(context, listen: false);
    cartListViewModel.cartListViewModelApi(partnerId!, sessionId!, context);
  }

  Future<void> fetchHomePageData() async {
    // Obtain the instance of CategoriesListViewModel
    final homePageViewModel =
    Provider.of<HomePageDataViewModel>(context, listen: false);
    await homePageViewModel.fetchHomePageData("6,4", context);
  }

  Future<void> updateCart(
      String productId, String qty, BuildContext context) async {
    print("inside update cart");
    final updateCartViewModel =
        Provider.of<UpdateCartViewModel>(context, listen: false);
    // Perform async update
    await updateCartViewModel.updateCart(
      productId.toString(),
      qty.toString(),
      context,
    );
    await fetchHomePageData();
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartScreen(),
        ));
  }

  Future<void> _addToCart(int productId,dynamic quantity) async {
    final addToCart = Provider.of<AddToCartViewModel>(context, listen: false);
    await addToCart.toggleCartStatus(partnerId!, productId,quantity, context);
    await fetchHomePageData();
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Product Details',
          style: TextStyle(
            fontSize: 18,
            fontFamily: MyFonts.LexendDeca_Bold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<ProductdetailsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading) {
            return Utils.loadingIndicator(context);
          }

          // Get the product details list from the view model
          final productDetailsList = viewModel.responseList;
          // print("frjbngvh"+productDetailsList[0].productPrice.toString());
          // Check if the list is empty
          if (productDetailsList.isEmpty) {
            return Center(child: Text('No product details available.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: productDetailsList.length,
              itemBuilder: (context, index) {
                final productDetails = productDetailsList[index];
                print("fdygdvghs" + productDetails.isIncart.toString());
                // Access the product at the current index
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        Center(
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://towanto-ecommerce-mainbranch-16118324.dev.odoo.com/web/image?model=product.product&id=${productDetails.id}&field=image_1920'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Product Title and Rating
                        Text(
                          "${productDetails.displayName}",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: MyFonts.LexendDeca_Bold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              // Compare the index with the review rating to determine if the star should be filled
                              return Icon(
                                index < productDetails.ratingCount
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                            SizedBox(width: 8),
                            // Display the review count next to the stars
                            Text(
                              '(${productDetails.ratingCount} review${productDetails.ratingCount > 1 ? 's' : ''})',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: MyFonts.Lexenddeca_regular,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 4.0,
                        ),
                        // Product Details Section
                        Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ListTileTheme(
                            contentPadding: EdgeInsets.zero,
                            child: ExpansionTile(
                              iconColor: AppColors.black,
                              title: Text(
                                'Product Details:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: MyFonts.LexendDeca_Bold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: [
                                _buildDetailRow(
                                    'Crop:', productDetails.crop.toString()),
                                _buildDetailRow('Variety:',
                                    productDetails.variety.toString()),
                                _buildDetailRow(
                                    'Company:', productDetails.productCompany),
                                _buildDetailRow('Packing Size:',
                                    productDetails.productWeight.toString()),
                                _buildDetailRow('Price:',
                                    productDetails.productPrice.toString()),
                                _buildDetailRow('Per Case/Bag:',
                                    productDetails.perCaseBag.toString()),
                                _buildDetailRow('Minimum Order Quantity:',
                                    productDetails.minimumOrderQty.toString()),
                                _buildDetailRow('price/kg:',
                                    productDetails.productPrice.toString()),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        // Quantity Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Quantity :',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: MyFonts.LexendDeca_Bold),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                size: 14,
                              ),
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              },
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.textbox_textcolor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: MyFonts.LexendDeca_Bold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                size: 14,
                              ),
                              onPressed: () => setState(() => quantity++),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),
                        // Buy Now Button
                        productDetails.productPrice == 0.0
                            ? ElevatedButton(
                                onPressed: () {
                                  // Implement buy now functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                child: Text(
                                  'Send Enquiry',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: MyFonts.LexendDeca_Bold,
                                  ),
                                ),
                              )
                            : SizedBox(), // Optionally, return an empty widget or another fallback widget when the condition is false

                        // Buy Now Button
                        productDetails.productPrice != 0.0
                            ? ElevatedButton(
                                onPressed: () async {
                                  print("cdsbvhjb"+productDetails.isIncart.toString());
                                  productDetails.isIncart
                                      ? updateCart(
                                          productDetails.cartId.toString(),
                                          quantity.toString(),
                                          context)
                                      :
                                      // print("_addToCart(productDetails.id): ${_addToCart(productDetails.id)}");
                                    await  _addToCart(productDetails.id,quantity);
                                  // print("before");
                                  // updateCart(productDetails.id.toString(),quantity.toString(),context);
                                  // print("after");
                                  // Implement buy now functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                child: Text(
                                  'Buy Now',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: MyFonts.LexendDeca_Bold),
                                ),
                              )
                            : SizedBox.shrink(),

                        SizedBox(height: 12),

                        // Wishlist Button
                        Consumer<AddToWhishListViewModel>(
                          builder: (context, viewModel, child) {
                            print("dscdecade" +
                                productDetails.isInWishlist.toString());
                            return TextButton.icon(
                              onPressed: () async {
                                await viewModel.toggleWishlistStatus(
                                  partnerId,
                                  productDetails.id,
                                  context,
                                );
                              },
                              icon: viewModel.isLoading
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.red,
                                      ),
                                    )
                                  : Icon(
                                      viewModel.isInWhishList ||
                                              productDetails.isInWishlist
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                              label: Text(
                                viewModel.isInWhishList ||
                                        productDetails.isInWishlist
                                    ? 'In Wishlist'
                                    : 'Add to Wishlist',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontFamily: MyFonts.Lexenddeca_regular,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 12),
                        productDetails.descriptionSale != false
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontFamily: MyFonts.LexendDeca_Bold,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    productDetails.descriptionSale.toString(),
                                    style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 14,
                                        fontFamily: MyFonts.Lexenddeca_regular,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: MyFonts.LexendDeca_Bold,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textbox_textcolor),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: MyFonts.Lexenddeca_regular,
                  fontWeight: FontWeight.normal,
                  color: AppColors.textbox_textcolor),
            ),
          ),
        ],
      ),
    );
  }
}
