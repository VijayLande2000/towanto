class GetAllBrandsModel {
  dynamic? status;
  dynamic? total;
  List<Brands>? brands;

  GetAllBrandsModel({this.status, this.total, this.brands});

  GetAllBrandsModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    total = json['total'];
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['status'] = this.status;
    data['total'] = this.total;
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  dynamic? id;
  dynamic? name;
  dynamic? description;
  dynamic? imageUrl;

  Brands({this.id, this.name, this.description, this.imageUrl});

  Brands.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
