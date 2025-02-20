class LoggedInUserInfoModel {
  String? jsonrpc;
  dynamic id;
  Result? result;

  LoggedInUserInfoModel({this.jsonrpc, this.id, this.result});

  LoggedInUserInfoModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['jsonrpc'] = jsonrpc;
    data['id'] = id;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  dynamic? name;
  dynamic? email; // Added email field
  dynamic? username;
  dynamic? zipcode;
  dynamic? phone;
  dynamic? vat;
  dynamic? street;
  dynamic? street2;
  dynamic? city;
  dynamic? country;
  dynamic? state;
  dynamic? firmName;

  Result({
    this.name,
    this.email, // Added email
    this.username,
    this.zipcode,
    this.phone,
    this.vat,
    this.street,
    this.street2,
    this.city,
    this.country,
    this.state,
    this.firmName,
  });

  Result.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    email = json['email']; // Added email
    username = json['username'];
    zipcode = json['zipcode'];
    phone = json['phone'];
    vat = json['vat'];
    street = json['street'];
    street2 = json['street2'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    firmName = json['firm_name'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email; // Added email
    data['username'] = username;
    data['zipcode'] = zipcode;
    data['phone'] = phone;
    data['vat'] = vat;
    data['street'] = street;
    data['street2'] = street2;
    data['city'] = city;
    data['country'] = country;
    data['state'] = state;
    data['firm_name'] = firmName;
    return data;
  }
}
