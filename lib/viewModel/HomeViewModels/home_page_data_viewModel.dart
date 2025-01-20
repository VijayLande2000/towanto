import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:towanto/model/HomeModels/home_page_model.dart';
import '../../model/HomeModels/categories_list_details_model.dart';
import '../../utils/repositories/HomeRepositories/home_page_data_repository.dart';

class HomePageDataViewModel extends ChangeNotifier {
  final HomePageDataRepository _homePageDataRepository = HomePageDataRepository();
  bool _isLoading = false;
  late BuildContext context;

  // Data fields to store parsed API data
  int _cartCount = 0;
  int _wishlistCount = 0;
  List<String> _sliderData = [];
  List<Category> _categoryList1 = [];
  List<Category> _categoryList2 = [];

  // Getters for the parsed data
  bool get isLoading => _isLoading;
  int get cartCount => _cartCount;
  int get wishlistCount => _wishlistCount;
  List<String> get sliderData => _sliderData;
  List<Category> get categoryList1 => _categoryList1;
  List<Category> get categoryList2 => _categoryList2;

  // Private setter for the loading state
  void _setLoading(bool value) {
    _isLoading = value;
    developer.log('Loading state updated: $_isLoading', name: 'HomePageDataViewModel');
    notifyListeners();
  }

  // Method to fetch and parse home page data
  Future<void> fetchHomePageData(String categoryIds, BuildContext context) async {
    try {
      this.context = context;
      _setLoading(true);
      developer.log('Fetching home page data...', name: 'HomePageDataViewModel');

      // API call to fetch home page data
      final response = await _homePageDataRepository.getHomePagedataApi(categoryIds, context);

      // Parse the response (assuming it's a JSON object)
      _cartCount = response.cartCount ?? 0;
      _wishlistCount = response.wishlistCount ?? 0;
      _sliderData = (response.sliderData ?? [])
          .map((sliderItem) => 'https://towanto-ecommerce-mainbranch-16118324.dev.odoo.com/web/image?$sliderItem')
          .toList();

      // Separate categories into two lists based on criteria
      _categoryList1 = (response.categories ?? [])
          .where((category) => category.categoryId == 6)
          .toList();

      _categoryList2 = (response.categories ?? [])
          .where((category) => category.categoryId == 4)
          .toList();

      developer.log(
        'Home page data parsed successfully: '
            'cartCount=$_cartCount, wishlistCount=$_wishlistCount, '
            'sliderData=${_sliderData.length}, '
            'categoryList1=${_categoryList1.length}, '
            'categoryList2=${_categoryList2.length}',
        name: 'HomePageDataViewModel',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error occurred while fetching home page data',
        name: 'HomePageDataViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      _setLoading(false);
    }
  }
}
