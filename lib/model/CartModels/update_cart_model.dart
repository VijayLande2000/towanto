class UpdateCartModel {
  dynamic jsonrpc;
  dynamic id;
  UpdateCartModel? result;

  UpdateCartModel({this.jsonrpc, this.id, this.result});

  UpdateCartModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result = json['result'] != null
        ? UpdateCartModel.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['jsonrpc'] = jsonrpc;
    data['id'] = id;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  dynamic status;
  dynamic message;

  Result({this.status, this.message});

  Result.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
