class GetAddressListModel {
  String? jsonrpc;
  dynamic id;
  Result? result;

  GetAddressListModel({this.jsonrpc, this.id, this.result});

  factory GetAddressListModel.fromJson(Map<String, dynamic> json) {
    return GetAddressListModel(
      jsonrpc: json['jsonrpc'],
      id: json['id'],
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'result': result?.toJson(),
    };
  }
}

class Result {
  List<Address>? addresses;

  Result({this.addresses});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      addresses: json['addresses'] != null
          ? (json['addresses'] as List).map((e) => Address.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addresses': addresses?.map((e) => e.toJson()).toList(),
    };
  }
}

class Address {
  int? id;
  String? firmName;
  dynamic proprietorName;
  String? email;
  String? phone;
  String? street;
  String? city;
  dynamic zipcode;
  String? type;
  String? countryName;
  String? stateName;
  String? vat;

  Address({
    this.id,
    this.firmName,
    this.proprietorName,
    this.email,
    this.phone,
    this.street,
    this.city,
    this.zipcode,
    this.type,
    this.countryName,
    this.stateName,
    this.vat,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      firmName: json['firm_name'],
      proprietorName: json['proprietor_name'],
      email: json['email'],
      phone: json['phone'],
      street: json['street'],
      city: json['city'],
      zipcode: json['zipcode'],
      type: json['type'],
      countryName: json['country_name'],
      stateName: json['state_name'],
      vat: json['vat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firm_name': firmName,
      'proprietor_name': proprietorName,
      'email': email,
      'phone': phone,
      'street': street,
      'city': city,
      'zipcode': zipcode,
      'type': type,
      'country_name': countryName,
      'state_name': stateName,
      'vat': vat,
    };
  }
}
