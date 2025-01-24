class AppUrl {

  // Dev URLs
  static const String devBaseurlauth = "https://towanto-ecommerce-mainbranch-16118324.dev.odoo.com/";


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
    getCatogiresListUrl = baseurlauth + "api/products?limit=10&offset=0";
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


    //we need to give here end point of the api
  }





}
