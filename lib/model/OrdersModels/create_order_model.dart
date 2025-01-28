class CreateOrderModel {
  String? jsonrpc;
  dynamic id;
  Result? result;

  CreateOrderModel({this.jsonrpc, this.id, this.result});

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
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
  bool? success;
  OrderData? orderData;
  InvoiceData? invoiceData;

  Result({this.success, this.orderData, this.invoiceData});

  Result.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    orderData = json['order_data'] != null
        ? OrderData.fromJson(json['order_data'])
        : null;
    invoiceData = json['invoice_data'] != null
        ? InvoiceData.fromJson(json['invoice_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (orderData != null) {
      data['order_data'] = orderData!.toJson();
    }
    if (invoiceData != null) {
      data['invoice_data'] = invoiceData!.toJson();
    }
    return data;
  }
}

class OrderData {
  int? amount;
  int? amountDue;
  int? amountPaid;
  int? attempts;
  int? createdAt;
  String? currency;
  String? entity;
  String? id;
  Notes? notes;
  dynamic offerId;
  String? receipt;
  String? status;

  OrderData({
    this.amount,
    this.amountDue,
    this.amountPaid,
    this.attempts,
    this.createdAt,
    this.currency,
    this.entity,
    this.id,
    this.notes,
    this.offerId,
    this.receipt,
    this.status,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    amountDue = json['amount_due'];
    amountPaid = json['amount_paid'];
    attempts = json['attempts'];
    createdAt = json['created_at'];
    currency = json['currency'];
    entity = json['entity'];
    id = json['id'];
    notes = json['notes'] != null ? Notes.fromJson(json['notes']) : null;
    offerId = json['offer_id'];
    receipt = json['receipt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['amount'] = amount;
    data['amount_due'] = amountDue;
    data['amount_paid'] = amountPaid;
    data['attempts'] = attempts;
    data['created_at'] = createdAt;
    data['currency'] = currency;
    data['entity'] = entity;
    data['id'] = id;
    if (notes != null) {
      data['notes'] = notes!.toJson();
    }
    data['offer_id'] = offerId;
    data['receipt'] = receipt;
    data['status'] = status;
    return data;
  }
}

class Notes {
  String? productName;

  Notes({this.productName});

  Notes.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_name'] = productName;
    return data;
  }
}

class InvoiceData {
  String? id;
  String? entity;
  dynamic receipt;
  dynamic invoiceNumber;
  String? customerId;
  CustomerDetails? customerDetails;
  String? orderId;
  List<LineItems>? lineItems;
  dynamic paymentId;
  String? status;
  int? expireBy;
  int? issuedAt;
  dynamic paidAt;
  dynamic cancelledAt;
  dynamic expiredAt;
  String? smsStatus;
  String? emailStatus;
  int? date;
  dynamic terms;
  bool? partialPayment;
  int? grossAmount;
  int? taxAmount;
  int? taxableAmount;
  int? amount;
  int? amountPaid;
  int? amountDue;
  String? currency;
  String? currencySymbol;
  String? description;
  List<dynamic>? notes;
  dynamic comment;
  String? shortUrl;
  bool? viewLess;
  dynamic billingStart;
  dynamic billingEnd;
  String? type;
  bool? groupTaxesDiscounts;
  int? createdAt;
  dynamic refNum;

  InvoiceData({
    this.id,
    this.entity,
    this.receipt,
    this.invoiceNumber,
    this.customerId,
    this.customerDetails,
    this.orderId,
    this.lineItems,
    this.paymentId,
    this.status,
    this.expireBy,
    this.issuedAt,
    this.paidAt,
    this.cancelledAt,
    this.expiredAt,
    this.smsStatus,
    this.emailStatus,
    this.date,
    this.terms,
    this.partialPayment,
    this.grossAmount,
    this.taxAmount,
    this.taxableAmount,
    this.amount,
    this.amountPaid,
    this.amountDue,
    this.currency,
    this.currencySymbol,
    this.description,
    this.notes,
    this.comment,
    this.shortUrl,
    this.viewLess,
    this.billingStart,
    this.billingEnd,
    this.type,
    this.groupTaxesDiscounts,
    this.createdAt,
    this.refNum,
  });

  InvoiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entity = json['entity'];
    receipt = json['receipt'];
    invoiceNumber = json['invoice_number'];
    customerId = json['customer_id'];
    customerDetails = json['customer_details'] != null
        ? CustomerDetails.fromJson(json['customer_details'])
        : null;
    orderId = json['order_id'];
    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems!.add(LineItems.fromJson(v));
      });
    }
    paymentId = json['payment_id'];
    status = json['status'];
    expireBy = json['expire_by'];
    issuedAt = json['issued_at'];
    paidAt = json['paid_at'];
    cancelledAt = json['cancelled_at'];
    expiredAt = json['expired_at'];
    smsStatus = json['sms_status'];
    emailStatus = json['email_status'];
    date = json['date'];
    terms = json['terms'];
    partialPayment = json['partial_payment'];
    grossAmount = json['gross_amount'];
    taxAmount = json['tax_amount'];
    taxableAmount = json['taxable_amount'];
    amount = json['amount'];
    amountPaid = json['amount_paid'];
    amountDue = json['amount_due'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    description = json['description'];
    if (json['notes'] != null) {
      notes = [];
      json['notes'].forEach((v) {
        notes!.add(v);
      });
    }
    comment = json['comment'];
    shortUrl = json['short_url'];
    viewLess = json['view_less'];
    billingStart = json['billing_start'];
    billingEnd = json['billing_end'];
    type = json['type'];
    groupTaxesDiscounts = json['group_taxes_discounts'];
    createdAt = json['created_at'];
    refNum = json['ref_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['entity'] = entity;
    data['receipt'] = receipt;
    data['invoice_number'] = invoiceNumber;
    data['customer_id'] = customerId;
    if (customerDetails != null) {
      data['customer_details'] = customerDetails!.toJson();
    }
    data['order_id'] = orderId;
    if (lineItems != null) {
      data['line_items'] = lineItems!.map((v) => v.toJson()).toList();
    }
    data['payment_id'] = paymentId;
    data['status'] = status;
    data['expire_by'] = expireBy;
    data['issued_at'] = issuedAt;
    data['paid_at'] = paidAt;
    data['cancelled_at'] = cancelledAt;
    data['expired_at'] = expiredAt;
    data['sms_status'] = smsStatus;
    data['email_status'] = emailStatus;
    data['date'] = date;
    data['terms'] = terms;
    data['partial_payment'] = partialPayment;
    data['gross_amount'] = grossAmount;
    data['tax_amount'] = taxAmount;
    data['taxable_amount'] = taxableAmount;
    data['amount'] = amount;
    data['amount_paid'] = amountPaid;
    data['amount_due'] = amountDue;
    data['currency'] = currency;
    data['currency_symbol'] = currencySymbol;
    data['description'] = description;
    if (notes != null) {
      data['notes'] = notes;
    }
    data['comment'] = comment;
    data['short_url'] = shortUrl;
    data['view_less'] = viewLess;
    data['billing_start'] = billingStart;
    data['billing_end'] = billingEnd;
    data['type'] = type;
    data['group_taxes_discounts'] = groupTaxesDiscounts;
    data['created_at'] = createdAt;
    data['ref_num'] = refNum;
    return data;
  }
}

class CustomerDetails {
  String? id;
  String? name;
  String? email;
  dynamic contact;
  dynamic gstin;
  BillingAddress? billingAddress;
  BillingAddress? shippingAddress;
  String? customerName;
  String? customerEmail;
  dynamic customerContact;

  CustomerDetails({
    this.id,
    this.name,
    this.email,
    this.contact,
    this.gstin,
    this.billingAddress,
    this.shippingAddress,
    this.customerName,
    this.customerEmail,
    this.customerContact,
  });

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    gstin = json['gstin'];
    billingAddress = json['billing_address'] != null
        ? BillingAddress.fromJson(json['billing_address'])
        : null;
    shippingAddress = json['shipping_address'] != null
        ? BillingAddress.fromJson(json['shipping_address'])
        : null;
    customerName = json['customer_name'];
    customerEmail = json['customer_email'];
    customerContact = json['customer_contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['contact'] = contact;
    data['gstin'] = gstin;
    if (billingAddress != null) {
      data['billing_address'] = billingAddress!.toJson();
    }
    if (shippingAddress != null) {
      data['shipping_address'] = shippingAddress!.toJson();
    }
    data['customer_name'] = customerName;
    data['customer_email'] = customerEmail;
    data['customer_contact'] = customerContact;
    return data;
  }
}

class BillingAddress {
  String? id;
  String? type;
  bool? primary;
  String? line1;
  String? line2;
  String? zipcode;
  String? city;
  String? state;
  String? country;
  dynamic contact;
  dynamic name;
  dynamic tag;
  dynamic landmark;

  BillingAddress({
    this.id,
    this.type,
    this.primary,
    this.line1,
    this.line2,
    this.zipcode,
    this.city,
    this.state,
    this.country,
    this.contact,
    this.name,
    this.tag,
    this.landmark,
  });

  BillingAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    primary = json['primary'];
    line1 = json['line1'];
    line2 = json['line2'];
    zipcode = json['zipcode'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    contact = json['contact'];
    name = json['name'];
    tag = json['tag'];
    landmark = json['landmark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['type'] = type;
    data['primary'] = primary;
    data['line1'] = line1;
    data['line2'] = line2;
    data['zipcode'] = zipcode;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['contact'] = contact;
    data['name'] = name;
    data['tag'] = tag;
    data['landmark'] = landmark;
    return data;
  }
}

// Previous classes remain the same...
class LineItems {
  String? id;
  dynamic itemId;
  dynamic refId;
  dynamic refType;
  String? name;
  String? description;
  int? amount;
  int? unitAmount;
  int? grossAmount;
  int? taxAmount;
  int? taxableAmount;
  int? netAmount;
  String? currency;
  String? type;
  bool? taxInclusive;
  dynamic hsnCode;
  dynamic sacCode;
  dynamic taxRate;
  dynamic unit;
  int? quantity;
  List<dynamic>? taxes;

  LineItems({
    this.id,
    this.itemId,
    this.refId,
    this.refType,
    this.name,
    this.description,
    this.amount,
    this.unitAmount,
    this.grossAmount,
    this.taxAmount,
    this.taxableAmount,
    this.netAmount,
    this.currency,
    this.type,
    this.taxInclusive,
    this.hsnCode,
    this.sacCode,
    this.taxRate,
    this.unit,
    this.quantity,
    this.taxes,
  });

  LineItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    refId = json['ref_id'];
    refType = json['ref_type'];
    name = json['name'];
    description = json['description'];
    amount = json['amount'];
    unitAmount = json['unit_amount'];
    grossAmount = json['gross_amount'];
    taxAmount = json['tax_amount'];
    taxableAmount = json['taxable_amount'];
    netAmount = json['net_amount'];
    currency = json['currency'];
    type = json['type'];
    taxInclusive = json['tax_inclusive'];
    hsnCode = json['hsn_code'];
    sacCode = json['sac_code'];
    taxRate = json['tax_rate'];
    unit = json['unit'];
    quantity = json['quantity'];
    if (json['taxes'] != null) {
      taxes = [];
      json['taxes'].forEach((v) {
        taxes!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['item_id'] = itemId;
    data['ref_id'] = refId;
    data['ref_type'] = refType;
    data['name'] = name;
    data['description'] = description;
    data['amount'] = amount;
    data['unit_amount'] = unitAmount;
    data['gross_amount'] = grossAmount;
    data['tax_amount'] = taxAmount;
    data['taxable_amount'] = taxableAmount;
    data['net_amount'] = netAmount;
    data['currency'] = currency;
    data['type'] = type;
    data['tax_inclusive'] = taxInclusive;
    data['hsn_code'] = hsnCode;
    data['sac_code'] = sacCode;
    data['tax_rate'] = taxRate;
    data['unit'] = unit;
    data['quantity'] = quantity;
    if (taxes != null) {
      data['taxes'] = taxes;
    }
    return data;
  }
}

class ParamAddress {
  final String line1;
  final String line2;
  final String zipcode;
  final String city;
  final String state;
  final String country;

  ParamAddress({
    required this.line1,
    required this.line2,
    required this.zipcode,
    required this.city,
    required this.state,
    required this.country,
  });
}

class Params {
  final dynamic paymentAmount;
  final dynamic productName;
  final dynamic name;
  final dynamic contact;
  final dynamic email;
  final ParamAddress billingAddress;
  final ParamAddress shippingAddress;
  final dynamic currency;

  Params({
    required this.paymentAmount,
    required this.productName,
    required this.name,
    required this.contact,
    required this.email,
    required this.billingAddress,
    required this.shippingAddress,
    required this.currency,
  });
}

