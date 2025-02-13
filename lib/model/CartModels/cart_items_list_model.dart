class CartItemsListModel {
  List<Product> products;
  dynamic totalAmount;

  CartItemsListModel({required this.products, required this.totalAmount});

  factory CartItemsListModel.fromJson(Map<dynamic, dynamic> json) {
    // Check if 'products' is null or empty and provide an empty list as a fallback
    return CartItemsListModel(
      products: json['products'] != null
          ? (json['products'] as List).map((item) => Product.fromJson(item)).toList()
          : [], // Fallback to an empty list if 'products' is null
      totalAmount: json['total_amount']?.toDouble() ?? 0.0, // Handle null for 'total_amount'
    );
  }


  Map<dynamic, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
      'total_amount': totalAmount,
    };
  }
}


class Product {
  dynamic id;
  dynamic analyticDistribution;
  dynamic analyticDistributionSearch;
  dynamic analyticPrecision;
  List<dynamic> orderId;
  dynamic sequence;
  List<dynamic> companyId;
  List<dynamic> currencyId;
  List<dynamic> orderPartnerId;
  List<dynamic> salesmanId;
  dynamic state;
  List<dynamic> taxCountryId;
  dynamic displayType;
  dynamic isDownpayment;
  dynamic isExpense;
  List<dynamic> productId;
  List<dynamic> productTemplateId;
  List<dynamic> productUomCategoryId;
  List<dynamic> productCustomAttributeValueIds;
  List<dynamic> productNoVariantAttributeValueIds;
  dynamic name;
  dynamic productUomQty;
  List<dynamic> productUom;
  List<dynamic> taxId;
  dynamic pricelistItemId;
  dynamic priceUnit;
  dynamic discount;
  dynamic priceSubtotal;
  dynamic priceTax;
  dynamic priceTotal;
  dynamic priceReduceTaxexcl;
  dynamic priceReduceTaxinc;
  dynamic productPackagingId;
  dynamic productPackagingQty;
  dynamic customerLead;
  dynamic qtyDeliveredMethod;
  dynamic qtyDelivered;
  dynamic qtyInvoiced;
  dynamic qtyToInvoice;
  List<dynamic> analyticLineIds;
  List<dynamic> invoiceLines;
  dynamic invoiceStatus;
  dynamic untaxedAmountInvoiced;
  dynamic untaxedAmountToInvoice;
  dynamic productType;
  dynamic productUpdatable;
  dynamic productUomReadonly;
  dynamic taxCalculationRoundingMethod;
  dynamic displayName;
  List<dynamic> createUid;
  dynamic createDate;
  List<dynamic> writeUid;
  dynamic writeDate;
  dynamic isDelivery;
  dynamic productQty;
  dynamic recomputeDeliveryPrice;
  dynamic isRewardLine;
  dynamic rewardId;
  dynamic couponId;
  dynamic rewardIdentifierCode;
  dynamic pointsCost;
  List<dynamic> saleOrderOptionIds;
  dynamic isConfigurableProduct;
  List<dynamic> productTemplateAttributeValueIds;
  dynamic routeId;
  List<dynamic> moveIds;
  dynamic virtualAvailableAtDate;
  dynamic scheduledDate;
  dynamic forecastExpectedDate;
  dynamic freeQtyToday;
  dynamic qtyAvailableToday;
  List<dynamic> warehouseId;
  dynamic qtyToDeliver;
  dynamic isMto;
  dynamic displayQtyWidget;
  dynamic linkedLineId;
  List<dynamic> optionLineIds;
  dynamic nameShort;
  dynamic shopWarning;
  dynamic sellerId;
  dynamic marketplaceStatus;
  dynamic marginPercentage;
  dynamic marginAmount;
  dynamic isSellerGroup;
  dynamic pickingId;
  dynamic deliveryCharges;
  dynamic deliveryOrderCount;

  Product({
    required this.id,
    required this.analyticDistribution,
    required this.analyticDistributionSearch,
    required this.analyticPrecision,
    required this.orderId,
    required this.sequence,
    required this.companyId,
    required this.currencyId,
    required this.orderPartnerId,
    required this.salesmanId,
    required this.state,
    required this.taxCountryId,
    required this.displayType,
    required this.isDownpayment,
    required this.isExpense,
    required this.productId,
    required this.productTemplateId,
    required this.productUomCategoryId,
    required this.productCustomAttributeValueIds,
    required this.productNoVariantAttributeValueIds,
    required this.name,
    required this.productUomQty,
    required this.productUom,
    required this.taxId,
    required this.pricelistItemId,
    required this.priceUnit,
    required this.discount,
    required this.priceSubtotal,
    required this.priceTax,
    required this.priceTotal,
    required this.priceReduceTaxexcl,
    required this.priceReduceTaxinc,
    required this.productPackagingId,
    required this.productPackagingQty,
    required this.customerLead,
    required this.qtyDeliveredMethod,
    required this.qtyDelivered,
    required this.qtyInvoiced,
    required this.qtyToInvoice,
    required this.analyticLineIds,
    required this.invoiceLines,
    required this.invoiceStatus,
    required this.untaxedAmountInvoiced,
    required this.untaxedAmountToInvoice,
    required this.productType,
    required this.productUpdatable,
    required this.productUomReadonly,
    required this.taxCalculationRoundingMethod,
    required this.displayName,
    required this.createUid,
    required this.createDate,
    required this.writeUid,
    required this.writeDate,
    required this.isDelivery,
    required this.productQty,
    required this.recomputeDeliveryPrice,
    required this.isRewardLine,
    required this.rewardId,
    required this.couponId,
    required this.rewardIdentifierCode,
    required this.pointsCost,
    required this.saleOrderOptionIds,
    required this.isConfigurableProduct,
    required this.productTemplateAttributeValueIds,
    required this.routeId,
    required this.moveIds,
    required this.virtualAvailableAtDate,
    required this.scheduledDate,
    required this.forecastExpectedDate,
    required this.freeQtyToday,
    required this.qtyAvailableToday,
    required this.warehouseId,
    required this.qtyToDeliver,
    required this.isMto,
    required this.displayQtyWidget,
    required this.linkedLineId,
    required this.optionLineIds,
    required this.nameShort,
    required this.shopWarning,
    required this.sellerId,
    required this.marketplaceStatus,
    required this.marginPercentage,
    required this.marginAmount,
    required this.isSellerGroup,
    required this.pickingId,
    required this.deliveryCharges,
    required this.deliveryOrderCount,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json['id'],
      analyticDistribution: json['analytic_distribution'],
      analyticDistributionSearch: json['analytic_distribution_search'],
      analyticPrecision: json['analytic_precision'],
      orderId: json['order_id'],
      sequence: json['sequence'],
      companyId: json['company_id'],
      currencyId: json['currency_id'],
      orderPartnerId: json['order_partner_id'],
      salesmanId: json['salesman_id'],
      state: json['state'],
      taxCountryId: json['tax_country_id'],
      displayType: json['display_type'],
      isDownpayment: json['is_downpayment'],
      isExpense: json['is_expense'],
      productId: json['product_id'],
      productTemplateId: json['product_template_id'],
      productUomCategoryId: json['product_uom_category_id'],
      productCustomAttributeValueIds:
      List<dynamic>.from(json['product_custom_attribute_value_ids']),
      productNoVariantAttributeValueIds:
      List<dynamic>.from(json['product_no_variant_attribute_value_ids']),
      name: json['name'],
      productUomQty: json['product_uom_qty'].toDouble(),
      productUom: json['product_uom'],
      taxId: json['tax_id'],
      pricelistItemId: json['pricelist_item_id'],
      priceUnit: json['price_unit'].toDouble(),
      discount: json['discount'].toDouble(),
      priceSubtotal: json['price_subtotal'].toDouble(),
      priceTax: json['price_tax'].toDouble(),
      priceTotal: json['price_total'].toDouble(),
      priceReduceTaxexcl: json['price_reduce_taxexcl'].toDouble(),
      priceReduceTaxinc: json['price_reduce_taxinc'].toDouble(),
      productPackagingId: json['product_packaging_id'],
      productPackagingQty: json['product_packaging_qty'].toDouble(),
      customerLead: json['customer_lead'].toDouble(),
      qtyDeliveredMethod: json['qty_delivered_method'],
      qtyDelivered: json['qty_delivered'].toDouble(),
      qtyInvoiced: json['qty_invoiced'].toDouble(),
      qtyToInvoice: json['qty_to_invoice'].toDouble(),
      analyticLineIds: List<dynamic>.from(json['analytic_line_ids']),
      invoiceLines: List<dynamic>.from(json['invoice_lines']),
      invoiceStatus: json['invoice_status'],
      untaxedAmountInvoiced: json['untaxed_amount_invoiced'].toDouble(),
      untaxedAmountToInvoice:
      json['untaxed_amount_to_invoice'].toDouble(),
      productType: json['product_type'],
      productUpdatable: json['product_updatable'],
      productUomReadonly: json['product_uom_readonly'],
      taxCalculationRoundingMethod:
      json['tax_calculation_rounding_method'],
      displayName: json['display_name'],
      createUid: json['create_uid'],
      createDate: json['create_date'],
      writeUid: json['write_uid'],
      writeDate: json['write_date'],
      isDelivery: json['is_delivery'],
      productQty: json['product_qty'].toDouble(),
      recomputeDeliveryPrice: json['recompute_delivery_price'],
      isRewardLine: json['is_reward_line'],
      rewardId: json['reward_id'],
      couponId: json['coupon_id'],
      rewardIdentifierCode: json['reward_identifier_code'],
      pointsCost: json['points_cost'].toDouble(),
      saleOrderOptionIds: List<dynamic>.from(json['sale_order_option_ids']),
      isConfigurableProduct: json['is_configurable_product'],
      productTemplateAttributeValueIds:
      List<dynamic>.from(json['product_template_attribute_value_ids']),
      routeId: json['route_id'],
      moveIds: List<dynamic>.from(json['move_ids']),
      virtualAvailableAtDate: json['virtual_available_at_date'].toDouble(),
      scheduledDate: json['scheduled_date'],
      forecastExpectedDate: json['forecast_expected_date'],
      freeQtyToday: json['free_qty_today'].toDouble(),
      qtyAvailableToday: json['qty_available_today'].toDouble(),
      warehouseId: List<dynamic>.from(json['warehouse_id']),
      qtyToDeliver: json['qty_to_deliver'].toDouble(),
      isMto: json['is_mto'],
      displayQtyWidget: json['display_qty_widget'],
      linkedLineId: json['linked_line_id'],
      optionLineIds: List<dynamic>.from(json['option_line_ids']),
      nameShort: json['name_short'],
      shopWarning: json['shop_warning'],
      sellerId: json['seller_id'],
      marketplaceStatus: json['marketplace_status'],
      marginPercentage: json['margin_percentage']?.toDouble(),

      marginAmount: json['margin_amount']?.toDouble(),
      isSellerGroup: json['is_seller_group'],
      pickingId: json['picking_id'],
      deliveryCharges: json['delivery_charges']?.toDouble(),
      deliveryOrderCount: json['delivery_order_count'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'analytic_distribution': analyticDistribution,
      'analytic_distribution_search': analyticDistributionSearch,
      'analytic_precision': analyticPrecision,
      'order_id': orderId,
      'sequence': sequence,
      'company_id': companyId,
      'currency_id': currencyId,
      'order_partner_id': orderPartnerId,
      'salesman_id': salesmanId,
      'state': state,
      'tax_country_id': taxCountryId,
      'display_type': displayType,
      'is_downpayment': isDownpayment,
      'is_expense': isExpense,
      'product_id': productId,
      'product_template_id': productTemplateId,
      'product_uom_category_id': productUomCategoryId,
      'product_custom_attribute_value_ids':
      productCustomAttributeValueIds,
      'product_no_variant_attribute_value_ids':
      productNoVariantAttributeValueIds,
      'name': name,
      'product_uom_qty': productUomQty,
      'product_uom': productUom,
      'tax_id': taxId,
      'pricelist_item_id': pricelistItemId,
      'price_unit': priceUnit,
      'discount': discount,
      'price_subtotal': priceSubtotal,
      'price_tax': priceTax,
      'price_total': priceTotal,
      'price_reduce_taxexcl': priceReduceTaxexcl,
      'price_reduce_taxinc': priceReduceTaxinc,
      'product_packaging_id': productPackagingId,
      'product_packaging_qty': productPackagingQty,
      'customer_lead': customerLead,
      'qty_delivered_method': qtyDeliveredMethod,
      'qty_delivered': qtyDelivered,
      'qty_invoiced': qtyInvoiced,
      'qty_to_invoice': qtyToInvoice,
      'analytic_line_ids': analyticLineIds,
      'invoice_lines': invoiceLines,
      'invoice_status': invoiceStatus,
      'untaxed_amount_invoiced': untaxedAmountInvoiced,
      'untaxed_amount_to_invoice': untaxedAmountToInvoice,
      'product_type': productType,
      'product_updatable': productUpdatable,
      'product_uom_readonly': productUomReadonly,
      'tax_calculation_rounding_method': taxCalculationRoundingMethod,
      'display_name': displayName,
      'create_uid': createUid,
      'create_date': createDate,
      'write_uid': writeUid,
      'write_date': writeDate,
      'is_delivery': isDelivery,
      'product_qty': productQty,
      'recompute_delivery_price': recomputeDeliveryPrice,
      'is_reward_line': isRewardLine,
      'reward_id': rewardId,
      'coupon_id': couponId,
      'reward_identifier_code': rewardIdentifierCode,
      'points_cost': pointsCost,
      'sale_order_option_ids': saleOrderOptionIds,
      'is_configurable_product': isConfigurableProduct,
      'product_template_attribute_value_ids':
      productTemplateAttributeValueIds,
      'route_id': routeId,
      'move_ids': moveIds,
      'virtual_available_at_date': virtualAvailableAtDate,
      'scheduled_date': scheduledDate,
      'forecast_expected_date': forecastExpectedDate,
      'free_qty_today': freeQtyToday,
      'qty_available_today': qtyAvailableToday,
      'warehouse_id': warehouseId,
      'qty_to_deliver': qtyToDeliver,
      'is_mto': isMto,
      'display_qty_widget': displayQtyWidget,
      'linked_line_id': linkedLineId,
      'option_line_ids': optionLineIds,
      'name_short': nameShort,
      'shop_warning': shopWarning,
      'seller_id': sellerId,
      'marketplace_status': marketplaceStatus,
      'margin_percentage': marginPercentage,
      'margin_amount': marginAmount,
      'is_seller_group': isSellerGroup,
      'picking_id': pickingId,
      'delivery_charges': deliveryCharges,
      'delivery_order_count': deliveryOrderCount,
    };
  }
}
