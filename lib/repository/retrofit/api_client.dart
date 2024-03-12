import 'package:dio/dio.dart';
import 'package:kumpulpay/data/shared_prefs.dart';
import 'package:kumpulpay/repository/model/data.dart';
import 'package:kumpulpay/repository/retrofit/apis.dart';
import 'package:retrofit/retrofit.dart';
part 'api_client.g.dart';

@RestApi(baseUrl: "http://192.168.102.18:1111")
// @Header('Authorization')
// String authorization = SharedPrefs().token;

abstract class ApiClient {
  // String get authorization => SharedPrefs().token ?? "";
  // String set authorization(String value){

  // }
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(Apis.test)
  Future<dynamic> getTest();

  // static String? authorization = SharedPrefs().token;

  @POST(Apis.auth)
  Future<AuthRes> postAuth(@Body() Map<String, dynamic> params,
      {@Header('Content-Type') String contentType = 'application/json'});

  @GET(Apis.productCategory)
  Future<dynamic> getProductCategory(
    @Header('Authorization') String authorization, {
    @Header('Content-Type') String contentType = 'application/json',
  });
}
