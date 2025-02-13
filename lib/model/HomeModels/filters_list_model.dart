class FilterListApiModel {
  List<Brands>? brands;
  List<dynamic>? varieties;
  List<dynamic>? packageSizes;
  PriceRange? priceRange;

  FilterListApiModel(
      {this.brands, this.varieties, this.packageSizes, this.priceRange});

  FilterListApiModel.fromJson(Map<String, dynamic> json) {
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
    varieties = json['varieties'].cast<String>();
    packageSizes = json['package_sizes'].cast<String>();
    priceRange = json['price_range'] != null
        ? new PriceRange.fromJson(json['price_range'])
        : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    data['varieties'] = this.varieties;
    data['package_sizes'] = this.packageSizes;
    if (this.priceRange != null) {
      data['price_range'] = this.priceRange!.toJson();
    }
    return data;
  }
}

class Brands {
  dynamic id;
  dynamic name;

  Brands({this.id, this.name});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class PriceRange {
  dynamic minPrice;
  dynamic maxPrice;

  PriceRange({this.minPrice, this.maxPrice});

  PriceRange.fromJson(Map<String, dynamic> json) {
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    return data;
  }
}
