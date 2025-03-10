import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Assuming these imports exist in your project
import 'package:towanto/utils/resources/colors.dart';
import 'package:badges/badges.dart' as badges;
import 'package:towanto/utils/resources/fonts.dart';
import 'package:towanto/view/Cart/cart_screen.dart';
import 'package:towanto/view/Home/product_details_screen.dart';
import 'package:towanto/view/Home/products_search_screen.dart';
import 'package:towanto/view/ManageAddress/address_list_screen.dart';
import 'package:towanto/view/Profile/update_account_information_screen.dart';
import 'package:towanto/view/Enquiry/enquiry_screen.dart';
import 'package:towanto/viewModel/HomeViewModels/home_page_data_viewModel.dart';

import '../../model/HomeModels/category_model.dart';
import '../../model/HomeModels/get_all_brands_model.dart';
import '../../model/HomeModels/home_page_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/network/networkService/app_url.dart';
import '../../utils/routes/route_names.dart';
import '../../viewModel/HomeViewModels/categories_list_viewModel.dart';
import '../Orders/orders_screen.dart';
import '../WhishList/whish_list_screen.dart';
import 'all_brands.dart';
import 'category_detail_screen.dart';
import 'getBrandsList.dart';

//checking the git track
class HomeGrid extends StatefulWidget {
  HomeGrid({Key? key}) : super(key: key);
  @override
  State<HomeGrid> createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  // Added constructor with key'
  late String savedUsername = "";

  Future<void> getUserName() async {
    savedUsername = (await PreferencesHelper.getString("login")) ?? "";
    print("dfvbnfjdk" + savedUsername);
  }

  @override
  void initState() {
    getUserName();

    // Fetch data after the initial build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHomePageData();
    });
    // TODO: implement initState
    super.initState();
  }

  Future<void> fetchHomePageData() async {
    // Obtain the instance of CategoriesListViewModel
    final homePageViewModel = Provider.of<HomePageDataViewModel>(context, listen: false);
    await homePageViewModel.fetchHomePageData("", context);
    await homePageViewModel.getAllBrandsList(context);
  }

  final List<CategoryItem> categories = [
    CategoryItem(
      name: 'Seeds',
      imageUrl: 'assets/images/seeds.png',
      backgroundColor: const Color(0xFFE3F2FD), // Light blue
      imagePadding: 2.0,
      id: 1,
    ),
    CategoryItem(
      name: 'Pesticides',
      imageUrl: 'assets/images/pesticide.jpg',
      backgroundColor: const Color(0xFFFFF9C4), // Light yellow
      imagePadding: 28.0,
      id: 2,
    ),
    CategoryItem(
      name: 'Machinery',
      imageUrl: 'assets/images/machine.jpg',
      backgroundColor: const Color(0xFFFFE0B2), // Light orange
      imagePadding: 28.0,
      id: 3,
    ),

    //  CategoryItem(
    //   name: 'Brands',
    //   imageUrl: 'assets/images/brands.jpg',
    //   backgroundColor: const Color(0xFFD1C4E9), // Light purple
    //   imagePadding: 20.0,
    //   id: 4,
    // ),

    /* CategoryItem(
      name: 'Seasonal',
      imageUrl: 'assets/images/seasonal.jpg',
      backgroundColor: const Color(0xFFC8E6C9), // Light green
      imagePadding: 28.0,
      id: 6,
    ),*/
    CategoryItem(
      name: 'Products',
      imageUrl: 'assets/images/products.png',
      backgroundColor: const Color(0xFFFFCDD2), // Light pink
      imagePadding: 12.0,
      id: 35,
    ),
    // CategoryItem(
    //   name: 'Latest',
    //   imageUrl: 'assets/images/seeds.png',
    //   backgroundColor: const Color(0xFFB3E5FC), // Light cyan
    //   imagePadding: 12.0,
    //   id: 35,
    // ),
  ];
  Widget buildCarouselSlider(BuildContext context, List<String> imageUrls,
      {void Function(String)? onTap}) {
    int current = 0;

    if (imageUrls.isEmpty) {
      // Return a placeholder or an empty widget when there are no images
      return Center(
        child: Text(
          'No images available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: imageUrls.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int realIndex) {
                return InkWell(
                  onTap: () {
                    if (onTap != null) onTap(imageUrls[itemIndex]);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(
                        4.0), // Use your desired padding here
                    child: Image.network(
                      imageUrls[itemIndex],
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 2.0,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    current = index;
                  });
                },
              ),
            ),
            imageUrls.length == 1
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageUrls.asMap().entries.map((entry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(current == entry.key ? 0.9 : 0.4),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        );
      },
    );
  }

  int _selectedIndex = 0;
  // Initial value
  @override
  Widget build(BuildContext context) {
    final homePageViewModel = Provider.of<HomePageDataViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min, // This will make the Row take only the space it needs
          children: [
            Image.asset(
              "assets/images/ic_launcher_foreground.png",
              fit: BoxFit.contain,
              height: 40,
            ),
            // Reduce this width value or remove the SizedBox completely for no gap
            const Text(
              'owanto',
              style: TextStyle(
                fontSize: 20,
                fontFamily: MyFonts.font_regular,
                // color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        elevation: 0,
        // backgroundColor: AppColors.brightBlue,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              // color: AppColors.black,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchProductScreen(),
                ),
              );
            },
            child: Icon(
              Icons.search_sharp,
              // color: AppColors.black,
              size: 24,
            ),
          ),
          SizedBox(
            width: 24,
          ),

          // Wishlist Icon with Badge
          Consumer<HomePageDataViewModel>(
            builder: (BuildContext context, HomePageDataViewModel value,
                Widget? child) {
              return badges.Badge(
                badgeContent: Text(
                  value.cartCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontFamily: MyFonts.font_regular,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                badgeStyle: badges.BadgeStyle(badgeColor: AppColors.yellow_color),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add_shopping_cart,
                    // color: AppColors.black,
                  ),
                ),
              );
            },
          ),
          SizedBox(
            width: 24,
          ),
          // Cart Icon with Badge
          Consumer<HomePageDataViewModel>(
            builder: (BuildContext context, HomePageDataViewModel value,
                Widget? child) {
              return badges.Badge(
                badgeStyle:
                    badges.BadgeStyle(badgeColor: AppColors.yellow_color),
                badgeContent: Text(
                  value.wishlistCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: MyFonts.font_regular,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WishlistScreen(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.favorite_border,
                    // color: AppColors.black,
                  ),
                ),
              );
            },
          ),

          SizedBox(
            width: 12,
          ),
        ],
      ),
      // drawer: CustomDrawer(selectedIndex: 1, categories: categories),
      drawer: CustomDrawer(
        selectedIndex: _selectedIndex,
        categories: categories,
        onIndexChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        user: savedUsername,
      ),

      body: Consumer<HomePageDataViewModel>(
          builder: (context, homePageViewModel, child) {
        if (homePageViewModel.isLoading) {
          return Utils.loadingIndicator(context);
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildCarouselSlider(
                  context,
                  homePageViewModel.sliderData,
                  onTap: (url) {
                    // Handle image tap, e.g., navigate to a new screen or display in full screen
                    print("Tapped on image with URL: $url");
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevent GridView from scrolling independently
                    shrinkWrap:
                        true, // Allow GridView to be sized by its content
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(category: categories[index]);
                    },
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 16, bottom: 8),
                //   child: Text(
                //     "Seasonal",
                //     style: const TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.w600,
                //       color: AppColors.appBarTitleTextColor,
                //       fontFamily: MyFonts.font_regular,
                //     ),
                //   ),
                // ),
                // In your build method
                buildDynamicCategoryLists(homePageViewModel, context),
                buildDynamicBrandsList(homePageViewModel, context)
              ],
            ),
          );
        }
      }),
    );
  }
}

class CategoryCard extends StatefulWidget {
  final CategoryItem category;

  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);
  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  // Removed unnecessary imagePadding parameter
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundcolormenu,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CategoryDetailScreen(category: widget.category),
            ),
          );
        },
        child: Container(

          decoration: BoxDecoration(
            color: widget.category.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: EdgeInsets.all(widget
                      .category.imagePadding), // Using category.imagePadding
                  child: Image.asset(
                    widget.category.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    widget.category.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
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
  }
}

// widgets/custom_drawer.dart
class CustomDrawer extends StatefulWidget {
  final int selectedIndex;
  final List<CategoryItem> categories;
  final Function(int) onIndexChanged; // Add this callback
  final String user;
  const CustomDrawer(
      {Key? key,
      required this.selectedIndex,
      required this.categories,
      required this.onIndexChanged,
      required this.user})
      : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late String savedUsername = "";

  Future<void> getUserName() async {
    savedUsername = (await PreferencesHelper.getString("login"))!;
    setState(() {});
    print("dfvbnfjdk" + savedUsername);
  }

  Future<void> logOut() async {
    await PreferencesHelper.removeKey(
        "login"); // Remove the string from storage
    savedUsername = ""; // Clear the local variable
    PreferencesHelper.clearSharedPreferences();
    Navigator.pushReplacementNamed(context, RoutesName.login);
    setState(() {}); // Update the UI
    print("Username deleted successfully");
  }

  @override
  void initState() {
    getUserName();
    // TODO: implement initState
    super.initState();
  }

  CategoryItem _getCategoryByName(String name) {
    return widget.categories.firstWhere(
      (category) => category.name == name,
      orElse: () => CategoryItem(
        name: 'Brands',
        imageUrl: 'assets/images/brands.jpg',
        backgroundColor: const Color(0xFFD1C4E9), // Light purple
        imagePadding: 20.0,
        id: 4,
      ),
    );
  }

  void _handleNavigation(BuildContext context, Widget screen, int index) {
    widget.onIndexChanged(index); // Call the callback with the new index
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    PreferencesHelper.saveString("selectedIndex", index.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.lightBlue, AppColors.brightBlue],
          ),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ic_launcher_foreground.png',
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    savedUsername ?? "",
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            DrawerItem(
              icon: Icons.grass,
              title: 'Seeds',
              isSelected: widget.selectedIndex == 0,
              onTap: () => _handleNavigation(
                context,
                CategoryDetailScreen(category: _getCategoryByName('Seeds')),
                0,
              ),
            ),
            DrawerItem(
              icon: Icons.science,
              title: 'Pesticides',
              isSelected: widget.selectedIndex == 1,
              onTap: () => _handleNavigation(
                context,
                CategoryDetailScreen(
                    category: _getCategoryByName('Pesticides')),
                1,
              ),
            ),
            DrawerItem(
                icon: Icons.agriculture,
                title: 'Machinery',
                isSelected: widget.selectedIndex == 2,
                onTap: () => _handleNavigation(
                      context,
                      CategoryDetailScreen(
                          category: _getCategoryByName('Machinery')),
                      2,
                    )),
            DrawerItem(
              icon: Icons.business,
              title: 'Brands',
              isSelected: widget.selectedIndex == 3,
              onTap: () => _handleNavigation(
                context,
                CategoryDetailScreen(category: _getCategoryByName('Brands')),
                3,
              ),
            ),
            DrawerItem(
              icon: Icons.contact_mail,
              title: 'Enquiry',
              isSelected: widget.selectedIndex == 4,
              onTap: () => _handleNavigation(
                context,
                EnquiryScreen(),
                4,
              ),
            ),
            DrawerItem(
              icon: Icons.person,
              title: 'Profile',
              isSelected: widget.selectedIndex == 5,
              onTap: () => _handleNavigation(
                context,
                AccountInfoScreen(),
                5,
              ),
            ),
            DrawerItem(
                icon: Icons.home,
                title: 'Manage Address',
                isSelected: widget.selectedIndex == 6,
                onTap: () => _handleNavigation(
                      context,
                      AddressManager(),
                      6,
                    )),
            DrawerItem(
                icon: Icons.list_alt_sharp,
                title: 'Orders List',
                isSelected: widget.selectedIndex == 7,
                onTap: () => _handleNavigation(
                      context,
                      OrdersListScreen(),
                      7,
                    )),
            const SizedBox(height: 20),
            const Divider(color: Colors.white30),
            DrawerItem(
              icon: Icons.logout_outlined,
              title: 'Log Out',
              isSelected: false,
              onTap: () {
                logOut();
                // Add cart navigation logic here
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen, String index) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    PreferencesHelper.saveString("selectedIndex", index);
  }
}

// widgets/drawer_item.dart
class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.grey.shade300.withOpacity(0.6)
            : Colors.transparent, // Change to a light gray shade
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? Colors.grey.shade800
              : Colors.white, // Darker color for selected icon
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.grey.shade800
                : Colors.white, // Darker color for selected text
            fontSize: 16,
            fontFamily: MyFonts.font_regular,
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.normal, // Bold selected text
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class Category {
  final int categoryId;
  final String categoryName;
  final List<Product> products;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.products,
  });
}

Widget buildDynamicCategoryLists(
    HomePageDataViewModel viewModel, BuildContext context) {
  return Column(
    children: viewModel.categoriesMap.entries.map((entry) {
      final categoryId = entry.key;
      final categories = entry.value;
      // Get the first category from the list to access category name
      final categoryName =
          categories.isNotEmpty ? categories.first.categoryName : '';

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              categoryName.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.appBarTitleTextColor,
                fontFamily: MyFonts.font_regular,
              ),
            ),
          ),
          Container(
            // height: MediaQuery.of(context).size.height * 0.29,
            width: double.maxFinite,
            child: _buildHorizontalListView(viewModel, categoryId),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16, top: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightBlue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailScreen(
                        category: CategoryItem(
                          name: categoryName ?? "",
                          imageUrl: 'assets/images/category_$categoryId.jpg',
                          backgroundColor:
                              Colors.grey.shade100, // Default background color
                          imagePadding: 24.0, // Default padding
                          id: categoryId,
                        ),
                      ),
                    ),
                  );
                },
                child: Text(
                  "View All ${categoryName}s",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor,
                    fontFamily: MyFonts.font_regular,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }).toList(),
  );
}

Widget _buildHorizontalListView(HomePageDataViewModel viewModel, int categoryId) {
  final categories = viewModel.getCategoriesById(categoryId);
  int totalProductCount = 0;
  categories.forEach((category) {
    totalProductCount += category.products.length;
  });

  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            for (var category in categories)
              for (var product in category.products)
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: Card(
                    color: AppColors.white,
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
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Important for natural sizing
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image container with aspect ratio
                            AspectRatio(
                              aspectRatio: 1.2, // Width:Height ratio
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Image.network(
                                    '${AppUrl.baseurlauth}web/image?model=product.product&id=${product.id}&field=image_1920',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      Icons.error,
                                      size: 32,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Product name
                            Text(
                              product.name ?? 'Unknown Product',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.appBarTitleTextColor,
                                fontFamily: MyFonts.font_regular,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Rating
                            Row(
                              children: [
                                ...List.generate(5, (index) {
                                  if (index < product.rating.floor()) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 14,
                                    );
                                  } else if (index < product.rating && product.rating % 1 != 0) {
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
                                const SizedBox(width: 4),
                                Text(
                                  '(${product.ratingCount})',
                                  style: TextStyle(
                                    fontFamily: MyFonts.font_regular,
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Price
                            Text(
                              (product.price != null && product.price > 0)
                                  ? '₹ ${product.price}'
                                  : "Price Locked",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.appBarTitleTextColor,
                                fontFamily: MyFonts.font_regular,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      );
    },
  );
}


Widget buildDynamicBrandsList(HomePageDataViewModel homePageDataViewModel, BuildContext context) {
  if (homePageDataViewModel.brandsList == null ||
      homePageDataViewModel.brandsList!.brands == null ||
      homePageDataViewModel.brandsList!.brands!.isEmpty) {
    return const SizedBox.shrink();
  }

  // Get only first 10 brands
  final limitedBrands = homePageDataViewModel.brandsList!.brands!.take(10).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 8),
        child: Text(
          "Brands",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.appBarTitleTextColor,
            fontFamily: MyFonts.font_regular,
          ),
        ),
      ),
      LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.28,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: limitedBrands.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                final brand = limitedBrands[index];
                final screenWidth = MediaQuery.of(context).size.width;

                return Container(
                  width: screenWidth * 0.45,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: Card(
                    color: AppColors.white,
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
                            builder: (context) => BrandProductsList(brandName: brand.name,brandid: brand.id,),
                          ),
                        );
                        // Navigate to brand detail page if needed
                      },
                      child: LayoutBuilder(
                        builder: (context, cardConstraints) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: brand.id != null
                                        ? Image.network(
                                      '${brand.imageUrl}',
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.camera,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                    )
                                        : Icon(
                                      Icons.camera,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brightBlue,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AllBrands(),));
              // Navigate to all brands page if needed
            },
            child: Text(
              "View All Brands",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
                fontFamily: MyFonts.font_regular,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

// Widget _buildHorizontalSeasonalListView(HomePageDataViewModel viewModel) {
//   // Calculate the total number of products across all categories
//   int totalProductCount = 0;
//   viewModel.categoryList1.forEach((category) {
//     totalProductCount += category.products.length;
//   });
//
//   return ListView.builder(
//     scrollDirection: Axis.horizontal,
//     itemCount: totalProductCount,
//     itemBuilder: (context, index) {
//       // Calculate which category and which product to access based on the total count
//       int productIndex = 0;
//       Category category;
//       for (category in viewModel.categoryList1) {
//         if (index < productIndex + category.products.length) {
//           // This category contains the item at the 'index' position
//           final product = category.products[index - productIndex];
//           final screenHeight = MediaQuery.of(context).size.height;
//
//           return Card(
//             color: AppColors.white,
//             elevation: 2,
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//               side: BorderSide(color: Colors.grey.shade200),
//             ),
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductDetailsPage(
//                       categoryId: product.id.toString(),
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.5,
//                 padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Product Image
//                     Container(
//                       height: screenHeight * 0.15,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Center(
//                         child: Image.network(
//                           '${AppUrl.baseurlauth}web/image?model=product.product&id=${product.id}&field=image_1920',
//                           fit: BoxFit.contain,
//                           errorBuilder: (context, error, stackTrace) => Icon(
//                             Icons.error,
//                             size: 48,
//                             color: Colors.grey.shade400,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     // Product Name
//                     Text(
//                       product.name,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.appBarTitleTextColor,
//                         fontFamily: MyFonts.font_regular,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     // Rating
//                     Row(
//                       children: [
//                         ...List.generate(
//                           5,
//                               (index) => Icon(
//                             Icons.star,
//                             size: 14,
//                             color: index < 4
//                                 ? Colors.orange
//                                 : Colors.grey.shade300,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           '46',
//                           style: TextStyle(
//                             fontFamily: MyFonts.font_regular,
//                             color: Colors.grey.shade600,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     // Price
//                     Text(
//                       '₹${product.price}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.appBarTitleTextColor,
//                         fontFamily: MyFonts.font_regular,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//         productIndex += category.products.length;
//       }
//       return const SizedBox.shrink();
//     },
//   );
// }
// Widget _buildHorizontalBrandListView(HomePageDataViewModel viewModel) {
//   // Calculate the total number of products across all categories
//   int totalProductCount = 0;
//   viewModel.categoryList2.forEach((category) {
//     totalProductCount += category.products.length;
//   });
//
//   return ListView.builder(
//     scrollDirection: Axis.horizontal,
//     itemCount: totalProductCount,
//     itemBuilder: (context, index) {
//       // Calculate which category and which product to access based on the total count
//       int productIndex = 0;
//       Category category;
//       for (category in viewModel.categoryList2) {
//         if (index < productIndex + category.products.length) {
//           // This category contains the item at the 'index' position
//           final product = category.products[index - productIndex];
//           final screenHeight = MediaQuery.of(context).size.height;
//
//           return Card(
//             color: AppColors.white,
//             elevation: 2,
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//               side: BorderSide(color: Colors.grey.shade200),
//             ),
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductDetailsPage(
//                       categoryId: product.id.toString(),
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.5,
//                 padding: const EdgeInsets.only(left: 12,right: 12,top: 12),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Product Image
//                     Container(
//                       height: screenHeight * 0.17,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Center(
//                         child: Image.network(
//                           '${AppUrl.baseurlauth}web/image?model=product.product&id=${product.id}&field=image_1920',
//                           fit: BoxFit.contain,
//                           errorBuilder: (context, error, stackTrace) => Icon(
//                             Icons.error,
//                             size: 48,
//                             color: Colors.grey.shade400,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     // Product Name
//                     Text(
//                       product.name,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.appBarTitleTextColor,
//                         fontFamily: MyFonts.font_regular,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     // Rating
//                     Row(
//                       children: [
//                         ...List.generate(
//                           5,
//                               (index) => Icon(
//                             Icons.star,
//                             size: 14,
//                             color: index < 4
//                                 ? Colors.orange
//                                 : Colors.grey.shade300,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           '46',
//                           style: TextStyle(
//                             fontFamily: MyFonts.font_regular,
//                             color: Colors.grey.shade600,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     // Price
//                     Text(
//                       '₹${product.price}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.appBarTitleTextColor,
//                         fontFamily: MyFonts.font_regular,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }
//         productIndex += category.products.length;
//       }
//       return const SizedBox.shrink();
//     },
//   );
// }
