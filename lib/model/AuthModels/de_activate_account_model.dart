class DeActivateAccountModel {
  String? jsonrpc;
  dynamic id;
  Result? result;

  DeActivateAccountModel({this.jsonrpc, this.id, this.result});

  DeActivateAccountModel.fromJson(Map<String, dynamic> json) {
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
  bool? success;
  String? message;
  String? redirectUrl;

  Result({this.success, this.message, this.redirectUrl});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['redirect_url'] = this.redirectUrl;
    return data;
  }
}
