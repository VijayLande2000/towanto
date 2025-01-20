class RemoveAddressModel {
  final String status;
  final String message;

  RemoveAddressModel({required this.status, required this.message});

  // Factory constructor to create an RemoveAddressModel from a JSON map
  factory RemoveAddressModel.fromJson(Map<String, dynamic> json) {
    return RemoveAddressModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }

  // Method to convert an RemoveAddressModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
