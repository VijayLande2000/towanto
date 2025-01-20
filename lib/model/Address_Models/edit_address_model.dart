class EditAddressModel {
  final dynamic status;
  final dynamic message;
  final dynamic addressId;

  EditAddressModel({
    required this.status,
    required this.message,
    required this.addressId,
  });

  // Factory constructor to create an instance from JSON
  factory EditAddressModel.fromJson(Map<dynamic, dynamic> json) {
    return EditAddressModel(
      status: json['status'] as dynamic,
      message: json['message'] as dynamic,
      addressId: json['address_id'] as dynamic,
    );
  }

  // Method to convert an instance to JSON
  Map<dynamic, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'address_id': addressId,
    };
  }
}
