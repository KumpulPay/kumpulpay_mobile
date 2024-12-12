import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kumpulpay/flavors.dart';
import 'package:kumpulpay/repository/retrofit/auth_interceptor.dart';

class AppConfig {
  final dio = Dio(
    BaseOptions(
      baseUrl: F.baseUrl,
      connectTimeout: const Duration(milliseconds: 20000),
      receiveTimeout: const Duration(milliseconds: 15000),
      contentType: "application/json",
      // validateStatus: (status) {
      //   // Anggap semua status kode di bawah 500 valid, termasuk 401
      //   return status != null && status < 500;
      // },
    ),
  );

  // Method untuk mengkonfigurasi Dio dengan interceptor
  Dio configDio({BuildContext? context}) {
    // Menambahkan AuthInterceptor ke dalam dio
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        context: context
      ),
    );

    // Mengembalikan dio yang sudah terkonfigurasi dengan interceptor
    return dio;
  }
}
