class GetBrandsByIdModel {
  GetBrandsByIdModel({
    required this.status,
    required this.totalProducts,
    required this.products,
  });

  final dynamic? status;
  final dynamic? totalProducts;
  final List<Product> products;

  factory GetBrandsByIdModel.fromJson(Map<dynamic, dynamic> json){
    return GetBrandsByIdModel(
      status: json["status"],
      totalProducts: json["total_products"],
      products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
    );
  }

}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
    required this.inCart,
  });

  final dynamic? id;
  final dynamic? name;
  final dynamic? price;
  final dynamic? imageUrl;
  final dynamic? rating;
  final dynamic? ratingCount;
  final dynamic? inCart;

  factory Product.fromJson(Map<dynamic, dynamic> json){
    return Product(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      imageUrl: json["image_url"],
      rating: json["rating"],
      ratingCount: json["rating_count"],
      inCart: json["in_cart"],
    );
  }

}
