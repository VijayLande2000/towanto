// Model for category items
import 'dart:ui';

class CategoryItem {
  final String name;
  final String imageUrl;
  final Color backgroundColor;
  final double imagePadding;
  final int id;// Changed to double from Color

  CategoryItem( {
    required this.name,
    required this.imageUrl,
    required this.backgroundColor,
    required this.imagePadding,
    required this.id,
  });
}