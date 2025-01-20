class WishlistItemModel {
  final int id;
  final List<dynamic> partnerId;
  final List<dynamic> productId;
  final List<dynamic>? currencyId;
  final dynamic pricelistId;
  final double price;
  final bool active;
  final String displayName;
  final List<dynamic> createUid;
  final DateTime createDate;
  final List<dynamic> writeUid;
  final DateTime writeDate;
  final bool stockNotification;

  WishlistItemModel({
    required this.id,
    required this.partnerId,
    required this.productId,
    this.currencyId,
    this.pricelistId,
    required this.price,
    required this.active,
    required this.displayName,
    required this.createUid,
    required this.createDate,
    required this.writeUid,
    required this.writeDate,
    required this.stockNotification,
  });

  // Factory method to parse JSON into WishlistItemModel object
  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] as int,
      partnerId: json['partner_id'] as List<dynamic>,
      productId: json['product_id'] as List<dynamic>,
      currencyId: json['currency_id'] as List<dynamic>?,
      pricelistId: json['pricelist_id'],
      price: (json['price'] as num).toDouble(),
      active: json['active'] as bool,
      displayName: json['display_name'] as String,
      createUid: json['create_uid'] as List<dynamic>,
      createDate: DateTime.parse(json['create_date']),
      writeUid: json['write_uid'] as List<dynamic>,
      writeDate: DateTime.parse(json['write_date']),
      stockNotification: json['stock_notification'] as bool,
    );
  }

  // Method to convert WishlistItemModel object into JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner_id': partnerId,
      'product_id': productId,
      'currency_id': currencyId,
      'pricelist_id': pricelistId,
      'price': price,
      'active': active,
      'display_name': displayName,
      'create_uid': createUid,
      'create_date': createDate.toIso8601String(),
      'write_uid': writeUid,
      'write_date': writeDate.toIso8601String(),
      'stock_notification': stockNotification,
    };
  }
}

// WishlistResponse for handling a list of wishlist items
class WishlistResponse {
  final List<WishlistItemModel> items;

  WishlistResponse({required this.items});

  // Factory method to parse JSON list into WishlistResponse
  factory WishlistResponse.fromJson(List<dynamic> jsonList) {
    return WishlistResponse(
      items: jsonList.map((json) => WishlistItemModel.fromJson(json)).toList(),
    );
  }

  // Method to convert WishlistResponse to JSON list
  List<Map<String, dynamic>> toJson() {
    return items.map((item) => item.toJson()).toList();
  }
}
