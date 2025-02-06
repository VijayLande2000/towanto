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
  Map<int, List<Category>> _categoriesMap = {};

  // Getters for the parsed data
  bool get isLoading => _isLoading;
  int get cartCount => _cartCount;
  int get wishlistCount => _wishlistCount;
  List<String> get sliderData => _sliderData;
  Map<int, List<Category>> get categoriesMap => _categoriesMap;

  void _setLoading(bool value) {
    _isLoading = value;
    developer.log('Loading state updated: $_isLoading', name: 'HomePageDataViewModel');
    notifyListeners();
  }

  Future<void> fetchHomePageData(String categoryIds, BuildContext context) async {
    try {
      this.context = context;
      _setLoading(true);
      developer.log('Fetching home page data...', name: 'HomePageDataViewModel');

      final response = await _homePageDataRepository.getHomePagedataApi(categoryIds, context);

      // Parse basic response data
      _cartCount = response.cartCount ?? 0;
      _wishlistCount = response.wishlistCount ?? 0;
      _sliderData = (response.sliderData ?? [])
          .map((sliderItem) => 'https://towanto-ecommerce-mainbranch-16118324.dev.odoo.com/$sliderItem')
          .toList();

      // Clear existing categories map
      _categoriesMap = {};

      // Only add categories that have products
      for (var category in response.categories ?? []) {
        if (category.products.isNotEmpty) {  // Only add if there are products
          if (!_categoriesMap.containsKey(category.categoryId)) {
            _categoriesMap[category.categoryId] = [];
          }
          _categoriesMap[category.categoryId]?.add(category);

          developer.log(
              'Added category ${category.categoryId} with ${category.products.length} products',
              name: 'HomePageDataViewModel'
          );
        } else {
          developer.log(
              'Skipped empty category ${category.categoryId}',
              name: 'HomePageDataViewModel'
          );
        }
      }

      developer.log(
        'Home page data parsed successfully: '
            'cartCount=$_cartCount, wishlistCount=$_wishlistCount, '
            'sliderData=${_sliderData.length}, '
            'active categories=${_categoriesMap.keys.length}',
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

  // Helper method to get categories by ID
  List<Category> getCategoriesById(int categoryId) {
    return _categoriesMap[categoryId] ?? [];
  }
}