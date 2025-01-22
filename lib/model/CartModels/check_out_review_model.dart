class CheckOutReviewModel {
  dynamic? jsonrpc;
  dynamic? id;
  Result? result;

  CheckOutReviewModel({this.jsonrpc, this.id, this.result});

  CheckOutReviewModel.fromJson(Map<dynamic, dynamic> json) {
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
  dynamic? status;
  ReviewSummary? reviewSummary;

  Result({this.status, this.reviewSummary});

  Result.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    reviewSummary = json['review_summary'] != null
        ? new ReviewSummary.fromJson(json['review_summary'])
        : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['status'] = this.status;
    if (this.reviewSummary != null) {
      data['review_summary'] = this.reviewSummary!.toJson();
    }
    return data;
  }
}

class ReviewSummary {
  dynamic? message;
  OrderDetails? orderDetails;

  ReviewSummary({this.message, this.orderDetails});

  ReviewSummary.fromJson(Map<dynamic, dynamic> json) {
    message = json['message'];
    orderDetails = json['order_details'] != null
        ? new OrderDetails.fromJson(json['order_details'])
        : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['message'] = this.message;
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails!.toJson();
    }
    return data;
  }
}

class OrderDetails {
  dynamic? id;
  dynamic? name;
  dynamic? dateOrder;
  dynamic? state;
  bool? deliveryStatus;
  PartnerId? partnerId;
  PartnerInvoiceId? partnerInvoiceId;
  PartnerInvoiceId? partnerShippingId;
  dynamic? shippingMethod;
  List<OrderLine>? orderLine;
  dynamic? totalTaxAmount;
  dynamic? totalDiscountAmount;
  dynamic? totalAmount;
  dynamic? totalUntaxedAmount;
  dynamic? deliveryCharges;

  OrderDetails(
      {this.id,
        this.name,
        this.dateOrder,
        this.state,
        this.deliveryStatus,
        this.partnerId,
        this.partnerInvoiceId,
        this.partnerShippingId,
        this.shippingMethod,
        this.orderLine,
        this.totalTaxAmount,
        this.totalDiscountAmount,
        this.totalAmount,
        this.totalUntaxedAmount,
        this.deliveryCharges});

  OrderDetails.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dateOrder = json['date_order'];
    state = json['state'];
    deliveryStatus = json['delivery_status'];
    partnerId = json['partner_id'] != null
        ? new PartnerId.fromJson(json['partner_id'])
        : null;
    partnerInvoiceId = json['partner_invoice_id'] != null
        ? new PartnerInvoiceId.fromJson(json['partner_invoice_id'])
        : null;
    partnerShippingId = json['partner_shipping_id'] != null
        ? new PartnerInvoiceId.fromJson(json['partner_shipping_id'])
        : null;
    shippingMethod = json['shipping_method'];
    if (json['order_line'] != null) {
      orderLine = <OrderLine>[];
      json['order_line'].forEach((v) {
        orderLine!.add(new OrderLine.fromJson(v));
      });
    }
    totalTaxAmount = json['total_tax_amount'];
    totalDiscountAmount = json['total_discount_amount'];
    totalAmount = json['total_amount'];
    totalUntaxedAmount = json['total_untaxed_amount'];
    deliveryCharges = json['delivery_charges'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['date_order'] = this.dateOrder;
    data['state'] = this.state;
    data['delivery_status'] = this.deliveryStatus;
    if (this.partnerId != null) {
      data['partner_id'] = this.partnerId!.toJson();
    }
    if (this.partnerInvoiceId != null) {
      data['partner_invoice_id'] = this.partnerInvoiceId!.toJson();
    }
    if (this.partnerShippingId != null) {
      data['partner_shipping_id'] = this.partnerShippingId!.toJson();
    }
    data['shipping_method'] = this.shippingMethod;
    if (this.orderLine != null) {
      data['order_line'] = this.orderLine!.map((v) => v.toJson()).toList();
    }
    data['total_tax_amount'] = this.totalTaxAmount;
    data['total_discount_amount'] = this.totalDiscountAmount;
    data['total_amount'] = this.totalAmount;
    data['total_untaxed_amount'] = this.totalUntaxedAmount;
    data['delivery_charges'] = this.deliveryCharges;
    return data;
  }
}

class PartnerId {
  dynamic? id;
  dynamic? name;
  dynamic? street;
  dynamic? street2;
  dynamic? city;
  dynamic? stateId;
  dynamic? countryId;
  dynamic? phone;
  dynamic? zip;

  PartnerId(
      {this.id,
        this.name,
        this.street,
        this.street2,
        this.city,
        this.stateId,
        this.countryId,
        this.phone,
        this.zip});

  PartnerId.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    street = json['street'];
    street2 = json['street2'];
    city = json['city'];
    stateId = json['state_id'];
    countryId = json['country_id'];
    phone = json['phone'];
    zip = json['zip'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['street'] = this.street;
    data['street2'] = this.street2;
    data['city'] = this.city;
    data['state_id'] = this.stateId;
    data['country_id'] = this.countryId;
    data['phone'] = this.phone;
    data['zip'] = this.zip;
    return data;
  }
}

class PartnerInvoiceId {
  dynamic? id;
  dynamic? name;
  dynamic? street;
  dynamic? street2;
  dynamic? city;
  dynamic? stateId;
  dynamic? countryId;
  dynamic? phone;
  dynamic? zip;

  PartnerInvoiceId(
      {this.id,
        this.name,
        this.street,
        this.street2,
        this.city,
        this.stateId,
        this.countryId,
        this.phone,
        this.zip});

  PartnerInvoiceId.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    street = json['street'];
    street2 = json['street2'];
    city = json['city'];
    stateId = json['state_id'];
    countryId = json['country_id'];
    phone = json['phone'];
    zip = json['zip'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['street'] = this.street;
    data['street2'] = this.street2;
    data['city'] = this.city;
    data['state_id'] = this.stateId;
    data['country_id'] = this.countryId;
    data['phone'] = this.phone;
    data['zip'] = this.zip;
    return data;
  }
}

class OrderLine {
  dynamic? productId;
  dynamic? productName;
  dynamic? productUomQty;
  dynamic? priceUnit;
  dynamic? priceSubtotal;
  dynamic? taxAmount;
  dynamic? priceTotal;
  dynamic? discountAmount;
  dynamic? cancelledQuantity;
  dynamic? shippedQuantity;
  dynamic? quantityRefunded;

  OrderLine(
      {this.productId,
        this.productName,
        this.productUomQty,
        this.priceUnit,
        this.priceSubtotal,
        this.taxAmount,
        this.priceTotal,
        this.discountAmount,
        this.cancelledQuantity,
        this.shippedQuantity,
        this.quantityRefunded});

  OrderLine.fromJson(Map<dynamic, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productUomQty = json['product_uom_qty'];
    priceUnit = json['price_unit'];
    priceSubtotal = json['price_subtotal'];
    taxAmount = json['tax_amount'];
    priceTotal = json['price_total'];
    discountAmount = json['discount_amount'];
    cancelledQuantity = json['cancelled_quantity'];
    shippedQuantity = json['shipped_quantity'];
    quantityRefunded = json['quantity_refunded'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_uom_qty'] = this.productUomQty;
    data['price_unit'] = this.priceUnit;
    data['price_subtotal'] = this.priceSubtotal;
    data['tax_amount'] = this.taxAmount;
    data['price_total'] = this.priceTotal;
    data['discount_amount'] = this.discountAmount;
    data['cancelled_quantity'] = this.cancelledQuantity;
    data['shipped_quantity'] = this.shippedQuantity;
    data['quantity_refunded'] = this.quantityRefunded;
    return data;
  }
}
