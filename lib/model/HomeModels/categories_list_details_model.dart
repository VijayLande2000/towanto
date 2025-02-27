class CategoriesListDetailsModel {
  CategoriesListDetailsModel({
    required this.status,
    required this.products,
    required this.totalCount,
    required this.categories,
  });

  final String? status;
  final List<Product> products;
  final dynamic? totalCount;
  final List<CategoryChilds> categories;

  factory CategoriesListDetailsModel.fromJson(Map<String, dynamic> json){
    return CategoriesListDetailsModel(
      status: json["status"],
      products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
      totalCount: json["total_count"],
      categories: json["categories"] == null ? [] : List<CategoryChilds>.from(json["categories"]!.map((x) => CategoryChilds.fromJson(x))),
    );
  }
}
class CategoryChilds {
  CategoryChilds({
    required this.id,
    required this.name,
    required this.displayName,
    required this.parentPath,
    required this.childId,
    required this.subcategories,
  });

  final dynamic? id;
  final String? name;
  final String? displayName;
  final String? parentPath;
  final List<dynamic> childId;
  final List<CategoryChilds> subcategories; // Change type to CategoryChilds

  factory CategoryChilds.fromJson(Map<String, dynamic> json) {
    return CategoryChilds(
      id: json["id"],
      name: json["name"],
      displayName: json["display_name"],
      parentPath: json["parent_path"],
      childId: json["child_id"] == null
          ? []
          : List<dynamic>.from(json["child_id"].map((x) => x)),
      subcategories: json["subcategories"] == null
          ? []
          : List<CategoryChilds>.from(json["subcategories"].map((x) => CategoryChilds.fromJson(x))), // Proper parsing
    );
  }
}


class Product {
  Product({
    required this.id,
    required this.isInCart,
    required this.activityIds,
    required this.activityState,
    required this.activityUserId,
    required this.activityTypeId,
    required this.activityTypeIcon,
    required this.activityDateDeadline,
    required this.myActivityDateDeadline,
    required this.activitySummary,
    required this.activityExceptionDecoration,
    required this.activityExceptionIcon,
    required this.activityCalendarEventId,
    required this.messageIsFollower,
    required this.messageFollowerIds,
    required this.messagePartnerIds,
    required this.messageIds,
    required this.hasMessage,
    required this.messageNeedaction,
    required this.messageNeedactionCounter,
    required this.messageHasError,
    required this.messageHasErrorCounter,
    required this.messageAttachmentCount,
    required this.ratingIds,
    required this.websiteMessageIds,
    required this.messageHasSmsError,
    required this.priceExtra,
    required this.lstPrice,
    required this.defaultCode,
    required this.code,
    required this.partnerRef,
    required this.active,
    required this.productTmplId,
    required this.barcode,
    required this.productTemplateAttributeValueIds,
    required this.productTemplateVariantValueIds,
    required this.combinationIndices,
    required this.isProductVariant,
    required this.standardPrice,
    required this.volume,
    required this.weight,
    required this.pricelistItemCount,
    required this.productDocumentIds,
    required this.productDocumentCount,
    required this.packagingIds,
    required this.additionalProductTagIds,
    required this.allProductTagIds,
    required this.imageVariant1920,
    required this.imageVariant1024,
    required this.imageVariant512,
    required this.imageVariant256,
    required this.imageVariant128,
    required this.canImageVariant1024BeZoomed,
    required this.image1920,
    required this.canImage1024BeZoomed,
    required this.writeDate,
    required this.displayName,
    required this.createUid,
    required this.createDate,
    required this.writeUid,
    required this.taxString,
    required this.stockQuantIds,
    required this.stockMoveIds,
    required this.qtyAvailable,
    required this.virtualAvailable,
    required this.freeQty,
    required this.incomingQty,
    required this.outgoingQty,
    required this.orderpodynamicIds,
    required this.nbrMovesIn,
    required this.nbrMovesOut,
    required this.nbrReorderingRules,
    required this.reorderingMinQty,
    required this.reorderingMaxQty,
    required this.putawayRuleIds,
    required this.storageCategoryCapacityIds,
    required this.showOnHandQtyStatusButton,
    required this.showForecastedQtyStatusButton,
    required this.validEan,
    required this.lotPropertiesDefinition,
    required this.standardPriceUpdateWarning,
    required this.variantBomIds,
    required this.bomLineIds,
    required this.bomCount,
    required this.usedInBomCount,
    required this.mrpProductQty,
    required this.isKits,
    required this.valueSvl,
    required this.quantitySvl,
    required this.avgCost,
    required this.totalValue,
    required this.companyCurrencyId,
    required this.stockValuationLayerIds,
    required this.valuation,
    required this.costMethod,
    required this.salesCount,
    required this.productCatalogProductIsInSaleOrder,
    required this.productVariantImageIds,
    required this.websiteUrl,
    required this.ribbonId,
    required this.baseUnitCount,
    required this.baseUnitId,
    required this.baseUnitPrice,
    required this.baseUnitName,
    required this.sellerId,
    required this.status,
    required this.stockNotificationPartnerIds,
    required this.websitePublished,
    required this.isPublished,
    required this.canPublish,
    required this.name,
    required this.sequence,
    required this.description,
    required this.descriptionPurchase,
    required this.descriptionSale,
    required this.detailedType,
    required this.type,
    required this.categId,
    required this.currencyId,
    required this.costCurrencyId,
    required this.listPrice,
    required this.volumeUomName,
    required this.weightUomName,
    required this.saleOk,
    required this.purchaseOk,
    required this.uomId,
    required this.uomName,
    required this.uomPoId,
    required this.companyId,
    required this.sellerIds,
    required this.variantSellerIds,
    required this.color,
    required this.attributeLineIds,
    required this.validProductTemplateAttributeLineIds,
    required this.productVariantIds,
    required this.productVariantId,
    required this.productVariantCount,
    required this.hasConfigurableAttributes,
    required this.productTooltip,
    required this.priority,
    required this.productTagIds,
    required this.productProperties,
    required this.taxesId,
    required this.supplierTaxesId,
    required this.propertyAccountIncomeId,
    required this.propertyAccountExpenseId,
    required this.accountTagIds,
    required this.fiscalCountryCodes,
    required this.responsibleId,
    required this.propertyStockProduction,
    required this.propertyStockInventory,
    required this.saleDelay,
    required this.tracking,
    required this.descriptionPicking,
    required this.descriptionPickingout,
    required this.descriptionPickingin,
    required this.locationId,
    required this.warehouseId,
    required this.hasAvailableRouteIds,
    required this.routeIds,
    required this.routeFromCategIds,
    required this.canBeExpensed,
    required this.bomIds,
    required this.useExpirationDate,
    required this.expirationTime,
    required this.useTime,
    required this.removalTime,
    required this.alertTime,
    required this.version,
    required this.ecoCount,
    required this.ecoIds,
    required this.serviceType,
    required this.saleLineWarn,
    required this.saleLineWarnMsg,
    required this.expensePolicy,
    required this.visibleExpensePolicy,
    required this.invoicePolicy,
    required this.productBrandId,
    required this.optionalProductIds,
    required this.expensePolicyTooltip,
    required this.hsCode,
    required this.countryOfOrigin,
    required this.ratingLastValue,
    required this.ratingLastFeedback,
    required this.ratingLastImage,
    required this.ratingCount,
    required this.ratingAvg,
    required this.ratingAvgText,
    required this.ratingPercentageSatisfaction,
    required this.ratingLastText,
    required this.websiteDescription,
    required this.descriptionEcommerce,
    required this.alternativeProductIds,
    required this.accessoryProductIds,
    required this.websiteSizeX,
    required this.websiteSizeY,
    required this.websiteRibbonId,
    required this.websiteSequence,
    required this.publicCategIds,
    required this.productTemplateImageIds,
    required this.compareListPrice,
    required this.shopId,
    required this.allowOutOfStockOrder,
    required this.availableThreshold,
    required this.showAvailability,
    required this.outOfStockMessage,
    required this.minimumOrderQty,
    required this.productWeight,
    required this.productCompany,
    required this.productPrice,
    required this.productTechnicalName,
    required this.crop,
    required this.variety,
    required this.quantitySlab,
    required this.perCaseBag,
    required this.websiteProductName,
    required this.xStudioPricePerUnit,
    required this.image1024,
    required this.image512,
    required this.image256,
    required this.image128,
  });

  final dynamic? id;
  final dynamic isInCart;
  final List<dynamic> activityIds;
  final dynamic? activityState;
  final dynamic? activityUserId;
  final dynamic? activityTypeId;
  final dynamic? activityTypeIcon;
  final dynamic? activityDateDeadline;
  final dynamic? myActivityDateDeadline;
  final dynamic? activitySummary;
  final dynamic? activityExceptionDecoration;
  final dynamic? activityExceptionIcon;
  final dynamic? activityCalendarEventId;
  final dynamic? messageIsFollower;
  final List<dynamic> messageFollowerIds;
  final List<dynamic> messagePartnerIds;
  final List<dynamic> messageIds;
  final dynamic? hasMessage;
  final dynamic? messageNeedaction;
  final dynamic? messageNeedactionCounter;
  final dynamic? messageHasError;
  final dynamic? messageHasErrorCounter;
  final dynamic? messageAttachmentCount;
  final List<dynamic> ratingIds;
  final List<dynamic> websiteMessageIds;
  final dynamic? messageHasSmsError;
  final double? priceExtra;
  final dynamic? lstPrice;
  final dynamic? defaultCode;
  final dynamic? code;
  final dynamic? partnerRef;
  final dynamic? active;
  final List<dynamic> productTmplId;
  final dynamic? barcode;
  final List<dynamic> productTemplateAttributeValueIds;
  final List<dynamic> productTemplateVariantValueIds;
  final dynamic? combinationIndices;
  final dynamic? isProductVariant;
  final dynamic? standardPrice;
  final dynamic? volume;
  final dynamic? weight;
  final dynamic? pricelistItemCount;
  final List<dynamic> productDocumentIds;
  final dynamic? productDocumentCount;
  final List<dynamic> packagingIds;
  final List<dynamic> additionalProductTagIds;
  final List<dynamic> allProductTagIds;
  final dynamic? imageVariant1920;
  final dynamic? imageVariant1024;
  final dynamic? imageVariant512;
  final dynamic? imageVariant256;
  final dynamic? imageVariant128;
  final dynamic? canImageVariant1024BeZoomed;
  final dynamic? image1920;
  final dynamic? canImage1024BeZoomed;
  final DateTime? writeDate;
  final dynamic? displayName;
  final List<dynamic> createUid;
  final DateTime? createDate;
  final List<dynamic> writeUid;
  final dynamic? taxString;
  final List<dynamic> stockQuantIds;
  final List<dynamic> stockMoveIds;
  final dynamic? qtyAvailable;
  final dynamic? virtualAvailable;
  final dynamic? freeQty;
  final dynamic? incomingQty;
  final dynamic? outgoingQty;
  final List<dynamic> orderpodynamicIds;
  final dynamic? nbrMovesIn;
  final dynamic? nbrMovesOut;
  final dynamic? nbrReorderingRules;
  final dynamic? reorderingMinQty;
  final dynamic? reorderingMaxQty;
  final List<dynamic> putawayRuleIds;
  final List<dynamic> storageCategoryCapacityIds;
  final dynamic? showOnHandQtyStatusButton;
  final dynamic? showForecastedQtyStatusButton;
  final dynamic? validEan;
  final List<dynamic> lotPropertiesDefinition;
  final dynamic? standardPriceUpdateWarning;
  final List<dynamic> variantBomIds;
  final List<dynamic> bomLineIds;
  final dynamic? bomCount;
  final dynamic? usedInBomCount;
  final dynamic? mrpProductQty;
  final dynamic? isKits;
  final dynamic? valueSvl;
  final dynamic? quantitySvl;
  final dynamic? avgCost;
  final dynamic? totalValue;
  final List<dynamic> companyCurrencyId;
  final List<dynamic> stockValuationLayerIds;
  final dynamic? valuation;
  final dynamic? costMethod;
  final dynamic? salesCount;
  final dynamic? productCatalogProductIsInSaleOrder;
  final List<dynamic> productVariantImageIds;
  final dynamic? websiteUrl;
  final dynamic? ribbonId;
  final dynamic? baseUnitCount;
  final dynamic? baseUnitId;
  final dynamic? baseUnitPrice;
  final dynamic? baseUnitName;
  final dynamic? sellerId;
  final dynamic? status;
  final List<dynamic> stockNotificationPartnerIds;
  final dynamic? websitePublished;
  final dynamic? isPublished;
  final dynamic? canPublish;
  final dynamic name;
  final dynamic? sequence;
  final dynamic? description;
  final dynamic? descriptionPurchase;
  final dynamic? descriptionSale;
  final dynamic? detailedType;
  final dynamic? type;
  final List<dynamic> categId;
  final List<dynamic> currencyId;
  final List<dynamic> costCurrencyId;
  final dynamic? listPrice;
  final dynamic? volumeUomName;
  final dynamic? weightUomName;
  final dynamic? saleOk;
  final dynamic? purchaseOk;
  final List<dynamic> uomId;
  final dynamic? uomName;
  final List<dynamic> uomPoId;
  final dynamic? companyId;
  final List<dynamic> sellerIds;
  final List<dynamic> variantSellerIds;
  final dynamic? color;
  final List<dynamic> attributeLineIds;
  final List<dynamic> validProductTemplateAttributeLineIds;
  final List<dynamic> productVariantIds;
  final List<dynamic> productVariantId;
  final dynamic? productVariantCount;
  final dynamic? hasConfigurableAttributes;
  final dynamic? productTooltip;
  final dynamic? priority;
  final List<dynamic> productTagIds;
  final List<ProductProperty> productProperties;
  final List<dynamic> taxesId;
  final List<dynamic> supplierTaxesId;
  final dynamic? propertyAccountIncomeId;
  final dynamic? propertyAccountExpenseId;
  final List<dynamic> accountTagIds;
  final dynamic? fiscalCountryCodes;
  final List<dynamic> responsibleId;
  final List<dynamic> propertyStockProduction;
  final List<dynamic> propertyStockInventory;
  final dynamic? saleDelay;
  final dynamic? tracking;
  final dynamic? descriptionPicking;
  final dynamic? descriptionPickingout;
  final dynamic? descriptionPickingin;
  final dynamic? locationId;
  final dynamic? warehouseId;
  final dynamic? hasAvailableRouteIds;
  final List<dynamic> routeIds;
  final List<dynamic> routeFromCategIds;
  final dynamic? canBeExpensed;
  final List<dynamic> bomIds;
  final dynamic? useExpirationDate;
  final dynamic? expirationTime;
  final dynamic? useTime;
  final dynamic? removalTime;
  final dynamic? alertTime;
  final dynamic? version;
  final dynamic? ecoCount;
  final List<dynamic> ecoIds;
  final dynamic? serviceType;
  final dynamic? saleLineWarn;
  final dynamic? saleLineWarnMsg;
  final dynamic? expensePolicy;
  final dynamic? visibleExpensePolicy;
  final dynamic? invoicePolicy;
  final List<dynamic> productBrandId;
  final List<dynamic> optionalProductIds;
  final dynamic? expensePolicyTooltip;
  final dynamic? hsCode;
  final dynamic? countryOfOrigin;
  final dynamic? ratingLastValue;
  final dynamic? ratingLastFeedback;
  final dynamic? ratingLastImage;
  final dynamic? ratingCount;
  final dynamic? ratingAvg;
  final dynamic? ratingAvgText;
  final dynamic? ratingPercentageSatisfaction;
  final dynamic? ratingLastText;
  final dynamic? websiteDescription;
  final dynamic? descriptionEcommerce;
  final List<dynamic> alternativeProductIds;
  final List<dynamic> accessoryProductIds;
  final dynamic? websiteSizeX;
  final dynamic? websiteSizeY;
  final dynamic? websiteRibbonId;
  final dynamic? websiteSequence;
  final List<dynamic> publicCategIds;
  final List<dynamic> productTemplateImageIds;
  final dynamic? compareListPrice;
  final dynamic? shopId;
  final dynamic? allowOutOfStockOrder;
  final dynamic? availableThreshold;
  final dynamic? showAvailability;
  final dynamic? outOfStockMessage;
  final dynamic? minimumOrderQty;
  final dynamic? productWeight;
  final dynamic? productCompany;
  final dynamic? productPrice;
  final dynamic? productTechnicalName;
  final dynamic? crop;
  final dynamic? variety;
  final dynamic? quantitySlab;
  final dynamic? perCaseBag;
  final dynamic? websiteProductName;
  final dynamic? xStudioPricePerUnit;
  final dynamic? image1024;
  final dynamic? image512;
  final dynamic? image256;
  final dynamic? image128;

  factory Product.fromJson(Map<dynamic, dynamic> json){
    return Product(
      id: json["id"],
      isInCart: json["is_in_cart"],
      activityIds: json["activity_ids"] == null ? [] : List<dynamic>.from(json["activity_ids"]!.map((x) => x)),
      activityState: json["activity_state"],
      activityUserId: json["activity_user_id"],
      activityTypeId: json["activity_type_id"],
      activityTypeIcon: json["activity_type_icon"],
      activityDateDeadline: json["activity_date_deadline"],
      myActivityDateDeadline: json["my_activity_date_deadline"],
      activitySummary: json["activity_summary"],
      activityExceptionDecoration: json["activity_exception_decoration"],
      activityExceptionIcon: json["activity_exception_icon"],
      activityCalendarEventId: json["activity_calendar_event_id"],
      messageIsFollower: json["message_is_follower"],
      messageFollowerIds: json["message_follower_ids"] == null ? [] : List<dynamic>.from(json["message_follower_ids"]!.map((x) => x)),
      messagePartnerIds: json["message_partner_ids"] == null ? [] : List<dynamic>.from(json["message_partner_ids"]!.map((x) => x)),
      messageIds: json["message_ids"] == null ? [] : List<dynamic>.from(json["message_ids"]!.map((x) => x)),
      hasMessage: json["has_message"],
      messageNeedaction: json["message_needaction"],
      messageNeedactionCounter: json["message_needaction_counter"],
      messageHasError: json["message_has_error"],
      messageHasErrorCounter: json["message_has_error_counter"],
      messageAttachmentCount: json["message_attachment_count"],
      ratingIds: json["rating_ids"] == null ? [] : List<dynamic>.from(json["rating_ids"]!.map((x) => x)),
      websiteMessageIds: json["website_message_ids"] == null ? [] : List<dynamic>.from(json["website_message_ids"]!.map((x) => x)),
      messageHasSmsError: json["message_has_sms_error"],
      priceExtra: json["price_extra"],
      lstPrice: json["lst_price"],
      defaultCode: json["default_code"],
      code: json["code"],
      partnerRef: json["partner_ref"],
      active: json["active"],
      productTmplId: json["product_tmpl_id"] == null ? [] : List<dynamic>.from(json["product_tmpl_id"]!.map((x) => x)),
      barcode: json["barcode"],
      productTemplateAttributeValueIds: json["product_template_attribute_value_ids"] == null ? [] : List<dynamic>.from(json["product_template_attribute_value_ids"]!.map((x) => x)),
      productTemplateVariantValueIds: json["product_template_variant_value_ids"] == null ? [] : List<dynamic>.from(json["product_template_variant_value_ids"]!.map((x) => x)),
      combinationIndices: json["combination_indices"],
      isProductVariant: json["is_product_variant"],
      standardPrice: json["standard_price"],
      volume: json["volume"],
      weight: json["weight"],
      pricelistItemCount: json["pricelist_item_count"],
      productDocumentIds: json["product_document_ids"] == null ? [] : List<dynamic>.from(json["product_document_ids"]!.map((x) => x)),
      productDocumentCount: json["product_document_count"],
      packagingIds: json["packaging_ids"] == null ? [] : List<dynamic>.from(json["packaging_ids"]!.map((x) => x)),
      additionalProductTagIds: json["additional_product_tag_ids"] == null ? [] : List<dynamic>.from(json["additional_product_tag_ids"]!.map((x) => x)),
      allProductTagIds: json["all_product_tag_ids"] == null ? [] : List<dynamic>.from(json["all_product_tag_ids"]!.map((x) => x)),
      imageVariant1920: json["image_variant_1920"],
      imageVariant1024: json["image_variant_1024"],
      imageVariant512: json["image_variant_512"],
      imageVariant256: json["image_variant_256"],
      imageVariant128: json["image_variant_128"],
      canImageVariant1024BeZoomed: json["can_image_variant_1024_be_zoomed"],
      image1920: json["image_1920"],
      canImage1024BeZoomed: json["can_image_1024_be_zoomed"],
      writeDate: DateTime.tryParse(json["write_date"] ?? ""),
      displayName: json["display_name"],
      createUid: json["create_uid"] == null ? [] : List<dynamic>.from(json["create_uid"]!.map((x) => x)),
      createDate: DateTime.tryParse(json["create_date"] ?? ""),
      writeUid: json["write_uid"] == null ? [] : List<dynamic>.from(json["write_uid"]!.map((x) => x)),
      taxString: json["tax_string"],
      stockQuantIds: json["stock_quant_ids"] == null ? [] : List<dynamic>.from(json["stock_quant_ids"]!.map((x) => x)),
      stockMoveIds: json["stock_move_ids"] == null ? [] : List<dynamic>.from(json["stock_move_ids"]!.map((x) => x)),
      qtyAvailable: json["qty_available"],
      virtualAvailable: json["virtual_available"],
      freeQty: json["free_qty"],
      incomingQty: json["incoming_qty"],
      outgoingQty: json["outgoing_qty"],
      orderpodynamicIds: json["orderpodynamic_ids"] == null ? [] : List<dynamic>.from(json["orderpodynamic_ids"]!.map((x) => x)),
      nbrMovesIn: json["nbr_moves_in"],
      nbrMovesOut: json["nbr_moves_out"],
      nbrReorderingRules: json["nbr_reordering_rules"],
      reorderingMinQty: json["reordering_min_qty"],
      reorderingMaxQty: json["reordering_max_qty"],
      putawayRuleIds: json["putaway_rule_ids"] == null ? [] : List<dynamic>.from(json["putaway_rule_ids"]!.map((x) => x)),
      storageCategoryCapacityIds: json["storage_category_capacity_ids"] == null ? [] : List<dynamic>.from(json["storage_category_capacity_ids"]!.map((x) => x)),
      showOnHandQtyStatusButton: json["show_on_hand_qty_status_button"],
      showForecastedQtyStatusButton: json["show_forecasted_qty_status_button"],
      validEan: json["valid_ean"],
      lotPropertiesDefinition: json["lot_properties_definition"] == null ? [] : List<dynamic>.from(json["lot_properties_definition"]!.map((x) => x)),
      standardPriceUpdateWarning: json["standard_price_update_warning"],
      variantBomIds: json["variant_bom_ids"] == null ? [] : List<dynamic>.from(json["variant_bom_ids"]!.map((x) => x)),
      bomLineIds: json["bom_line_ids"] == null ? [] : List<dynamic>.from(json["bom_line_ids"]!.map((x) => x)),
      bomCount: json["bom_count"],
      usedInBomCount: json["used_in_bom_count"],
      mrpProductQty: json["mrp_product_qty"],
      isKits: json["is_kits"],
      valueSvl: json["value_svl"],
      quantitySvl: json["quantity_svl"],
      avgCost: json["avg_cost"],
      totalValue: json["total_value"],
      companyCurrencyId: json["company_currency_id"] == null ? [] : List<dynamic>.from(json["company_currency_id"]!.map((x) => x)),
      stockValuationLayerIds: json["stock_valuation_layer_ids"] == null ? [] : List<dynamic>.from(json["stock_valuation_layer_ids"]!.map((x) => x)),
      valuation: json["valuation"],
      costMethod: json["cost_method"],
      salesCount: json["sales_count"],
      productCatalogProductIsInSaleOrder: json["product_catalog_product_is_in_sale_order"],
      productVariantImageIds: json["product_variant_image_ids"] == null ? [] : List<dynamic>.from(json["product_variant_image_ids"]!.map((x) => x)),
      websiteUrl: json["website_url"],
      ribbonId: json["ribbon_id"],
      baseUnitCount: json["base_unit_count"],
      baseUnitId: json["base_unit_id"],
      baseUnitPrice: json["base_unit_price"],
      baseUnitName: json["base_unit_name"],
      sellerId: json["seller_id"],
      status: json["status"],
      stockNotificationPartnerIds: json["stock_notification_partner_ids"] == null ? [] : List<dynamic>.from(json["stock_notification_partner_ids"]!.map((x) => x)),
      websitePublished: json["website_published"],
      isPublished: json["is_published"],
      canPublish: json["can_publish"],
      name: json["name"],
      sequence: json["sequence"],
      description: json["description"],
      descriptionPurchase: json["description_purchase"],
      descriptionSale: json["description_sale"],
      detailedType: json["detailed_type"],
      type: json["type"],
      categId: json["categ_id"] == null ? [] : List<dynamic>.from(json["categ_id"]!.map((x) => x)),
      currencyId: json["currency_id"] == null ? [] : List<dynamic>.from(json["currency_id"]!.map((x) => x)),
      costCurrencyId: json["cost_currency_id"] == null ? [] : List<dynamic>.from(json["cost_currency_id"]!.map((x) => x)),
      listPrice: json["list_price"],
      volumeUomName: json["volume_uom_name"],
      weightUomName: json["weight_uom_name"],
      saleOk: json["sale_ok"],
      purchaseOk: json["purchase_ok"],
      uomId: json["uom_id"] == null ? [] : List<dynamic>.from(json["uom_id"]!.map((x) => x)),
      uomName: json["uom_name"],
      uomPoId: json["uom_po_id"] == null ? [] : List<dynamic>.from(json["uom_po_id"]!.map((x) => x)),
      companyId: json["company_id"],
      sellerIds: json["seller_ids"] == null ? [] : List<dynamic>.from(json["seller_ids"]!.map((x) => x)),
      variantSellerIds: json["variant_seller_ids"] == null ? [] : List<dynamic>.from(json["variant_seller_ids"]!.map((x) => x)),
      color: json["color"],
      attributeLineIds: json["attribute_line_ids"] == null ? [] : List<dynamic>.from(json["attribute_line_ids"]!.map((x) => x)),
      validProductTemplateAttributeLineIds: json["valid_product_template_attribute_line_ids"] == null ? [] : List<dynamic>.from(json["valid_product_template_attribute_line_ids"]!.map((x) => x)),
      productVariantIds: json["product_variant_ids"] == null ? [] : List<dynamic>.from(json["product_variant_ids"]!.map((x) => x)),
      productVariantId: json["product_variant_id"] == null ? [] : List<dynamic>.from(json["product_variant_id"]!.map((x) => x)),
      productVariantCount: json["product_variant_count"],
      hasConfigurableAttributes: json["has_configurable_attributes"],
      productTooltip: json["product_tooltip"],
      priority: json["priority"],
      productTagIds: json["product_tag_ids"] == null ? [] : List<dynamic>.from(json["product_tag_ids"]!.map((x) => x)),
      productProperties: json["product_properties"] == null ? [] : List<ProductProperty>.from(json["product_properties"]!.map((x) => ProductProperty.fromJson(x))),
      taxesId: json["taxes_id"] == null ? [] : List<dynamic>.from(json["taxes_id"]!.map((x) => x)),
      supplierTaxesId: json["supplier_taxes_id"] == null ? [] : List<dynamic>.from(json["supplier_taxes_id"]!.map((x) => x)),
      propertyAccountIncomeId: json["property_account_income_id"],
      propertyAccountExpenseId: json["property_account_expense_id"],
      accountTagIds: json["account_tag_ids"] == null ? [] : List<dynamic>.from(json["account_tag_ids"]!.map((x) => x)),
      fiscalCountryCodes: json["fiscal_country_codes"],
      responsibleId: json["responsible_id"] == null ? [] : List<dynamic>.from(json["responsible_id"]!.map((x) => x)),
      propertyStockProduction: json["property_stock_production"] == null ? [] : List<dynamic>.from(json["property_stock_production"]!.map((x) => x)),
      propertyStockInventory: json["property_stock_inventory"] == null ? [] : List<dynamic>.from(json["property_stock_inventory"]!.map((x) => x)),
      saleDelay: json["sale_delay"],
      tracking: json["tracking"],
      descriptionPicking: json["description_picking"],
      descriptionPickingout: json["description_pickingout"],
      descriptionPickingin: json["description_pickingin"],
      locationId: json["location_id"],
      warehouseId: json["warehouse_id"],
      hasAvailableRouteIds: json["has_available_route_ids"],
      routeIds: json["route_ids"] == null ? [] : List<dynamic>.from(json["route_ids"]!.map((x) => x)),
      routeFromCategIds: json["route_from_categ_ids"] == null ? [] : List<dynamic>.from(json["route_from_categ_ids"]!.map((x) => x)),
      canBeExpensed: json["can_be_expensed"],
      bomIds: json["bom_ids"] == null ? [] : List<dynamic>.from(json["bom_ids"]!.map((x) => x)),
      useExpirationDate: json["use_expiration_date"],
      expirationTime: json["expiration_time"],
      useTime: json["use_time"],
      removalTime: json["removal_time"],
      alertTime: json["alert_time"],
      version: json["version"],
      ecoCount: json["eco_count"],
      ecoIds: json["eco_ids"] == null ? [] : List<dynamic>.from(json["eco_ids"]!.map((x) => x)),
      serviceType: json["service_type"],
      saleLineWarn: json["sale_line_warn"],
      saleLineWarnMsg: json["sale_line_warn_msg"],
      expensePolicy: json["expense_policy"],
      visibleExpensePolicy: json["visible_expense_policy"],
      invoicePolicy: json["invoice_policy"],
      productBrandId: json["product_brand_id"] == null || json["product_brand_id"] is! List ?
      [] :
      List<dynamic>.from(json["product_brand_id"].map((x) => x)),      optionalProductIds: json["optional_product_ids"] == null ? [] : List<dynamic>.from(json["optional_product_ids"]!.map((x) => x)),
      expensePolicyTooltip: json["expense_policy_tooltip"],
      hsCode: json["hs_code"],
      countryOfOrigin: json["country_of_origin"],
      ratingLastValue: json["rating_last_value"],
      ratingLastFeedback: json["rating_last_feedback"],
      ratingLastImage: json["rating_last_image"],
      ratingCount: json["rating_count"],
      ratingAvg: json["rating_avg"],
      ratingAvgText: json["rating_avg_text"],
      ratingPercentageSatisfaction: json["rating_percentage_satisfaction"],
      ratingLastText: json["rating_last_text"],
      websiteDescription: json["website_description"],
      descriptionEcommerce: json["description_ecommerce"],
      alternativeProductIds: json["alternative_product_ids"] == null ? [] : List<dynamic>.from(json["alternative_product_ids"]!.map((x) => x)),
      accessoryProductIds: json["accessory_product_ids"] == null ? [] : List<dynamic>.from(json["accessory_product_ids"]!.map((x) => x)),
      websiteSizeX: json["website_size_x"],
      websiteSizeY: json["website_size_y"],
      websiteRibbonId: json["website_ribbon_id"],
      websiteSequence: json["website_sequence"],
      publicCategIds: json["public_categ_ids"] == null ? [] : List<dynamic>.from(json["public_categ_ids"]!.map((x) => x)),
      productTemplateImageIds: json["product_template_image_ids"] == null ? [] : List<dynamic>.from(json["product_template_image_ids"]!.map((x) => x)),
      compareListPrice: json["compare_list_price"],
      shopId: json["shop_id"],
      allowOutOfStockOrder: json["allow_out_of_stock_order"],
      availableThreshold: json["available_threshold"],
      showAvailability: json["show_availability"],
      outOfStockMessage: json["out_of_stock_message"],
      minimumOrderQty: json["minimum_order_qty"],
      productWeight: json["product_weight"],
      productCompany: json["product_company"],
      productPrice: json["product_price"],
      productTechnicalName: json["product_technical_name"],
      crop: json["crop"],
      variety: json["variety"],
      quantitySlab: json["quantity_slab"],
      perCaseBag: json["per_case_bag"],
      websiteProductName: json["website_product_name"],
      xStudioPricePerUnit: json["x_studio_price_per_unit"],
      image1024: json["image_1024"],
      image512: json["image_512"],
      image256: json["image_256"],
      image128: json["image_128"],
    );
  }

}

class ProductProperty {
  ProductProperty({
    required this.name,
    required this.type,
    required this.string,
    required this.value,
  });

  final String? name;
  final String? type;
  final String? string;
  final dynamic? value;

  factory ProductProperty.fromJson(Map<String, dynamic> json){
    return ProductProperty(
      name: json["name"],
      type: json["type"],
      string: json["string"],
      value: json["value"],
    );
  }

}
