import 'package:dio/dio.dart';
import 'package:kumpulpay/repository/model/data.dart';
import 'package:kumpulpay/repository/retrofit/apis.dart';
import 'package:retrofit/retrofit.dart';
part 'api_client.g.dart';


@RestApi(baseUrl: "https://kp-dev-api.harmonyliving.id")
abstract class ApiClient {

  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(Apis.test)
  Future<dynamic> getTest();

  @POST(Apis.auth)
  Future<AuthRes> postAuth(@Body() Map<String, dynamic> params);

  @GET(Apis.productCategory)
  Future<dynamic> getProductCategory(
    @Header('Authorization') String authorization, {
    @Header('Content-Type') String contentType = 'application/json',
  });
}
