class OrdersListModel {
  dynamic? status;
  List<Data>? data;

  OrdersListModel({this.status, this.data});

  OrdersListModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic? id;
  dynamic? name;
  dynamic? partnerName;
  dynamic? state;
  dynamic? deliveryStatus;
  dynamic? amountTotal;
  dynamic? dateOrder;

  Data(
      {this.id,
        this.name,
        this.partnerName,
        this.state,
        this.deliveryStatus,
        this.amountTotal,
        this.dateOrder});

  Data.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    partnerName = json['partner_name'];
    state = json['state'];
    deliveryStatus = json['delivery_status'];
    amountTotal = json['amount_total'];
    dateOrder = json['date_order'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['partner_name'] = this.partnerName;
    data['state'] = this.state;
    data['delivery_status'] = this.deliveryStatus;
    data['amount_total'] = this.amountTotal;
    data['date_order'] = this.dateOrder;
    return data;
  }
}
