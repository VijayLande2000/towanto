class PaymentAddressModel {
  final int addressId;
  final String name;
  final String proprietorName;
  final String email;
  final String phone;
  final String street;
  final String city;
  final String zipcode;
  final String type;
  final String country;
  final String state;
  final String vat;

  PaymentAddressModel({
    required this.addressId,
    required this.name,
    required this.proprietorName,
    required this.email,
    required this.phone,
    required this.street,
    required this.city,
    required this.zipcode,
    required this.type,
    required this.country,
    required this.state,
    required this.vat,
  });
}