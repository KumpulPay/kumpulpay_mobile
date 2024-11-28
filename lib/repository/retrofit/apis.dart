// Class for api tags
class Apis {
  static const String test = '/api/v1/test';
  // auth
  static const String auth = '/api/v1/auth/login';
  static const String authWithGoogle = '/api/v1/auth/with-google';
  static const String register = '/api/v1/auth/register';
  static const String refreshToken = '/api/v1/auth/refresh-token';
  static const String profile = '/api/v1/user/profile';

  static const String home = '/api/v1/home';

  // product ppob
  static const String productCategory = '/api/v1/ppob/category';
  static const String product = '/api/v1/ppob/product';
  static const String productProvider = '/api/v1/ppob/product-provider';

  static const String historyTransaction = '/api/v1/ppob/transaction';
  static const String ppobTransaction = '/api/v1/ppob/transaction';
  static const String ppobCheckBill = '/api/v1/ppob/check-bill';

  // paylater
  static const String paylaterPeriod = '/api/v1/paylater/period';
  static const String paylaterInvoice = '/api/v1/paylater/invoice';

  // pin transaction
  static const String pinCreate = '/api/v1/security/pin/create';
  static const String pinReset = '/api/v1/security/pin/reset';

  // password
  static const String passwordChange = '/api/v1/security/password/change';
  static const String passwordForgot = '/api/v1/security/password/forgot';

  // master
  static const String companyBank = '/api/v1/company/bank';


  // wallet
  static const String walletDeposit = '/api/v1/wallet/deposit';
  static const String walletTransaction = '/api/v1/wallet/transaction';

  // user
  static const String updateFcm = '/api/v1/user/fcm';

  // company
  static const String companyFaq = '/api/v1/company/faq';

}
