import 'package:dio/dio.dart';
import 'package:kumpulpay/repository/retrofit/api_client.dart';

class AppRepository {
  ApiClient _apiRequest;
  Dio dio;

  AppRepository() {
    dio = Dio();
    _apiRequest = ApiClient(dio);
  }
}
