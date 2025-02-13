class SearchProductModel {
  dynamic? jsonrpc;
  dynamic? id;
  Result? result;

  SearchProductModel({this.jsonrpc, this.id, this.result});

  SearchProductModel.fromJson(Map<dynamic, dynamic> json) {
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
  List<Products>? products;

  Result({this.products});

  Result.fromJson(Map<dynamic, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  dynamic? id;
  dynamic? name;
  dynamic? listPrice;
  dynamic? description;
  dynamic? rating;
  dynamic? ratingCount;

  Products({this.id, this.name, this.listPrice, this.description});

  Products.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    listPrice = json['list_price'];
    description = json['description'];
    rating = json['rating'];
    ratingCount = json['rating_count'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['list_price'] = this.listPrice;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['rating_count'] = this.ratingCount;
    return data;
  }
}
