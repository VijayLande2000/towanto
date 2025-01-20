class DeleteWishlistResponseModel {
  final bool success;
  final String message;

  DeleteWishlistResponseModel({required this.success, required this.message});

  // Factory method to parse JSON into DeleteWishlistResponseModel object
  factory DeleteWishlistResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteWishlistResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  // Method to convert DeleteWishlistResponseModel object into JSON map
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
