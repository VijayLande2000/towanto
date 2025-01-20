class DeleteCart {
  final bool success;
  final String message;

  DeleteCart({required this.success, required this.message});

  // Factory method to create an instance from a JSON map
  factory DeleteCart.fromJson(Map<String, dynamic> json) {
    return DeleteCart(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
