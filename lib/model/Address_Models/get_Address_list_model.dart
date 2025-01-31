class GetAddressListModel {
  GetAddressListModel({
    required this.jsonrpc,
    required this.id,
    required this.result,
  });

  final String? jsonrpc;
  final dynamic id;
  final Result? result;

  factory GetAddressListModel.fromJson(Map<String, dynamic> json){
    return GetAddressListModel(
      jsonrpc: json["jsonrpc"],
      id: json["id"],
      result: json["result"] == null ? null : Result.fromJson(json["result"]),
    );
  }

}

class Result {
  Result({
    required this.addresses,
  });

  final List<Address> addresses;

  factory Result.fromJson(Map<String, dynamic> json){
    return Result(
      addresses: json["addresses"] == null ? [] : List<Address>.from(json["addresses"]!.map((x) => Address.fromJson(x))),
    );
  }

}

class Address {
  Address({
    required this.id,
    required this.firmName,
    required this.proprietorName,
    required this.email,
    required this.phone,
    required this.street,
    required this.city,
    required this.zipcode,
    required this.type,
    required this.countryName,
    required this.stateName,
    required this.vat,
  });

  final int? id;
  final dynamic? firmName;
  final String? proprietorName;
  final String? email;
  final String? phone;
  final String? street;
  final String? city;
  final dynamic? zipcode;
  final String? type;
  final String? countryName;
  final String? stateName;
  final String? vat;

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      id: json["id"],
      firmName: json["firm_name"],
      proprietorName: json["proprietor_name"],
      email: json["email"],
      phone: json["phone"],
      street: json["street"],
      city: json["city"],
      zipcode: json["zipcode"],
      type: json["type"].toString(),
      countryName: json["country_name"],
      stateName: json["state_name"],
      vat: json["vat"],
    );
  }

}
