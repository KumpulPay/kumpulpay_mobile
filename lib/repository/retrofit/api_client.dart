import 'package:dio/dio.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/model/data.dart';
import 'package:kumpulpay/repository/model/default_response.dart';
import 'package:kumpulpay/repository/retrofit/apis.dart';
import 'package:retrofit/retrofit.dart';
part 'api_client.g.dart';


@RestApi()
abstract class ApiClient {
  
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST(Apis.accountChecker)
  Future<DefaultResponse> postAccountChecker({
    @Body() required dynamic body,
  });

  @POST(Apis.auth)
  Future<DefaultResponse> postAuth({
    @Body() required Map<String, dynamic> params
  });

  @POST(Apis.refreshToken)
  Future<DefaultResponse> postRefreshToken({
    @Header('Authorization') required String authorization,
  });

  @POST(Apis.authWithGoogle)
  Future<DefaultResponse> postAuthWithGoogle({@Body() required Map<String, dynamic> params});

  @POST(Apis.register)
  Future<DefaultResponse> postRegister({
    @Body() required dynamic body,
    @Queries() Map<String, dynamic>? queries
  });

  @PATCH(Apis.profile)
  Future<DefaultResponse> patchProfile({
    @Header('Authorization') required String authorization,
    @Body() required dynamic body,
    @Queries() Map<String, dynamic>? queries
  });   

  @PATCH(Apis.kyc)
  Future<DefaultResponse> patchDataKyc({
    @Header('Authorization') required String authorization,
    @Body() required dynamic body,
    @Queries() Map<String, dynamic>? queries
  });    

  @GET(Apis.home)
  Future<DefaultResponse> getHome({
    @Header('Authorization') required String authorization
  });

  @GET(Apis.productCategory)
  Future<DefaultResponse> getProductCategory({
    @Header('Authorization') required String authorization,
    @Queries() Map<String, dynamic>? queries
  });

  @GET(Apis.product)
  Future<DefaultResponse> getProduct({
    @Header('Authorization') required String authorization,
    @Queries() Map<String, dynamic>? queries
  });

  @GET(Apis.productProvider)
  Future<DefaultResponse> getProductProvider({
    @Header('Authorization') required String authorization,
    @Queries() Map<String, dynamic>? queries
  });

  @GET(Apis.historyTransaction)
  Future<DefaultResponse> getHistoryTransaction({
    @Header('Authorization') required String authorization,
    @Queries() Map<String, dynamic>? queries
  });

  @POST(Apis.ppobTransaction)
  Future<DefaultResponse> postPpobTransaction({
    @Header('Authorization') required String authorization,
    @Body() required dynamic body,
    @Queries() Map<String, dynamic>? queries
  });

  @POST(Apis.ppobCheckBill)
  Future<DefaultResponse> postCheckBill({
    @Header('Authorization') required String authorization,
    @Body() required dynamic body,
    @Queries() Map<String, dynamic>? queries
  });

  // paylater
  @GET(Apis.paylaterPeriod)
  Future<dynamic> getPaylaterPeriod({
    @Header('Authorization') required String authorization,
    @Queries() Map<String, dynamic>? queries
  });

  @GET(Apis.paylaterInvoice)
  Future<dynamic> getPaylaterInvoice({
    @Header('Authorization') required String authorization,
    @Queries() Map<String, dynamic>? queries
  });

  // pin transaction
  @POST(Apis.pinCreate)
  Future<DefaultResponse> postPinCreate({
    @Header('Authorization') required String authorization,
    @Body() required String body,
    @Queries() Map<String, dynamic>? queries
  });

  // password change
  @POST(Apis.passwordChange)
  Future<DefaultResponse> postPasswordChange({
    @Header('Authorization') required String authorization,
    @Body() required dynamic body,
    @Queries() Map<String, dynamic>? queries
  });

  // start master & service
  @GET(Apis.companyBank)
  Future<DefaultResponse> getCompanyBank({
    @Header('Authorization') required String authorization,
    @Queries() Map<String, dynamic>? queries
  });

  @GET(Apis.regional)
  Future<DefaultResponse> getRegional({
    @Header('Authorization') required String authorization,
    @Queries() Map<String, dynamic>? queries
  });
  // end master & service

  // start wallet
  @POST(Apis.walletDeposit)
  Future<DefaultResponse> postWalletDeposit({
    @Header('Authorization') required String authorization,
    @Body() required dynamic body,
    @Queries() Map<String, dynamic>? queries
  });

  @GET(Apis.walletDeposit)
  Future<DefaultResponse> getWalletDeposit({
    @Header('Authorization') required String authorization,
    @Queries() Map<String, dynamic>? queries
  });

  @GET(Apis.walletTransaction)
  Future<DefaultResponse> getWalletTransaction({
    @Header('Authorization') required String authorization,
    @Queries() Map<String, dynamic>? queries
  });
  // end wallet

  // start user
  @POST(Apis.updateFcm)
  Future<DefaultResponse> postUpdateFcm({
    @Header('Authorization') required String authorization,
    @Body() required dynamic body,
    @Queries() Map<String, dynamic>? queries
  });
  // end user

  // start company faq
  @GET(Apis.companyFaq)
  Future<DefaultResponse> getCompanyFaq({
    @Header('Authorization') required String authorization,
    @Queries() Map<String, dynamic>? queries
  });
  // end company faq

  
}