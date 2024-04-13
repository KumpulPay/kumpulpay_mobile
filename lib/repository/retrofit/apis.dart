// Class for api tags
class Apis {
  static const String test = '/api/v1/test';
  // auth
  static const String auth = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';

  static const String home = '/api/v1/home';

  // product ppob
  static const String productCategory = '/api/v1/ppob/product-category';
  static const String productProvider = '/api/v1/ppob/product-provider';

  static const String historyTransaction = '/api/v1/ppob/transaction-history';
  static const String ppobTransaction = '/api/v1/ppob/transaction';

  // paylater
  static const String paylaterPeriod = '/api/v1/paylater/period';
  static const String paylaterInvoice = '/api/v1/paylater/invoice';

  // pin transaction
  static const String pinCreate = '/api/v1/security/pin/create';
  static const String pinReset = '/api/v1/security/pin/reset';

  // master
  static const String companyBank = '/api/v1/company/bank';


  // wallet
  static const String walletDeposit = '/api/v1/wallet/deposit';

}
