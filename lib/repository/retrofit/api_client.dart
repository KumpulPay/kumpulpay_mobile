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

  @GET(Apis.home)
  Future<dynamic> getHome(@Header('Authorization') String authorization);

  @GET(Apis.productCategory)
  Future<dynamic> getProductCategory(
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
      @Header('Authorization') String authorization,@Body() String body,
      {@Header('Content-Type') String contentType = 'application/json',
      @Queries() Map<String, dynamic>? queries});     
}
