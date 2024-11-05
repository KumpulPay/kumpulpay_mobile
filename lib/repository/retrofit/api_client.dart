import 'package:dio/dio.dart';
import 'package:kumpulpay/repository/model/data.dart';
import 'package:kumpulpay/repository/retrofit/apis.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
part 'api_client.g.dart';

@RestApi(baseUrl: "https://dev-api.kumpulpay.com")
// const String flavor = String.fromEnvironment('app.flavor');
// @RestApi(baseUrl: flavor.name)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(Apis.test)
  Future<dynamic> getTest();

  @POST(Apis.auth)
  Future<AuthRes> postAuth(@Body() Map<String, dynamic> params);

  @POST(Apis.register)
  Future<dynamic> postRegister(
      // @Header('Authorization') String authorization,
      @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @GET(Apis.home)
  Future<dynamic> getHome(@Header('Authorization') String authorization);

  @GET(Apis.productCategory)
  Future<dynamic> getProductCategory(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @GET(Apis.product)
  Future<dynamic> getProduct(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @GET(Apis.productProvider)
  Future<dynamic> getProductProvider(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @GET(Apis.historyTransaction)
  Future<dynamic> getHistoryTransaction(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @POST(Apis.ppobTransaction)
  Future<dynamic> postPpobTransaction(
      @Header('Authorization') String authorization, @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  // paylater
  @GET(Apis.paylaterPeriod)
  Future<dynamic> getPaylaterPeriod(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});    

  @GET(Apis.paylaterInvoice)
  Future<dynamic> getPaylaterInvoice(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  // pin transaction
  @POST(Apis.pinCreate)
  Future<dynamic> postPinCreate(
      @Header('Authorization') String authorization, @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  // password change
  @POST(Apis.passwordChange)
  Future<dynamic> postPasswordChange(
      @Header('Authorization') String authorization, @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});    

  // start master
  @GET(Apis.companyBank)
  Future<dynamic> getCompanyBank(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});  
  // end master

  // start wallet
  @POST(Apis.walletDeposit)
  Future<dynamic> postWalletDeposit(
      @Header('Authorization') String authorization, @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});

  @GET(Apis.walletDeposit)
  Future<dynamic> getWalletDeposit(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});    

  @GET(Apis.walletTransaction)
  Future<dynamic> getWalletTransaction(
      @Header('Authorization') String authorization,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});    
  // end wallet


  // start user
  @POST(Apis.updateFcm)
  Future<dynamic> postUpdateFcm(
      @Header('Authorization') String authorization, @Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});
  // end user
}



// class AuthInterceptor extends Interceptor {

//   final AuthService authService;
//   final Dio dio;

//   AuthInterceptor(this.authService, this.dio);

//   @override
//   Future onRequest(RequestOptions options) async {
//     // Add the authorization token to the request
//     // Here, you should retrieve the token from wherever it is stored
//     String authToken = SharedPrefs().token;
//     options.headers["Authorization"] = "Bearer $authToken";
//     return options;
//   }

//   @override
//   Future onError(DioError err) async {
//     if (err.response?.statusCode == 401) {
//       // Token expired, refresh the token
//       String refreshToken = await getRefreshToken();
//       try {
//         // Call the refresh token endpoint
//         Response<String> response =
//             await authService.refreshToken({"refreshToken": refreshToken});
//         // If refresh token is successful, retry the original request
//         if (response.statusCode == 200) {
//           RequestOptions options = err.response!.requestOptions;
//           options.headers["Authorization"] = "Bearer ${response.data}";
//           return dio.request(options.path!, options: options);
//         }
//       } catch (e) {
//         // Handle refresh token error
//       }
//     }
//     return err;
//   }
// }
