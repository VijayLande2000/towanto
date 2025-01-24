class LoggedInUserInfoModel {
  dynamic jsonrpc;
  dynamic id;
  Result? result;

  LoggedInUserInfoModel({this.jsonrpc, this.id, this.result});

  LoggedInUserInfoModel.fromJson(Map<dynamic, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
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
  dynamic? partnerDisplayName;
  dynamic? zipcode;
  dynamic? phone;
  dynamic? vat;
  dynamic? street;
  dynamic? street2;
  dynamic? city;
  dynamic? country;
  dynamic? state;
  dynamic companyName;

  Result(
      {this.name,
        this.username,
        this.partnerDisplayName,
        this.zipcode,
        this.phone,
        this.vat,
        this.street,
        this.street2,
        this.city,
        this.country,
        this.state,
        this.companyName});

  Result.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    username = json['username'];
    partnerDisplayName = json['partner_display_name'];
    zipcode = json['zipcode'];
    phone = json['phone'];
    vat = json['vat'];
    street = json['street'];
    street2 = json['street2'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    companyName = json['company_name'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['partner_display_name'] = this.partnerDisplayName;
    data['zipcode'] = this.zipcode;
    data['phone'] = this.phone;
    data['vat'] = this.vat;
    data['street'] = this.street;
    data['street2'] = this.street2;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['company_name'] = this.companyName;
    return data;
  }
}
