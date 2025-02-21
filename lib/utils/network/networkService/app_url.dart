class AppUrl {

  // Dev URLs
  static const String devBaseurlauth = "https://towanto-ecommerce-mainbranch-18244307.dev.odoo.com/";


  // URLs to be used based on the environment
  static late String baseurlauth;


  // Auth URLs
  static late String loginUrl;
  static late String signUpUrl;
  static late String getCatogiresListUrl;
  static late String getProductDetailsUrl;
  static late String addToCartUrl;
  static late String cartItemsListUrl;
  static late String getHomePagedataurl;
  static late String updatecartItemUrl;
  static late String deletecartItemUrl;
  static late String addWhishListItemUrl;
  static late String whishlistListItemUrl;
  static late String deletewhishlistItemUrl;
  static late String postEnquireyUrl;
  static late String updateAccountInfo;
  static late String deleteAccount;
  static late String getAddressUrl;
  static late String removeAddressUrl;
  static late String addAddressUrl;
  static late String editAddressUrl;
  static late String getOrderslist;
  static late String getOrderDetails;
  static late String getproductSearch;
  static late String getcheckOutReviewDetails;
  static late String forgotPasswordUrl;
  static late String getLoggedInUserInfo;
  static late String cancelOrderApi;
  static late String createOrder;
  static late String paymentConfirmation;
  static late String deactivateAccount;
  static late String getAllCountries;
  static late String getAllStates;
  static late String getAllFilters;
  static late String getFilterProducts;
  static late String getBrandsByiD;


  // Method to set the URLs based on the environment key
  static void setEnvironment(String environmentKey) {
    switch (environmentKey) {
      case 'Dev':
        baseurlauth = devBaseurlauth;
        break;
      default:
        throw Exception('Unknown environment: $environmentKey');
    }
    _initializeUrls();
  }

  // Method to initialize URLs
  static void _initializeUrls() {
    loginUrl = baseurlauth + "/api/login";
    signUpUrl = baseurlauth + "api/create-user";
    signUpUrl = baseurlauth + "api/create-user";
    getCatogiresListUrl = baseurlauth + "api/allproducts?limit=10&offset=0";
    getProductDetailsUrl = baseurlauth + "api/product";
    addToCartUrl = baseurlauth + "api/add_to_cart";
    cartItemsListUrl = baseurlauth + "api/add_to_cart";
    getHomePagedataurl = baseurlauth + "api/products_categ";
    updatecartItemUrl = baseurlauth + "api/add_to_cart";
    deletecartItemUrl = baseurlauth + "api/add_to_cart";
    addWhishListItemUrl = baseurlauth + "product/wishlist/create";
    whishlistListItemUrl = baseurlauth + "api/wishlist";
    deletewhishlistItemUrl = baseurlauth + "product/wishlist/delete";
    postEnquireyUrl = baseurlauth + "api/create_enquiry";


    updateAccountInfo = baseurlauth + "custom_api/update_user_info";
    deleteAccount = baseurlauth + "api/create_enquiry";
    getAddressUrl = baseurlauth + "api/get_address";
    removeAddressUrl = baseurlauth + "api/delete_address";
    addAddressUrl = baseurlauth + "api/add_address";
    editAddressUrl = baseurlauth + "api/update_address";
    getOrderslist = baseurlauth + "api/getorderlist";
    getOrderDetails = baseurlauth + "api/getorderdetails";
    getproductSearch = baseurlauth + "api/product_search";
    getcheckOutReviewDetails = baseurlauth + "api/checkout/review";
    forgotPasswordUrl = baseurlauth + "api/forgot_password";
    getLoggedInUserInfo = baseurlauth + "custom_api/get_user_info";
    cancelOrderApi = baseurlauth + "api/cancel_order";
    createOrder = baseurlauth + "api/createOrder";
    paymentConfirmation = baseurlauth +"api/payment_confirm";
    deactivateAccount = baseurlauth +"my/deactivate_user_account";
    getAllCountries = baseurlauth +"get_country";
    getAllStates = baseurlauth +"get_states";
    getAllFilters = baseurlauth +"api/get_filters";
    getFilterProducts = baseurlauth + "api/filter_products";
    getBrandsByiD = baseurlauth + "api/getproductsbybrand";
    //we need to give here end point of the api
  }





}
