import 'package:dio/dio.dart';
import 'package:kumpulpay/flavors.dart';
import 'package:kumpulpay/repository/retrofit/auth_interceptor.dart';

class AppConfig {
  final dio = Dio(
    BaseOptions(
      baseUrl: F.baseUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
      contentType: "application/json",
    ),
  );

  // Method untuk mengkonfigurasi Dio dengan interceptor
  Dio configDio() {
    // Menambahkan AuthInterceptor ke dalam dio
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        refreshTokenEndpoint: '${F.baseUrl}/auth/refresh-token',
        // refreshTokenEndpoint: Apis.refreshToken,
      ),
    );

    // Mengembalikan dio yang sudah terkonfigurasi dengan interceptor
    return dio;
  }
}
