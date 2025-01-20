class CategoriesListDetailsModel {
  final dynamic id;
  final List<dynamic>? activityIds;
  final dynamic activityState;
  final dynamic activityUserId;
  final dynamic activityTypeId;
  final dynamic activityTypeIcon;
  final dynamic activityDateDeadline;
  final dynamic myActivityDateDeadline;
  final dynamic activitySummary;
  final dynamic activityExceptionDecoration;
  final dynamic activityExceptionIcon;
  final dynamic activityCalendarEventId;
  final dynamic messageIsFollower;
  final List<dynamic>? messageFollowerIds;
  final List<dynamic>? messagePartnerIds;
  final List<dynamic>? messageIds;
  final dynamic hasMessage;
  final dynamic messageNeedaction;
  final dynamic messageNeedactionCounter;
  final dynamic messageHasError;
  final dynamic messageHasErrorCounter;
  final dynamic messageAttachmentCount;
  final List<dynamic>? ratingIds;
  final List<dynamic>? websiteMessageIds;
  final dynamic messageHasSmsError;
  final dynamic priceExtra;
  final dynamic lstPrice;
  final dynamic partnerRef;
  final dynamic active;
  final List<dynamic> productTmplId;
  final dynamic image1920;
  final DateTime writeDate;
  final dynamic displayName;
  final List<dynamic> createUid;
  final DateTime createDate;
  final List<dynamic> writeUid;
  final dynamic taxString;
  final List<dynamic>? stockMoveIds;
  final dynamic qtyAvailable;
  final dynamic virtualAvailable;
  final dynamic freeQty;
  final dynamic incomingQty;
  final dynamic outgoingQty;
  final dynamic nbrMovesIn;
  final dynamic nbrMovesOut;
  final dynamic nbrReorderingRules;
  final dynamic reorderingMinQty;
  final dynamic reorderingMaxQty;
  final dynamic showOnHandQtyStatusButton;
  final dynamic showForecastedQtyStatusButton;
  final dynamic validEan;
  final List<dynamic> productProperties;
  final List<dynamic> stockValuationLayerIds;
  final dynamic valuation;
  final dynamic costMethod;
  final dynamic salesCount;
  final dynamic productCatalogProductIsInSaleOrder;
  final dynamic websiteUrl;
  final dynamic baseUnitPrice;
  final dynamic baseUnitName;
  final dynamic status;
  final dynamic websitePublished;
  final dynamic isPublished;
  final dynamic canPublish;
  final dynamic name;
  final dynamic sequence;
  final dynamic descriptionSale;
  final dynamic detailedType;
  final dynamic type;
  final List<dynamic> categId;
  final List<dynamic> currencyId;
  final List<dynamic> costCurrencyId;
  final dynamic listPrice;
  final dynamic saleOk;
  final dynamic purchaseOk;
  final List<dynamic> uomId;
  final dynamic uomName;
  final List<dynamic> uomPoId;
  final dynamic productTooltip;
  final List<dynamic> productTagIds;
  final List<dynamic>? publicCategIds;
  final dynamic compareListPrice;
  final dynamic minimumOrderQty;
  final dynamic productWeight;
  final dynamic productCompany;
  final dynamic productPrice;
  final dynamic crop;
  final dynamic variety;
  final dynamic perCaseBag;

  CategoriesListDetailsModel({
    required this.id,
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
    required this.partnerRef,
    required this.active,
    required this.productTmplId,
    required this.image1920,
    required this.writeDate,
    required this.displayName,
    required this.createUid,
    required this.createDate,
    required this.writeUid,
    required this.taxString,
    required this.stockMoveIds,
    required this.qtyAvailable,
    required this.virtualAvailable,
    required this.freeQty,
    required this.incomingQty,
    required this.outgoingQty,
    required this.nbrMovesIn,
    required this.nbrMovesOut,
    required this.nbrReorderingRules,
    required this.reorderingMinQty,
    required this.reorderingMaxQty,
    required this.showOnHandQtyStatusButton,
    required this.showForecastedQtyStatusButton,
    required this.validEan,
    required this.productProperties,
    required this.stockValuationLayerIds,
    required this.valuation,
    required this.costMethod,
    required this.salesCount,
    required this.productCatalogProductIsInSaleOrder,
    required this.websiteUrl,
    required this.baseUnitPrice,
    required this.baseUnitName,
    required this.status,
    required this.websitePublished,
    required this.isPublished,
    required this.canPublish,
    required this.name,
    required this.sequence,
    required this.descriptionSale,
    required this.detailedType,
    required this.type,
    required this.categId,
    required this.currencyId,
    required this.costCurrencyId,
    required this.listPrice,
    required this.saleOk,
    required this.purchaseOk,
    required this.uomId,
    required this.uomName,
    required this.uomPoId,
    required this.productTooltip,
    required this.productTagIds,
    required this.publicCategIds,
    required this.compareListPrice,
    required this.minimumOrderQty,
    required this.productWeight,
    required this.productCompany,
    required this.productPrice,
    required this.crop,
    required this.variety,
    required this.perCaseBag,
  });

  factory CategoriesListDetailsModel.fromJson(Map<String, dynamic> json) {
    return CategoriesListDetailsModel(
      id: json['id'],
      activityIds: json['activity_ids'] != null
          ? List<int>.from(json['activity_ids'])
          : [],  // Provide an empty list if json['activity_ids'] is null
      activityState: json['activity_state'],
      activityUserId: json['activity_user_id'],
      activityTypeId: json['activity_type_id'],
      activityTypeIcon: json['activity_type_icon'],
      activityDateDeadline: json['activity_date_deadline'],
      myActivityDateDeadline: json['my_activity_date_deadline'],
      activitySummary: json['activity_summary'],
      activityExceptionDecoration: json['activity_exception_decoration'],
      activityExceptionIcon: json['activity_exception_icon'],
      activityCalendarEventId: json['activity_calendar_event_id'],
      messageIsFollower: json['message_is_follower'],
      messageFollowerIds: json['message_follower_ids'] != null
          ? List<int>.from(json['message_follower_ids'])
          : [],  // Provide an empty list if json['message_follower_ids'] is null

      messagePartnerIds: json['message_partner_ids'] != null
          ? List<int>.from(json['message_partner_ids'])
          : [],  // Provide an empty list if json['message_partner_ids'] is null

      messageIds: json['message_ids'] != null
          ? List<int>.from(json['message_ids'])
          : [],  // Provide an empty list if json['message_ids'] is null
      hasMessage: json['has_message'],
      messageNeedaction: json['message_needaction'],
      messageNeedactionCounter: json['message_needaction_counter'],
      messageHasError: json['message_has_error'],
      messageHasErrorCounter: json['message_has_error_counter'],
      messageAttachmentCount: json['message_attachment_count'],
      ratingIds: json['rating_ids'] != null
          ? List<int>.from(json['rating_ids'])
          : [],  // Provide an empty list if json['rating_ids'] is null

      websiteMessageIds: json['website_message_ids'] != null
          ? List<int>.from(json['website_message_ids'])
          : [],  // Provide an empty list if json['website_message_ids'] is null

      messageHasSmsError: json['message_has_sms_error'],
      priceExtra: (json['price_extra'] != null) ? json['price_extra'].toDouble() : 0.0,
      lstPrice: (json['lst_price'] != null) ? json['lst_price'].toDouble() : 0.0,
      partnerRef: json['partner_ref'],
      active: json['active'],
      productTmplId: json['product_tmpl_id'] != null
          ? List<dynamic>.from(json['product_tmpl_id'])
          : [],  // Provide an empty list if json['product_tmpl_id'] is null

      createUid: json['create_uid'] != null
          ? List<dynamic>.from(json['create_uid'])
          : [],  // Provide an empty list if json['create_uid'] is null
      image1920: json['image_1920'],
      writeDate: json['write_date'] != null ? DateTime.parse(json['write_date']) : DateTime.now(),
      displayName: json['display_name'],
      createDate: json['create_date'] != null ? DateTime.parse(json['create_date']) : DateTime.now(),
      taxString: json['tax_string'],
      qtyAvailable: (json['qty_available'] != null) ? json['qty_available'].toDouble() : 0.0,
      virtualAvailable: (json['virtual_available'] != null) ? json['virtual_available'].toDouble() : 0.0,
      freeQty: (json['free_qty'] != null) ? json['free_qty'].toDouble() : 0.0,
      incomingQty: (json['incoming_qty'] != null) ? json['incoming_qty'].toDouble() : 0.0,
      outgoingQty: (json['outgoing_qty'] != null) ? json['outgoing_qty'].toDouble() : 0.0,

      nbrMovesIn: json['nbr_moves_in'],
      nbrMovesOut: json['nbr_moves_out'],
      nbrReorderingRules: json['nbr_reordering_rules'],
      listPrice: (json['list_price'] != null) ? json['list_price'].toDouble() : 0.0,
      baseUnitPrice: (json['base_unit_price'] != null) ? json['base_unit_price'].toDouble() : 0.0,
      reorderingMinQty: (json['reordering_min_qty'] != null) ? json['reordering_min_qty'].toDouble() : 0.0,
      reorderingMaxQty: (json['reordering_max_qty'] != null) ? json['reordering_max_qty'].toDouble() : 0.0,

      showOnHandQtyStatusButton: json['show_on_hand_qty_status_button'],
      showForecastedQtyStatusButton: json['show_forecasted_qty_status_button'],
      validEan: json['valid_ean'],

      valuation: json['valuation'],
      costMethod: json['cost_method'],
      salesCount: json['sales_count'],
      productCatalogProductIsInSaleOrder: json['product_catalog_product_is_in_sale_order'],
      websiteUrl: json['website_url'],
      baseUnitName: json['base_unit_name'],
      status: json['status'],
      websitePublished: json['website_published'],
      isPublished: json['is_published'],
      canPublish: json['can_publish'],
      name: json['name'],
      sequence: json['sequence'],
      descriptionSale: json['description_sale'],
      detailedType: json['detailed_type'],
      type: json['type'],

      saleOk: json['sale_ok'],
      purchaseOk: json['purchase_ok'],
      uomName: json['uom_name'],
      productTooltip: json['product_tooltip'],
      productTagIds: json['product_tag_ids'] != null
          ? List<dynamic>.from(json['product_tag_ids'])
          : [],  // Provide an empty list if json['product_tag_ids'] is null

      publicCategIds: json['public_categ_ids'] != null
          ? List<int>.from(json['public_categ_ids'])
          : [],  // Provide an empty list if json['public_categ_ids'] is null

      uomPoId: json['uom_po_id'] != null
          ? List<dynamic>.from(json['uom_po_id'])
          : [],  // Provide an empty list if json['uom_po_id'] is null

      uomId: json['uom_id'] != null
          ? List<dynamic>.from(json['uom_id'])
          : [],  // Provide an empty list if json['uom_id'] is null

      categId: json['categ_id'] != null
          ? List<dynamic>.from(json['categ_id'])
          : [],  // Provide an empty list if json['categ_id'] is null

      currencyId: json['currency_id'] != null
          ? List<dynamic>.from(json['currency_id'])
          : [],  // Provide an empty list if json['currency_id'] is null

      writeUid: json['write_uid'] != null
          ? List<dynamic>.from(json['write_uid'])
          : [],  // Provide an empty list if json['write_uid'] is null

      costCurrencyId: json['cost_currency_id'] != null
          ? List<dynamic>.from(json['cost_currency_id'])
          : [],  // Provide an empty list if json['cost_currency_id'] is null

      productProperties: json['product_properties'] != null
          ? List<dynamic>.from(json['product_properties'])
          : [],  // Provide an empty list if json['product_properties'] is null

      stockValuationLayerIds: json['stock_valuation_layer_ids'] != null
          ? List<int>.from(json['stock_valuation_layer_ids'])
          : [],  // Provide an empty list if json['stock_valuation_layer_ids'] is null

      stockMoveIds: json['stock_move_ids'] != null
          ? List<int>.from(json['stock_move_ids'])
          : [],  // Provide an empty list if json['stock_move_ids'] is null
      compareListPrice: json['compare_list_price'],
      minimumOrderQty: json['minimum_order_qty'],
      productWeight: json['product_weight'],
      productCompany: json['product_company'],
      productPrice: json['product_price'],
      crop: json['crop'],
      variety: json['variety'],
      perCaseBag: json['per_case_bag'],
    );
  }

}
