class UpdateAccountInfromationModel {
  final dynamic status;
  final dynamic message;
  final Partner? partner;

  UpdateAccountInfromationModel({
    required this.status,
    required this.message,
    this.partner,
  });

  factory UpdateAccountInfromationModel.fromJson(Map<dynamic, dynamic> json) {
    return UpdateAccountInfromationModel(
      status: json['status'] as dynamic,
      message: json['message'] as dynamic,
      partner: json['partner'] != null ? Partner.fromJson(json['partner']) : null,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'partner': partner?.toJson(),
    };
  }
}

class Partner {
  final dynamic name;
  final dynamic email;
  final dynamic phone;
  final dynamic vat;
  final dynamic street;
  final dynamic street2;
  final dynamic city;
  final dynamic country;
  final dynamic state;
  final dynamic zipcode;
  final dynamic companyName;

  Partner({
    this.name,
    this.email,
    this.phone,
    this.vat,
    this.street,
    this.street2,
    this.city,
    this.country,
    this.state,
    this.zipcode,
    this.companyName,
  });

  factory Partner.fromJson(Map<dynamic, dynamic> json) {
    return Partner(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      vat: json['vat'],
      street: json['street'],
      street2: json['street2'],
      city: json['city'],
      country: json['country'],
      state: json['state'],
      zipcode: json['zipcode'],
      companyName: json['company_name'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'vat': vat,
      'street': street,
      'street2': street2,
      'city': city,
      'country': country,
      'state': state,
      'zipcode': zipcode,
      'company_name': companyName,
    };
  }
}
