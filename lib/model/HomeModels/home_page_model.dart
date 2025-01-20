class HomeDataModel {
  final dynamic cartCount;
  final dynamic wishlistCount;
  final List<dynamic> sliderData;
  final List<Category> categories;

  HomeDataModel({
    required this.cartCount,
    required this.wishlistCount,
    required this.sliderData,
    required this.categories,
  });

  factory HomeDataModel.fromJson(Map<dynamic, dynamic> json) {
    return HomeDataModel(
      cartCount: json['cart_count'] as dynamic,
      wishlistCount: json['wishlist_count'] as dynamic,
      sliderData: List<dynamic>.from(json['slider_data'] ?? []),
      categories: (json['categories'] as List<dynamic>)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList(),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'cart_count': cartCount,
      'wishlist_count': wishlistCount,
      'slider_data': sliderData,
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
}

class Category {
  final dynamic categoryId;
  final List<Product> products;

  Category({
    required this.categoryId,
    required this.products,
  });

  factory Category.fromJson(Map<dynamic, dynamic> json) {
    return Category(
      categoryId: json['category_id'] as dynamic,
      products: (json['products'] as List<dynamic>)
          .map((productJson) => Product.fromJson(productJson))
          .toList(),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}

class Product {
  final dynamic id;
  final dynamic name;
  final double price;
  final dynamic categoryId;
  final dynamic description;
  final dynamic image1920;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.description,
    required this.image1920,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json['id'] as dynamic,
      name: json['name'] as dynamic,
      price: (json['price'] as num).toDouble(),
      categoryId: json['category_id'] as dynamic,
      description: json['description'] as dynamic,
      image1920: json['image_1920'] as dynamic,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category_id': categoryId,
      'description': description,
      'image_1920': image1920,
    };
  }
}
