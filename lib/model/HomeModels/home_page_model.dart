class HomeDataModel {
  HomeDataModel({
    required this.cartCount,
    required this.wishlistCount,
    required this.sliderData,
    required this.categories,
  });

  final int? cartCount;
  final int? wishlistCount;
  final List<String> sliderData;
  final List<Category> categories;

  factory HomeDataModel.fromJson(Map<String, dynamic> json){
    return HomeDataModel(
      cartCount: json["cart_count"],
      wishlistCount: json["wishlist_count"],
      sliderData: json["slider_data"] == null ? [] : List<String>.from(json["slider_data"]!.map((x) => x)),
      categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
    );
  }

}

class Category {
  Category({
    required this.categoryId,
    required this.categoryName,
    required this.products,
  });

  final int? categoryId;
  final String? categoryName;
  final List<Product> products;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
    );
  }

}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.description,
    required this.image1920,
    required this.rating,
    required this.ratingCount,
  });

  final dynamic id;
  final dynamic name;
  final dynamic price;
  final dynamic categoryId;
  final dynamic description;
  final dynamic image1920;
  final dynamic rating;
  final dynamic ratingCount;

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      categoryId: json["category_id"],
      description: json["description"],
      image1920: json["image_1920"],
      rating: json["rating"],
      ratingCount: json["rating_count"],
    );
  }

}
