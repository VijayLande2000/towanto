class OrderDetailsModel {
  dynamic? jsonrpc;
  dynamic? id; // Corrected to dynamic? or dynamic? depending on the expected type
  Result? result;

  OrderDetailsModel({this.jsonrpc, this.id, this.result});

  OrderDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id']; // Assuming id is an dynamiceger. Change type as needed.
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = {};
    data['jsonrpc'] = jsonrpc;
    data['id'] = id;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  dynamic? status;
  Message? message;

  Result({this.status, this.message});

  Result.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = {};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  dynamic? id;
  dynamic? name;
  dynamic? dateOrder;
  dynamic? state;
  dynamic? deliveryStatus;
  PartnerId? partnerId;
  PartnerId? partnerInvoiceId;
  PartnerId? partnerShippingId;
  dynamic? shippingMethod;
  List<OrderLine>? orderLine;
  dynamic? totalTaxAmount;
  dynamic? totalDiscountAmount;
  dynamic? totalAmount;
  dynamic? totalUntaxedAmount;
  dynamic? deliveryCharges;
  List<dynamic>? paymentDetails; // Changed to List<dynamic> to accommodate various types

  Message({
    this.id,
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
    this.deliveryCharges,
    this.paymentDetails,
  });

  Message.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dateOrder = json['date_order'];
    state = json['state'];
    deliveryStatus = json['delivery_status'];
    partnerId = json['partner_id'] != null ? PartnerId.fromJson(json['partner_id']) : null;
    partnerInvoiceId = json['partner_invoice_id'] != null ? PartnerId.fromJson(json['partner_invoice_id']) : null;
    partnerShippingId = json['partner_shipping_id'] != null ? PartnerId.fromJson(json['partner_shipping_id']) : null;
    shippingMethod = json['shipping_method'];
    if (json['order_line'] != null) {
      orderLine = [];
      json['order_line'].forEach((v) {
        orderLine!.add(OrderLine.fromJson(v));
      });
    }
    totalTaxAmount = json['total_tax_amount'];
    totalDiscountAmount = json['total_discount_amount'];
    totalAmount = json['total_amount'];
    totalUntaxedAmount = json['total_untaxed_amount'];
    deliveryCharges = json['delivery_charges'];
    if (json['payment_details'] != null) {
      paymentDetails = [];
      json['payment_details'].forEach((v) {
        paymentDetails!.add(v); // Removed Null.fromJson(v), assuming dynamic data
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['date_order'] = dateOrder;
    data['state'] = state;
    data['delivery_status'] = deliveryStatus;
    if (partnerId != null) {
      data['partner_id'] = partnerId!.toJson();
    }
    if (partnerInvoiceId != null) {
      data['partner_invoice_id'] = partnerInvoiceId!.toJson();
    }
    if (partnerShippingId != null) {
      data['partner_shipping_id'] = partnerShippingId!.toJson();
    }
    data['shipping_method'] = shippingMethod;
    if (orderLine != null) {
      data['order_line'] = orderLine!.map((v) => v.toJson()).toList();
    }
    data['total_tax_amount'] = totalTaxAmount;
    data['total_discount_amount'] = totalDiscountAmount;
    data['total_amount'] = totalAmount;
    data['total_untaxed_amount'] = totalUntaxedAmount;
    data['delivery_charges'] = deliveryCharges;
    if (paymentDetails != null) {
      data['payment_details'] = paymentDetails!;
    }
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

  PartnerId({
    this.id,
    this.name,
    this.street,
    this.street2,
    this.city,
    this.stateId,
    this.countryId,
    this.phone,
    this.zip,
  });

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
    final Map<dynamic, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['street'] = street;
    data['street2'] = street2;
    data['city'] = city;
    data['state_id'] = stateId;
    data['country_id'] = countryId;
    data['phone'] = phone;
    data['zip'] = zip;
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

  OrderLine({
    this.productId,
    this.productName,
    this.productUomQty,
    this.priceUnit,
    this.priceSubtotal,
    this.taxAmount,
    this.priceTotal,
    this.discountAmount,
    this.cancelledQuantity,
    this.shippedQuantity,
    this.quantityRefunded,
  });

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
    final Map<dynamic, dynamic> data = {};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_uom_qty'] = productUomQty;
    data['price_unit'] = priceUnit;
    data['price_subtotal'] = priceSubtotal;
    data['tax_amount'] = taxAmount;
    data['price_total'] = priceTotal;
    data['discount_amount'] = discountAmount;
    data['cancelled_quantity'] = cancelledQuantity;
    data['shipped_quantity'] = shippedQuantity;
    data['quantity_refunded'] = quantityRefunded;
    return data;
  }
}
