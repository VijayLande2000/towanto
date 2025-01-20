class AddWhishListResponseModel {
  final bool success;
  final int? wishlistItemId;

  AddWhishListResponseModel({required this.success, this.wishlistItemId});

  // Factory method to parse JSON response into AddWhishListResponseModel object
  factory AddWhishListResponseModel.fromJson(Map<String, dynamic> json) {
    return AddWhishListResponseModel(
      success: json['success'] != null ? json['success'] as bool : false, // Defaulting to false if null
      wishlistItemId: json['wishlist_item_id'] as int?,
    );
  }

  // Method to convert AddWhishListResponseModel object into JSON map
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'wishlist_item_id': wishlistItemId,
    };
  }
}
