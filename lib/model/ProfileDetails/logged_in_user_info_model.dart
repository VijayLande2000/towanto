class LoggedInUserInfoModel {
  String? jsonrpc;
  dynamic id;
  Result? result;

  LoggedInUserInfoModel({this.jsonrpc, this.id, this.result});

  LoggedInUserInfoModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jsonrpc'] = this.jsonrpc;
    data['id'] = this.id;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  dynamic? name;
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

  Result(
      {this.name,
        this.username,
        this.zipcode,
        this.phone,
        this.vat,
        this.street,
        this.street2,
        this.city,
        this.country,
        this.state,
        this.firmName});

  Result.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['zipcode'] = this.zipcode;
    data['phone'] = this.phone;
    data['vat'] = this.vat;
    data['street'] = this.street;
    data['street2'] = this.street2;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['firm_name'] = this.firmName;
    return data;
  }
}
