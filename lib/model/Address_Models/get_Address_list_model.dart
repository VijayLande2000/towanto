class GetAddressListModel {
  dynamic? jsonrpc;
  dynamic id;
  Result? result;

  GetAddressListModel({this.jsonrpc, this.id, this.result});

  factory GetAddressListModel.fromJson(Map<dynamic, dynamic> json) {
    return GetAddressListModel(
      jsonrpc: json['jsonrpc'],
      id: json['id'],
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
    );
  }

  Map<dynamic, dynamic> toJson() {
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

  factory Result.fromJson(Map<dynamic, dynamic> json) {
    return Result(
      addresses: json['addresses'] != null
          ? (json['addresses'] as List).map((e) => Address.fromJson(e)).toList()
          : null,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'addresses': addresses?.map((e) => e.toJson()).toList(),
    };
  }
}

class Address {
  int? id;
  dynamic? name;
  dynamic? street;
  dynamic? city;
  dynamic? state;
  dynamic? country;
  dynamic? zip;
  dynamic? phone;
  dynamic? email;
  dynamic type;

  Address({
    this.id,
    this.name,
    this.street,
    this.city,
    this.state,
    this.country,
    this.zip,
    this.phone,
    this.email,
    this.type
  });

  factory Address.fromJson(Map<dynamic, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zip: json['zip'],
      phone: json['phone'],
      email: json['email'],
      type: json['type'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'zip': zip,
      'phone': phone,
      'email': email,
      'type': type,
    };
  }
}
